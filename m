From: akpm@linux-foundation.org
Subject: + ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:26:58 -0700
Message-ID: <200707202226.l6KMQw5H019666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760551AbXGTW1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: use list_for_each_entry_safe() when wiping auth toks
has been added to the -mm tree.  Its filename is
     ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: use list_for_each_entry_safe() when wiping auth toks
From: Michael Halcrow <mhalcrow@us.ibm.com>

Use list_for_each_entry_safe() when wiping the authentication token list.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks
+++ a/fs/ecryptfs/keystore.c
@@ -469,26 +469,19 @@ out:
 
 static void wipe_auth_tok_list(struct list_head *auth_tok_list_head)
 {
-	struct list_head *walker;
 	struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
+	struct ecryptfs_auth_tok_list_item *auth_tok_list_item_tmp;
 
-	walker = auth_tok_list_head->next;
-	while (walker != auth_tok_list_head) {
-		auth_tok_list_item =
-		    list_entry(walker, struct ecryptfs_auth_tok_list_item,
-			       list);
-		walker = auth_tok_list_item->list.next;
-		memset(auth_tok_list_item, 0,
-		       sizeof(struct ecryptfs_auth_tok_list_item));
+	list_for_each_entry_safe(auth_tok_list_item, auth_tok_list_item_tmp,
+				 auth_tok_list_head, list) {
+		list_del(&auth_tok_list_item->list);
 		kmem_cache_free(ecryptfs_auth_tok_list_item_cache,
 				auth_tok_list_item);
 	}
-	auth_tok_list_head->next = NULL;
 }
 
 struct kmem_cache *ecryptfs_auth_tok_list_item_cache;
 
-
 /**
  * parse_tag_1_packet
  * @crypt_stat: The cryptographic context to modify based on packet
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
