public with sharing class Controller {
    
    @AuraEnabled
    public static List<LookupResult> LookupRecords(String searchTerm, List<String> selectedIds,String sObjectName, String field, String subField,Integer maxResults) {
        List<LookupResult> results = new List<LookupResult>();
        
        String strQuery = 'SELECT Id, '+field + (String.isNotBlank(subField) ? ' ,'+subField : '')+' FROM '+sObjectName;
        strQuery += ' WHERE '+field+' LIKE \'' + searchTerm + '%\' AND ';  
        strQuery += ' Id NOT IN :selectedIds ORDER BY '+field+' LIMIT :maxResults';
        
        List<sObject> searchResults = Database.query(strQuery);   
        if(searchResults != NUll && !searchResults.isEmpty()){
            for(sObject sObj : searchResults){
                LookupResult res = new LookupResult();
                res.Id = sObj.Id;
                res.title = String.valueOf(sObj.get(field));
                if(String.isNotBlank(subField) && sObj.get(subField) != NULL){
                    res.subtitle = String.valueOf(sObj.get(subField));
                }else{
                    res.subtitle = sObjectName;
                }
                results.add(res);
            } 
        }
        return results;        
    }
    
    @AuraEnabled
    public static LookupResult getRecentlyCreatedRecord(String sObjectName, String recordId, String field, String subField) {
        LookupResult result = new LookupSearchResult();
        String strQuery = 'SELECT Id, '+field + (String.isNotBlank(subField) ? ' ,'+subField : '')+' FROM '+sObjectName +' WHERE Id =:recordId LIMIT 1';
        List<sObject> searchResults = Database.query(strQuery);   
        if(searchResults != NUll && !searchResults.isEmpty()){
            sObject sObj = searchResults.get(0);
            LookupResult res = new LookupResult();
            result.Id = sObj.Id;
            result.title = String.valueOf(sObj.get(field));
            if(String.isNotBlank(subField) && sObj.get(subField) != NULL){
                result.subtitle = String.valueOf(sObj.get(subField));
            }else{
                result.subtitle = sObjectName;
            }
        }
        return result;        
    }
    
    public class LookupResult {
        @AuraEnabled public Id id{get;set;}
        @AuraEnabled public String title{get;set;}
        @AuraEnabled public String subtitle{get;set;}
    }
}