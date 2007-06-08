From: akpm@linux-foundation.org
Subject: - intel_agp-use-table-for-device-probe-update.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:18 -0700
Message-ID: <200706081735.l58HZId9006352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932158AbXFHRfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel_agp-use-table-for-device-probe update
has been removed from the -mm tree.  Its filename was
     intel_agp-use-table-for-device-probe-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_agp-use-table-for-device-probe update
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

Fixed issues noted by Christoph Hellwig, and I changed device table
scan a bit to allow the case that some models of graphics chips may
have same host bridge type. This type of chip will be added in the future.

This patch cleans up device probe function. Eric Anholt was the original author.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |  106 ++++++++++++---------------------
 1 file changed, 41 insertions(+), 65 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-use-table-for-device-probe-update drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-use-table-for-device-probe-update
+++ a/drivers/char/agp/intel-agp.c
@@ -1750,83 +1750,56 @@ static const struct intel_driver_descrip
 	unsigned int chip_id;
 	unsigned int gmch_chip_id;
 	char *name;
-	struct agp_bridge_driver *driver;
-	struct agp_bridge_driver *gmch_driver;
+	const struct agp_bridge_driver *driver;
+	const struct agp_bridge_driver *gmch_driver;
 } intel_agp_chipsets[] = {
-	{ PCI_DEVICE_ID_INTEL_82443LX_0, 0, "440LX",
-            (struct agp_bridge_driver *)&intel_generic_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82443BX_0, 0, "440BX",
-            (struct agp_bridge_driver *)&intel_generic_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82443GX_0, 0, "440GX",
-            (struct agp_bridge_driver *)&intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443LX_0, 0, "440LX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443BX_0, 0, "440BX", &intel_generic_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82443GX_0, 0, "440GX", &intel_generic_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82810_MC1, PCI_DEVICE_ID_INTEL_82810_IG1, "i810",
-            NULL, (struct agp_bridge_driver *)&intel_810_driver },
+		NULL, &intel_810_driver },
 	{ PCI_DEVICE_ID_INTEL_82810_MC3, PCI_DEVICE_ID_INTEL_82810_IG3, "i810",
-            NULL, (struct agp_bridge_driver *)&intel_810_driver },
+		NULL, &intel_810_driver },
 	{ PCI_DEVICE_ID_INTEL_82810E_MC, PCI_DEVICE_ID_INTEL_82810E_IG, "i810",
-            NULL, (struct agp_bridge_driver *)&intel_810_driver },
+		NULL, &intel_810_driver },
 	{ PCI_DEVICE_ID_INTEL_82815_MC, PCI_DEVICE_ID_INTEL_82815_CGC, "i815",
-            (struct agp_bridge_driver *)&intel_810_driver,
-            (struct agp_bridge_driver *)&intel_815_driver },
-	{ PCI_DEVICE_ID_INTEL_82820_HB, 0, "i820",
-            (struct agp_bridge_driver *)&intel_820_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82820_UP_HB, 0, "i820",
-            (struct agp_bridge_driver *)&intel_820_driver, NULL },
+		&intel_810_driver, &intel_815_driver },
+	{ PCI_DEVICE_ID_INTEL_82820_HB, 0, "i820", &intel_820_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82820_UP_HB, 0, "i820", &intel_820_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82830_HB, PCI_DEVICE_ID_INTEL_82830_CGC, "830M",
-            (struct agp_bridge_driver *)&intel_830mp_driver,
-            (struct agp_bridge_driver *)&intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82840_HB, 0, "i840",
-            (struct agp_bridge_driver *)&intel_840_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82845_HB, 0, "845G",
-            (struct agp_bridge_driver *)&intel_845_driver, NULL },
+		&intel_830mp_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82840_HB, 0, "i840", &intel_840_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82845_HB, 0, "845G", &intel_845_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82845G_HB, PCI_DEVICE_ID_INTEL_82845G_IG, "830M",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82850_HB, 0, "i850",
-	    (struct agp_bridge_driver *)&intel_850_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_82855PM_HB, 0, "855PM",
-            (struct agp_bridge_driver *)&intel_845_driver, NULL },
+		&intel_845_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82850_HB, 0, "i850", &intel_850_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_82855PM_HB, 0, "855PM", &intel_845_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82855GM_HB, PCI_DEVICE_ID_INTEL_82855GM_IG, "855GM",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82860_HB, 0, "i860",
-            (struct agp_bridge_driver *)&intel_860_driver, NULL },
+		&intel_845_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82860_HB, 0, "i860", &intel_860_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82865_HB, PCI_DEVICE_ID_INTEL_82865_IG, "865",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_830_driver },
-	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, "i875",
-            (struct agp_bridge_driver *)&intel_845_driver, NULL },
+		&intel_845_driver, &intel_830_driver },
+	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, "i875", &intel_845_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, "915G",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_915_driver },
+		&intel_845_driver, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, "915GM",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_915_driver },
+		&intel_845_driver, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, "945G",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_915_driver },
+		&intel_845_driver, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, "945GM",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_915_driver },
+		&intel_845_driver, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, "946GZ",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_i965_driver },
+		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, "965G",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_i965_driver },
+		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, "965Q",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_i965_driver },
+		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, "965G",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_i965_driver },
+		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, "965GM",
-            (struct agp_bridge_driver *)&intel_845_driver,
-            (struct agp_bridge_driver *)&intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505",
-            (struct agp_bridge_driver *)&intel_7505_driver, NULL },
-	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205",
-            (struct agp_bridge_driver *)&intel_7505_driver, NULL },
+		&intel_845_driver, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
 	{ 0, 0, NULL, NULL, NULL }
 };
 
@@ -1845,8 +1818,13 @@ static int __devinit agp_intel_probe(str
 		return -ENOMEM;
 
 	for (i = 0; intel_agp_chipsets[i].name != NULL; i++) {
-		if (pdev->device == intel_agp_chipsets[i].chip_id)
-		    break;
+		/* In case that multiple models of gfx chip may
+		   stand on same host bridge type, this can be
+		   sure we detect the right IGD. */
+		if ((pdev->device == intel_agp_chipsets[i].chip_id) &&
+			((intel_agp_chipsets[i].gmch_chip_id == 0) ||
+				find_gmch(intel_agp_chipsets[i].gmch_chip_id)))
+			break;
 	}
 
 	if (intel_agp_chipsets[i].name == NULL) {
@@ -1857,12 +1835,10 @@ static int __devinit agp_intel_probe(str
 		return -ENODEV;
 	}
 
-	if (intel_agp_chipsets[i].gmch_chip_id != 0 &&
-		find_gmch(intel_agp_chipsets[i].gmch_chip_id)) {
+	if (intel_agp_chipsets[i].gmch_chip_id != 0)
 	    bridge->driver = intel_agp_chipsets[i].gmch_driver;
-	} else {
+	else
 	    bridge->driver = intel_agp_chipsets[i].driver;
-	}
 
 	if (bridge->driver == NULL) {
 		printk(KERN_WARNING PFX "Failed to find bridge device "
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

git-agpgart.patch
