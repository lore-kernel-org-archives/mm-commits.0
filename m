From: akpm@osdl.org
Subject: - struct-path-convert-s390.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:52 -0800
Message-ID: <200612082004.kB8K4qfi002238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426307AbWLHUE5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert s390
has been removed from the -mm tree.  Its filename was
     struct-path-convert-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert s390
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/s390/hypfs/inode.c  |    4 ++--
 arch/s390/kernel/debug.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/s390/hypfs/inode.c~struct-path-convert-s390 arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~struct-path-convert-s390
+++ a/arch/s390/hypfs/inode.c
@@ -109,7 +109,7 @@ static void hypfs_drop_inode(struct inod
 
 static int hypfs_open(struct inode *inode, struct file *filp)
 {
-	char *data = filp->f_dentry->d_inode->i_private;
+	char *data = filp->f_path.dentry->d_inode->i_private;
 	struct hypfs_sb_info *fs_info;
 
 	if (filp->f_mode & FMODE_WRITE) {
@@ -174,7 +174,7 @@ static ssize_t hypfs_aio_write(struct ki
 	struct hypfs_sb_info *fs_info;
 	size_t count = iov_length(iov, nr_segs);
 
-	sb = iocb->ki_filp->f_dentry->d_inode->i_sb;
+	sb = iocb->ki_filp->f_path.dentry->d_inode->i_sb;
 	fs_info = sb->s_fs_info;
 	/*
 	 * Currently we only allow one update per second for two reasons:
diff -puN arch/s390/kernel/debug.c~struct-path-convert-s390 arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~struct-path-convert-s390
+++ a/arch/s390/kernel/debug.c
@@ -603,13 +603,13 @@ debug_open(struct inode *inode, struct f
 	debug_info_t *debug_info, *debug_info_snapshot;
 
 	down(&debug_lock);
-	debug_info = file->f_dentry->d_inode->i_private;
+	debug_info = file->f_path.dentry->d_inode->i_private;
 	/* find debug view */
 	for (i = 0; i < DEBUG_MAX_VIEWS; i++) {
 		if (!debug_info->views[i])
 			continue;
 		else if (debug_info->debugfs_entries[i] ==
-			 file->f_dentry) {
+			 file->f_path.dentry) {
 			goto found;	/* found view ! */
 		}
 	}
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

