From: akpm@linux-foundation.org
Subject: - add-support-for-vectored-and-async-i-o-to-all-simple-filesystems.patch removed from -mm tree
Date: Wed, 09 May 2007 15:25:11 -0700
Message-ID: <200705092225.l49MPBxq004217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759158AbXEIWZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Add support for vectored and async I/O to all simple filesystems
has been removed from the -mm tree.  Its filename was
     add-support-for-vectored-and-async-i-o-to-all-simple-filesystems.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: Add support for vectored and async I/O to all simple filesystems
From: Christoph Hellwig <hch@lst.de>


Every filesystem using generic_file_read/generic_file_write directly can
easily support vectored and async (well at least the API, it's not async quite
yet in mainline) I/O.  This patch adds the proper vectors to all filesystems
and switches them to do_sync_read/do_sync_write.  This we we can get rid of
plain generic_file_read/generic_file_write soon and remove one of the many
variants of those functions.  Long term I plan to unify aio and vectored
support into a single operation so we can cut down filemap.c to a sane set of
these routines.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/raw.c      |    2 +-
 fs/adfs/file.c          |    9 +++++++--
 fs/bfs/file.c           |    8 ++++++--
 fs/block_dev.c          |    2 +-
 fs/ext2/file.c          |    4 ++--
 fs/fuse/file.c          |    8 ++++++--
 fs/hfs/inode.c          |    8 ++++++--
 fs/hfsplus/inode.c      |    8 ++++++--
 fs/hostfs/hostfs_kern.c |    4 ++--
 fs/jffs/inode-v23.c     |    8 ++++++--
 fs/jffs2/file.c         |    8 ++++++--
 fs/jfs/file.c           |    4 ++--
 fs/minix/file.c         |    8 ++++++--
 fs/ntfs/file.c          |    2 +-
 fs/qnx4/file.c          |    8 ++++++--
 fs/ramfs/file-mmu.c     |    8 ++++++--
 fs/read_write.c         |    4 +++-
 fs/reiserfs/file.c      |   12 ++++--------
 fs/sysv/file.c          |    8 ++++++--
 fs/ufs/file.c           |    8 ++++++--
 ramfs/inode.c           |    0 
 21 files changed, 89 insertions(+), 42 deletions(-)

diff -puN drivers/char/raw.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems drivers/char/raw.c
--- devel/drivers/char/raw.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/drivers/char/raw.c	2005-12-12 01:19:09.000000000 -0800
@@ -262,7 +262,7 @@ static ssize_t raw_file_aio_write(struct
 
 
 static struct file_operations raw_fops = {
-	.read	=	generic_file_read,
+	.read	=	do_sync_read,
 	.aio_read = 	generic_file_aio_read,
 	.write	=	raw_file_write,
 	.aio_write = 	raw_file_aio_write,
diff -puN fs/adfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/adfs/file.c
--- devel/fs/adfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/adfs/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -31,11 +31,16 @@
 
 struct file_operations adfs_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= file_fsync,
-	.write		= generic_file_write,
 	.sendfile	= generic_file_sendfile,
+
 };
 
 struct inode_operations adfs_file_inode_operations = {
diff -puN fs/bfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/bfs/file.c
--- devel/fs/bfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/bfs/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -19,8 +19,12 @@
 
 struct file_operations bfs_file_operations = {
 	.llseek 	= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.sendfile	= generic_file_sendfile,
 };
diff -puN fs/block_dev.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/block_dev.c
--- devel/fs/block_dev.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/block_dev.c	2005-12-12 01:19:09.000000000 -0800
@@ -796,7 +796,7 @@ struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
 	.llseek		= block_llseek,
-	.read		= generic_file_read,
+	.read		= do_sync_read,
 	.write		= blkdev_file_write,
   	.aio_read	= generic_file_aio_read,
   	.aio_write	= blkdev_file_aio_write, 
diff -puN fs/ext2/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/ext2/file.c
--- devel/fs/ext2/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/ext2/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -41,8 +41,8 @@ static int ext2_release_file (struct ino
  */
 struct file_operations ext2_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.ioctl		= ext2_ioctl,
diff -puN fs/fuse/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/fuse/file.c
--- devel/fs/fuse/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/fuse/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -560,8 +560,12 @@ static int fuse_set_page_dirty(struct pa
 
 static struct file_operations fuse_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= fuse_file_mmap,
 	.open		= fuse_open,
 	.flush		= fuse_flush,
diff -puN fs/hfs/inode.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/hfs/inode.c
--- devel/fs/hfs/inode.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/hfs/inode.c	2005-12-12 01:19:09.000000000 -0800
@@ -615,8 +615,12 @@ int hfs_inode_setattr(struct dentry *den
 
 static struct file_operations hfs_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.sendfile	= generic_file_sendfile,
 	.fsync		= file_fsync,
diff -puN fs/hfsplus/inode.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/hfsplus/inode.c
--- devel/fs/hfsplus/inode.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/hfsplus/inode.c	2005-12-12 01:19:09.000000000 -0800
@@ -301,8 +301,12 @@ static struct inode_operations hfsplus_f
 
 static struct file_operations hfsplus_file_operations = {
 	.llseek 	= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.sendfile	= generic_file_sendfile,
 	.fsync		= file_fsync,
diff -puN fs/hostfs/hostfs_kern.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/hostfs/hostfs_kern.c
--- devel/fs/hostfs/hostfs_kern.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/hostfs/hostfs_kern.c	2005-12-12 01:19:09.000000000 -0800
@@ -386,13 +386,13 @@ int hostfs_fsync(struct file *file, stru
 
 static struct file_operations hostfs_file_fops = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
+	.read		= do_sync_read,
 	.sendfile	= generic_file_sendfile,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.readv		= generic_file_readv,
 	.writev		= generic_file_writev,
-	.write		= generic_file_write,
+	.write		= do_sync_write,
 	.mmap		= generic_file_mmap,
 	.open		= hostfs_file_open,
 	.release	= NULL,
diff -puN fs/jffs2/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/jffs2/file.c
--- devel/fs/jffs2/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/jffs2/file.c	2005-12-12 01:19:33.000000000 -0800
@@ -42,8 +42,12 @@ struct file_operations jffs2_file_operat
 {
 	.llseek =	generic_file_llseek,
 	.open =		generic_file_open,
-	.read =		generic_file_read,
-	.write =	generic_file_write,
+	.read =		do_sync_read,
+	.write =	do_sync_write,
+	.readv =	generic_file_readv,
+	.writev =	generic_file_writev,
+	.aio_read =	generic_file_aio_read,
+	.aio_write =	generic_file_aio_write,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
 	.sendfile =	generic_file_sendfile
diff -puN fs/jffs/inode-v23.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/jffs/inode-v23.c
--- devel/fs/jffs/inode-v23.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/jffs/inode-v23.c	2005-12-12 01:19:09.000000000 -0800
@@ -1633,8 +1633,12 @@ static struct file_operations jffs_file_
 {
 	.open		= generic_file_open,
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.ioctl		= jffs_ioctl,
 	.mmap		= generic_file_readonly_mmap,
 	.fsync		= jffs_fsync,
diff -puN fs/jfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/jfs/file.c
--- devel/fs/jfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/jfs/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -103,8 +103,8 @@ struct inode_operations jfs_file_inode_o
 struct file_operations jfs_file_operations = {
 	.open		= jfs_open,
 	.llseek		= generic_file_llseek,
-	.write		= generic_file_write,
-	.read		= generic_file_read,
+	.write		= do_sync_write,
+	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
diff -puN fs/minix/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/minix/file.c
--- devel/fs/minix/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/minix/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -17,8 +17,12 @@ int minix_sync_file(struct file *, struc
 
 struct file_operations minix_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= minix_sync_file,
 	.sendfile	= generic_file_sendfile,
diff -puN fs/ntfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/ntfs/file.c
--- devel/fs/ntfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/ntfs/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -2306,7 +2306,7 @@ static int ntfs_file_fsync(struct file *
 
 struct file_operations ntfs_file_ops = {
 	.llseek		= generic_file_llseek,	 /* Seek inside file. */
-	.read		= generic_file_read,	 /* Read from file. */
+	.read		= do_sync_read,		 /* Read from file. */
 	.aio_read	= generic_file_aio_read, /* Async read from file. */
 	.readv		= generic_file_readv,	 /* Read from file. */
 #ifdef NTFS_RW
diff -puN fs/qnx4/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/qnx4/file.c
--- devel/fs/qnx4/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/qnx4/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -25,11 +25,15 @@
 struct file_operations qnx4_file_operations =
 {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
+	.read		= do_sync_read,
+	.readv		= generic_file_readv,
+	.aio_read	= generic_file_aio_read,
 	.mmap		= generic_file_mmap,
 	.sendfile	= generic_file_sendfile,
 #ifdef CONFIG_QNX4FS_RW
-	.write		= generic_file_write,
+	.write		= do_sync_write,
+	.writev		= generic_file_writev,
+	.aio_write	= generic_file_aio_write,
 	.fsync		= qnx4_sync_file,
 #endif
 };
diff -puN fs/ramfs/inode.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/ramfs/inode.c
diff -puN fs/read_write.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/read_write.c
--- devel/fs/read_write.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/read_write.c	2005-12-12 01:19:09.000000000 -0800
@@ -20,7 +20,9 @@
 
 struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
+	.read		= do_sync_read,
+	.readv		= generic_file_readv,
+	.aio_read	= generic_file_aio_read,
 	.mmap		= generic_file_readonly_mmap,
 	.sendfile	= generic_file_sendfile,
 };
diff -puN fs/reiserfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/reiserfs/file.c
--- devel/fs/reiserfs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/reiserfs/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -1541,22 +1541,18 @@ static ssize_t reiserfs_file_write(struc
 	return res;
 }
 
-static ssize_t reiserfs_aio_write(struct kiocb *iocb, const char __user * buf,
-				  size_t count, loff_t pos)
-{
-	return generic_file_aio_write(iocb, buf, count, pos);
-}
-
 struct file_operations reiserfs_file_operations = {
-	.read = generic_file_read,
+	.read = do_sync_read,
 	.write = reiserfs_file_write,
+	.readv = generic_file_readv,
+	.writev = generic_file_writev,
 	.ioctl = reiserfs_ioctl,
 	.mmap = generic_file_mmap,
 	.release = reiserfs_file_release,
 	.fsync = reiserfs_sync_file,
 	.sendfile = generic_file_sendfile,
 	.aio_read = generic_file_aio_read,
-	.aio_write = reiserfs_aio_write,
+	.aio_write = generic_file_aio_write,
 };
 
 struct inode_operations reiserfs_file_inode_operations = {
diff -puN fs/sysv/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/sysv/file.c
--- devel/fs/sysv/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/sysv/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -21,8 +21,12 @@
  */
 struct file_operations sysv_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= sysv_sync_file,
 	.sendfile	= generic_file_sendfile,
diff -puN fs/ufs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/ufs/file.c
--- devel/fs/ufs/file.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/ufs/file.c	2005-12-12 01:19:09.000000000 -0800
@@ -43,8 +43,12 @@
  
 struct file_operations ufs_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.open           = generic_file_open,
 	.sendfile	= generic_file_sendfile,
diff -puN fs/ramfs/file-mmu.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems fs/ramfs/file-mmu.c
--- devel/fs/ramfs/file-mmu.c~add-support-for-vectored-and-async-i-o-to-all-simple-filesystems	2005-12-12 01:19:09.000000000 -0800
+++ devel-akpm/fs/ramfs/file-mmu.c	2005-12-12 01:19:09.000000000 -0800
@@ -44,8 +44,12 @@ struct address_space_operations ramfs_ao
 };
 
 struct file_operations ramfs_file_operations = {
-	.read		= generic_file_read,
-	.write		= generic_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.readv		= generic_file_readv,
+	.writev		= generic_file_writev,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= simple_sync_file,
 	.sendfile	= generic_file_sendfile,
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
