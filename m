From: akpm@linux-foundation.org
Subject: + sm501-add-support-for-the-sm502-programmable-pll.patch added to -mm tree
Date: Tue, 26 Feb 2008 11:15:22 -0800
Message-ID: <200802261916.m1QJGE5V004182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761777AbYBZTQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Feb 2008 14:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, ben-linux@fluff.org


The patch titled
     sm501: add support for the SM502 programmable PLL
has been added to the -mm tree.  Its filename is
     sm501-add-support-for-the-sm502-programmable-pll.patch

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
Subject: sm501: add support for the SM502 programmable PLL
From: Ville Syrjala <syrjala@sci.fi>

SM502 has a programmable PLL which can provide the panel pixel clock instead
of the 288MHz and 336MHz PLLs.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c        |  163 +++++++++++++++++++++++++++--------
 include/linux/sm501-regs.h |    3 
 include/linux/sm501.h      |    3 
 3 files changed, 133 insertions(+), 36 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-add-support-for-the-sm502-programmable-pll drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-add-support-for-the-sm502-programmable-pll
+++ a/drivers/mfd/sm501.c
@@ -48,6 +48,7 @@ struct sm501_devdata {
 	unsigned int			 pdev_id;
 	unsigned int			 irq;
 	void __iomem			*regs;
+	unsigned int			 rev;
 };
 
 #define MHZ (1000 * 1000)
@@ -417,46 +418,108 @@ struct sm501_clock {
 	unsigned long mclk;
 	int divider;
 	int shift;
+	unsigned int m, n, k;
 };
 
+/* sm501_calc_clock
+ *
+ * Calculates the nearest discrete clock frequency that
+ * can be achieved with the specified input clock.
+ *   the maximum divisor is 3 or 5
+ */
+
+static int sm501_calc_clock(unsigned long freq,
+			    struct sm501_clock *clock,
+			    int max_div,
+			    unsigned long mclk,
+			    long *best_diff)
+{
+	int ret = 0;
+	int divider;
+	int shift;
+	long diff;
+
+	/* try dividers 1 and 3 for CRT and for panel,
+	   try divider 5 for panel only.*/
+
+	for (divider = 1; divider <= max_div; divider += 2) {
+		/* try all 8 shift values.*/
+		for (shift = 0; shift < 8; shift++) {
+			/* Calculate difference to requested clock */
+			diff = sm501fb_round_div(mclk, divider << shift) - freq;
+			if (diff < 0)
+				diff = -diff;
+
+			/* If it is less than the current, use it */
+			if (diff < *best_diff) {
+				*best_diff = diff;
+
+				clock->mclk = mclk;
+				clock->divider = divider;
+				clock->shift = shift;
+				ret = 1;
+			}
+		}
+	}
+
+	return ret;
+}
+
+/* sm501_calc_pll
+ *
+ * Calculates the nearest discrete clock frequency that can be
+ * achieved using the programmable PLL.
+ *   the maximum divisor is 3 or 5
+ */
+
+static unsigned long sm501_calc_pll(unsigned long freq,
+					struct sm501_clock *clock,
+					int max_div)
+{
+	unsigned long mclk;
+	unsigned int m, n, k;
+	long best_diff = 999999999;
+
+	/*
+	 * The SM502 datasheet doesn't specify the min/max values for M and N.
+	 * N = 1 at least doesn't work in practice.
+	 */
+	for (m = 2; m <= 255; m++) {
+		for (n = 2; n <= 127; n++) {
+			for (k = 0; k <= 1; k++) {
+				mclk = (24000000UL * m / n) >> k;
+
+				if (sm501_calc_clock(freq, clock, max_div,
+						     mclk, &best_diff)) {
+					clock->m = m;
+					clock->n = n;
+					clock->k = k;
+				}
+			}
+		}
+	}
+
+	/* Return best clock. */
+	return clock->mclk / (clock->divider << clock->shift);
+}
+
 /* sm501_select_clock
  *
- * selects nearest discrete clock frequency the SM501 can achive
+ * Calculates the nearest discrete clock frequency that can be
+ * achieved using the 288MHz and 336MHz PLLs.
  *   the maximum divisor is 3 or 5
  */
+
 static unsigned long sm501_select_clock(unsigned long freq,
 					struct sm501_clock *clock,
 					int max_div)
 {
 	unsigned long mclk;
-	int divider;
-	int shift;
-	long diff;
 	long best_diff = 999999999;
 
 	/* Try 288MHz and 336MHz clocks. */
 	for (mclk = 288000000; mclk <= 336000000; mclk += 48000000) {
-		/* try dividers 1 and 3 for CRT and for panel,
-		   try divider 5 for panel only.*/
-
-		for (divider = 1; divider <= max_div; divider += 2) {
-			/* try all 8 shift values.*/
-			for (shift = 0; shift < 8; shift++) {
-				/* Calculate difference to requested clock */
-				diff = sm501fb_round_div(mclk, divider << shift) - freq;
-				if (diff < 0)
-					diff = -diff;
-
-				/* If it is less than the current, use it */
-				if (diff < best_diff) {
-					best_diff = diff;
-
-					clock->mclk = mclk;
-					clock->divider = divider;
-					clock->shift = shift;
-				}
-			}
-		}
+		sm501_calc_clock(freq, clock, max_div, mclk, &best_diff);
 	}
 
 	/* Return best clock. */
@@ -478,6 +541,7 @@ unsigned long sm501_set_clock(struct dev
 	unsigned long gate = readl(sm->regs + SM501_CURRENT_GATE);
 	unsigned long clock = readl(sm->regs + SM501_CURRENT_CLOCK);
 	unsigned char reg;
+	unsigned int pll_reg = 0;
 	unsigned long sm501_freq; /* the actual frequency acheived */
 
 	struct sm501_clock to;
@@ -492,14 +556,28 @@ unsigned long sm501_set_clock(struct dev
 		 * requested frequency the value must be multiplied by
 		 * 2. This clock also has an additional pre divisor */
 
-		sm501_freq = (sm501_select_clock(2 * req_freq, &to, 5) / 2);
-		reg=to.shift & 0x07;/* bottom 3 bits are shift */
-		if (to.divider == 3)
-			reg |= 0x08; /* /3 divider required */
-		else if (to.divider == 5)
-			reg |= 0x10; /* /5 divider required */
-		if (to.mclk != 288000000)
-			reg |= 0x20; /* which mclk pll is source */
+		if (sm->rev >= 0xC0) {
+			/* SM502 -> use the programmable PLL */
+			sm501_freq = (sm501_calc_pll(2 * req_freq,
+						     &to, 5) / 2);
+			reg=to.shift & 0x07;/* bottom 3 bits are shift */
+			if (to.divider == 3)
+				reg |= 0x08; /* /3 divider required */
+			else if (to.divider == 5)
+				reg |= 0x10; /* /5 divider required */
+			reg |= 0x40; /* select the programmable PLL */
+			pll_reg = 0x20000 | (to.k << 15) | (to.n << 8) | to.m;
+		} else {
+			sm501_freq = (sm501_select_clock(2 * req_freq,
+							 &to, 5) / 2);
+			reg=to.shift & 0x07;/* bottom 3 bits are shift */
+			if (to.divider == 3)
+				reg |= 0x08; /* /3 divider required */
+			else if (to.divider == 5)
+				reg |= 0x10; /* /5 divider required */
+			if (to.mclk != 288000000)
+				reg |= 0x20; /* which mclk pll is source */
+		}
 		break;
 
 	case SM501_CLOCK_V2XCLK:
@@ -560,6 +638,10 @@ unsigned long sm501_set_clock(struct dev
 	}
 
 	writel(mode, sm->regs + SM501_POWER_MODE_CONTROL);
+
+	if (pll_reg)
+		writel(pll_reg, sm->regs + SM501_PROGRAMMABLE_PLL_CONTROL);
+
 	sm501_sync_regs(sm);
 
 	dev_info(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
@@ -580,15 +662,24 @@ EXPORT_SYMBOL_GPL(sm501_set_clock);
  * finds the closest available frequency for a given clock
 */
 
-unsigned long sm501_find_clock(int clksrc,
+unsigned long sm501_find_clock(struct device *dev,
+			       int clksrc,
 			       unsigned long req_freq)
 {
+	struct sm501_devdata *sm = dev_get_drvdata(dev);
 	unsigned long sm501_freq; /* the frequency achiveable by the 501 */
 	struct sm501_clock to;
 
 	switch (clksrc) {
 	case SM501_CLOCK_P2XCLK:
-		sm501_freq = (sm501_select_clock(2 * req_freq, &to, 5) / 2);
+		if (sm->rev >= 0xC0) {
+			/* SM502 -> use the programmable PLL */
+			sm501_freq = (sm501_calc_pll(2 * req_freq,
+						     &to, 5) / 2);
+		} else {
+			sm501_freq = (sm501_select_clock(2 * req_freq,
+							 &to, 5) / 2);
+		}
 		break;
 
 	case SM501_CLOCK_V2XCLK:
@@ -895,6 +986,8 @@ static int sm501_init_dev(struct sm501_d
 	dev_info(sm->dev, "SM501 At %p: Version %08lx, %ld Mb, IRQ %d\n",
 		 sm->regs, devid, (unsigned long)mem_avail >> 20, sm->irq);
 
+	sm->rev = devid & SM501_DEVICEID_REVMASK;
+
 	sm501_dump_gate(sm);
 
 	ret = device_create_file(sm->dev, &dev_attr_dbg_regs);
diff -puN include/linux/sm501-regs.h~sm501-add-support-for-the-sm502-programmable-pll include/linux/sm501-regs.h
--- a/include/linux/sm501-regs.h~sm501-add-support-for-the-sm502-programmable-pll
+++ a/include/linux/sm501-regs.h
@@ -129,11 +129,14 @@
 
 #define SM501_DEVICEID_SM501		(0x05010000)
 #define SM501_DEVICEID_IDMASK		(0xffff0000)
+#define SM501_DEVICEID_REVMASK		(0x000000ff)
 
 #define SM501_PLLCLOCK_COUNT		(0x000064)
 #define SM501_MISC_TIMING		(0x000068)
 #define SM501_CURRENT_SDRAM_CLOCK	(0x00006C)
 
+#define SM501_PROGRAMMABLE_PLL_CONTROL	(0x000074)
+
 /* GPIO base */
 #define SM501_GPIO			(0x010000)
 #define SM501_GPIO_DATA_LOW		(0x00)
diff -puN include/linux/sm501.h~sm501-add-support-for-the-sm502-programmable-pll include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-add-support-for-the-sm502-programmable-pll
+++ a/include/linux/sm501.h
@@ -24,7 +24,8 @@ extern int sm501_unit_power(struct devic
 extern unsigned long sm501_set_clock(struct device *dev,
 				     int clksrc, unsigned long freq);
 
-extern unsigned long sm501_find_clock(int clksrc, unsigned long req_freq);
+extern unsigned long sm501_find_clock(struct device *dev,
+				      int clksrc, unsigned long req_freq);
 
 /* sm501_misc_control
  *
_

Patches currently in -mm which might be from syrjala@sci.fi are

sm501fb-direct-color-visual-does-not-work.patch
sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch
sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch
sm501fb-fix-timing-limits.patch
sm501-remove-a-duplicated-table.patch
sm501-add-support-for-the-sm502-programmable-pll.patch
