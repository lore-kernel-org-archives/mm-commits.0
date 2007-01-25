From: akpm@osdl.org
Subject: + reiser4-drop-check_cryptcompress.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:45:21 -0800
Message-ID: <200701250545.l0P5jLF9007169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48084 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965353AbXAYFpZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:45:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4: drop check_cryptcompress
has been added to the -mm tree.  Its filename is
     reiser4-drop-check_cryptcompress.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: drop check_cryptcompress
From: Edward Shishkin <edward@namesys.com>

Drop check_cryptcompress()

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |   68 +++++----------------
 fs/reiser4/plugin/file/file_conversion.c |    7 --
 2 files changed, 17 insertions(+), 58 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-drop-check_cryptcompress fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-drop-check_cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -54,24 +54,6 @@ int cryptcompress_inode_ok(struct inode 
 }
 #endif
 
-static int check_cryptcompress(struct inode *inode)
-{
-	int result = 0;
-	assert("edward-1307", inode_compression_plugin(inode) != NULL);
-
-	if (inode_cluster_size(inode) < PAGE_CACHE_SIZE) {
-		warning("edward-1331",
-			"%s clusters are unsupported",
-			inode_cluster_plugin(inode)->h.label);
-		return RETERR(-EINVAL);
-	}
-
-	/* FIXME-EDWARD: init? or check? */
-	if (inode_compression_plugin(inode)->init)
-		result = inode_compression_plugin(inode)->init();
-	return result;
-}
-
 /* The following is a part of reiser4 cipher key manager
    which is called when opening/creating a cryptcompress file */
 
@@ -431,35 +413,25 @@ static int inode_set_crypto(struct inode
  	return 0;
 }
 
-static int
-inode_set_compression(struct inode * object)
+static int inode_init_compression(struct inode * object)
 {
 	int result = 0;
-	compression_plugin * cplug;
-
-	cplug = inode_compression_plugin(object);
-
-	if (cplug->init != NULL) {
-		result = cplug->init();
-		if (result)
-			return result;
-	}
-
-	return 0;
+	assert("edward-1461", object != NULL);
+	if (inode_compression_plugin(object)->init)
+		result = inode_compression_plugin(object)->init();
+	return result;
 }
 
-static int inode_set_cluster(struct inode *object)
+static int inode_check_cluster(struct inode * object)
 {
 	assert("edward-696", object != NULL);
 
-	/* Check size of logical cluster */
-	if (inode_cluster_plugin(object)->shift < PAGE_CACHE_SHIFT) {
+	if (inode_cluster_size(object) < PAGE_CACHE_SIZE) {
 		warning("edward-1320", "Can not support '%s' "
-			"cluster: (less then page size)",
+			"logical clusters (less then page size)",
 			inode_cluster_plugin(object)->h.label);
 		return RETERR(-EINVAL);
 	}
-
 	return 0;
 }
 
@@ -503,11 +475,11 @@ create_cryptcompress(struct inode *objec
 	if (result)
 		goto error;
 	/* set compression */
-	result = inode_set_compression(object);
+	result = inode_init_compression(object);
 	if (result)
 		goto error;
 	/* set cluster */
-	result = inode_set_cluster(object);
+	result = inode_check_cluster(object);
 	if (result)
 		goto error;
 
@@ -523,6 +495,7 @@ create_cryptcompress(struct inode *objec
 /* ->open() method of the cryptcompress plugin */
 int open_object_cryptcompress(struct inode * inode, struct file * file)
 {
+	int result;
 	struct inode * parent;
 
 	assert("edward-1394", inode != NULL);
@@ -534,7 +507,12 @@ int open_object_cryptcompress(struct ino
 	assert("edward-698",
 	       inode_file_plugin(inode) ==
 	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
-
+	result = inode_check_cluster(inode);
+	if (result)
+		return result;
+	result = inode_init_compression(inode);
+	if (result)
+		return result;
 	if (!need_cipher(inode))
 		/* the file is not to be ciphered */
 		return 0;
@@ -1250,12 +1228,6 @@ int readpage_cryptcompress(struct file *
 		unlock_page(page);
 		return PTR_ERR(ctx);
 	}
-	result = check_cryptcompress(page->mapping->host);
-	if (result) {
-		unlock_page(page);
-		reiser4_exit_context(ctx);
-		return result;
-	}
 	assert("edward-113",
 	       ergo(file != NULL,
 		    page->mapping == file->f_dentry->d_inode->i_mapping));
@@ -2640,9 +2612,6 @@ write_cryptcompress_flow(struct file *fi
 	assert("edward-159", current_blocksize == PAGE_CACHE_SIZE);
 	assert("edward-1274", get_current_context()->grabbed_blocks == 0);
 
-	result = check_cryptcompress(inode);
-	if (result)
-		return result;
 	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
 	if (hint == NULL)
 		return RETERR(-ENOMEM);
@@ -3704,9 +3673,6 @@ int setattr_cryptcompress(struct dentry 
 	struct inode *inode;
 
 	inode = dentry->d_inode;
-	result = check_cryptcompress(inode);
-	if (result)
-		return result;
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (inode->i_size != attr->ia_size) {
 			reiser4_context *ctx;
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-drop-check_cryptcompress fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-drop-check_cryptcompress
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -585,13 +585,6 @@ ssize_t prot_sendfile_cryptcompress(stru
 			    (file, ppos, count, actor, target));
 }
 
-#if 0
-int prot_delete_object_cryptcompress(struct inode *inode)
-{
-	return PROT_PASSIVE(int, delete_object, (inode));
-}
-#endif  /*  0  */
-
 /*
   Local variables:
   c-indentation-style: "K&R"
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
