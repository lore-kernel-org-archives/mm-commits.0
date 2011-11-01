From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-fix-sync_single_range_-dma-debugging.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:07:00 -0700
Message-ID: <201111012107.pA1L72CA030829@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clemens@ladisch.de, fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: fix sync_single_range_* DMA debugging
has been removed from the -mm tree.  Its filename was
     dma-mapping-fix-sync_single_range_-dma-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Clemens Ladisch <clemens@ladisch.de>
Subject: dma-mapping: fix sync_single_range_* DMA debugging

Commit 5fd75a7850b5 (dma-mapping: remove unnecessary sync_single_range_*
in dma_map_ops) unified not only the dma_map_ops but also the
corresponding debug_dma_sync_* calls.  This led to spurious WARN()ings
like the following because the DMA debug code was no longer able to detect
the DMA buffer base address without the separate offset parameter:

WARNING: at lib/dma-debug.c:911 check_sync+0xce/0x446()
firewire_ohci 0000:04:00.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x00000000cedaa400] [size=1024 bytes]
Call Trace: ...
 [<ffffffff811326a5>] check_sync+0xce/0x446
 [<ffffffff81132ad9>] debug_dma_sync_single_for_device+0x39/0x3b
 [<ffffffffa01d6e6a>] ohci_queue_iso+0x4f3/0x77d [firewire_ohci]
 ...

To fix this, unshare the sync_single_* and sync_single_range_*
implementations so that we are able to call the correct debug_dma_sync_*
functions.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/dma-mapping-common.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/dma-mapping-common.h~dma-mapping-fix-sync_single_range_-dma-debugging include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~dma-mapping-fix-sync_single_range_-dma-debugging
+++ a/include/asm-generic/dma-mapping-common.h
@@ -123,7 +123,12 @@ static inline void dma_sync_single_range
 						 size_t size,
 						 enum dma_data_direction dir)
 {
-	dma_sync_single_for_cpu(dev, addr + offset, size, dir);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_for_cpu)
+		ops->sync_single_for_cpu(dev, addr + offset, size, dir);
+	debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 }
 
 static inline void dma_sync_single_range_for_device(struct device *dev,
@@ -132,7 +137,12 @@ static inline void dma_sync_single_range
 						    size_t size,
 						    enum dma_data_direction dir)
 {
-	dma_sync_single_for_device(dev, addr + offset, size, dir);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	BUG_ON(!valid_dma_direction(dir));
+	if (ops->sync_single_for_device)
+		ops->sync_single_for_device(dev, addr + offset, size, dir);
+	debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 }
 
 static inline void
_

Patches currently in -mm which might be from clemens@ladisch.de are

origin.patch
linux-next.patch
hpet-factor-timer-allocate-from-open.patch

