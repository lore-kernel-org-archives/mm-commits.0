From: akpm@linux-foundation.org
Subject: + ext2-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:22 -0800
Message-ID: <200803052220.m25MKMMI024003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765036AbYCEWUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     ext2: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     ext2-replace-remaining-__function__-occurrences.patch

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
@@ -64,7 +64,7 @@ void ext2_xip_verify_sb(struct super_blo
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

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
ext4-replace-remaining-__function__-occurrences.patch
nfs-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cifs-replace-remaining-__function__-occurrences.patch
reiserfs-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch

