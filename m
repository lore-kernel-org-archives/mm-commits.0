From: akpm@linux-foundation.org
Subject: [merged] zram-avoid-lockdep-splat-by-revalidate_disk.patch
 removed from -mm tree
Date: Thu, 24 Jul 2014 13:47:15 -0700
Message-ID: <53d170d3.1kZ5QIGCsXHXrud7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:43654 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651AbaGXUrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 16:47:16 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so917057pdj.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 13:47:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, ngupta@vflare.org, patrakov@gmail.com, sasha.levin@oracle.com, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: avoid lockdep splat by revalidate_disk
has been removed from the -mm tree.  Its filename was
     zram-avoid-lockdep-splat-by-revalidate_disk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: avoid lockdep splat by revalidate_disk

Sasha reported lockdep warning [1] introduced by [2].

It could be fixed by doing disk revalidation out of the init_lock.
It's okay because disk capacity change is protected by init_lock
so that revalidate_disk always sees up-to-date value so there is
no race.

[1] https://lkml.org/lkml/2014/7/3/735
[2] zram: revalidate disk after capacity change

Fixes 2e32baea46ce542c56 ("zram: revalidate disk after capacity change").

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-avoid-lockdep-splat-by-revalidate_disk drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-avoid-lockdep-splat-by-revalidate_disk
+++ a/drivers/block/zram/zram_drv.c
@@ -622,11 +622,18 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	if (reset_capacity) {
+	if (reset_capacity)
 		set_capacity(zram->disk, 0);
-		revalidate_disk(zram->disk);
-	}
+
 	up_write(&zram->init_lock);
+
+	/*
+	 * Revalidate disk out of the init_lock to avoid lockdep splat.
+	 * It's okay because disk's capacity is protected by init_lock
+	 * so that revalidate_disk always sees up-to-date capacity.
+	 */
+	if (reset_capacity)
+		revalidate_disk(zram->disk);
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -666,8 +673,15 @@ static ssize_t disksize_store(struct dev
 	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	revalidate_disk(zram->disk);
 	up_write(&zram->init_lock);
+
+	/*
+	 * Revalidate disk out of the init_lock to avoid lockdep splat.
+	 * It's okay because disk's capacity is protected by init_lock
+	 * so that revalidate_disk always sees up-to-date capacity.
+	 */
+	revalidate_disk(zram->disk);
+
 	return len;
 
 out_destroy_comp:
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
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
mm-vmallocc-clean-up-map_vm_area-third-argument.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-rename-struct-table-to-zram_table_entry.patch
zram-remove-unused-sector_size-define.patch
zram-use-size_t-instead-of-u16.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

