From: akpm@linux-foundation.org
Subject: - ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:10 -0700
Message-ID: <200710162040.l9GKeARF015658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765124AbXJPVBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:01:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: use list_for_each_entry_safe() when wiping auth toks
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: use list_for_each_entry_safe() when wiping auth toks
From: Michael Halcrow <mhalcrow@us.ibm.com>

Use list_for_each_entry_safe() when wiping the authentication token list.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

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
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
