From: akpm@linux-foundation.org
Subject: - ufs-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:06 -0700
Message-ID: <200804282201.m3SM161Q018816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965739AbYD1WBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jengelh@linux01.gwdg.de, mm-commits@vger.kernel.org


The patch titled
     ufs: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     ufs-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

