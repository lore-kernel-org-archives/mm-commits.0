From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fs-introduce-rwf_nowait-and-fmode_aio_nowait.patch removed from -mm tree
Date: Fri, 16 Jun 2017 13:00:05 -0700
Message-ID: <594438c5.lSHexYndwoay9DwR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdFPUAG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 16:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: introduce RWF_NOWAIT and FMODE_AIO_NOWAIT
has been removed from the -mm tree.  Its filename was
     fs-introduce-rwf_nowait-and-fmode_aio_nowait.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: fs: introduce RWF_NOWAIT and FMODE_AIO_NOWAIT

RWF_NOWAIT informs kernel to bail out if an AIO request will block for
reasons such as file allocations, or a writeback triggered, or would block
while allocating requests while performing direct I/O.

RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.

FMODE_AIO_NOWAIT is a flag which identifies the file opened is capable of
returning -EAGAIN if the AIO call will block.  This must be set by
supporting filesystems in the ->open() call.

Filesystems xfs, btrfs and ext4 would be supported in the following patches.

Link: http://lkml.kernel.org/r/20170615160002.17233-5-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                |    6 ++++++
 include/linux/fs.h      |   11 ++++++++++-
 include/uapi/linux/fs.h |    1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~fs-introduce-rwf_nowait-and-fmode_aio_nowait fs/aio.c
--- a/fs/aio.c~fs-introduce-rwf_nowait-and-fmode_aio_nowait
+++ a/fs/aio.c
@@ -1592,6 +1592,12 @@ static int io_submit_one(struct kioctx *
 		goto out_put_req;
 	}
 
+	if ((req->common.ki_flags & IOCB_NOWAIT) &&
+			!(req->common.ki_flags & IOCB_DIRECT)) {
+		ret = -EOPNOTSUPP;
+		goto out_put_req;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff -puN include/linux/fs.h~fs-introduce-rwf_nowait-and-fmode_aio_nowait include/linux/fs.h
--- a/include/linux/fs.h~fs-introduce-rwf_nowait-and-fmode_aio_nowait
+++ a/include/linux/fs.h
@@ -142,6 +142,9 @@ typedef int (dio_iodone_t)(struct kiocb
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
+/* File is capable of returning -EAGAIN if AIO will block */
+#define FMODE_AIO_NOWAIT	((__force fmode_t)0x8000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -268,6 +271,7 @@ struct writeback_control;
 #define IOCB_DSYNC		(1 << 4)
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
+#define IOCB_NOWAIT		(1 << 7)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3060,9 +3064,14 @@ static inline int iocb_flags(struct file
 
 static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
 {
-	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
+	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT)))
 		return -EOPNOTSUPP;
 
+	if (flags & RWF_NOWAIT) {
+		if (!(ki->ki_filp->f_mode & FMODE_AIO_NOWAIT))
+			return -EOPNOTSUPP;
+		ki->ki_flags |= IOCB_NOWAIT;
+	}
 	if (flags & RWF_HIPRI)
 		ki->ki_flags |= IOCB_HIPRI;
 	if (flags & RWF_DSYNC)
diff -puN include/uapi/linux/fs.h~fs-introduce-rwf_nowait-and-fmode_aio_nowait include/uapi/linux/fs.h
--- a/include/uapi/linux/fs.h~fs-introduce-rwf_nowait-and-fmode_aio_nowait
+++ a/include/uapi/linux/fs.h
@@ -360,5 +360,6 @@ struct fscrypt_key {
 #define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
 #define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
 #define RWF_SYNC			0x00000004 /* per-IO O_SYNC */
+#define RWF_NOWAIT			0x00000008 /* per-IO, return -EAGAIN if operation would block */
 
 #endif /* _UAPI_LINUX_FS_H */
_

Patches currently in -mm which might be from rgoldwyn@suse.com are

fs-return-if-direct-write-will-trigger-writeback.patch
fs-introduce-iomap_nowait.patch
block-return-on-congested-block-device.patch
ext4-nowait-aio-support.patch
xfs-nowait-aio-support.patch
btrfs-nowait-aio-support.patch

