From: akpm@osdl.org
Subject: - struct-path-convert-udf.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:17 -0800
Message-ID: <200612082005.kB8K5H3H002282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57492 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426316AbWLHUFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert udf
has been removed from the -mm tree.  Its filename was
     struct-path-convert-udf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert udf
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/udf/dir.c  |    4 ++--
 fs/udf/file.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/udf/dir.c~struct-path-convert-udf fs/udf/dir.c
--- a/fs/udf/dir.c~struct-path-convert-udf
+++ a/fs/udf/dir.c
@@ -77,7 +77,7 @@ const struct file_operations udf_dir_ope
 
 int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *dir = filp->f_dentry->d_inode;
+	struct inode *dir = filp->f_path.dentry->d_inode;
 	int result;
 
 	lock_kernel();
@@ -225,7 +225,7 @@ do_udf_readdir(struct inode * dir, struc
 
 		if ( cfi.fileCharacteristics & FID_FILE_CHAR_PARENT )
 		{
-			iblock = parent_ino(filp->f_dentry);
+			iblock = parent_ino(filp->f_path.dentry);
 			flen = 2;
 			memcpy(fname, "..", flen);
 			dt_type = DT_DIR;
diff -puN fs/udf/file.c~struct-path-convert-udf fs/udf/file.c
--- a/fs/udf/file.c~struct-path-convert-udf
+++ a/fs/udf/file.c
@@ -108,7 +108,7 @@ static ssize_t udf_file_aio_write(struct
 {
 	ssize_t retval;
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int err, pos;
 	size_t count = iocb->ki_left;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

