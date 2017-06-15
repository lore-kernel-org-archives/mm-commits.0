From: akpm@linux-foundation.org
Subject: + fs-introduce-iomap_nowait.patch added to -mm tree
Date: Thu, 15 Jun 2017 11:54:48 -0700
Message-ID: <5942d7f8.h01hy3PVXFqY/fLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdFOSy7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 14:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: introduce IOMAP_NOWAIT
has been added to the -mm tree.  Its filename is
     fs-introduce-iomap_nowait.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-introduce-iomap_nowait.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-introduce-iomap_nowait.patch

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
Subject: fs: introduce IOMAP_NOWAIT

IOCB_NOWAIT translates to IOMAP_NOWAIT for iomaps.  This is used by XFS in
the XFS patch.

Link: http://lkml.kernel.org/r/20170615160002.17233-7-rgoldwyn@suse.de
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

 fs/iomap.c            |    2 ++
 include/linux/iomap.h |    1 +
 2 files changed, 3 insertions(+)

diff -puN fs/iomap.c~fs-introduce-iomap_nowait fs/iomap.c
--- a/fs/iomap.c~fs-introduce-iomap_nowait
+++ a/fs/iomap.c
@@ -879,6 +879,8 @@ iomap_dio_rw(struct kiocb *iocb, struct
 	} else {
 		dio->flags |= IOMAP_DIO_WRITE;
 		flags |= IOMAP_WRITE;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			flags |= IOMAP_NOWAIT;
 	}
 
 	ret = filemap_write_and_wait_range(mapping, start, end);
diff -puN include/linux/iomap.h~fs-introduce-iomap_nowait include/linux/iomap.h
--- a/include/linux/iomap.h~fs-introduce-iomap_nowait
+++ a/include/linux/iomap.h
@@ -52,6 +52,7 @@ struct iomap {
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
 #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
+#define IOMAP_NOWAIT		(1 << 5) /* Don't wait for writeback */
 
 struct iomap_ops {
 	/*
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

