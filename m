From: akpm@linux-foundation.org
Subject: - ext2-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:24 -0700
Message-ID: <200804282200.m3SM0OHw018693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965543AbYD1WA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext2: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     ext2-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |   10 +++++-----
 fs/ext2/dir.c    |   14 +++++++-------
 fs/ext2/super.c  |    6 +++---
 fs/ext2/xip.c    |    2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/ext2/balloc.c~ext2-replace-remaining-__function__-occurrences fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~ext2-replace-remaining-__function__-occurrences
+++ a/fs/ext2/balloc.c
@@ -106,7 +106,7 @@ static int ext2_valid_block_bitmap(struc
 		return 1;
 
 err_out:
-	ext2_error(sb, __FUNCTION__,
+	ext2_error(sb, __func__,
 			"Invalid block bitmap - "
 			"block_group = %d, block = %lu",
 			block_group, bitmap_blk);
@@ -132,7 +132,7 @@ read_block_bitmap(struct super_block *sb
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-		ext2_error(sb, __FUNCTION__,
+		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -143,7 +143,7 @@ read_block_bitmap(struct super_block *sb
 
 	if (bh_submit_read(bh) < 0) {
 		brelse(bh);
-		ext2_error(sb, __FUNCTION__,
+		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %u",
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
@@ -248,7 +248,7 @@ restart:
 	BUG_ON(bad);
 }
 #define rsv_window_dump(root, verbose) \
-	__rsv_window_dump((root), (verbose), __FUNCTION__)
+	__rsv_window_dump((root), (verbose), __func__)
 #else
 #define rsv_window_dump(root, verbose) do {} while (0)
 #endif
@@ -547,7 +547,7 @@ do_more:
 	for (i = 0, group_freed = 0; i < count; i++) {
 		if (!ext2_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
 						bit + i, bitmap_bh->b_data)) {
-			ext2_error(sb, __FUNCTION__,
+			ext2_error(sb, __func__,
 				"bit already cleared for block %lu", block + i);
 		} else {
 			group_freed++;
diff -puN fs/ext2/dir.c~ext2-replace-remaining-__function__-occurrences fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-replace-remaining-__function__-occurrences
+++ a/fs/ext2/dir.c
@@ -295,7 +295,7 @@ ext2_readdir (struct file * filp, void *
 		struct page *page = ext2_get_page(inode, n);
 
 		if (IS_ERR(page)) {
-			ext2_error(sb, __FUNCTION__,
+			ext2_error(sb, __func__,
 				   "bad page in #%lu",
 				   inode->i_ino);
 			filp->f_pos += PAGE_CACHE_SIZE - offset;
@@ -314,7 +314,7 @@ ext2_readdir (struct file * filp, void *
 		limit = kaddr + ext2_last_byte(inode, n) - EXT2_DIR_REC_LEN(1);
 		for ( ;(char*)de <= limit; de = ext2_next_entry(de)) {
 			if (de->rec_len == 0) {
-				ext2_error(sb, __FUNCTION__,
+				ext2_error(sb, __func__,
 					"zero-length directory entry");
 				ext2_put_page(page);
 				return -EIO;
@@ -381,7 +381,7 @@ struct ext2_dir_entry_2 * ext2_find_entr
 			kaddr += ext2_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
 				if (de->rec_len == 0) {
-					ext2_error(dir->i_sb, __FUNCTION__,
+					ext2_error(dir->i_sb, __func__,
 						"zero-length directory entry");
 					ext2_put_page(page);
 					goto out;
@@ -396,7 +396,7 @@ struct ext2_dir_entry_2 * ext2_find_entr
 			n = 0;
 		/* next page is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
-			ext2_error(dir->i_sb, __FUNCTION__,
+			ext2_error(dir->i_sb, __func__,
 				"dir %lu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
 				(unsigned long long)dir->i_blocks);
@@ -506,7 +506,7 @@ int ext2_add_link (struct dentry *dentry
 				goto got_it;
 			}
 			if (de->rec_len == 0) {
-				ext2_error(dir->i_sb, __FUNCTION__,
+				ext2_error(dir->i_sb, __func__,
 					"zero-length directory entry");
 				err = -EIO;
 				goto out_unlock;
@@ -578,7 +578,7 @@ int ext2_delete_entry (struct ext2_dir_e
 
 	while ((char*)de < (char*)dir) {
 		if (de->rec_len == 0) {
-			ext2_error(inode->i_sb, __FUNCTION__,
+			ext2_error(inode->i_sb, __func__,
 				"zero-length directory entry");
 			err = -EIO;
 			goto out;
@@ -670,7 +670,7 @@ int ext2_empty_dir (struct inode * inode
 
 		while ((char *)de <= kaddr) {
 			if (de->rec_len == 0) {
-				ext2_error(inode->i_sb, __FUNCTION__,
+				ext2_error(inode->i_sb, __func__,
 					"zero-length directory entry");
 				printk("kaddr=%p, de=%p\n", kaddr, de);
 				goto not_empty;
diff -puN fs/ext2/super.c~ext2-replace-remaining-__function__-occurrences fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-replace-remaining-__function__-occurrences
+++ a/fs/ext2/super.c
@@ -89,7 +89,7 @@ void ext2_update_dynamic_rev(struct supe
 	if (le32_to_cpu(es->s_rev_level) > EXT2_GOOD_OLD_REV)
 		return;
 
-	ext2_warning(sb, __FUNCTION__,
+	ext2_warning(sb, __func__,
 		     "updating to rev %d because of new feature flag, "
 		     "running e2fsck is recommended",
 		     EXT2_DYNAMIC_REV);
@@ -1060,7 +1060,7 @@ static int ext2_fill_super(struct super_
 		goto failed_mount3;
 	}
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
-		ext2_warning(sb, __FUNCTION__,
+		ext2_warning(sb, __func__,
 			"mounting ext3 filesystem as ext2");
 	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
 	return 0;
@@ -1177,7 +1177,7 @@ static int ext2_remount (struct super_bl
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
 	    invalidate_inodes(sb))
-		ext2_warning(sb, __FUNCTION__, "busy inodes while remounting "\
+		ext2_warning(sb, __func__, "busy inodes while remounting "\
 			     "xip remain in cache (no functional problem)");
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
diff -puN fs/ext2/xip.c~ext2-replace-remaining-__function__-occurrences fs/ext2/xip.c
--- a/fs/ext2/xip.c~ext2-replace-remaining-__function__-occurrences
+++ a/fs/ext2/xip.c
@@ -68,7 +68,7 @@ void ext2_xip_verify_sb(struct super_blo
 	if ((sbi->s_mount_opt & EXT2_MOUNT_XIP) &&
 	    !sb->s_bdev->bd_disk->fops->direct_access) {
 		sbi->s_mount_opt &= (~EXT2_MOUNT_XIP);
-		ext2_warning(sb, __FUNCTION__,
+		ext2_warning(sb, __func__,
 			     "ignoring xip option - not supported by bdev");
 	}
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

