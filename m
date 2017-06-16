From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-use-rwf_-flags-for-aio-operations.patch
 removed from -mm tree
Date: Fri, 16 Jun 2017 13:00:02 -0700
Message-ID: <594438c2.hLYCKXOI68Sj0jZN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdFPUAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 16:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use RWF_* flags for AIO operations
has been removed from the -mm tree.  Its filename was
     fs-use-rwf_-flags-for-aio-operations.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: fs: use RWF_* flags for AIO operations

aio_rw_flags is introduced in struct iocb (using aio_reserved1) which will
carry the RWF_* flags.  We cannot use aio_flags because they are not
checked for validity which may break existing applications.

Note, the only place RWF_HIPRI comes in effect is dio_await_one().  All
the rest of the locations, aio code return -EIOCBQUEUED before the checks
for RWF_HIPRI.

Link: http://lkml.kernel.org/r/20170615160002.17233-4-rgoldwyn@suse.de
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

 fs/aio.c                     |    8 +++++++-
 include/uapi/linux/aio_abi.h |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~fs-use-rwf_-flags-for-aio-operations fs/aio.c
--- a/fs/aio.c~fs-use-rwf_-flags-for-aio-operations
+++ a/fs/aio.c
@@ -1541,7 +1541,7 @@ static int io_submit_one(struct kioctx *
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
+	if (unlikely(iocb->aio_reserved2)) {
 		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
@@ -1586,6 +1586,12 @@ static int io_submit_one(struct kioctx *
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	ret = kiocb_set_rw_flags(&req->common, iocb->aio_rw_flags);
+	if (unlikely(ret)) {
+		pr_debug("EINVAL: aio_rw_flags\n");
+		goto out_put_req;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff -puN include/uapi/linux/aio_abi.h~fs-use-rwf_-flags-for-aio-operations include/uapi/linux/aio_abi.h
--- a/include/uapi/linux/aio_abi.h~fs-use-rwf_-flags-for-aio-operations
+++ a/include/uapi/linux/aio_abi.h
@@ -79,7 +79,7 @@ struct io_event {
 struct iocb {
 	/* these are internal to the kernel/libc. */
 	__u64	aio_data;	/* data to be returned in event's data */
-	__u32	PADDED(aio_key, aio_reserved1);
+	__u32	PADDED(aio_key, aio_rw_flags);
 				/* the kernel sets aio_key to the req # */
 
 	/* common fields */
_

Patches currently in -mm which might be from rgoldwyn@suse.com are

fs-introduce-rwf_nowait-and-fmode_aio_nowait.patch
fs-return-if-direct-write-will-trigger-writeback.patch
fs-introduce-iomap_nowait.patch
block-return-on-congested-block-device.patch
ext4-nowait-aio-support.patch
xfs-nowait-aio-support.patch
btrfs-nowait-aio-support.patch

