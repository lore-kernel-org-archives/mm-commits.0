From: akpm@linux-foundation.org
Subject: + block_dev-implement-readpages-to-optimize-sequential-read.patch added to -mm tree
Date: Thu, 21 Aug 2014 14:44:19 -0700
Message-ID: <53f66833.SKKHGwOzmNS2V1vS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:56681 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbaHUVoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 17:44:21 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so1681846igd.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 14:44:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, jmoyer@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block_dev: implement readpages() to optimize sequential read
has been added to the -mm tree.  Its filename is
     block_dev-implement-readpages-to-optimize-sequential-read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block_dev-implement-readpages-to-optimize-sequential-read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block_dev-implement-readpages-to-optimize-sequential-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

vfs-make-guard_bh_eod-more-generic.patch
vfs-guard-end-of-device-for-mpage-interface.patch
block_dev-implement-readpages-to-optimize-sequential-read.patch
linux-next.patch

