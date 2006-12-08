From: akpm@osdl.org
Subject: - gfs2-vs-streamline-generic_file_-interfaces-and-filemap.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:22 -0800
Message-ID: <200612081105.kB8B5MPc018633@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425384AbWLHLGR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:06:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, hch@lst.de, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gfs2-vs-streamline-generic_file_-interfaces-and-filemap
has been removed from the -mm tree.  Its filename was
     gfs2-vs-streamline-generic_file_-interfaces-and-filemap.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: gfs2-vs-streamline-generic_file_-interfaces-and-filemap
From: Badari Pulavarty <pbadari@us.ibm.com>


Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/gfs2/ops_file.c |   70 ++++++-------------------------------------
 1 file changed, 10 insertions(+), 60 deletions(-)

diff -puN fs/gfs2/ops_file.c~gfs2-vs-streamline-generic_file_-interfaces-and-filemap fs/gfs2/ops_file.c
--- devel/fs/gfs2/ops_file.c~gfs2-vs-streamline-generic_file_-interfaces-and-filemap	2006-05-19 16:01:01.000000000 -0700
+++ devel-akpm/fs/gfs2/ops_file.c	2006-05-19 16:01:01.000000000 -0700
@@ -165,7 +165,7 @@ static ssize_t gfs2_direct_IO_read(struc
 }
 
 /**
- * __gfs2_file_aio_read - The main GFS2 read function
+ * gfs2_file_aio_read - The main GFS2 read function
  * 
  * N.B. This is almost, but not quite the same as __generic_file_aio_read()
  * the important subtle different being that inode->i_size isn't valid
@@ -173,9 +173,8 @@ static ssize_t gfs2_direct_IO_read(struc
  * path since otherwise locking is done entirely at the page cache
  * layer.
  */
-static ssize_t __gfs2_file_aio_read(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs, loff_t *ppos)
+static ssize_t gfs2_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
+				    unsigned long nr_segs, loff_t pos)
 {
 	struct file *filp = iocb->ki_filp;
 	struct gfs2_inode *ip = filp->f_mapping->host->u.generic_ip;
@@ -184,6 +183,7 @@ static ssize_t __gfs2_file_aio_read(stru
 	unsigned long seg;
 	size_t count;
 
+	BUG_ON(iocb->ki_pos != pos);
 	count = 0;
 	for (seg = 0; seg < nr_segs; seg++) {
 		const struct iovec *iv = &iov[seg];
@@ -206,7 +206,7 @@ static ssize_t __gfs2_file_aio_read(stru
 
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
-		loff_t pos = *ppos, size;
+		loff_t size;
 		struct address_space *mapping;
 		struct inode *inode;
 
@@ -231,7 +231,7 @@ static ssize_t __gfs2_file_aio_read(stru
 			if (retval > 0 && !is_sync_kiocb(iocb))
 				retval = -EIOCBQUEUED;
 			if (retval > 0)
-				*ppos = pos + retval;
+				iocb->ki_pos = pos + retval;
 		}
 		file_accessed(filp);
 		gfs2_glock_dq_m(1, &gh);
@@ -251,7 +251,8 @@ fallback_to_normal:
 			if (desc.count == 0)
 				continue;
 			desc.error = 0;
-			do_generic_file_read(filp,ppos,&desc,file_read_actor);
+			do_generic_file_read(filp,&iocb->ki_pos,&desc,
+						file_read_actor);
 			retval += desc.written;
 			if (desc.error) {
 				retval = retval ?: desc.error;
@@ -264,55 +265,6 @@ out:
 }
 
 /**
- * gfs2_read - Read bytes from a file
- * @file: The file to read from
- * @buf: The buffer to copy into
- * @size: The amount of data requested
- * @offset: The current file offset
- *
- * Outputs: Offset - updated according to number of bytes read
- *
- * Returns: The number of bytes read, errno on failure
- */
-
-static ssize_t gfs2_read(struct file *filp, char __user *buf, size_t size,
-			 loff_t *offset)
-{
-	struct iovec local_iov = { .iov_base = buf, .iov_len = size };
-	struct kiocb kiocb;
-	ssize_t ret;
-
-	init_sync_kiocb(&kiocb, filp);
-	ret = __gfs2_file_aio_read(&kiocb, &local_iov, 1, offset);
-	if (-EIOCBQUEUED == ret)
-		ret = wait_on_sync_kiocb(&kiocb);
-	return ret;
-}
-
-static ssize_t gfs2_file_readv(struct file *filp, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t *ppos)
-{
-	struct kiocb kiocb;
-	ssize_t ret;
-
-	init_sync_kiocb(&kiocb, filp);
-	ret = __gfs2_file_aio_read(&kiocb, iov, nr_segs, ppos);
-	if (-EIOCBQUEUED == ret)
-		ret = wait_on_sync_kiocb(&kiocb);
-	return ret;
-}
-
-static ssize_t gfs2_file_aio_read(struct kiocb *iocb, char __user *buf,
-				  size_t count, loff_t pos)
-{
-        struct iovec local_iov = { .iov_base = buf, .iov_len = count };
-
-        BUG_ON(iocb->ki_pos != pos);
-        return __gfs2_file_aio_read(iocb, &local_iov, 1, &iocb->ki_pos);
-}
-
-
-/**
  * filldir_reg_func - Report a directory entry to the caller of gfs2_dir_read()
  * @opaque: opaque data used by the function
  * @name: the name of the directory entry
@@ -970,11 +922,9 @@ static int gfs2_flock(struct file *file,
 
 struct file_operations gfs2_file_fops = {
 	.llseek = gfs2_llseek,
-	.read = gfs2_read,
-	.readv = gfs2_file_readv,
+	.read = do_sync_read,
 	.aio_read = gfs2_file_aio_read,
-	.write = generic_file_write,
-	.writev = generic_file_writev,
+	.write = do_sync_write,
 	.aio_write = generic_file_aio_write,
 	.unlocked_ioctl = gfs2_ioctl,
 	.mmap = gfs2_mmap,
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
dio-centralize-completion-in-dio_complete.patch
dio-call-blk_run_address_space-once-per-op.patch
dio-formalize-bio-counters-as-a-dio-reference-count.patch
dio-remove-duplicate-bio-wait-code.patch
dio-only-call-aio_complete-after-returning-eiocbqueued.patch
dio-lock-refcount-operations.patch

