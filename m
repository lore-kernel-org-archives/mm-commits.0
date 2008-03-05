From: akpm@linux-foundation.org
Subject: + ufs-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:40 -0800
Message-ID: <200803052220.m25MKeKm024030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbYCEW3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 17:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jengelh@linux01.gwdg.de


The patch titled
     ufs: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     ufs-replace-remaining-__function__-occurrences.patch

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
Subject: ufs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |    4 ++--
 fs/ufs/dir.c    |   14 +++++++-------
 fs/ufs/inode.c  |    2 +-
 fs/ufs/ufs.h    |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-replace-remaining-__function__-occurrences fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-replace-remaining-__function__-occurrences
+++ a/fs/ufs/balloc.c
@@ -277,7 +277,7 @@ static void ufs_change_blocknr(struct in
 			if (!page)/* it was truncated */
 				continue;
 			if (IS_ERR(page)) {/* or EIO */
-				ufs_error(inode->i_sb, __FUNCTION__,
+				ufs_error(inode->i_sb, __func__,
 					  "read of page %llu failed\n",
 					  (unsigned long long)index);
 				continue;
@@ -308,7 +308,7 @@ static void ufs_change_blocknr(struct in
 				ll_rw_block(READ, 1, &bh);
 				wait_on_buffer(bh);
 				if (!buffer_uptodate(bh)) {
-					ufs_error(inode->i_sb, __FUNCTION__,
+					ufs_error(inode->i_sb, __func__,
 						  "read of block failed\n");
 					break;
 				}
diff -puN fs/ufs/dir.c~ufs-replace-remaining-__function__-occurrences fs/ufs/dir.c
--- a/fs/ufs/dir.c~ufs-replace-remaining-__function__-occurrences
+++ a/fs/ufs/dir.c
@@ -179,7 +179,7 @@ bad_entry:
 	goto fail;
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
-	ufs_error(sb, __FUNCTION__,
+	ufs_error(sb, __func__,
 		   "entry in directory #%lu spans the page boundary"
 		   "offset=%lu",
 		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
@@ -284,7 +284,7 @@ struct ufs_dir_entry *ufs_find_entry(str
 			kaddr += ufs_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
 				if (de->d_reclen == 0) {
-					ufs_error(dir->i_sb, __FUNCTION__,
+					ufs_error(dir->i_sb, __func__,
 						  "zero-length directory entry");
 					ufs_put_page(page);
 					goto out;
@@ -356,7 +356,7 @@ int ufs_add_link(struct dentry *dentry, 
 				goto got_it;
 			}
 			if (de->d_reclen == 0) {
-				ufs_error(dir->i_sb, __FUNCTION__,
+				ufs_error(dir->i_sb, __func__,
 					  "zero-length directory entry");
 				err = -EIO;
 				goto out_unlock;
@@ -456,7 +456,7 @@ ufs_readdir(struct file *filp, void *dir
 		struct page *page = ufs_get_page(inode, n);
 
 		if (IS_ERR(page)) {
-			ufs_error(sb, __FUNCTION__,
+			ufs_error(sb, __func__,
 				  "bad page in #%lu",
 				  inode->i_ino);
 			filp->f_pos += PAGE_CACHE_SIZE - offset;
@@ -475,7 +475,7 @@ ufs_readdir(struct file *filp, void *dir
 		limit = kaddr + ufs_last_byte(inode, n) - UFS_DIR_REC_LEN(1);
 		for ( ;(char*)de <= limit; de = ufs_next_entry(sb, de)) {
 			if (de->d_reclen == 0) {
-				ufs_error(sb, __FUNCTION__,
+				ufs_error(sb, __func__,
 					"zero-length directory entry");
 				ufs_put_page(page);
 				return -EIO;
@@ -536,7 +536,7 @@ int ufs_delete_entry(struct inode *inode
 
 	while ((char*)de < (char*)dir) {
 		if (de->d_reclen == 0) {
-			ufs_error(inode->i_sb, __FUNCTION__,
+			ufs_error(inode->i_sb, __func__,
 				  "zero-length directory entry");
 			err = -EIO;
 			goto out;
@@ -633,7 +633,7 @@ int ufs_empty_dir(struct inode * inode)
 
 		while ((char *)de <= kaddr) {
 			if (de->d_reclen == 0) {
-				ufs_error(inode->i_sb, __FUNCTION__,
+				ufs_error(inode->i_sb, __func__,
 					"zero-length directory entry: "
 					"kaddr=%p, de=%p\n", kaddr, de);
 				goto not_empty;
diff -puN fs/ufs/inode.c~ufs-replace-remaining-__function__-occurrences fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-replace-remaining-__function__-occurrences
+++ a/fs/ufs/inode.c
@@ -929,7 +929,7 @@ void ufs_delete_inode (struct inode * in
 	old_i_size = inode->i_size;
 	inode->i_size = 0;
 	if (inode->i_blocks && ufs_truncate(inode, old_i_size))
-		ufs_warning(inode->i_sb, __FUNCTION__, "ufs_truncate failed\n");
+		ufs_warning(inode->i_sb, __func__, "ufs_truncate failed\n");
 	ufs_free_inode (inode);
 	unlock_kernel();
 	return;
diff -puN fs/ufs/ufs.h~ufs-replace-remaining-__function__-occurrences fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~ufs-replace-remaining-__function__-occurrences
+++ a/fs/ufs/ufs.h
@@ -66,7 +66,7 @@ struct ufs_inode_info {
 #ifdef CONFIG_UFS_DEBUG
 #	define UFSD(f, a...)	{					\
 		printk ("UFSD (%s, %d): %s:",				\
-			__FILE__, __LINE__, __FUNCTION__);		\
+			__FILE__, __LINE__, __func__);		\
 		printk (f, ## a);					\
 	}
 #else
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

