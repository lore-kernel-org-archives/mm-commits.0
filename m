From: akpm@osdl.org
Subject: - struct-path-convert-md.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:02 -0800
Message-ID: <200612082004.kB8K42ni002139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426277AbWLHUEK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert md
has been removed from the -mm tree.  Its filename was
     struct-path-convert-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert md
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/bitmap.c    |    8 ++++----
 drivers/md/dm-linear.c |    2 +-
 drivers/md/dm-mpath.c  |    2 +-
 drivers/md/md.c        |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/md/bitmap.c~struct-path-convert-md drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~struct-path-convert-md
+++ a/drivers/md/bitmap.c
@@ -212,8 +212,8 @@ char *file_path(struct file *file, char 
 	if (!buf)
 		return NULL;
 
-	d = file->f_dentry;
-	v = file->f_vfsmnt;
+	d = file->f_path.dentry;
+	v = file->f_path.mnt;
 
 	buf = d_path(d, v, buf, count);
 
@@ -349,7 +349,7 @@ static struct page *read_page(struct fil
 			      unsigned long count)
 {
 	struct page *page = NULL;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct buffer_head *bh;
 	sector_t block;
 
@@ -662,7 +662,7 @@ static void bitmap_file_put(struct bitma
 	bitmap_file_unmap(bitmap);
 
 	if (file) {
-		struct inode *inode = file->f_dentry->d_inode;
+		struct inode *inode = file->f_path.dentry->d_inode;
 		invalidate_inode_pages(inode->i_mapping);
 		fput(file);
 	}
diff -puN drivers/md/dm-linear.c~struct-path-convert-md drivers/md/dm-linear.c
--- a/drivers/md/dm-linear.c~struct-path-convert-md
+++ a/drivers/md/dm-linear.c
@@ -108,7 +108,7 @@ static int linear_ioctl(struct dm_target
 	struct dentry fake_dentry = {};
 
 	fake_file.f_mode = lc->dev->mode;
-	fake_file.f_dentry = &fake_dentry;
+	fake_file.f_path.dentry = &fake_dentry;
 	fake_dentry.d_inode = bdev->bd_inode;
 
 	return blkdev_driver_ioctl(bdev->bd_inode, &fake_file, bdev->bd_disk, cmd, arg);
diff -puN drivers/md/dm-mpath.c~struct-path-convert-md drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~struct-path-convert-md
+++ a/drivers/md/dm-mpath.c
@@ -1272,7 +1272,7 @@ static int multipath_ioctl(struct dm_tar
 	struct dentry fake_dentry = {};
 	int r = 0;
 
-	fake_file.f_dentry = &fake_dentry;
+	fake_file.f_path.dentry = &fake_dentry;
 
 	spin_lock_irqsave(&m->lock, flags);
 
diff -puN drivers/md/md.c~struct-path-convert-md drivers/md/md.c
--- a/drivers/md/md.c~struct-path-convert-md
+++ a/drivers/md/md.c
@@ -4846,8 +4846,8 @@ static int md_seq_show(struct seq_file *
 				chunk_kb ? "KB" : "B");
 			if (bitmap->file) {
 				seq_printf(seq, ", file: ");
-				seq_path(seq, bitmap->file->f_vfsmnt,
-					 bitmap->file->f_dentry," \t\n");
+				seq_path(seq, bitmap->file->f_path.mnt,
+					 bitmap->file->f_path.dentry," \t\n");
 			}
 
 			seq_printf(seq, "\n");
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-md.patch
struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
struct-path-convert-ncpfs.patch
struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
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

