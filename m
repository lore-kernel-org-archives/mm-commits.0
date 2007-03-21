From: akpm@linux-foundation.org
Subject: + mm-move-common-segment-checks-to-separate-helper-function-v7.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:01:38 -0700
Message-ID: <200703212201.l2LM1cCD004668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55447 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933278AbXCUWBs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:01:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, hch@lst.de


The patch titled
     mm: move common segment checks to separate helper function
has been added to the -mm tree.  Its filename is
     mm-move-common-segment-checks-to-separate-helper-function-v7.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: move common segment checks to separate helper function
From: Dmitriy Monakhov <dmonakhov@openvz.org>

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/file.c             |   21 +-------
 fs/xfs/linux-2.6/xfs_lrw.c |   22 +--------
 include/linux/fs.h         |    3 +
 mm/filemap.c               |   83 +++++++++++++++++++----------------
 4 files changed, 55 insertions(+), 74 deletions(-)

diff -puN fs/ntfs/file.c~mm-move-common-segment-checks-to-separate-helper-function-v7 fs/ntfs/file.c
--- a/fs/ntfs/file.c~mm-move-common-segment-checks-to-separate-helper-function-v7
+++ a/fs/ntfs/file.c
@@ -2129,28 +2129,13 @@ static ssize_t ntfs_file_aio_write_noloc
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	loff_t pos;
-	unsigned long seg;
 	size_t count;		/* after file limit checks */
 	ssize_t written, err;
 
 	count = 0;
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *iv = &iov[seg];
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		count += iv->iov_len;
-		if (unlikely((ssize_t)(count|iv->iov_len) < 0))
-			return -EINVAL;
-		if (access_ok(VERIFY_READ, iv->iov_base, iv->iov_len))
-			continue;
-		if (!seg)
-			return -EFAULT;
-		nr_segs = seg;
-		count -= iv->iov_len;	/* This segment is no good */
-		break;
-	}
+	err = generic_segment_checks(iov, &nr_segs, &count, VERIFY_READ);
+	if (err)
+		return err;
 	pos = *ppos;
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
 	/* We can write back this queue in page reclaim. */
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~mm-move-common-segment-checks-to-separate-helper-function-v7 fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~mm-move-common-segment-checks-to-separate-helper-function-v7
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -639,7 +639,6 @@ xfs_write(
 	xfs_fsize_t		isize, new_size;
 	xfs_iocore_t		*io;
 	bhv_vnode_t		*vp;
-	unsigned long		seg;
 	int			iolock;
 	int			eventsent = 0;
 	bhv_vrwlock_t		locktype;
@@ -652,24 +651,9 @@ xfs_write(
 	vp = BHV_TO_VNODE(bdp);
 	xip = XFS_BHVTOI(bdp);
 
-	for (seg = 0; seg < segs; seg++) {
-		const struct iovec *iv = &iovp[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		ocount += iv->iov_len;
-		if (unlikely((ssize_t)(ocount|iv->iov_len) < 0))
-			return -EINVAL;
-		if (access_ok(VERIFY_READ, iv->iov_base, iv->iov_len))
-			continue;
-		if (seg == 0)
-			return -EFAULT;
-		segs = seg;
-		ocount -= iv->iov_len;  /* This segment is no good */
-		break;
-	}
+	error = generic_segment_checks(iovp, &segs, &ocount, VERIFY_READ);
+	if (error)
+		return error;
 
 	count = ocount;
 	pos = *offset;
diff -puN include/linux/fs.h~mm-move-common-segment-checks-to-separate-helper-function-v7 include/linux/fs.h
--- a/include/linux/fs.h~mm-move-common-segment-checks-to-separate-helper-function-v7
+++ a/include/linux/fs.h
@@ -1727,6 +1727,9 @@ extern ssize_t generic_file_sendfile(str
 extern void do_generic_mapping_read(struct address_space *mapping,
 				    struct file_ra_state *, struct file *,
 				    loff_t *, read_descriptor_t *, read_actor_t);
+extern int generic_segment_checks(const struct iovec *iov,
+		unsigned long *nr_segs, size_t *count,
+		unsigned long access_flags);
 
 /* fs/splice.c */
 extern ssize_t generic_file_splice_read(struct file *, loff_t *,
diff -puN mm/filemap.c~mm-move-common-segment-checks-to-separate-helper-function-v7 mm/filemap.c
--- a/mm/filemap.c~mm-move-common-segment-checks-to-separate-helper-function-v7
+++ a/mm/filemap.c
@@ -1107,6 +1107,46 @@ success:
 	return size;
 }
 
+/*
+ * Performs necessary checks before doing a write
+ * @iov:	io vector request
+ * @nr_segs:	number of segments in the iovec
+ * @count:	number of bytes to write
+ * @access_flags: type of access: %VERIFY_READ or %VERIFY_WRITE
+ *
+ * Adjust number of segments and amount of bytes to write (nr_segs should be
+ * properly initialized first). Returns appropriate error code that caller
+ * should return or zero in case that write should be allowed.
+ */
+int generic_segment_checks(const struct iovec *iov,
+			unsigned long *nr_segs, size_t *count,
+			unsigned long access_flags)
+{
+	unsigned long   seg;
+	size_t cnt = 0;
+	for (seg = 0; seg < *nr_segs; seg++) {
+		const struct iovec *iv = &iov[seg];
+
+		/*
+		 * If any segment has a negative length, or the cumulative
+		 * length ever wraps negative then return -EINVAL.
+		 */
+		cnt += iv->iov_len;
+		if (unlikely((ssize_t)(cnt|iv->iov_len) < 0))
+			return -EINVAL;
+		if (access_ok(access_flags, iv->iov_base, iv->iov_len))
+			continue;
+		if (seg == 0)
+			return -EFAULT;
+		*nr_segs = seg;
+		cnt -= iv->iov_len;	/* This segment is no good */
+		break;
+	}
+	*count = cnt;
+	return 0;
+}
+EXPORT_SYMBOL(generic_segment_checks);
+
 /**
  * generic_file_aio_read - generic filesystem read routine
  * @iocb:	kernel I/O control block
@@ -1128,24 +1168,9 @@ generic_file_aio_read(struct kiocb *iocb
 	loff_t *ppos = &iocb->ki_pos;
 
 	count = 0;
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *iv = &iov[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		count += iv->iov_len;
-		if (unlikely((ssize_t)(count|iv->iov_len) < 0))
-			return -EINVAL;
-		if (access_ok(VERIFY_WRITE, iv->iov_base, iv->iov_len))
-			continue;
-		if (seg == 0)
-			return -EFAULT;
-		nr_segs = seg;
-		count -= iv->iov_len;	/* This segment is no good */
-		break;
-	}
+	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (retval)
+		return retval;
 
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
@@ -2028,30 +2053,14 @@ __generic_file_aio_write_nolock(struct k
 	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
 	struct inode 	*inode = mapping->host;
-	unsigned long	seg;
 	loff_t		pos;
 	ssize_t		written;
 	ssize_t		err;
 
 	ocount = 0;
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *iv = &iov[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		ocount += iv->iov_len;
-		if (unlikely((ssize_t)(ocount|iv->iov_len) < 0))
-			return -EINVAL;
-		if (access_ok(VERIFY_READ, iv->iov_base, iv->iov_len))
-			continue;
-		if (seg == 0)
-			return -EFAULT;
-		nr_segs = seg;
-		ocount -= iv->iov_len;	/* This segment is no good */
-		break;
-	}
+	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
+	if (err)
+		return err;
 
 	count = ocount;
 	pos = *ppos;
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

kobject-kobject_shadow_add-cleanup.patch
driver-core-handles-kobject_uevent-failure-while-device_add.patch
driver-core-handle-sysfs_op-failure-while-device_add.patch
git-libata-all.patch
git-netdev-all.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
ext3-dirindex-error-pointer-issues.patch
ext3-dirindex-error-pointer-issues-fix.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
udf-possible-null-pointer-dereference-while-load_partition.patch
