From: akpm@linux-foundation.org
Subject: - edac-mpc85xx-add-support-for-mpc8572.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:21 -0700
Message-ID: <200810182319.m9INJLDm029468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbYJRXTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akilkenny@xes-inc.com, djiang@mvista.com, dougthompson@xmission.com, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     edac mpc85xx: add support for mpc8572
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-add-support-for-mpc8572.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac mpc85xx: add support for mpc8572
From: Andrew Kilkenny <akilkenny@xes-inc.com>

This adds support for the dual-core MPC8572 processor.  We have
to support making SPR changes on each core.  Also, since we can
have multiple memory controllers sharing an interrupt, flag the
interrupts with IRQF_SHARED.

Signed-off-by: Andrew Kilkenny <akilkenny@xes-inc.com>
Signed-off-by: Nate Case <ncase@xes-inc.com>
Acked-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-mpc8572 drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-mpc8572
+++ a/drivers/edac/mpc85xx_edac.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/mod_devicetable.h>
 #include <linux/edac.h>
+#include <linux/smp.h>
 
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
@@ -40,7 +41,7 @@ static u32 orig_pci_err_en;
 #endif
 
 static u32 orig_l2_err_disable;
-static u32 orig_hid1;
+static u32 orig_hid1[2];
 
 /************************ MC SYSFS parts ***********************************/
 
@@ -647,6 +648,9 @@ static struct of_device_id mpc85xx_l2_er
 	{
 	 .compatible = "fsl,8568-l2-cache-controller",
 	 },
+	{
+	 .compatible = "fsl,mpc8572-l2-cache-controller",
+	 },
 	{},
 };
 
@@ -912,7 +916,8 @@ static int __devinit mpc85xx_mc_err_prob
 		/* register interrupts */
 		pdata->irq = irq_of_parse_and_map(op->node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_mc_isr, IRQF_DISABLED,
+				       mpc85xx_mc_isr,
+					IRQF_DISABLED | IRQF_SHARED,
 				       "[EDAC] MC err", mci);
 		if (res < 0) {
 			printk(KERN_ERR "%s: Unable to request irq %d for "
@@ -980,6 +985,9 @@ static struct of_device_id mpc85xx_mc_er
 	{
 	 .compatible = "fsl,8568-memory-controller",
 	 },
+	{
+	 .compatible = "fsl,mpc8572-memory-controller",
+	 },
 	{},
 };
 
@@ -995,6 +1003,14 @@ static struct of_platform_driver mpc85xx
 		   },
 };
 
+
+static void __init mpc85xx_mc_clear_rfxe(void *data)
+{
+	orig_hid1[smp_processor_id()] = mfspr(SPRN_HID1);
+	mtspr(SPRN_HID1, (orig_hid1[smp_processor_id()] & ~0x20000));
+}
+
+
 static int __init mpc85xx_mc_init(void)
 {
 	int res = 0;
@@ -1030,19 +1046,22 @@ static int __init mpc85xx_mc_init(void)
 	 * need to clear HID1[RFXE] to disable machine check int
 	 * so we can catch it
 	 */
-	if (edac_op_state == EDAC_OPSTATE_INT) {
-		orig_hid1 = mfspr(SPRN_HID1);
-		mtspr(SPRN_HID1, (orig_hid1 & ~0x20000));
-	}
+	if (edac_op_state == EDAC_OPSTATE_INT)
+		on_each_cpu(mpc85xx_mc_clear_rfxe, NULL, 0);
 
 	return 0;
 }
 
 module_init(mpc85xx_mc_init);
 
+static void __exit mpc85xx_mc_restore_hid1(void *data)
+{
+	mtspr(SPRN_HID1, orig_hid1[smp_processor_id()]);
+}
+
 static void __exit mpc85xx_mc_exit(void)
 {
-	mtspr(SPRN_HID1, orig_hid1);
+	on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
 #ifdef CONFIG_PCI
 	of_unregister_platform_driver(&mpc85xx_pci_err_driver);
 #endif
_

Patches currently in -mm which might be from akilkenny@xes-inc.com are

origin.patch

