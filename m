From: akpm@linux-foundation.org
Subject: - hfs-handle-more-on-disk-corruptions-without-oopsing.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:22 -0800
Message-ID: <200801131133.m0DBX2cO009811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbYAMLd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: handle more on-disk corruptions without oopsing
has been removed from the -mm tree.  Its filename was
     hfs-handle-more-on-disk-corruptions-without-oopsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: handle more on-disk corruptions without oopsing
From: Eric Sandeen <sandeen@redhat.com>

hfs seems prone to bad things when it encounters on disk corruption.  Many
values are read from disk, and used as lengths to memcpy, as an example. 
This patch fixes up several of these problematic cases.

o sanity check the on-disk maximum key lengths on mount
  (these are set to a defined value at mkfs time and shouldn't differ)
o check on-disk node keylens against the maximum key length for each tree
o fix hfs_btree_open so that going out via free_tree: doesn't wind
  up in hfs_releasepage, which wants to follow the very pointer
  we were trying to set up:
	HFS_SB(sb)->cat_tree = hfs_btree_open()
		...
		failure gets to hfs_releasepage and tries
		to follow HFS_SB(sb)->cat_tree

Tested with the fsfuzzer; it survives more than it used to.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bfind.c |   12 ++++++++++++
 fs/hfs/brec.c  |   15 +++++++++++++--
 fs/hfs/btree.c |   13 ++++++++++++-
 fs/hfs/hfs.h   |    5 +++++
 4 files changed, 42 insertions(+), 3 deletions(-)

diff -puN fs/hfs/bfind.c~hfs-handle-more-on-disk-corruptions-without-oopsing fs/hfs/bfind.c
--- a/fs/hfs/bfind.c~hfs-handle-more-on-disk-corruptions-without-oopsing
+++ a/fs/hfs/bfind.c
@@ -52,6 +52,10 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		rec = (e + b) / 2;
 		len = hfs_brec_lenoff(bnode, rec, &off);
 		keylen = hfs_brec_keylen(bnode, rec);
+		if (keylen == HFS_BAD_KEYLEN) {
+			res = -EINVAL;
+			goto done;
+		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 		cmpval = bnode->tree->keycmp(fd->key, fd->search_key);
 		if (!cmpval) {
@@ -67,6 +71,10 @@ int __hfs_brec_find(struct hfs_bnode *bn
 	if (rec != e && e >= 0) {
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
+		if (keylen == HFS_BAD_KEYLEN) {
+			res = -EINVAL;
+			goto done;
+		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 	}
 done:
@@ -198,6 +206,10 @@ int hfs_brec_goto(struct hfs_find_data *
 
 	len = hfs_brec_lenoff(bnode, fd->record, &off);
 	keylen = hfs_brec_keylen(bnode, fd->record);
+	if (keylen == HFS_BAD_KEYLEN) {
+		res = -EINVAL;
+		goto out;
+	}
 	fd->keyoffset = off;
 	fd->keylength = keylen;
 	fd->entryoffset = off + keylen;
diff -puN fs/hfs/brec.c~hfs-handle-more-on-disk-corruptions-without-oopsing fs/hfs/brec.c
--- a/fs/hfs/brec.c~hfs-handle-more-on-disk-corruptions-without-oopsing
+++ a/fs/hfs/brec.c
@@ -44,10 +44,21 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 		recoff = hfs_bnode_read_u16(node, node->tree->node_size - (rec + 1) * 2);
 		if (!recoff)
 			return 0;
-		if (node->tree->attributes & HFS_TREE_BIGKEYS)
+		if (node->tree->attributes & HFS_TREE_BIGKEYS) {
 			retval = hfs_bnode_read_u16(node, recoff) + 2;
-		else
+			if (retval > node->tree->max_key_len + 2) {
+				printk(KERN_ERR "hfs: keylen %d too large\n",
+					retval);
+				retval = HFS_BAD_KEYLEN;
+			}
+		} else {
 			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
+			if (retval > node->tree->max_key_len + 1) {
+				printk(KERN_ERR "hfs: keylen %d too large\n",
+					retval);
+				retval = HFS_BAD_KEYLEN;
+			}
+		}
 	}
 	return retval;
 }
diff -puN fs/hfs/btree.c~hfs-handle-more-on-disk-corruptions-without-oopsing fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-handle-more-on-disk-corruptions-without-oopsing
+++ a/fs/hfs/btree.c
@@ -81,6 +81,17 @@ struct hfs_btree *hfs_btree_open(struct 
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
+	if ((id == HFS_EXT_CNID) && (tree->max_key_len != HFS_MAX_EXT_KEYLEN)) {
+		printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
+			tree->max_key_len);
+		goto fail_page;
+	}
+	if ((id == HFS_CAT_CNID) && (tree->max_key_len != HFS_MAX_CAT_KEYLEN)) {
+		printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
+			tree->max_key_len);
+		goto fail_page;
+	}
+
 	tree->node_size_shift = ffs(size) - 1;
 	tree->pages_per_bnode = (tree->node_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
@@ -89,9 +100,9 @@ struct hfs_btree *hfs_btree_open(struct 
 	return tree;
 
  fail_page:
-	tree->inode->i_mapping->a_ops = &hfs_aops;
 	page_cache_release(page);
  free_tree:
+	tree->inode->i_mapping->a_ops = &hfs_aops;
 	iput(tree->inode);
 	kfree(tree);
 	return NULL;
diff -puN fs/hfs/hfs.h~hfs-handle-more-on-disk-corruptions-without-oopsing fs/hfs/hfs.h
--- a/fs/hfs/hfs.h~hfs-handle-more-on-disk-corruptions-without-oopsing
+++ a/fs/hfs/hfs.h
@@ -28,6 +28,8 @@
 #define HFS_MAX_NAMELEN		128
 #define HFS_MAX_VALENCE		32767U
 
+#define HFS_BAD_KEYLEN		0xFF
+
 /* Meanings of the drAtrb field of the MDB,
  * Reference: _Inside Macintosh: Files_ p. 2-61
  */
@@ -167,6 +169,9 @@ typedef union hfs_btree_key {
 	struct hfs_ext_key ext;
 } hfs_btree_key;
 
+#define HFS_MAX_CAT_KEYLEN	(sizeof(struct hfs_cat_key) - sizeof(u8))
+#define HFS_MAX_EXT_KEYLEN	(sizeof(struct hfs_ext_key) - sizeof(u8))
+
 typedef union hfs_btree_key btree_key;
 
 struct hfs_extent {
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
git-kbuild.patch
ext2-change-the-default-behaviour-on-error.patch
export-iov_shorten-for-ext4s-use.patch
export-iov_shorten-for-ext4s-use-fix.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
ext3-change-the-default-behaviour-on-error.patch
