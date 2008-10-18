From: akpm@linux-foundation.org
Subject: - radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:36 -0700
Message-ID: <200810182317.m9INHatU029125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbYJRXRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, davem@davemloft.net, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     radeonfb: misc cleanup of engine and dst cache handling
has been removed from the -mm tree.  Its filename was
     radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: misc cleanup of engine and dst cache handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Fix a couple of incomplete tests of the chip families in the engine
init/reset code and proper initialization of the destination cache mode. 
The result should better match what the latest X radeon driver does.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |   22 +++++++++++--------
 drivers/video/aty/radeon_base.c  |   13 ++++-------
 drivers/video/aty/radeonfb.h     |   33 +++++++++++++++++------------
 include/video/radeon.h           |    5 +++-
 4 files changed, 42 insertions(+), 31 deletions(-)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling
+++ a/drivers/video/aty/radeon_accel.c
@@ -211,9 +211,7 @@ void radeonfb_engine_reset(struct radeon
 	host_path_cntl = INREG(HOST_PATH_CNTL);
 	rbbm_soft_reset = INREG(RBBM_SOFT_RESET);
 
-	if (rinfo->family == CHIP_FAMILY_R300 ||
-	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	if (IS_R300_VARIANT(rinfo)) {
 		u32 tmp;
 
 		OUTREG(RBBM_SOFT_RESET, (rbbm_soft_reset |
@@ -249,9 +247,7 @@ void radeonfb_engine_reset(struct radeon
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 &&
-	    rinfo->family != CHIP_FAMILY_R350 &&
-	    rinfo->family != CHIP_FAMILY_RV350)
+	if (!IS_R300_VARIANT(rinfo))
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
 	OUTREG(CLOCK_CNTL_INDEX, clock_cntl_index);
@@ -268,10 +264,18 @@ void radeonfb_engine_init (struct radeon
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
diff -puN drivers/video/aty/radeon_base.c~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling
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
diff -puN drivers/video/aty/radeonfb.h~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling
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
 
 
diff -puN include/video/radeon.h~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling include/video/radeon.h
--- a/include/video/radeon.h~radeonfb-misc-cleanup-of-engine-and-dst-cache-handling
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
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
edac-cell-fix-incorrect-edac_mode.patch

