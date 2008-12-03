From: akpm@linux-foundation.org
Subject: - agp-follow-lspci-device-vendor-style.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:28:48 -0800
Message-ID: <200812032028.mB3KSmP4028083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759251AbYLCU3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:29:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     agp: follow lspci device/vendor style
has been removed from the -mm tree.  Its filename was
     agp-follow-lspci-device-vendor-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: agp: follow lspci device/vendor style
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format used by
lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/ali-agp.c      |    2 +-
 drivers/char/agp/amd64-agp.c    |    2 +-
 drivers/char/agp/ati-agp.c      |    2 +-
 drivers/char/agp/intel-agp.c    |    2 +-
 drivers/char/agp/isoch.c        |    2 +-
 drivers/char/agp/sis-agp.c      |    2 +-
 drivers/char/agp/sworks-agp.c   |    2 +-
 drivers/char/agp/uninorth-agp.c |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/agp/ali-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/ali-agp.c
--- a/drivers/char/agp/ali-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/ali-agp.c
@@ -316,7 +316,7 @@ static int __devinit agp_ali_probe(struc
 			goto found;
 	}
 
-	dev_err(&pdev->dev, "unsupported ALi chipset [%04x/%04x])\n",
+	dev_err(&pdev->dev, "unsupported ALi chipset [%04x:%04x])\n",
 		pdev->vendor, pdev->device);
 	return -ENODEV;
 
diff -puN drivers/char/agp/amd64-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/amd64-agp.c
@@ -507,7 +507,7 @@ static int __devinit agp_amd64_probe(str
 	    pdev->device == PCI_DEVICE_ID_AMD_8151_0) {
 		amd8151_init(pdev, bridge);
 	} else {
-		dev_info(&pdev->dev, "AGP bridge [%04x/%04x]\n",
+		dev_info(&pdev->dev, "AGP bridge [%04x:%04x]\n",
 			 pdev->vendor, pdev->device);
 	}
 
diff -puN drivers/char/agp/ati-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/ati-agp.c
--- a/drivers/char/agp/ati-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/ati-agp.c
@@ -488,7 +488,7 @@ static int __devinit agp_ati_probe(struc
 			goto found;
 	}
 
-	dev_err(&pdev->dev, "unsupported Ati chipset [%04x/%04x])\n",
+	dev_err(&pdev->dev, "unsupported Ati chipset [%04x:%04x])\n",
 		pdev->vendor, pdev->device);
 	return -ENODEV;
 
diff -puN drivers/char/agp/intel-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/intel-agp.c
@@ -2201,7 +2201,7 @@ static int __devinit agp_intel_probe(str
 
 	if (intel_agp_chipsets[i].name == NULL) {
 		if (cap_ptr)
-			dev_warn(&pdev->dev, "unsupported Intel chipset [%04x/%04x]\n",
+			dev_warn(&pdev->dev, "unsupported Intel chipset [%04x:%04x]\n",
 				 pdev->vendor, pdev->device);
 		agp_put_bridge(bridge);
 		return -ENODEV;
diff -puN drivers/char/agp/isoch.c~agp-follow-lspci-device-vendor-style drivers/char/agp/isoch.c
--- a/drivers/char/agp/isoch.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/isoch.c
@@ -359,7 +359,7 @@ int agp_3_5_enable(struct agp_bridge_dat
 			case 0x0001:    /* Unclassified device */
 				/* Don't know what this is, but log it for investigation. */
 				if (mcapndx != 0) {
-					dev_info(&td->dev, "wacky, found unclassified AGP device %s [%04x/%04x]\n",
+					dev_info(&td->dev, "wacky, found unclassified AGP device %s [%04x:%04x]\n",
 						 pci_name(dev),
 						 dev->vendor, dev->device);
 				}
diff -puN drivers/char/agp/sis-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/sis-agp.c
--- a/drivers/char/agp/sis-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/sis-agp.c
@@ -190,7 +190,7 @@ static int __devinit agp_sis_probe(struc
 		return -ENODEV;
 
 
-	dev_info(&pdev->dev, "SiS chipset [%04x/%04x]\n",
+	dev_info(&pdev->dev, "SiS chipset [%04x:%04x]\n",
 		 pdev->vendor, pdev->device);
 	bridge = agp_alloc_bridge();
 	if (!bridge)
diff -puN drivers/char/agp/sworks-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/sworks-agp.c
--- a/drivers/char/agp/sworks-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/sworks-agp.c
@@ -466,7 +466,7 @@ static int __devinit agp_serverworks_pro
 	default:
 		if (cap_ptr)
 			dev_err(&pdev->dev, "unsupported Serverworks chipset "
-				"[%04x/%04x]\n", pdev->vendor, pdev->device);
+				"[%04x:%04x]\n", pdev->vendor, pdev->device);
 		return -ENODEV;
 	}
 
diff -puN drivers/char/agp/uninorth-agp.c~agp-follow-lspci-device-vendor-style drivers/char/agp/uninorth-agp.c
--- a/drivers/char/agp/uninorth-agp.c~agp-follow-lspci-device-vendor-style
+++ a/drivers/char/agp/uninorth-agp.c
@@ -601,7 +601,7 @@ static int __devinit agp_uninorth_probe(
 		}
 	}
 
-	dev_err(&pdev->dev, "unsupported Apple chipset [%04x/%04x]\n",
+	dev_err(&pdev->dev, "unsupported Apple chipset [%04x:%04x]\n",
 		pdev->vendor, pdev->device);
 	return -ENODEV;
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
pnpacpi-enable-power-management.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
clocksource-acpi_pmc-put-acpi_pm_read_slow-under-config_pci.patch

