From: akpm@linux-foundation.org
Subject: - reiser4-fix-readpage_cryptcompress.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:42 -0800
Message-ID: <200703060204.l2624goq008834@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965717AbXCFCEq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix readpage_cryptcompress
has been removed from the -mm tree.  Its filename was
     reiser4-fix-readpage_cryptcompress.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix readpage_cryptcompress
From: Edward Shishkin <edward@namesys.com>

. Fixed oops when readpage_ctail() returns error
  (trying to unlock non-locked page)
. Print inode and number of corrupted disk cluster.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |   19 +++++++++++++------
 fs/reiser4/plugin/item/ctail.c         |    5 ++++-
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-readpage_cryptcompress fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-readpage_cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1161,8 +1161,13 @@ int reiser4_inflate_cluster(reiser4_clus
 	if (need_inflate(clust, inode, need_cipher(inode)) &&
 	    coplug->checksum != NULL) {
 		result = dc_check_checksum(coplug, tc);
-		if (result)
+		if (unlikely(result)) {
+			warning("edward-1460",
+				"Inode %llu: disk cluster %lu looks corrupted",
+				(unsigned long long)get_inode_oid(inode),
+				clust->index);
 			return RETERR(-EIO);
+		}
 	}
 	if (need_cipher(inode)) {
 		cipher_plugin * ciplug;
@@ -1233,8 +1238,10 @@ int readpage_cryptcompress(struct file *
 	assert("edward-89", page->mapping && page->mapping->host);
 
 	ctx = reiser4_init_context(page->mapping->host->i_sb);
-	if (IS_ERR(ctx))
+	if (IS_ERR(ctx)) {
+		unlock_page(page);
 		return PTR_ERR(ctx);
+	}
 	result = check_cryptcompress(page->mapping->host);
 	if (result) {
 		unlock_page(page);
@@ -1247,6 +1254,7 @@ int readpage_cryptcompress(struct file *
 
 	if (PageUptodate(page)) {
 		warning("edward-1338", "page is already uptodate\n");
+		unlock_page(page);
 		reiser4_exit_context(ctx);
 		return 0;
 	}
@@ -1260,10 +1268,9 @@ int readpage_cryptcompress(struct file *
 		return -EINVAL;
 	}
 	result = iplug->s.file.readpage(&clust, page);
-	if (result)
-		unlock_page(page);
-	assert("edward-64",
-	       ergo(result == 0, (PageLocked(page) || PageUptodate(page))));
+
+	assert("edward-1459", !PageLocked(page));
+	assert("edward-64", ergo(result == 0, PageUptodate(page)));
 	put_cluster_handle(&clust);
 	reiser4_exit_context(ctx);
 	return result;
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-fix-readpage_cryptcompress fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-fix-readpage_cryptcompress
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -671,12 +671,15 @@ int readpage_ctail(void *vp, struct page
 	assert("edward-867", !tfm_cluster_is_uptodate(&clust->tc));
 
 	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
-	if (hint == NULL)
+	if (hint == NULL) {
+		unlock_page(page);
 		return RETERR(-ENOMEM);
+	}
 	clust->hint = hint;
 	result = load_file_hint(clust->file, hint);
 	if (result) {
 		kfree(hint);
+		unlock_page(page);
 		return result;
 	}
 	assert("vs-25", hint->ext_coord.lh == &hint->lh);
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
