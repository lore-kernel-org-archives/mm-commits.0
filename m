From: akpm@linux-foundation.org
Subject: - fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:29 -0700
Message-ID: <200807182324.m6INOTru004199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbYGRX0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, hch@lst.de, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fifo/pipe: reuse xxx_fifo_fops for xxx_pipe_fops
has been removed from the -mm tree.  Its filename was
     fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fifo/pipe: reuse xxx_fifo_fops for xxx_pipe_fops
From: Denys Vlasenko <vda.linux@googlemail.com>

I noticed that read/write/rdwr_pipe_fops are (1) const and
(2) exactly identical to xxx_fifo_fops, which are also const.

Use the same struct file_operations objects for ->f_op of pipes and fifos.

Size difference:

# size linux-2.6.25-rc6*/*/pipe.o
   text    data     bss     dec     hex filename
   6534     144       0    6678    1a16 linux-2.6.25-rc6/fs/pipe.o
   5862     144       0    6006    1776 linux-2.6.25-rc6-pt/fs/pipe.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fifo.c          |    8 +++---
 fs/pipe.c          |   51 ++++++-------------------------------------
 include/linux/fs.h |    6 ++---
 3 files changed, 15 insertions(+), 50 deletions(-)

diff -puN fs/fifo.c~fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops fs/fifo.c
--- a/fs/fifo.c~fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops
+++ a/fs/fifo.c
@@ -57,7 +57,7 @@ static int fifo_open(struct inode *inode
 	 *  POSIX.1 says that O_NONBLOCK means return with the FIFO
 	 *  opened, even when there is no process writing the FIFO.
 	 */
-		filp->f_op = &read_fifo_fops;
+		filp->f_op = &read_pipefifo_fops;
 		pipe->r_counter++;
 		if (pipe->readers++ == 0)
 			wake_up_partner(inode);
@@ -86,7 +86,7 @@ static int fifo_open(struct inode *inode
 		if ((filp->f_flags & O_NONBLOCK) && !pipe->readers)
 			goto err;
 
-		filp->f_op = &write_fifo_fops;
+		filp->f_op = &write_pipefifo_fops;
 		pipe->w_counter++;
 		if (!pipe->writers++)
 			wake_up_partner(inode);
@@ -105,7 +105,7 @@ static int fifo_open(struct inode *inode
 	 *  This implementation will NEVER block on a O_RDWR open, since
 	 *  the process can at least talk to itself.
 	 */
-		filp->f_op = &rdwr_fifo_fops;
+		filp->f_op = &rdwr_pipefifo_fops;
 
 		pipe->readers++;
 		pipe->writers++;
@@ -151,5 +151,5 @@ err_nocleanup:
  * depending on the access mode of the file...
  */
 const struct file_operations def_fifo_fops = {
-	.open		= fifo_open,	/* will set read or write pipe_fops */
+	.open		= fifo_open,	/* will set read_ or write_pipefifo_fops */
 };
diff -puN fs/pipe.c~fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops fs/pipe.c
--- a/fs/pipe.c~fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops
+++ a/fs/pipe.c
@@ -777,8 +777,10 @@ pipe_rdwr_open(struct inode *inode, stru
 /*
  * The file_operations structs are not static because they
  * are also used in linux/fs/fifo.c to do operations on FIFOs.
+ *
+ * Pipes reuse fifos' file_operations structs.
  */
-const struct file_operations read_fifo_fops = {
+const struct file_operations read_pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= pipe_read,
@@ -790,7 +792,7 @@ const struct file_operations read_fifo_f
 	.fasync		= pipe_read_fasync,
 };
 
-const struct file_operations write_fifo_fops = {
+const struct file_operations write_pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read		= bad_pipe_r,
 	.write		= do_sync_write,
@@ -802,44 +804,7 @@ const struct file_operations write_fifo_
 	.fasync		= pipe_write_fasync,
 };
 
-const struct file_operations rdwr_fifo_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_rdwr_open,
-	.release	= pipe_rdwr_release,
-	.fasync		= pipe_rdwr_fasync,
-};
-
-static const struct file_operations read_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= do_sync_read,
-	.aio_read	= pipe_read,
-	.write		= bad_pipe_w,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_read_open,
-	.release	= pipe_read_release,
-	.fasync		= pipe_read_fasync,
-};
-
-static const struct file_operations write_pipe_fops = {
-	.llseek		= no_llseek,
-	.read		= bad_pipe_r,
-	.write		= do_sync_write,
-	.aio_write	= pipe_write,
-	.poll		= pipe_poll,
-	.unlocked_ioctl	= pipe_ioctl,
-	.open		= pipe_write_open,
-	.release	= pipe_write_release,
-	.fasync		= pipe_write_fasync,
-};
-
-static const struct file_operations rdwr_pipe_fops = {
+const struct file_operations rdwr_pipefifo_fops = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= pipe_read,
@@ -927,7 +892,7 @@ static struct inode * get_pipe_inode(voi
 	inode->i_pipe = pipe;
 
 	pipe->readers = pipe->writers = 1;
-	inode->i_fop = &rdwr_pipe_fops;
+	inode->i_fop = &rdwr_pipefifo_fops;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
@@ -978,7 +943,7 @@ struct file *create_write_pipe(void)
 	d_instantiate(dentry, inode);
 
 	err = -ENFILE;
-	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipe_fops);
+	f = alloc_file(pipe_mnt, dentry, FMODE_WRITE, &write_pipefifo_fops);
 	if (!f)
 		goto err_dentry;
 	f->f_mapping = inode->i_mapping;
@@ -1020,7 +985,7 @@ struct file *create_read_pipe(struct fil
 
 	f->f_pos = 0;
 	f->f_flags = O_RDONLY;
-	f->f_op = &read_pipe_fops;
+	f->f_op = &read_pipefifo_fops;
 	f->f_mode = FMODE_READ;
 	f->f_version = 0;
 
diff -puN include/linux/fs.h~fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops include/linux/fs.h
--- a/include/linux/fs.h~fifo-pipe-reuse-xxx_fifo_fops-for-xxx_pipe_fops
+++ a/include/linux/fs.h
@@ -1699,9 +1699,9 @@ extern void init_special_inode(struct in
 extern void make_bad_inode(struct inode *);
 extern int is_bad_inode(struct inode *);
 
-extern const struct file_operations read_fifo_fops;
-extern const struct file_operations write_fifo_fops;
-extern const struct file_operations rdwr_fifo_fops;
+extern const struct file_operations read_pipefifo_fops;
+extern const struct file_operations write_pipefifo_fops;
+extern const struct file_operations rdwr_pipefifo_fops;
 
 extern int fs_may_remount_ro(struct super_block *);
 
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch
linux-next.patch
aic7xxx-introduce-dont_generate_debug_code-keyword-in-aicasm-parser.patch
aic7xxx-update-reg-files.patch
aic7xxx-update-_shipped-files.patch

