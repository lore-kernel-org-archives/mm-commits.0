From: akpm@linux-foundation.org
Subject: [merged]
 block_dev-implement-readpages-to-optimize-sequential-read.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:19:25 -0700
Message-ID: <543c17ad.O9EdjeK16Y+aPFAZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, jmoyer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block_dev: implement readpages() to optimize sequential read
has been removed from the -mm tree.  Its filename was
     block_dev-implement-readpages-to-optimize-sequential-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: block_dev: implement readpages() to optimize sequential read

Sequential read from a block device is expected to be equal or faster than
from the file on a filesystem.  But it is not correct due to the lack of
effective readpages() in the address space operations for block device.

This implements readpages() operation for block device by using
mpage_readpages() which can create multipage BIOs instead of BIOs for each
page and reduce system CPU time consumption.

Install 1GB of RAM disk storage:

	# modprobe scsi_debug dev_size_mb=1024 delay=0

Sequential read from file on a filesystem:

	# mkfs.ext4 /dev/$DEV
	# mount /dev/$DEV /mnt
	# fio --name=t --size=512m --rw=read --filename=/mnt/file
	...
	  read : io=524288KB, bw=2133.4MB/s, iops=546133, runt=   240msec

Sequential read from a block device:
	# fio --name=t --size=512m --rw=read --filename=/dev/$DEV
	...
(Without this commit)
	  read : io=524288KB, bw=1700.2MB/s, iops=435455, runt=   301msec

(With this commit)
	  read : io=524288KB, bw=2160.4MB/s, iops=553046, runt=   237msec

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/block_dev.c~block_dev-implement-readpages-to-optimize-sequential-read fs/block_dev.c
--- a/fs/block_dev.c~block_dev-implement-readpages-to-optimize-sequential-read
+++ a/fs/block_dev.c
@@ -304,6 +304,12 @@ static int blkdev_readpage(struct file *
 	return block_read_full_page(page, blkdev_get_block);
 }
 
+static int blkdev_readpages(struct file *file, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
+}
+
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -1622,6 +1628,7 @@ static int blkdev_releasepage(struct pag
 
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
+	.readpages	= blkdev_readpages,
 	.writepage	= blkdev_writepage,
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch

