From: akpm@linux-foundation.org
Subject: + address-hfs-on-disk-corruption-robustness-review-comments.patch added to -mm tree
Date: Mon, 14 Jan 2008 15:17:06 -0800
Message-ID: <200801142317.m0ENH6G6020304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbYANXRx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jan 2008 18:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, zippel@linux-m68k.org


The patch titled
     address hfs on-disk corruption robustness review comments
has been added to the -mm tree.  Its filename is
     address-hfs-on-disk-corruption-robustness-review-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: address hfs on-disk corruption robustness review comments
From: Eric Sandeen <sandeen@redhat.com>

Address Roman's review comments for the previously sent on-disk
corruption hfs robustness patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/bfind.c |   11 ++++++-----
 fs/hfs/brec.c  |    4 ++--
 fs/hfs/btree.c |   26 +++++++++++++++++---------
 fs/hfs/hfs.h   |    2 --
 4 files changed, 25 insertions(+), 18 deletions(-)

diff -puN fs/hfs/bfind.c~address-hfs-on-disk-corruption-robustness-review-comments fs/hfs/bfind.c
--- a/fs/hfs/bfind.c~address-hfs-on-disk-corruption-robustness-review-comments
+++ a/fs/hfs/bfind.c
@@ -52,9 +52,9 @@ int __hfs_brec_find(struct hfs_bnode *bn
 		rec = (e + b) / 2;
 		len = hfs_brec_lenoff(bnode, rec, &off);
 		keylen = hfs_brec_keylen(bnode, rec);
-		if (keylen == HFS_BAD_KEYLEN) {
+		if (keylen == 0) {
 			res = -EINVAL;
-			goto done;
+			goto fail;
 		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 		cmpval = bnode->tree->keycmp(fd->key, fd->search_key);
@@ -71,9 +71,9 @@ int __hfs_brec_find(struct hfs_bnode *bn
 	if (rec != e && e >= 0) {
 		len = hfs_brec_lenoff(bnode, e, &off);
 		keylen = hfs_brec_keylen(bnode, e);
-		if (keylen == HFS_BAD_KEYLEN) {
+		if (keylen == 0) {
 			res = -EINVAL;
-			goto done;
+			goto fail;
 		}
 		hfs_bnode_read(bnode, fd->key, off, keylen);
 	}
@@ -83,6 +83,7 @@ done:
 	fd->keylength = keylen;
 	fd->entryoffset = off + keylen;
 	fd->entrylength = len - keylen;
+fail:
 	return res;
 }
 
@@ -206,7 +207,7 @@ int hfs_brec_goto(struct hfs_find_data *
 
 	len = hfs_brec_lenoff(bnode, fd->record, &off);
 	keylen = hfs_brec_keylen(bnode, fd->record);
-	if (keylen == HFS_BAD_KEYLEN) {
+	if (keylen == 0) {
 		res = -EINVAL;
 		goto out;
 	}
diff -puN fs/hfs/brec.c~address-hfs-on-disk-corruption-robustness-review-comments fs/hfs/brec.c
--- a/fs/hfs/brec.c~address-hfs-on-disk-corruption-robustness-review-comments
+++ a/fs/hfs/brec.c
@@ -49,14 +49,14 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
 			if (retval > node->tree->max_key_len + 2) {
 				printk(KERN_ERR "hfs: keylen %d too large\n",
 					retval);
-				retval = HFS_BAD_KEYLEN;
+				retval = 0;
 			}
 		} else {
 			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
 			if (retval > node->tree->max_key_len + 1) {
 				printk(KERN_ERR "hfs: keylen %d too large\n",
 					retval);
-				retval = HFS_BAD_KEYLEN;
+				retval = 0;
 			}
 		}
 	}
diff -puN fs/hfs/btree.c~address-hfs-on-disk-corruption-robustness-review-comments fs/hfs/btree.c
--- a/fs/hfs/btree.c~address-hfs-on-disk-corruption-robustness-review-comments
+++ a/fs/hfs/btree.c
@@ -81,15 +81,23 @@ struct hfs_btree *hfs_btree_open(struct 
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
-	if ((id == HFS_EXT_CNID) && (tree->max_key_len != HFS_MAX_EXT_KEYLEN)) {
-		printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
-			tree->max_key_len);
-		goto fail_page;
-	}
-	if ((id == HFS_CAT_CNID) && (tree->max_key_len != HFS_MAX_CAT_KEYLEN)) {
-		printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
-			tree->max_key_len);
-		goto fail_page;
+	switch(id) {
+	case HFS_EXT_CNID:
+		if (tree->max_key_len != HFS_MAX_EXT_KEYLEN) {
+			printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
+				tree->max_key_len);
+			goto fail_page;
+		}
+		break;
+	case HFS_CAT_CNID:
+		if (tree->max_key_len != HFS_MAX_CAT_KEYLEN) {
+			printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
+				tree->max_key_len);
+			goto fail_page;
+		}
+		break;
+	default:
+		BUG();
 	}
 
 	tree->node_size_shift = ffs(size) - 1;
diff -puN fs/hfs/hfs.h~address-hfs-on-disk-corruption-robustness-review-comments fs/hfs/hfs.h
--- a/fs/hfs/hfs.h~address-hfs-on-disk-corruption-robustness-review-comments
+++ a/fs/hfs/hfs.h
@@ -28,8 +28,6 @@
 #define HFS_MAX_NAMELEN		128
 #define HFS_MAX_VALENCE		32767U
 
-#define HFS_BAD_KEYLEN		0xFF
-
 /* Meanings of the drAtrb field of the MDB,
  * Reference: _Inside Macintosh: Files_ p. 2-61
  */
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
hfs-fix-coverity-found-null-deref.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
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
