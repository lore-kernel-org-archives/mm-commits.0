From: akpm@linux-foundation.org
Subject: [merged] zram-revalidate-disk-after-capacity-change.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:22 -0700
Message-ID: <53bae2ca.e7zMRcfJPdDXTRnJ%akpm__1390.8959962011$1404756694$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43255 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGSLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id x13so657609qcv.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, ngupta@vflare.org, patrakov@gmail.com, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: revalidate disk after capacity change
has been removed from the -mm tree.  Its filename was
     zram-revalidate-disk-after-capacity-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: revalidate disk after capacity change

Alexander reported mkswap on /dev/zram0 is failed if other process is
opening the block device file.

Step is as follows,

0. Reset the unused zram device.
1. Use a program that opens /dev/zram0 with O_RDWR and sleeps
   until killed.
2. While that program sleeps, echo the correct value to
   /sys/block/zram0/disksize.
3. Verify (e.g. in /proc/partitions) that the disk size is applied
   correctly. It is.
4. While that program still sleeps, attempt to mkswap /dev/zram0.
   This fails: mkswap: error: swap area needs to be at least 40 KiB

When I investigated, the size get by ioctl(fd, BLKGETSIZE64, xxx) on
mkswap to get a size of blockdev was zero although zram0 has right size by
2.

The reason is zram didn't revalidate disk after changing capacity so that
size of blockdev's inode is not uptodate until all of file is close.

This patch should fix the BUG.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-revalidate-disk-after-capacity-change drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-revalidate-disk-after-capacity-change
+++ a/drivers/block/zram/zram_drv.c
@@ -622,8 +622,10 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	if (reset_capacity)
+	if (reset_capacity) {
 		set_capacity(zram->disk, 0);
+		revalidate_disk(zram->disk);
+	}
 	up_write(&zram->init_lock);
 }
 
@@ -664,6 +666,7 @@ static ssize_t disksize_store(struct dev
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	revalidate_disk(zram->disk);
 	up_write(&zram->init_lock);
 	return len;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-rename-struct-table-to-zram_table_entry.patch
zram-remove-unused-sector_size-define.patch
zram-use-size_t-instead-of-u16.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

