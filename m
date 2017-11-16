From: akpm@linux-foundation.org
Subject: [merged] bdi-introduce-bdi_cap_synchronous_io.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:00:07 -0800
Message-ID: <20171116200007.2zKoeG9e8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934614AbdKPUAJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, dan.j.williams@intel.com, hch@lst.de, hughd@google.com, idryomov@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sergey.senozhatsky@gmail.com, ying.huang@intel.com


The patch titled
     Subject: bdi: introduce BDI_CAP_SYNCHRONOUS_IO
has been removed from the -mm tree.  Its filename was
     bdi-introduce-bdi_cap_synchronous_io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: bdi: introduce BDI_CAP_SYNCHRONOUS_IO

As discussed at
lkml.kernel.org/r/<20170728165604.10455-1-ross.zwisler@linux.intel.com>,
someday we will remove rw_page().  If so, we need something to detect such
super-fast storage on which synchronous IO operations like the current
rw_page are always a win.

Introduces BDI_CAP_SYNCHRONOUS_IO to indicate such devices.  With it, we
could use various optimization techniques.

Link: http://lkml.kernel.org/r/1505886205-9671-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c           |    2 ++
 drivers/block/zram/zram_drv.c |    2 +-
 drivers/nvdimm/btt.c          |    3 +++
 drivers/nvdimm/pmem.c         |    2 ++
 include/linux/backing-dev.h   |    8 ++++++++
 5 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/block/brd.c~bdi-introduce-bdi_cap_synchronous_io drivers/block/brd.c
--- a/drivers/block/brd.c~bdi-introduce-bdi_cap_synchronous_io
+++ a/drivers/block/brd.c
@@ -20,6 +20,7 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/backing-dev.h>
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 #include <linux/pfn_t.h>
 #include <linux/dax.h>
@@ -448,6 +449,7 @@ static struct brd_device *brd_alloc(int
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
+	disk->queue->backing_dev_info->capabilities |= BDI_CAP_SYNCHRONOUS_IO;
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
diff -puN drivers/block/zram/zram_drv.c~bdi-introduce-bdi_cap_synchronous_io drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~bdi-introduce-bdi_cap_synchronous_io
+++ a/drivers/block/zram/zram_drv.c
@@ -1558,7 +1558,7 @@ static int zram_add(void)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
 	zram->disk->queue->backing_dev_info->capabilities |=
-					BDI_CAP_STABLE_WRITES;
+			(BDI_CAP_STABLE_WRITES | BDI_CAP_SYNCHRONOUS_IO);
 	add_disk(zram->disk);
 
 	ret = sysfs_create_group(&disk_to_dev(zram->disk)->kobj,
diff -puN drivers/nvdimm/btt.c~bdi-introduce-bdi_cap_synchronous_io drivers/nvdimm/btt.c
--- a/drivers/nvdimm/btt.c~bdi-introduce-bdi_cap_synchronous_io
+++ a/drivers/nvdimm/btt.c
@@ -23,6 +23,7 @@
 #include <linux/ndctl.h>
 #include <linux/fs.h>
 #include <linux/nd.h>
+#include <linux/backing-dev.h>
 #include "btt.h"
 #include "nd.h"
 
@@ -1402,6 +1403,8 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_disk->private_data = btt;
 	btt->btt_disk->queue = btt->btt_queue;
 	btt->btt_disk->flags = GENHD_FL_EXT_DEVT;
+	btt->btt_disk->queue->backing_dev_info->capabilities |=
+			BDI_CAP_SYNCHRONOUS_IO;
 
 	blk_queue_make_request(btt->btt_queue, btt_make_request);
 	blk_queue_logical_block_size(btt->btt_queue, btt->sector_size);
diff -puN drivers/nvdimm/pmem.c~bdi-introduce-bdi_cap_synchronous_io drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~bdi-introduce-bdi_cap_synchronous_io
+++ a/drivers/nvdimm/pmem.c
@@ -31,6 +31,7 @@
 #include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/nd.h>
+#include <linux/backing-dev.h>
 #include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
@@ -394,6 +395,7 @@ static int pmem_attach_disk(struct devic
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
+	disk->queue->backing_dev_info->capabilities |= BDI_CAP_SYNCHRONOUS_IO;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
diff -puN include/linux/backing-dev.h~bdi-introduce-bdi_cap_synchronous_io include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~bdi-introduce-bdi_cap_synchronous_io
+++ a/include/linux/backing-dev.h
@@ -122,6 +122,8 @@ int bdi_set_max_ratio(struct backing_dev
  * BDI_CAP_STRICTLIMIT:    Keep number of dirty pages below bdi threshold.
  *
  * BDI_CAP_CGROUP_WRITEBACK: Supports cgroup-aware writeback.
+ * BDI_CAP_SYNCHRONOUS_IO: Device is so fast that asynchronous IO would be
+ *			   inefficient.
  */
 #define BDI_CAP_NO_ACCT_DIRTY	0x00000001
 #define BDI_CAP_NO_WRITEBACK	0x00000002
@@ -129,6 +131,7 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_STABLE_WRITES	0x00000008
 #define BDI_CAP_STRICTLIMIT	0x00000010
 #define BDI_CAP_CGROUP_WRITEBACK 0x00000020
+#define BDI_CAP_SYNCHRONOUS_IO	0x00000040
 
 #define BDI_CAP_NO_ACCT_AND_WRITEBACK \
 	(BDI_CAP_NO_WRITEBACK | BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_ACCT_WB)
@@ -174,6 +177,11 @@ static inline int wb_congested(struct bd
 long congestion_wait(int sync, long timeout);
 long wait_iff_congested(struct pglist_data *pgdat, int sync, long timeout);
 
+static inline bool bdi_cap_synchronous_io(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_SYNCHRONOUS_IO;
+}
+
 static inline bool bdi_cap_stable_pages_required(struct backing_dev_info *bdi)
 {
 	return bdi->capabilities & BDI_CAP_STABLE_WRITES;
_

Patches currently in -mm which might be from minchan@kernel.org are


