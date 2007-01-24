From: akpm@osdl.org
Subject: + remove-ext_inc_count-and-_dec_count.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:52:58 -0800
Message-ID: <200701240352.l0O3qwrS007730@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50007 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030183AbXAXDxG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     remove ext[34]_inc_count and _dec_count
has been added to the -mm tree.  Its filename is
     remove-ext_inc_count-and-_dec_count.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove ext[34]_inc_count and _dec_count
From: Eric Sandeen <sandeen@redhat.com>

- Naming is confusing, ext3_inc_count manipulates i_nlink not i_count
- handle argument passed in is not used
- ext3 and ext4 already call inc_nlink and dec_nlink directly in other places

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/namei.c |   21 +++------------------
 fs/ext4/namei.c |   21 +++------------------
 2 files changed, 6 insertions(+), 36 deletions(-)

diff -puN fs/ext3/namei.c~remove-ext_inc_count-and-_dec_count fs/ext3/namei.c
--- a/fs/ext3/namei.c~remove-ext_inc_count-and-_dec_count
+++ a/fs/ext3/namei.c
@@ -1618,21 +1618,6 @@ static int ext3_delete_entry (handle_t *
 	return -ENOENT;
 }
 
-/*
- * ext3_mark_inode_dirty is somewhat expensive, so unlike ext2 we
- * do not perform it in these functions.  We perform it at the call site,
- * if it is needed.
- */
-static inline void ext3_inc_count(handle_t *handle, struct inode *inode)
-{
-	inc_nlink(inode);
-}
-
-static inline void ext3_dec_count(handle_t *handle, struct inode *inode)
-{
-	drop_nlink(inode);
-}
-
 static int ext3_add_nondir(handle_t *handle,
 		struct dentry *dentry, struct inode *inode)
 {
@@ -1642,7 +1627,7 @@ static int ext3_add_nondir(handle_t *han
 		d_instantiate(dentry, inode);
 		return 0;
 	}
-	ext3_dec_count(handle, inode);
+	drop_nlink(inode);
 	iput(inode);
 	return err;
 }
@@ -2163,7 +2148,7 @@ retry:
 		err = __page_symlink(inode, symname, l,
 				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 		if (err) {
-			ext3_dec_count(handle, inode);
+			drop_nlink(inode);
 			ext3_mark_inode_dirty(handle, inode);
 			iput (inode);
 			goto out_stop;
@@ -2208,7 +2193,7 @@ retry:
 		handle->h_sync = 1;
 
 	inode->i_ctime = CURRENT_TIME_SEC;
-	ext3_inc_count(handle, inode);
+	inc_nlink(inode);
 	atomic_inc(&inode->i_count);
 
 	err = ext3_add_nondir(handle, dentry, inode);
diff -puN fs/ext4/namei.c~remove-ext_inc_count-and-_dec_count fs/ext4/namei.c
--- a/fs/ext4/namei.c~remove-ext_inc_count-and-_dec_count
+++ a/fs/ext4/namei.c
@@ -1616,21 +1616,6 @@ static int ext4_delete_entry (handle_t *
 	return -ENOENT;
 }
 
-/*
- * ext4_mark_inode_dirty is somewhat expensive, so unlike ext2 we
- * do not perform it in these functions.  We perform it at the call site,
- * if it is needed.
- */
-static inline void ext4_inc_count(handle_t *handle, struct inode *inode)
-{
-	inc_nlink(inode);
-}
-
-static inline void ext4_dec_count(handle_t *handle, struct inode *inode)
-{
-	drop_nlink(inode);
-}
-
 static int ext4_add_nondir(handle_t *handle,
 		struct dentry *dentry, struct inode *inode)
 {
@@ -1640,7 +1625,7 @@ static int ext4_add_nondir(handle_t *han
 		d_instantiate(dentry, inode);
 		return 0;
 	}
-	ext4_dec_count(handle, inode);
+	drop_nlink(inode);
 	iput(inode);
 	return err;
 }
@@ -2161,7 +2146,7 @@ retry:
 		err = __page_symlink(inode, symname, l,
 				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 		if (err) {
-			ext4_dec_count(handle, inode);
+			drop_nlink(inode);
 			ext4_mark_inode_dirty(handle, inode);
 			iput (inode);
 			goto out_stop;
@@ -2206,7 +2191,7 @@ retry:
 		handle->h_sync = 1;
 
 	inode->i_ctime = CURRENT_TIME_SEC;
-	ext4_inc_count(handle, inode);
+	inc_nlink(inode);
 	atomic_inc(&inode->i_count);
 
 	err = ext4_add_nondir(handle, dentry, inode);
_

Patches currently in -mm which might be from sandeen@redhat.com are

ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch
ext3-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
ext4-refuse-ro-to-rw-remount-of-fs-with-orphan.patch
return-enoent-from-ext3_link-when-racing-with-unlink.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
remove-ext_inc_count-and-_dec_count.patch
