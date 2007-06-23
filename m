From: akpm@linux-foundation.org
Subject: + intel_agp-dont-load-if-no-igd-and-agp-port.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:47:28 -0700
Message-ID: <200706231647.l5NGlPcM019482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbXFWQr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:47:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, carlo@alinoe.com, davej@codemonkey.org.uk


The patch titled
     intel_agp: don't load if no IGD and AGP port
has been added to the -mm tree.  Its filename is
     intel_agp-dont-load-if-no-igd-and-agp-port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel_agp: don't load if no IGD and AGP port
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

After i915 chip, GMCH has no AGP port.  Origin bridge driver in device
table will try to access illegal regs like APBASE, APSIZE, etc.  This may
cause problem.

So mark them as NULL in the table, we won't load if no IGD got detect and
bridge has no AGP port.

(Carlo's original bug report: "Somewhere between 2.6.18 and 2.6.19, a patch
was added to the kernel that makes it hang on my machine after the message:

apgart: Detected an Intel 965G Chipset.

When I upgraded to 2.6.22-rc4 (from debian trunk), I still ran
into this same bug.")

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Reported-by: Carlo Wood <carlo@alinoe.com>
Testted-by: Carlo Wood <carlo@alinoe.com>
Acked-by: Carlo Wood <carlo@alinoe.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   35 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-dont-load-if-no-igd-and-agp-port drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-dont-load-if-no-igd-and-agp-port
+++ a/drivers/char/agp/intel-agp.c
@@ -1850,35 +1850,35 @@ static const struct intel_driver_descrip
 		&intel_845_driver, &intel_830_driver },
 	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, 0, "i875", &intel_845_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, 0, "915G",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, 0, "915GM",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, 0, "945G",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 1, "945GM",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0, "945GME",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, 0, "965G",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, 0, "965Q",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, 0, "G33",
-		&intel_845_driver, &intel_g33_driver },
+		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q35_HB, PCI_DEVICE_ID_INTEL_Q35_IG, 0, "Q35",
-		&intel_845_driver, &intel_g33_driver },
+		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
-		&intel_845_driver, &intel_g33_driver },
+		NULL, &intel_g33_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
@@ -1924,8 +1924,11 @@ static int __devinit agp_intel_probe(str
 	}
 
 	if (bridge->driver == NULL) {
-		printk(KERN_WARNING PFX "Failed to find bridge device "
-			"(chip_id: %04x)\n", intel_agp_chipsets[i].gmch_chip_id);
+		/* bridge has no AGP and no IGD detected */
+		if (cap_ptr)
+			printk(KERN_WARNING PFX "Failed to find bridge device "
+				"(chip_id: %04x)\n",
+				intel_agp_chipsets[i].gmch_chip_id);
 		agp_put_bridge(bridge);
 		return -ENODEV;
         }
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

intel_agp-dont-load-if-no-igd-and-agp-port.patch
