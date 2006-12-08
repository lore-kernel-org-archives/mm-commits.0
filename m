From: akpm@osdl.org
Subject: - struct-path-convert-ocfs2.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:26 -0800
Message-ID: <200612082004.kB8K4QJG002181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57312 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426260AbWLHUEb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert ocfs2
has been removed from the -mm tree.  Its filename was
     struct-path-convert-ocfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert ocfs2
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ocfs2/aops.c      |    4 ++--
 fs/ocfs2/dir.c       |    2 +-
 fs/ocfs2/dlm/dlmfs.c |    4 ++--
 fs/ocfs2/file.c      |   34 +++++++++++++++++-----------------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff -puN fs/ocfs2/aops.c~struct-path-convert-ocfs2 fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~struct-path-convert-ocfs2
+++ a/fs/ocfs2/aops.c
@@ -595,7 +595,7 @@ static void ocfs2_dio_end_io(struct kioc
 			     ssize_t bytes,
 			     void *private)
 {
-	struct inode *inode = iocb->ki_filp->f_dentry->d_inode;
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
@@ -611,7 +611,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 			       unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode->i_mapping->host;
+	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	int ret;
 
 	mlog_entry_void();
diff -puN fs/ocfs2/dir.c~struct-path-convert-ocfs2 fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~struct-path-convert-ocfs2
+++ a/fs/ocfs2/dir.c
@@ -79,7 +79,7 @@ int ocfs2_readdir(struct file * filp, vo
 	struct buffer_head * bh, * tmp;
 	struct ocfs2_dir_entry * de;
 	int err;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
 	int lock_level = 0;
diff -puN fs/ocfs2/dlm/dlmfs.c~struct-path-convert-ocfs2 fs/ocfs2/dlm/dlmfs.c
--- a/fs/ocfs2/dlm/dlmfs.c~struct-path-convert-ocfs2
+++ a/fs/ocfs2/dlm/dlmfs.c
@@ -176,7 +176,7 @@ static ssize_t dlmfs_file_read(struct fi
 	int bytes_left;
 	ssize_t readlen;
 	char *lvb_buf;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
@@ -220,7 +220,7 @@ static ssize_t dlmfs_file_write(struct f
 	int bytes_left;
 	ssize_t writelen;
 	char *lvb_buf;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	mlog(0, "inode %lu, count = %zu, *ppos = %llu\n",
 		inode->i_ino, count, *ppos);
diff -puN fs/ocfs2/file.c~struct-path-convert-ocfs2 fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~struct-path-convert-ocfs2
+++ a/fs/ocfs2/file.c
@@ -68,7 +68,7 @@ static int ocfs2_file_open(struct inode 
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		   file->f_dentry->d_name.len, file->f_dentry->d_name.name);
+		   file->f_path.dentry->d_name.len, file->f_path.dentry->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 
@@ -98,8 +98,8 @@ static int ocfs2_file_release(struct ino
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", inode, file,
-		       file->f_dentry->d_name.len,
-		       file->f_dentry->d_name.name);
+		       file->f_path.dentry->d_name.len,
+		       file->f_path.dentry->d_name.name);
 
 	spin_lock(&oi->ip_lock);
 	if (!--oi->ip_open_count)
@@ -1131,13 +1131,13 @@ static ssize_t ocfs2_file_aio_write(stru
 {
 	int ret, rw_level, have_alloc_sem = 0;
 	struct file *filp = iocb->ki_filp;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int appending = filp->f_flags & O_APPEND ? 1 : 0;
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
 		   (unsigned int)nr_segs,
-		   filp->f_dentry->d_name.len,
-		   filp->f_dentry->d_name.name);
+		   filp->f_path.dentry->d_name.len,
+		   filp->f_path.dentry->d_name.name);
 
 	/* happy write of zero bytes */
 	if (iocb->ki_left == 0)
@@ -1159,7 +1159,7 @@ static ssize_t ocfs2_file_aio_write(stru
 		goto out;
 	}
 
-	ret = ocfs2_prepare_inode_for_write(filp->f_dentry, &iocb->ki_pos,
+	ret = ocfs2_prepare_inode_for_write(filp->f_path.dentry, &iocb->ki_pos,
 					    iocb->ki_left, appending);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -1207,12 +1207,12 @@ static ssize_t ocfs2_file_splice_write(s
 				       unsigned int flags)
 {
 	int ret;
-	struct inode *inode = out->f_dentry->d_inode;
+	struct inode *inode = out->f_path.dentry->d_inode;
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
 		   (unsigned int)len,
-		   out->f_dentry->d_name.len,
-		   out->f_dentry->d_name.name);
+		   out->f_path.dentry->d_name.len,
+		   out->f_path.dentry->d_name.name);
 
 	inode_double_lock(inode, pipe->inode);
 
@@ -1222,7 +1222,7 @@ static ssize_t ocfs2_file_splice_write(s
 		goto out;
 	}
 
-	ret = ocfs2_prepare_inode_for_write(out->f_dentry, ppos, len, 0);
+	ret = ocfs2_prepare_inode_for_write(out->f_path.dentry, ppos, len, 0);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_unlock;
@@ -1247,12 +1247,12 @@ static ssize_t ocfs2_file_splice_read(st
 				      unsigned int flags)
 {
 	int ret = 0;
-	struct inode *inode = in->f_dentry->d_inode;
+	struct inode *inode = in->f_path.dentry->d_inode;
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
 		   (unsigned int)len,
-		   in->f_dentry->d_name.len,
-		   in->f_dentry->d_name.name);
+		   in->f_path.dentry->d_name.len,
+		   in->f_path.dentry->d_name.name);
 
 	/*
 	 * See the comment in ocfs2_file_aio_read()
@@ -1278,12 +1278,12 @@ static ssize_t ocfs2_file_aio_read(struc
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", filp,
 		   (unsigned int)nr_segs,
-		   filp->f_dentry->d_name.len,
-		   filp->f_dentry->d_name.name);
+		   filp->f_path.dentry->d_name.len,
+		   filp->f_path.dentry->d_name.name);
 
 	if (!inode) {
 		ret = -EINVAL;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
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

