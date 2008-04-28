From: akpm@linux-foundation.org
Subject: - ncpfs-add-prototypes-to-ncp_fsh.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:06 -0700
Message-ID: <200804282155.m3SLt6BY018074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934904AbYD1VzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, VANDROVE@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     ncpfs: add prototypes to ncp_fs.h
has been removed from the -mm tree.  Its filename was
     ncpfs-add-prototypes-to-ncp_fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ncpfs: add prototypes to ncp_fs.h
From: Harvey Harrison <harvey.harrison@gmail.com>

Removes some externs from C files, noticed from the sparse warnings:
fs/ncpfs/dir.c:90:26: warning: symbol 'ncp_root_dentry_operations' was not declared. Should it be static?
fs/ncpfs/symlink.c:107:5: warning: symbol 'ncp_symlink' was not declared. Should it be static?
fs/ncpfs/symlink.c:101:39: warning: symbol 'ncp_symlink_aops' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c       |    6 ------
 include/linux/ncp_fs.h |    7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-add-prototypes-to-ncp_fsh fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-add-prototypes-to-ncp_fsh
+++ a/fs/ncpfs/inode.c
@@ -107,12 +107,6 @@ static const struct super_operations ncp
 	.show_options	= ncp_show_options,
 };
 
-extern struct dentry_operations ncp_root_dentry_operations;
-#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
-extern const struct address_space_operations ncp_symlink_aops;
-extern int ncp_symlink(struct inode*, struct dentry*, const char*);
-#endif
-
 /*
  * Fill in the ncpfs-specific information in the inode.
  */
diff -puN include/linux/ncp_fs.h~ncpfs-add-prototypes-to-ncp_fsh include/linux/ncp_fs.h
--- a/include/linux/ncp_fs.h~ncpfs-add-prototypes-to-ncp_fsh
+++ a/include/linux/ncp_fs.h
@@ -204,6 +204,7 @@ void ncp_update_inode2(struct inode *, s
 /* linux/fs/ncpfs/dir.c */
 extern const struct inode_operations ncp_dir_inode_operations;
 extern const struct file_operations ncp_dir_operations;
+extern struct dentry_operations ncp_root_dentry_operations;
 int ncp_conn_logged_in(struct super_block *);
 int ncp_date_dos2unix(__le16 time, __le16 date);
 void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
@@ -223,6 +224,12 @@ int ncp_disconnect(struct ncp_server *se
 void ncp_lock_server(struct ncp_server *server);
 void ncp_unlock_server(struct ncp_server *server);
 
+/* linux/fs/ncpfs/symlink.c */
+#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
+extern const struct address_space_operations ncp_symlink_aops;
+int ncp_symlink(struct inode*, struct dentry*, const char*);
+#endif
+
 /* linux/fs/ncpfs/file.c */
 extern const struct inode_operations ncp_file_inode_operations;
 extern const struct file_operations ncp_file_operations;
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

