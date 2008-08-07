From: akpm@linux-foundation.org
Subject: + radeonfb-fix-engine-hangs-and-cache-flushing.patch added to -mm tree
Date: Wed, 06 Aug 2008 20:31:45 -0700
Message-ID: <200808070331.m773VjHZ029650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbYHGDcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 23:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, davem@davemloft.net, stable@kernel.org


The patch titled
     radeonfb: fix copyarea for R300 and later
has been added to the -mm tree.  Its filename is
     radeonfb-fix-engine-hangs-and-cache-flushing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix copyarea for R300 and later
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

(Thanks to David Miller for debugging that on his rv370 and
providing the initial version of that patch !)

This patches fixes a few things.

One is, among the 3 or so different variants of cache control
registers, radeon_engine_flush() is using one that shouldn't be used on
r3xx and later.  This fixes it by making is use one that should work on
everything at least for the 2D cache.

We also didn't use the proper list of chip families on some functions,
this resyncs us with what X does.

In addition, I added a waitfor fifo in radeon_engine_flush() to make
sure the cache flush command did hit the register backbone before
testing for completion of the flush operation.

Finally, we enqueue a destination cache flush and a wait for engine
idle before solid fills and blits.  This effectively prevents those
operations from being pipelined and shouldn't be necessary but it
appaears to cure some hangs on David's card, so I suspect something
fishy is going on with the engine caches.  The performances of radeonfb
don't appear to suffer a great deal from that anyway.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |   39 ++++++++++++++++++++++-------
 drivers/video/aty/radeon_base.c  |   13 +++------
 drivers/video/aty/radeonfb.h     |   33 ++++++++++++++----------
 include/video/radeon.h           |    9 +++++-
 4 files changed, 63 insertions(+), 31 deletions(-)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-fix-engine-hangs-and-cache-flushing drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-fix-engine-hangs-and-cache-flushing
+++ a/drivers/video/aty/radeon_accel.c
@@ -55,6 +55,14 @@ static void radeonfb_prim_fillrect(struc
 	OUTREG(DP_WRITE_MSK, 0xffffffff);
 	OUTREG(DP_CNTL, (DST_X_LEFT_TO_RIGHT | DST_Y_TOP_TO_BOTTOM));
 
+	/* Ensure the dst cache is flushed and the engine idle before
+	 * issuing the operation.
+	 *
+	 * This works around engine lockups on some cards
+	 */
+	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
+	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
+
 	radeon_fifo_wait(2);  
 	OUTREG(DST_Y_X, (region->dy << 16) | region->dx);
 	OUTREG(DST_WIDTH_HEIGHT, (region->width << 16) | region->height);
@@ -116,6 +124,15 @@ static void radeonfb_prim_copyarea(struc
 	OUTREG(DP_CNTL, (xdir>=0 ? DST_X_LEFT_TO_RIGHT : 0)
 			| (ydir>=0 ? DST_Y_TOP_TO_BOTTOM : 0));
 
+	/* Ensure the dst cache is flushed and the engine idle before
+	 * issuing the operation.
+	 *
+	 * This works around engine lockups on some cards
+	 */
+	radeon_fifo_wait(2);
+	OUTREG(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL);
+	OUTREG(WAIT_UNTIL, (WAIT_2D_IDLECLEAN | WAIT_DMA_GUI_IDLE));
+
 	radeon_fifo_wait(3);
 	OUTREG(SRC_Y_X, (sy << 16) | sx);
 	OUTREG(DST_Y_X, (dy << 16) | dx);
@@ -203,9 +220,7 @@ void radeonfb_engine_reset(struct radeon
 	host_path_cntl = INREG(HOST_PATH_CNTL);
 	rbbm_soft_reset = INREG(RBBM_SOFT_RESET);
 
-	if (rinfo->family == CHIP_FAMILY_R300 ||
-	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	if (IS_R300_VARIANT(rinfo)) {
 		u32 tmp;
 
 		OUTREG(RBBM_SOFT_RESET, (rbbm_soft_reset |
@@ -241,9 +256,7 @@ void radeonfb_engine_reset(struct radeon
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 &&
-	    rinfo->family != CHIP_FAMILY_R350 &&
-	    rinfo->family != CHIP_FAMILY_RV350)
+	if (!IS_R300_VARIANT(rinfo))
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
 	OUTREG(CLOCK_CNTL_INDEX, clock_cntl_index);
@@ -260,10 +273,18 @@ void radeonfb_engine_init (struct radeon
 	radeonfb_engine_reset(rinfo);
 
 	radeon_fifo_wait (1);
-	if ((rinfo->family != CHIP_FAMILY_R300) &&
-	    (rinfo->family != CHIP_FAMILY_R350) &&
-	    (rinfo->family != CHIP_FAMILY_RV350))
+	if (IS_R300_VARIANT(rinfo)) {
+		OUTREG(RB2D_DSTCACHE_MODE, INREG(RB2D_DSTCACHE_MODE) |
+		       RB2D_DC_AUTOFLUSH_ENABLE |
+		       RB2D_DC_DC_DISABLE_IGNORE_PE);
+	} else {
+		/* This needs to be double checked with ATI. Latest X driver
+		 * completely "forgets" to set this register on < r3xx, and
+		 * we used to just write 0 there... I'll keep the 0 and update
+		 * that when we have sorted things out on X side.
+		 */
 		OUTREG(RB2D_DSTCACHE_MODE, 0);
+	}
 
 	radeon_fifo_wait (3);
 	/* We re-read MC_FB_LOCATION from card as it can have been
diff -puN drivers/video/aty/radeon_base.c~radeonfb-fix-engine-hangs-and-cache-flushing drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-fix-engine-hangs-and-cache-flushing
+++ a/drivers/video/aty/radeon_base.c
@@ -1286,11 +1286,10 @@ static void radeon_write_pll_regs(struct
 	radeon_pll_errata_after_data(rinfo);
 
 	/* Set PPLL ref. div */
-	if (rinfo->family == CHIP_FAMILY_R300 ||
+	if (IS_R300_VARIANT(rinfo) ||
 	    rinfo->family == CHIP_FAMILY_RS300 ||
-	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350 ||
-	    rinfo->family == CHIP_FAMILY_RV380 ) {
+	    rinfo->family == CHIP_FAMILY_RS400 ||
+	    rinfo->family == CHIP_FAMILY_RS480) {
 		if (mode->ppll_ref_div & R300_PPLL_REF_DIV_ACC_MASK) {
 			/* When restoring console mode, use saved PPLL_REF_DIV
 			 * setting.
@@ -1461,10 +1460,7 @@ static void radeon_calc_pll_regs(struct 
 		/* Not all chip revs have the same format for this register,
 		 * extract the source selection
 		 */
-		if (rinfo->family == CHIP_FAMILY_R200 ||
-		    rinfo->family == CHIP_FAMILY_R300 ||
-		    rinfo->family == CHIP_FAMILY_R350 ||
-		    rinfo->family == CHIP_FAMILY_RV350) {
+		if (rinfo->family == CHIP_FAMILY_R200 || IS_R300_VARIANT(rinfo)) {
 			source = (fp2_gen_cntl >> 10) & 0x3;
 			/* sourced from transform unit, check for transform unit
 			 * own source
@@ -2005,6 +2001,7 @@ static void radeon_identify_vram(struct 
             (rinfo->family == CHIP_FAMILY_RS200) ||
             (rinfo->family == CHIP_FAMILY_RS300) ||
             (rinfo->family == CHIP_FAMILY_RC410) ||
+            (rinfo->family == CHIP_FAMILY_RS400) ||
 	    (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
diff -puN drivers/video/aty/radeonfb.h~radeonfb-fix-engine-hangs-and-cache-flushing drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-fix-engine-hangs-and-cache-flushing
+++ a/drivers/video/aty/radeonfb.h
@@ -53,6 +53,7 @@ enum radeon_family {
 	CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
 	CHIP_FAMILY_R420,     /* R420/R423/M18 */
 	CHIP_FAMILY_RC410,
+	CHIP_FAMILY_RS400,
 	CHIP_FAMILY_RS480,
 	CHIP_FAMILY_LAST,
 };
@@ -533,33 +534,39 @@ static inline u32 radeon_get_dstbpp(u16 
 /*
  * 2D Engine helper routines
  */
-static inline void radeon_engine_flush (struct radeonfb_info *rinfo)
+
+static inline void _radeon_fifo_wait(struct radeonfb_info *rinfo, int entries)
 {
 	int i;
 
-	/* initiate flush */
-	OUTREGP(RB2D_DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL,
-	        ~RB2D_DC_FLUSH_ALL);
-
-	for (i=0; i < 2000000; i++) {
-		if (!(INREG(RB2D_DSTCACHE_CTLSTAT) & RB2D_DC_BUSY))
+	for (i=0; i<2000000; i++) {
+		if ((INREG(RBBM_STATUS) & 0x7f) >= entries)
 			return;
 		udelay(1);
 	}
-	printk(KERN_ERR "radeonfb: Flush Timeout !\n");
+	printk(KERN_ERR "radeonfb: FIFO Timeout !\n");
 }
 
-
-static inline void _radeon_fifo_wait(struct radeonfb_info *rinfo, int entries)
+static inline void radeon_engine_flush (struct radeonfb_info *rinfo)
 {
 	int i;
 
-	for (i=0; i<2000000; i++) {
-		if ((INREG(RBBM_STATUS) & 0x7f) >= entries)
+	/* Initiate flush */
+	OUTREGP(DSTCACHE_CTLSTAT, RB2D_DC_FLUSH_ALL,
+	        ~RB2D_DC_FLUSH_ALL);
+
+	/* Ensure FIFO is empty, ie, make sure the flush commands
+	 * has reached the cache
+	 */
+	_radeon_fifo_wait (rinfo, 64);
+
+	/* Wait for the flush to complete */
+	for (i=0; i < 2000000; i++) {
+		if (!(INREG(DSTCACHE_CTLSTAT) & RB2D_DC_BUSY))
 			return;
 		udelay(1);
 	}
-	printk(KERN_ERR "radeonfb: FIFO Timeout !\n");
+	printk(KERN_ERR "radeonfb: Flush Timeout !\n");
 }
 
 
diff -puN include/video/radeon.h~radeonfb-fix-engine-hangs-and-cache-flushing include/video/radeon.h
--- a/include/video/radeon.h~radeonfb-fix-engine-hangs-and-cache-flushing
+++ a/include/video/radeon.h
@@ -386,7 +386,7 @@
 #define SC_BOTTOM_RIGHT                        0x16F0  
 #define SRC_SC_BOTTOM_RIGHT                    0x16F4  
 #define RB2D_DSTCACHE_MODE		       0x3428
-#define RB2D_DSTCACHE_CTLSTAT		       0x342C
+#define RB2D_DSTCACHE_CTLSTAT_broken	       0x342C /* do not use */
 #define LVDS_GEN_CNTL			       0x02d0
 #define LVDS_PLL_CNTL			       0x02d4
 #define FP2_GEN_CNTL                           0x0288
@@ -532,6 +532,9 @@
 #define RB2D_DC_FLUSH_ALL			   (RB2D_DC_FLUSH_2D | RB2D_DC_FREE_2D)
 #define RB2D_DC_BUSY				   (1 << 31)
 
+/* DSTCACHE_MODE bits constants */
+#define RB2D_DC_AUTOFLUSH_ENABLE                   (1 << 8)
+#define RB2D_DC_DC_DISABLE_IGNORE_PE               (1 << 17)
 
 /* CRTC_GEN_CNTL bit constants */
 #define CRTC_DBL_SCAN_EN                           0x00000001
@@ -742,6 +745,10 @@
 #define SOFT_RESET_RB           		   (1 <<  6)
 #define SOFT_RESET_HDP          		   (1 <<  7)
 
+/* WAIT_UNTIL bit constants */
+#define WAIT_DMA_GUI_IDLE			   (1 << 9)
+#define WAIT_2D_IDLECLEAN			   (1 << 16)
+
 /* SURFACE_CNTL bit consants */
 #define SURF_TRANSLATION_DIS			   (1 << 8)
 #define NONSURF_AP0_SWP_16BPP			   (1 << 20)
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

radeonfb-fix-engine-hangs-and-cache-flushing.patch
linux-next.patch
powerpc-replace-__function__-with-__func__.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
radeonfb-revert-fix-radeon-ddc-regression.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

