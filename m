From: akpm@linux-foundation.org
Subject: [merged] block-disable-block-device-dax-by-default.patch removed
 from -mm tree
Date: Mon, 29 Feb 2016 12:24:50 -0800
Message-ID: <56d4a912.b3fSXOgYSK1+8NvH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbcB2UYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, axboe@fb.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, ross.zwisler@linux.intel.com, tytso@mit.edu, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: disable block device DAX by default
has been removed from the -mm tree.  Its filename was
     block-disable-block-device-dax-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: block: disable block device DAX by default

The recent *sync enabling discovered that we are inserting into the
block_device pagecache counter to the expectations of the dirty data
tracking for dax mappings.  This can lead to data corruption.

We want to support DAX for block devices eventually, but it requires wider
changes to properly manage the pagecache.

  [<ffffffff81576d93>] dump_stack+0x85/0xc2
  [<ffffffff812b9ee0>] dax_writeback_mapping_range+0x60/0xe0
  [<ffffffff812a1d4f>] blkdev_writepages+0x3f/0x50
  [<ffffffff811db011>] do_writepages+0x21/0x30
  [<ffffffff811cb6a6>] __filemap_fdatawrite_range+0xc6/0x100
  [<ffffffff811cb75a>] filemap_write_and_wait+0x4a/0xa0
  [<ffffffff812a15e0>] set_blocksize+0x70/0xd0
  [<ffffffff812a273d>] sb_set_blocksize+0x1d/0x50
  [<ffffffff8132ac9b>] ext4_fill_super+0x75b/0x3360
  [<ffffffff81583381>] ? vsnprintf+0x201/0x4c0
  [<ffffffff815836d9>] ? snprintf+0x49/0x60
  [<ffffffff81263010>] mount_bdev+0x180/0x1b0
  [<ffffffff8132a540>] ? ext4_calculate_overhead+0x370/0x370
  [<ffffffff8131ad95>] ext4_mount+0x15/0x20
  [<ffffffff81263908>] mount_fs+0x38/0x170

Mark the support broken so its disabled by default, but otherwise still
available for testing.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig  |   13 +++++++++++++
 fs/block_dev.c |    6 +++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN block/Kconfig~block-disable-block-device-dax-by-default block/Kconfig
--- a/block/Kconfig~block-disable-block-device-dax-by-default
+++ a/block/Kconfig
@@ -88,6 +88,19 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
+config BLK_DEV_DAX
+	bool "Block device DAX support"
+	depends on FS_DAX
+	depends on BROKEN
+	help
+	  When DAX support is available (CONFIG_FS_DAX) raw block
+	  devices can also support direct userspace access to the
+	  storage capacity via MMAP(2) similar to a file on a
+	  DAX-enabled filesystem.  However, the DAX I/O-path disables
+	  some standard I/O-statistics, and the MMAP(2) path has some
+	  operational differences due to bypassing the page
+	  cache.  If in doubt, say N.
+
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
 	depends on BLK_CGROUP=y
diff -puN fs/block_dev.c~block-disable-block-device-dax-by-default fs/block_dev.c
--- a/fs/block_dev.c~block-disable-block-device-dax-by-default
+++ a/fs/block_dev.c
@@ -1201,7 +1201,11 @@ static int __blkdev_get(struct block_dev
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		bdev->bd_inode->i_flags = disk->fops->direct_access ? S_DAX : 0;
+		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
+			bdev->bd_inode->i_flags = S_DAX;
+		else
+			bdev->bd_inode->i_flags = 0;
+
 		if (!partno) {
 			ret = -ENXIO;
 			bdev->bd_part = disk_get_part(disk, partno);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-config_nr_zones_extended.patch

