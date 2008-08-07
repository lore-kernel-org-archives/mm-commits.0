From: akpm@linux-foundation.org
Subject: - radeonfb-fix-engine-hangs-and-cache-flushing-v2.patch removed from -mm tree
Date: Thu, 07 Aug 2008 02:10:38 -0700
Message-ID: <200808070910.m779Ad3F009207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbYHGMXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 08:23:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     radeonfb: fix engine hangs and cache flushing (v2)
has been removed from the -mm tree.  Its filename was
     radeonfb-fix-engine-hangs-and-cache-flushing-v2.patch

This patch was dropped because it was folded into radeonfb-fix-engine-hangs-and-cache-flushing.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix engine hangs and cache flushing (v2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

(Thanks to David Miller for debugging that on his rv370 and
providing the initial version of that patch !)

This patches fixes a few things.

One is, among the 3 or so different variants of cache control registers,
radeon_engine_flush() is using one that shouldn't be used on r3xx and
later. This fixes it by making is use one that should work on everything
at least for the 2D cache.

We also didn't use the proper list of chip families on some functions,
this resyncs us with what X does.

In addition, I added a waitfor fifo in radeon_engine_flush() to make
sure the cache flush command did hit the register backbone before testing
for completion of the flush operation.

Finally, we enqueue a destination cache flush and a wait for engine
idle before solid fills and blits. This effectively prevents those
operations from being pipelined and shouldn't be necessary but it
appaears to cure some hangs on David's card, so I suspect something
fishy is going on with the engine caches. The performances of radeonfb
don't appear to suffer a great deal from that anyway.

v2. adds a missing wait on fifo

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-fix-engine-hangs-and-cache-flushing-v2 drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-fix-engine-hangs-and-cache-flushing-v2
+++ a/drivers/video/aty/radeon_accel.c
@@ -60,6 +60,7 @@ static void radeonfb_prim_fillrect(struc
 	 *
 	 * This works around engine lockups on some cards
 	 */
+	radeon_fifo_wait(2);
 	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
 	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

radeonfb-fix-engine-hangs-and-cache-flushing.patch
radeonfb-fix-engine-hangs-and-cache-flushing-v2.patch
radeonfb-fix-engine-hangs-and-cache-flushing-checkpatch-fixes.patch
linux-next.patch
powerpc-replace-__function__-with-__func__.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

