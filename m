From: akpm@linux-foundation.org
Subject: - sm501-clock-updates-and-checks.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:20:41 -0700
Message-ID: <200706250920.l5P9KfxX031038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45720 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbXFYJVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     SM501: Clock updates and checks
has been removed from the -mm tree.  Its filename was
     sm501-clock-updates-and-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SM501: Clock updates and checks
From: Ben Dooks <ben-linux@fluff.org>

Ensure that the M1XCLK and MCLK are sourced from the same PLL (and refuse to
bind the driver if they are not).

Update the PCI to safe initialisation values, as 72MHz is the maximum clock
for 33MHz PCI bus mastering.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c        |   33 +++++++++++++++++++++++++++++++--
 include/linux/sm501-regs.h |    5 +++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-clock-updates-and-checks drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-clock-updates-and-checks
+++ a/drivers/mfd/sm501.c
@@ -855,6 +855,24 @@ static void sm501_init_regs(struct sm501
 		dev_info(sm->dev, "setting MCLK to %ld\n", init->mclk);
 		sm501_set_clock(sm->dev, SM501_CLOCK_MCLK, init->mclk);
 	}
+
+}
+
+/* Check the PLL sources for the M1CLK and M1XCLK
+ *
+ * If the M1CLK and M1XCLKs are not sourced from the same PLL, then
+ * there is a risk (see errata AB-5) that the SM501 will cease proper
+ * function. If this happens, then it is likely the SM501 will
+ * hang the system.
+*/
+
+static int sm501_check_clocks(struct sm501_devdata *sm)
+{
+	unsigned long pwrmode = readl(sm->regs + SM501_CURRENT_CLOCK);
+	unsigned long msrc = (pwrmode & SM501_POWERMODE_M_SRC);
+	unsigned long m1src = (pwrmode & SM501_POWERMODE_M1_SRC);
+
+	return ((msrc == 0 && m1src != 0) || (msrc != 0 && m1src == 0));
 }
 
 static unsigned int sm501_mem_local[] = {
@@ -911,6 +929,13 @@ static int sm501_init_dev(struct sm501_d
 		}
 	}
 
+	ret = sm501_check_clocks(sm);
+	if (ret) {
+		dev_err(sm->dev, "M1X and M clocks sourced from different "
+					"PLLs\n");
+		return -EINVAL;
+	}
+
 	/* always create a framebuffer */
 	sm501_register_display(sm, &mem_avail);
 
@@ -1048,8 +1073,12 @@ static struct sm501_initdata sm501_pci_i
 	},
 
 	.devices	= SM501_USE_ALL,
-	.mclk		= 100 * MHZ,
-	.m1xclk		= 160 * MHZ,
+
+	/* Errata AB-3 says that 72MHz is the fastest available
+	 * for 33MHZ PCI with proper bus-mastering operation */
+
+	.mclk		= 72 * MHZ,
+	.m1xclk		= 144 * MHZ,
 };
 
 static struct sm501_platdata_fbsub sm501_pdata_fbsub = {
diff -puN include/linux/sm501-regs.h~sm501-clock-updates-and-checks include/linux/sm501-regs.h
--- a/include/linux/sm501-regs.h~sm501-clock-updates-and-checks
+++ a/include/linux/sm501-regs.h
@@ -64,6 +64,11 @@
 #define SM501_DEBUG_CONTROL		(0x000034)
 
 /* power management */
+#define SM501_POWERMODE_P2X_SRC		(1<<29)
+#define SM501_POWERMODE_V2X_SRC		(1<<20)
+#define SM501_POWERMODE_M_SRC		(1<<12)
+#define SM501_POWERMODE_M1_SRC		(1<<4)
+
 #define SM501_CURRENT_GATE		(0x000038)
 #define SM501_CURRENT_CLOCK		(0x00003C)
 #define SM501_POWER_MODE_0_GATE		(0x000040)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-watchdog.patch
spi-tle620x-power-switch-driver.patch
