From: akpm@linux-foundation.org
Subject: [merged]
 tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:59 -0700
Message-ID: <523219f7.HgK08heJbtmN9IPw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3ILTqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tpmdd@sirrix.com, tpmdd@selhorst.net, rob.herring@calxeda.com, rafael.j.wysocki@intel.com, matthew.garrett@nebula.com, mail@srajiv.net, leosilva@linux.vnet.ibm.com, grant.likely@linaro.org, bhelgaas@google.com, ashley@ashleylai.com, a.zummo@towertech.it, PeterHuewe@gmx.de, shuah.kh@samsung.com

Subject: [merged] tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops.patch removed from -mm tree
To: shuah.kh@samsung.com,PeterHuewe@gmx.de,a.zummo@towertech.it,ashley@ashleylai.com,bhelgaas@google.com,grant.likely@linaro.org,leosilva@linux.vnet.ibm.com,mail@srajiv.net,matthew.garrett@nebula.com,rafael.j.wysocki@intel.com,rob.herring@calxeda.com,tpmdd@selhorst.net,tpmdd@sirrix.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:59 -0700


The patch titled
     Subject: tpm: convert tpm_tis driver to use dev_pm_ops from legacy pm_ops
has been removed from the -mm tree.  Its filename was
     tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shuah Khan <shuah.kh@samsung.com>
Subject: tpm: convert tpm_tis driver to use dev_pm_ops from legacy pm_ops

Convert drivers/char/tpm/tpm_tis.c to use dev_pm_ops instead of legacy
pm_ops.  This patch depends on pnp driver bus ops change to invoke
pnp_driver dev_pm_ops.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Cc: Ashley Lai <ashley@ashleylai.com>
Cc: Rajiv Andrade <mail@srajiv.net>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Sirrix AG <tpmdd@sirrix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Peter Hüwe <PeterHuewe@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |   60 ++++++++++++++---------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

diff -puN drivers/char/tpm/tpm_tis.c~tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm-convert-tpm_tis-driver-to-use-dev_pm_ops-from-legacy-pm_ops
+++ a/drivers/char/tpm/tpm_tis.c
@@ -766,6 +766,25 @@ static void tpm_tis_reenable_interrupts(
 }
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+static int tpm_tis_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	int ret;
+
+	if (chip->vendor.irq)
+		tpm_tis_reenable_interrupts(chip);
+
+	ret = tpm_pm_resume(dev);
+	if (!ret)
+		tpm_do_selftest(chip);
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
+
 #ifdef CONFIG_PNP
 static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
@@ -787,26 +806,6 @@ static int tpm_tis_pnp_init(struct pnp_d
 	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
 }
 
-static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
-{
-	return tpm_pm_suspend(&dev->dev);
-}
-
-static int tpm_tis_pnp_resume(struct pnp_dev *dev)
-{
-	struct tpm_chip *chip = pnp_get_drvdata(dev);
-	int ret;
-
-	if (chip->vendor.irq)
-		tpm_tis_reenable_interrupts(chip);
-
-	ret = tpm_pm_resume(&dev->dev);
-	if (!ret)
-		tpm_do_selftest(chip);
-
-	return ret;
-}
-
 static struct pnp_device_id tpm_pnp_tbl[] = {
 	{"PNP0C31", 0},		/* TPM */
 	{"ATM1200", 0},		/* Atmel */
@@ -835,9 +834,12 @@ static struct pnp_driver tis_pnp_driver
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
-	.suspend = tpm_tis_pnp_suspend,
-	.resume = tpm_tis_pnp_resume,
 	.remove = tpm_tis_pnp_remove,
+#ifdef CONFIG_PM_SLEEP
+	.driver	= {
+		.pm = &tpm_tis_pm,
+	},
+#endif
 };
 
 #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
@@ -846,20 +848,6 @@ module_param_string(hid, tpm_pnp_tbl[TIS
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 #endif
 
-#ifdef CONFIG_PM_SLEEP
-static int tpm_tis_resume(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (chip->vendor.irq)
-		tpm_tis_reenable_interrupts(chip);
-
-	return tpm_pm_resume(dev);
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
