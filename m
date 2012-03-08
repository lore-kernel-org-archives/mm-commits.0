From: akpm@linux-foundation.org
Subject: [merged] intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:29 -0800
Message-ID: <20120308191729.78818A06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:46608 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab2CHTRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:30 -0500
Received: by mail-gy0-f202.google.com with SMTP id z15so102917ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.demeter@intel.com, alan@linux.intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mika.westerberg@linux.intel.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: intel_mid_powerbtn: use MSIC read/write instead of ipc_scu
has been removed from the -mm tree.  Its filename was
     intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michael Demeter <michael.demeter@intel.com>
Subject: intel_mid_powerbtn: use MSIC read/write instead of ipc_scu

In the 2.6.36 kernel we did not have the MSIC driver.  Changed all
ipc_scu_reads/writes to use the MSIC driver and defines.  Added a fix from
the 2.6.36 kernel where the SCU FW could send a power button interrupt to
the IA32 FW and the kernel was not running yet.  This resulted in the
interrupt not getting cleared and the power button was ignored.  this fix
just clears the interrupt on start-up.

[alan@linux.intel.com: revert style-only changes. Remove unused variable. Fix comment style.]
Signed-off-by: Michael Demeter <michael.demeter@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_mid_powerbtn.c |   32 +++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff -puN drivers/platform/x86/intel_mid_powerbtn.c~intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu drivers/platform/x86/intel_mid_powerbtn.c
--- a/drivers/platform/x86/intel_mid_powerbtn.c~intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu
+++ a/drivers/platform/x86/intel_mid_powerbtn.c
@@ -23,21 +23,27 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-
-#include <asm/intel_scu_ipc.h>
+#include <linux/mfd/intel_msic.h>
 
 #define DRIVER_NAME "msic_power_btn"
 
-#define MSIC_PB_STATUS	0x3f
 #define MSIC_PB_LEVEL	(1 << 3) /* 1 - release, 0 - press */
 
+/*
+ * MSIC document ti_datasheet defines the 1st bit reg 0x21 is used to mask
+ * power button interrupt
+ */
+#define MSIC_PWRBTNM    (1 << 0)
+
 static irqreturn_t mfld_pb_isr(int irq, void *dev_id)
 {
 	struct input_dev *input = dev_id;
 	int ret;
 	u8 pbstat;
 
-	ret = intel_scu_ipc_ioread8(MSIC_PB_STATUS, &pbstat);
+	ret = intel_msic_reg_read(INTEL_MSIC_PBSTATUS, &pbstat);
+	dev_dbg(input->dev.parent, "PB_INT status= %d\n", pbstat);
+
 	if (ret < 0) {
 		dev_err(input->dev.parent, "Read error %d while reading"
 			       " MSIC_PB_STATUS\n", ret);
@@ -88,6 +94,24 @@ static int __devinit mfld_pb_probe(struc
 	}
 
 	platform_set_drvdata(pdev, input);
+
+	/*
+	 * SCU firmware might send power button interrupts to IA core before
+	 * kernel boots and doesn't get EOI from IA core. The first bit of
+	 * MSIC reg 0x21 is kept masked, and SCU firmware doesn't send new
+	 * power interrupt to Android kernel. Unmask the bit when probing
+	 * power button in kernel.
+	 * There is a very narrow race between irq handler and power button
+	 * initialization. The race happens rarely. So we needn't worry
+	 * about it.
+	 */
+	error = intel_msic_reg_update(INTEL_MSIC_IRQLVL1MSK, 0, MSIC_PWRBTNM);
+	if (error) {
+		dev_err(&pdev->dev, "Unable to clear power button interrupt, "
+				"error: %d\n", error);
+		goto err_free_irq;
+	}
+
 	return 0;
 
 err_free_irq:
_

Patches currently in -mm which might be from michael.demeter@intel.com are

linux-next.patch

