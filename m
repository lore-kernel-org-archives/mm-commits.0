From: akpm@linux-foundation.org
Subject: - reiser4-fix-missed-unlock-and-exit_context.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:42 -0800
Message-ID: <200703060200.l2620gLm008747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965688AbXCFCBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix missed unlock and exit_context
has been removed from the -mm tree.  Its filename was
     reiser4-fix-missed-unlock-and-exit_context.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix missed unlock and exit_context
From: Edward Shishkin <edward@namesys.com>

. Added missed reiser4_exit_context() and mutex unlock in the
  cases of returned errors.
. Removed unused cipher plugins

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/crypto/cipher.c      |   79 -----------------------
 fs/reiser4/plugin/file/cryptcompress.c |   34 ++-------
 fs/reiser4/plugin/plugin.h             |    1 
 fs/reiser4/reiser4.h                   |    6 -
 4 files changed, 10 insertions(+), 110 deletions(-)

diff -puN fs/reiser4/plugin/crypto/cipher.c~reiser4-fix-missed-unlock-and-exit_context fs/reiser4/plugin/crypto/cipher.c
--- a/fs/reiser4/plugin/crypto/cipher.c~reiser4-fix-missed-unlock-and-exit_context
+++ a/fs/reiser4/plugin/crypto/cipher.c
@@ -4,68 +4,6 @@
 
 #include "../../debug.h"
 #include "../plugin.h"
-#include "../file/cryptcompress.h"
-#include <linux/types.h>
-#include <linux/random.h>
-
-#define MIN_CIPHER_BLOCKSIZE 8
-#define MAX_CIPHER_BLOCKSIZE 128
-
-/*
-  Default align() method of the cipher plugin (look for description of this
-  method in plugin/plugin.h)
-
-  1) creates the aligning armored format of the input flow before encryption.
-     "armored" means that padding is filled by private data (for example,
-     pseudo-random sequence of bytes is not private data).
-  2) returns length of appended padding
-
-   [ flow | aligning_padding ]
-            ^
-            |
-	  @pad
-*/
-static int align_stream_common(__u8 * pad,
-			       int flow_size /* size of non-aligned flow */,
-			       int blocksize /* cipher block size */)
-{
-	int pad_size;
-
-	assert("edward-01", pad != NULL);
-	assert("edward-02", flow_size != 0);
-	assert("edward-03", blocksize != 0
-	       || blocksize <= MAX_CIPHER_BLOCKSIZE);
-
-	pad_size = blocksize - (flow_size % blocksize);
-	get_random_bytes(pad, pad_size);
-	return pad_size;
-}
-
-/* This is used for all the cipher algorithms which do not inflate
-   block-aligned data */
-static loff_t scale_common(struct inode *inode, size_t blocksize,
-			   loff_t src_off /* offset to scale */ )
-{
-	return src_off;
-}
-
-static void free_aes (struct crypto_blkcipher * tfm)
-{
-#if REISER4_AES
-	crypto_free_blkcipher(tfm);
-#endif
-	return;
-}
-
-static struct crypto_blkcipher * alloc_aes (void)
-{
-#if REISER4_AES
-	return crypto_alloc_blkcipher("ecb(aes)", 0, CRYPTO_ALG_ASYNC);
-#else
-	warning("edward-1417", "aes unsupported");
-	return ERR_PTR(-EINVAL);
-#endif /* REISER4_AES */
-}
 
 cipher_plugin cipher_plugins[LAST_CIPHER_ID] = {
 	[NONE_CIPHER_ID] = {
@@ -84,23 +22,6 @@ cipher_plugin cipher_plugins[LAST_CIPHER
 		.setkey = NULL,
 		.encrypt = NULL,
 		.decrypt = NULL
-	},
-	[AES_CIPHER_ID] = {
-		.h = {
-			.type_id = REISER4_CIPHER_PLUGIN_TYPE,
-			.id = AES_CIPHER_ID,
-			.pops = NULL,
-			.label = "aes",
-			.desc = "aes cipher transform",
-			.linkage = {NULL, NULL}
-		},
-		.alloc = alloc_aes,
-		.free = free_aes,
-		.scale = scale_common,
-		.align_stream = align_stream_common,
-		.setkey = NULL,
-		.encrypt = NULL,
-		.decrypt = NULL
 	}
 };
 
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-missed-unlock-and-exit_context fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-fix-missed-unlock-and-exit_context
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -94,7 +94,6 @@ crypto_stat_t * reiser4_alloc_crypto_sta
 	crypto_stat_t * info;
 	int fipsize;
 
-	assert("edward-1421", 0);
 	info = kmalloc(sizeof(*info), reiser4_ctx_gfp_mask_get());
 	if (!info)
 		return ERR_PTR(-ENOMEM);
@@ -176,7 +175,6 @@ static int create_keyid (crypto_stat_t *
 	struct blkcipher_desc cdesc;
 	struct scatterlist sg;
 
-	assert("edward-1422", 0);
 	assert("edward-1367", info != NULL);
 	assert("edward-1368", info->keyid != NULL);
 
@@ -1460,7 +1458,6 @@ static int try_capture_cluster(reiser4_c
 		goto exit;
 	make_cluster_jnode_dirty_locked(clust, node, &old_size, inode);
       exit:
-	assert("edward-1034", !result);
 	spin_unlock_jnode(node);
 	jput(node);
 	return result;
@@ -1707,7 +1704,6 @@ static int update_sd_cryptcompress(struc
 	result = reiser4_grab_space_force(	/* one for stat data update */
 						 estimate_update_common(inode),
 						 BA_CAN_COMMIT);
-	assert("edward-979", !result);
 	if (result)
 		return result;
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
@@ -1901,7 +1897,6 @@ balance_dirty_page_cluster(reiser4_clust
 	update_cluster(inode, clust, off, to_file);
 
 	result = update_sd_cryptcompress(inode);
-	assert("edward-988", !result);
 	if (result)
 		return result;
 	assert("edward-726", clust->hint->lh.owner == NULL);
@@ -2027,7 +2022,6 @@ int find_disk_cluster(reiser4_cluster_t 
 		result =
 		    reiser4_grab_space_force(estimate_dirty_cluster(inode),
 					     BA_CAN_COMMIT);
-		assert("edward-990", !result);
 		if (result)
 			goto out;
 	}
@@ -2246,7 +2240,6 @@ read_some_cluster_pages(struct inode *in
 		}
 		if (!tfm_cluster_is_uptodate(&clust->tc)) {
 			result = ctail_read_disk_cluster(clust, inode, mode);
-			assert("edward-992", !result);
 			if (result)
 				goto out;
 			assert("edward-925",
@@ -2255,7 +2248,6 @@ read_some_cluster_pages(struct inode *in
 		lock_page(pg);
 		result = do_readpage_ctail(inode, clust, pg, mode);
 		unlock_page(pg);
-		assert("edward-993", !result);
 		if (result) {
 			impossible("edward-219",
 				   "do_readpage_ctail returned crap");
@@ -2267,7 +2259,6 @@ read_some_cluster_pages(struct inode *in
 		   to make flush update convert its content */
 		result = find_disk_cluster(clust, inode, 0 /* do not read items */,
 					   mode);
-		assert("edward-994", !result);
 	}
  out:
 	tfm_cluster_clr_uptodate(&clust->tc);
@@ -2786,10 +2777,10 @@ write_cryptcompress_flow(struct file *fi
 ssize_t write_cryptcompress(struct file *file, const char __user *buf,
 			    size_t count, loff_t *off, int *conv)
 {
-	ssize_t result;
+	ssize_t result = 0;
 	struct inode *inode;
 	reiser4_context *ctx;
-  	loff_t pos;
+  	loff_t pos = *off;
   	cryptcompress_info_t *info;
 
   	assert("edward-1449", *conv == 0);
@@ -2807,26 +2798,21 @@ ssize_t write_cryptcompress(struct file 
 
 	result = generic_write_checks(file, off, &count, 0);
   	if (unlikely(result != 0))
-  		return result;
+		goto unlock;
   	if (unlikely(count == 0))
-  		return 0;
-
-  	down_write(&info->lock);
+		goto unlock;
 
-  	pos = *off;
-  	result = write_cryptcompress_flow(file, inode, buf, count, pos, conv);
+	down_write(&info->lock);
+	result = write_cryptcompress_flow(file, inode, buf, count, pos, conv);
   	if (*conv == 0)
   		up_write(&info->lock);
-
+ unlock:
   	up(&reiser4_inode_data(inode)->mutex_write);
-  	if (result < 0) {
-  		if (result == -EEXIST)
-  			printk("write_cryptcompress_flow returns EEXIST!\n");
-  		return result;
-  	}
+  	if (result < 0)
+		goto out;
   	/* update position in a file */
   	*off = pos + result;
-
+ out:
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
 	return result;
diff -puN fs/reiser4/plugin/plugin.h~reiser4-fix-missed-unlock-and-exit_context fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-fix-missed-unlock-and-exit_context
+++ a/fs/reiser4/plugin/plugin.h
@@ -714,7 +714,6 @@ typedef enum {
 
 typedef enum {
 	NONE_CIPHER_ID,
-	AES_CIPHER_ID,
 	LAST_CIPHER_ID
 } reiser4_cipher_id;
 
diff -puN fs/reiser4/reiser4.h~reiser4-fix-missed-unlock-and-exit_context fs/reiser4/reiser4.h
--- a/fs/reiser4/reiser4.h~reiser4-fix-missed-unlock-and-exit_context
+++ a/fs/reiser4/reiser4.h
@@ -37,12 +37,6 @@
 #define REISER4_SHA256 (0)
 #endif
 
-#if defined(CONFIG_CRYPTO_AES_586)
-#define REISER4_AES (1)
-#else
-#define REISER4_AES (0)
-#endif
-
 /*
  * Turn on large keys mode. In his mode (which is default), reiser4 key has 4
  * 8-byte components. In the old "small key" mode, it's 3 8-byte
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
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
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
