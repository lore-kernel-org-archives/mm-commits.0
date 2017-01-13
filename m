From: akpm@linux-foundation.org
Subject: + dax-enable-iostat-for-read-write.patch added to -mm tree
Date: Fri, 13 Jan 2017 14:54:23 -0800
Message-ID: <58795a9f.sHODvyFF5mMpvBh5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdAMWyY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 17:54:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, dan.j.williams@intel.com, david@fromorbit.com, joe@perches.com, ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: DAX: enable iostat for read/write
has been added to the -mm tree.  Its filename is
     dax-enable-iostat-for-read-write.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-enable-iostat-for-read-write.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-enable-iostat-for-read-write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: DAX: enable iostat for read/write

DAX IO path does not support iostat, but its metadata IO path does. 
Therefore, iostat shows metadata IO statistics only, which has been
confusing to users.

Add iostat support to the DAX read/write path.

Note, iostat still does not support the DAX mmap path as it allows user
applications to access directly.

Link: http://lkml.kernel.org/r/20170113233418.32252-1-toshi.kani@hpe.com
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN fs/dax.c~dax-enable-iostat-for-read-write fs/dax.c
--- a/fs/dax.c~dax-enable-iostat-for-read-write
+++ a/fs/dax.c
@@ -1081,12 +1081,24 @@ dax_iomap_rw(struct kiocb *iocb, struct
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
+	struct gendisk *disk = inode->i_sb->s_bdev->bd_disk;
 	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
 	unsigned flags = 0;
+	unsigned long start = 0;
+	int do_acct = blk_queue_io_stat(disk->queue);
 
 	if (iov_iter_rw(iter) == WRITE)
 		flags |= IOMAP_WRITE;
 
+	if (do_acct) {
+		size_t sec = iov_iter_count(iter) >> 9;
+
+		start = jiffies;
+		generic_start_io_acct(iov_iter_rw(iter),
+				      max_t(unsigned long, 1, sec),
+				      &disk->part0);
+	}
+
 	while (iov_iter_count(iter)) {
 		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
 				iter, dax_iomap_actor);
@@ -1096,6 +1108,9 @@ dax_iomap_rw(struct kiocb *iocb, struct
 		done += ret;
 	}
 
+	if (do_acct)
+		generic_end_io_acct(iov_iter_rw(iter), &disk->part0, start);
+
 	iocb->ki_pos += done;
 	return done ? done : ret;
 }
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

dax-enable-iostat-for-read-write.patch

