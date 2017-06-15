From: akpm@linux-foundation.org
Subject: + fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 11:54:36 -0700
Message-ID: <5942d7ec.1qELsHCGKjTzu4pB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752535AbdFOSyr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 14:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: separate out kiocb flags setup based on RWF_* flags
has been added to the -mm tree.  Its filename is
     fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: fs: separate out kiocb flags setup based on RWF_* flags

Patch series "No wait AIO", v12.

This series adds nonblocking feature to asynchronous I/O writes. 
io_submit() can be delayed for a number of reasons:

 - Block allocation for files
 - Data writebacks for direct I/O
 - Sleeping because of waiting to acquire i_rwsem
 - Congested block device

The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if any of
these conditions are met.  This way userspace can push most of the
write()s to the kernel to the best of its ability to complete and if it
returns -EAGAIN, can defer it to another thread.

In order to enable this, IOCB_RW_FLAG_NOWAIT is introduced in
uapi/linux/aio_abi.h.  If set for aio_rw_flags, it translates to
IOCB_NOWAIT for struct iocb, REQ_NOWAIT for bio.bi_opf and IOMAP_NOWAIT
for iomap.  aio_rw_flags is a new flag replacing aio_reserved1.  We could
not use aio_flags because it is not currently checked for invalidity in
the kernel.

This feature is provided for direct I/O of asynchronous I/O only.  I have
tested it against xfs, ext4, and btrfs while I intend to add more
filesystems.  The nowait feature is for request based devices.  In the
future, I intend to add support to stacked devices such as md.

Applications will have to check supportability by sending a async direct
write and any other error besides -EAGAIN would mean it is not supported.

First two patches are prep patches into nowait I/O.


This patch (of 10):

Separate out kiocb flags setup based on RWF_* flags.

Link: http://lkml.kernel.org/r/20170615160002.17233-2-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c    |   12 +++---------
 include/linux/fs.h |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff -puN fs/read_write.c~fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags fs/read_write.c
--- a/fs/read_write.c~fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags
+++ a/fs/read_write.c
@@ -678,16 +678,10 @@ static ssize_t do_iter_readv_writev(stru
 	struct kiocb kiocb;
 	ssize_t ret;
 
-	if (flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))
-		return -EOPNOTSUPP;
-
 	init_sync_kiocb(&kiocb, filp);
-	if (flags & RWF_HIPRI)
-		kiocb.ki_flags |= IOCB_HIPRI;
-	if (flags & RWF_DSYNC)
-		kiocb.ki_flags |= IOCB_DSYNC;
-	if (flags & RWF_SYNC)
-		kiocb.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+	ret = kiocb_set_rw_flags(&kiocb, flags);
+	if (ret)
+		return ret;
 	kiocb.ki_pos = *ppos;
 
 	if (type == READ)
diff -puN include/linux/fs.h~fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags include/linux/fs.h
--- a/include/linux/fs.h~fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags
+++ a/include/linux/fs.h
@@ -3056,6 +3056,20 @@ static inline int iocb_flags(struct file
 	return res;
 }
 
+static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
+{
+	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
+		return -EOPNOTSUPP;
+
+	if (flags & RWF_HIPRI)
+		ki->ki_flags |= IOCB_HIPRI;
+	if (flags & RWF_DSYNC)
+		ki->ki_flags |= IOCB_DSYNC;
+	if (flags & RWF_SYNC)
+		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
+	return 0;
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
_

Patches currently in -mm which might be from rgoldwyn@suse.com are

fs-separate-out-kiocb-flags-setup-based-on-rwf_-flags.patch
fs-introduce-filemap_range_has_page.patch
fs-use-rwf_-flags-for-aio-operations.patch
fs-introduce-rwf_nowait-and-fmode_aio_nowait.patch
fs-return-if-direct-write-will-trigger-writeback.patch
fs-introduce-iomap_nowait.patch
block-return-on-congested-block-device.patch
ext4-nowait-aio-support.patch
xfs-nowait-aio-support.patch
btrfs-nowait-aio-support.patch

