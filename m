From: akpm@linux-foundation.org
Subject: + sm501-suspend-support.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:32:12 -0700
Message-ID: <200706191832.l5JIWC3N018107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760760AbXFSSd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     SM501: suspend support
has been added to the -mm tree.  Its filename is
     sm501-suspend-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SM501: suspend support
From: Ben Dooks <ben-linux@fluff.org>

This patch adds support for suspending the core (mfd driver) of the SM501.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   99 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 91 insertions(+), 8 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-suspend-support drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-suspend-support
+++ a/drivers/mfd/sm501.c
@@ -41,6 +41,9 @@ struct sm501_devdata {
 	struct resource			*regs_claim;
 	struct sm501_platdata		*platdata;
 
+	unsigned int			 in_suspend;
+	unsigned long			 pm_misc;
+
 	int				 unit_power[20];
 	unsigned int			 pdev_id;
 	unsigned int			 irq;
@@ -169,10 +172,31 @@ x		 "M %ld.%ld (%ld), MX1 %ld.%ld (%ld)\
 		fmt_freq(decode_div(pll2, pm1, 8,  1<<12, 15, misc_div)),
 		fmt_freq(decode_div(pll2, pm1, 0,  1<<4,  15, misc_div)));
 }
-#else
-static void sm501_dump_clk(struct sm501_devdata *sm)
+
+static void sm501_dump_regs(struct sm501_devdata *sm)
+{
+	void __iomem *regs = sm->regs;
+
+	dev_info(sm->dev, "System Control   %08x\n", readl(regs + SM501_SYSTEM_CONTROL));
+	dev_info(sm->dev, "Misc Control     %08x\n", readl(regs + SM501_MISC_CONTROL));
+	dev_info(sm->dev, "GPIO Control Low %08x\n", readl(regs + SM501_GPIO31_0_CONTROL));
+	dev_info(sm->dev, "GPIO Control Hi  %08x\n", readl(regs + SM501_GPIO63_32_CONTROL));
+	dev_info(sm->dev, "DRAM Control     %08x\n", readl(regs + SM501_DRAM_CONTROL));
+	dev_info(sm->dev, "Arbitration Ctrl %08x\n", readl(regs + SM501_ARBTRTN_CONTROL));
+	dev_info(sm->dev, "Misc Timing      %08x\n", readl(regs + SM501_MISC_TIMING));
+}
+
+static void sm501_dump_gate(struct sm501_devdata *sm)
 {
+	dev_info(sm->dev, "CurrentGate      %08x\n", readl(sm->regs + SM501_CURRENT_GATE));
+	dev_info(sm->dev, "CurrentClock     %08x\n", readl(sm->regs + SM501_CURRENT_CLOCK));
+	dev_info(sm->dev, "PowerModeControl %08x\n", readl(sm->regs + SM501_POWER_MODE_CONTROL));
 }
+
+#else
+static inline void sm501_dump_gate(struct sm501_devdata *sm) { }
+static inline void sm501_dump_regs(struct sm501_devdata *sm) { }
+static inline void sm501_dump_clk(struct sm501_devdata *sm) { }
 #endif
 
 /* sm501_sync_regs
@@ -185,9 +209,21 @@ static void sm501_sync_regs(struct sm501
 	readl(sm->regs);
 }
 
+static inline void sm501_mdelay(struct sm501_devdata *sm, unsigned int delay)
+{
+	/* during suspend/resume, we are currently not allowed to sleep,
+	 * so change to using mdelay() instead of msleep() if we
+	 * are in one of these paths */
+
+	if (sm->in_suspend)
+		mdelay(delay);
+	else
+		msleep(delay);
+}
+
 /* sm501_misc_control
  *
- * alters the misceleneous control parameters
+ * alters the miscellaneous control parameters
 */
 
 int sm501_misc_control(struct device *dev,
@@ -368,7 +404,7 @@ int sm501_unit_power(struct device *dev,
 	dev_dbg(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
 		gate, clock, mode);
 
-	msleep(16);
+	sm501_mdelay(sm, 16);
 
  already:
 	mutex_unlock(&sm->clock_lock);
@@ -538,7 +574,7 @@ unsigned long sm501_set_clock(struct dev
 	dev_info(sm->dev, "gate %08lx, clock %08lx, mode %08lx\n",
 		 gate, clock, mode);
 
-	msleep(16);
+	sm501_mdelay(sm, 16);
 	mutex_unlock(&sm->clock_lock);
 
 	sm501_dump_clk(sm);
@@ -841,9 +877,7 @@ static int sm501_init_dev(struct sm501_d
 		 sm->regs, readl(sm->regs + SM501_DEVICEID),
 		 (unsigned long)mem_avail >> 20, sm->irq);
 
-	dev_info(sm->dev, "CurrentGate      %08x\n", readl(sm->regs+0x38));
-	dev_info(sm->dev, "CurrentClock     %08x\n", readl(sm->regs+0x3c));
-	dev_info(sm->dev, "PowerModeControl %08x\n", readl(sm->regs+0x54));
+	sm501_dump_gate(sm);
 
 	ret = device_create_file(sm->dev, &dev_attr_dbg_regs);
 	if (ret)
@@ -933,6 +967,53 @@ static int sm501_plat_probe(struct platf
 
 }
 
+/* power management support */
+
+static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct sm501_devdata *sm = platform_get_drvdata(pdev);
+
+	sm->in_suspend = 1;
+	sm->pm_misc = readl(sm->regs + SM501_MISC_CONTROL);
+
+	sm501_dump_regs(sm);
+	return 0;
+}
+
+static int sm501_plat_resume(struct platform_device *pdev)
+{
+	struct sm501_devdata *sm = platform_get_drvdata(pdev);
+
+	sm501_dump_regs(sm);
+	sm501_dump_gate(sm);
+	sm501_dump_clk(sm);
+
+	/* check to see if we are in the same state as when suspended */
+
+	if (readl(sm->regs + SM501_MISC_CONTROL) != sm->pm_misc) {
+		dev_info(sm->dev, "SM501_MISC_CONTROL changed over sleep\n");
+		writel(sm->pm_misc, sm->regs + SM501_MISC_CONTROL);
+
+		/* our suspend causes the controller state to change,
+		 * either by something attempting setup, power loss,
+		 * or an external reset event on power change */
+
+		if (sm->platdata && sm->platdata->init) {
+			sm501_init_regs(sm, sm->platdata->init);
+		}
+	}
+
+	/* dump our state from resume */
+
+	sm501_dump_regs(sm);
+	sm501_dump_clk(sm);
+
+	sm->in_suspend = 0;
+
+	return 0;
+}
+
+
 /* Initialisation data for PCI devices */
 
 static struct sm501_initdata sm501_pci_initdata = {
@@ -1126,6 +1207,8 @@ static struct platform_driver sm501_plat
 	},
 	.probe		= sm501_plat_probe,
 	.remove		= sm501_plat_remove,
+	.suspend	= sm501_plat_suspend,
+	.resume		= sm501_plat_resume,
 };
 
 static int __init sm501_base_init(void)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

spi-tle620x-power-switch-driver.patch
sm501-suspend-support.patch
sm501-suspend-support-fix.patch
sm501-initialise-sdram-clock-before-bus-clocks.patch
sm501-fix-sm501_init_reg-mask-set-order.patch
sm501-clock-updates-and-checks.patch
sm501-clock-updates-and-checks-fix.patch
sm501-add-documentation-sm501txt.patch
sm501-check-sm501-id-register-on-initialisation.patch
