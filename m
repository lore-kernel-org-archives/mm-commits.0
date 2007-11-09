From: akpm@linux-foundation.org
Subject: + mm-fix-blkdev-size-calculation-in-generic_write_checks.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:51:23 -0800
Message-ID: <200711090451.lA94pOCe030151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759432AbXKIEvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:51:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     mm: fix blkdev size calculation in generic_write_checks
has been added to the -mm tree.  Its filename is
     mm-fix-blkdev-size-calculation-in-generic_write_checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix blkdev size calculation in generic_write_checks
From: Dmitry Monakhov <dmonakhov@openvz.org>

Currently block device size calculated regardless its bd_block_size.  This
may result attempt to write outside block device if i_size not aligned to
bdev->bd_block_size and result in EIO.

#### TEST_CASE_BEGIN
# fdisk -l /dev/sdc
Disk /dev/sdc: 36.7 GB, 36703918080 bytes
255 heads, 63 sectors/track, 4462 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1   *           1         254     2040223+  83  Ldinux
/dev/sdc2             255         379     1004062+  83  Linux
####
#### /dev/sdc2 size not aligned to 4K

#### at this time bd_block_size == 512 so generic_write_check
#### performed correctly
# dd if=/dev/zero of=/dev/sdc2 bs=1k count=7 seek=1004058
dd: writing `/dev/sdc2': No space left on device
5+0 records in
4+0 records out

#### this bdev contain ext4fs with blksize = 4K
# mount /dev/sdc2 /mnt/
#### after we mounted this bdev bd_block_size == fsblksize == 4K

#### the same write operation failed with EIO
# dd if=/dev/zero of=/dev/sdc2 bs=1k count=7 seek=1004058
dd: writing `/dev/sdc2': Input/output error
3+0 records in
2+0 records out
#### Attempt to write whole fsblock result write access outside
#### blkdevice and cause -EIO (returned by blkdev_get_block)
#### TEST_CASE_END

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-fix-blkdev-size-calculation-in-generic_write_checks mm/filemap.c
--- a/mm/filemap.c~mm-fix-blkdev-size-calculation-in-generic_write_checks
+++ a/mm/filemap.c
@@ -1856,9 +1856,11 @@ inline int generic_write_checks(struct f
 	} else {
 #ifdef CONFIG_BLOCK
 		loff_t isize;
+		unsigned int blksize;
 		if (bdev_read_only(I_BDEV(inode)))
 			return -EPERM;
-		isize = i_size_read(inode);
+		blksize = block_size(I_BDEV(inode));
+		isize = i_size_read(inode) & ~(blksize - 1);
 		if (*pos >= isize) {
 			if (*count || *pos > isize)
 				return -ENOSPC;
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

git-md-accel.patch
mm-fix-blkdev-size-calculation-in-generic_write_checks.patch
