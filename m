From: akpm@linux-foundation.org
Subject: - nvidiafb-rivafb-switch-to-pci_get-refcounting.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:58 -0700
Message-ID: <200705090301.l4931wMc010776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033204AbXEIDCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb/rivafb: switch to pci_get refcounting
has been removed from the -mm tree.  Its filename was
     nvidiafb-rivafb-switch-to-pci_get-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb/rivafb: switch to pci_get refcounting
From: Alan Cox <alan@redhat.com>

Switch to pci_get refcounting APIs

[adaplas]
Fix a long-standing bug where the return value of
pci_find_slot()/pci_get_bus_and_slot() is ignored.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_hw.c    |   15 +++++++++------
 drivers/video/nvidia/nv_setup.c |    3 ++-
 drivers/video/riva/nv_driver.c  |    6 ++++--
 drivers/video/riva/riva_hw.c    |   12 ++++++++----
 4 files changed, 23 insertions(+), 13 deletions(-)

diff -puN drivers/video/nvidia/nv_hw.c~nvidiafb-rivafb-switch-to-pci_get-refcounting drivers/video/nvidia/nv_hw.c
--- a/drivers/video/nvidia/nv_hw.c~nvidiafb-rivafb-switch-to-pci_get-refcounting
+++ a/drivers/video/nvidia/nv_hw.c
@@ -686,7 +686,7 @@ static void nForceUpdateArbitrationSetti
 
 	if ((par->Chipset & 0x0FF0) == 0x01A0) {
 		unsigned int uMClkPostDiv;
-		dev = pci_find_slot(0, 3);
+		dev = pci_get_bus_and_slot(0, 3);
 		pci_read_config_dword(dev, 0x6C, &uMClkPostDiv);
 		uMClkPostDiv = (uMClkPostDiv >> 8) & 0xf;
 
@@ -694,11 +694,11 @@ static void nForceUpdateArbitrationSetti
 			uMClkPostDiv = 4;
 		MClk = 400000 / uMClkPostDiv;
 	} else {
-		dev = pci_find_slot(0, 5);
+		dev = pci_get_bus_and_slot(0, 5);
 		pci_read_config_dword(dev, 0x4c, &MClk);
 		MClk /= 1000;
 	}
-
+	pci_dev_put(dev);
 	pll = NV_RD32(par->PRAMDAC0, 0x0500);
 	M = (pll >> 0) & 0xFF;
 	N = (pll >> 8) & 0xFF;
@@ -707,19 +707,21 @@ static void nForceUpdateArbitrationSetti
 	sim_data.pix_bpp = (char)pixelDepth;
 	sim_data.enable_video = 0;
 	sim_data.enable_mp = 0;
-	pci_find_slot(0, 1);
+	dev = pci_get_bus_and_slot(0, 1);
 	pci_read_config_dword(dev, 0x7C, &sim_data.memory_type);
+	pci_dev_put(dev);
 	sim_data.memory_type = (sim_data.memory_type >> 12) & 1;
 	sim_data.memory_width = 64;
 
-	dev = pci_find_slot(0, 3);
+	dev = pci_get_bus_and_slot(0, 3);
 	pci_read_config_dword(dev, 0, &memctrl);
+	pci_dev_put(dev);
 	memctrl >>= 16;
 
 	if ((memctrl == 0x1A9) || (memctrl == 0x1AB) || (memctrl == 0x1ED)) {
 		int dimm[3];
 
-		pci_find_slot(0, 2);
+		dev = pci_get_bus_and_slot(0, 2);
 		pci_read_config_dword(dev, 0x40, &dimm[0]);
 		dimm[0] = (dimm[0] >> 8) & 0x4f;
 		pci_read_config_dword(dev, 0x44, &dimm[1]);
@@ -731,6 +733,7 @@ static void nForceUpdateArbitrationSetti
 			printk("nvidiafb: your nForce DIMMs are not arranged "
 			       "in optimal banks!\n");
 		}
+		pci_dev_put(dev);
 	}
 
 	sim_data.mem_latency = 3;
diff -puN drivers/video/nvidia/nv_setup.c~nvidiafb-rivafb-switch-to-pci_get-refcounting drivers/video/nvidia/nv_setup.c
--- a/drivers/video/nvidia/nv_setup.c~nvidiafb-rivafb-switch-to-pci_get-refcounting
+++ a/drivers/video/nvidia/nv_setup.c
@@ -261,7 +261,7 @@ static void nv10GetConfig(struct nvidia_
 	}
 #endif
 
-	dev = pci_find_slot(0, 1);
+	dev = pci_get_bus_and_slot(0, 1);
 	if ((par->Chipset & 0xffff) == 0x01a0) {
 		int amt = 0;
 
@@ -276,6 +276,7 @@ static void nv10GetConfig(struct nvidia_
 		par->RamAmountKBytes =
 		    (NV_RD32(par->PFB, 0x020C) & 0xFFF00000) >> 10;
 	}
+	pci_dev_put(dev);
 
 	par->CrystalFreqKHz = (NV_RD32(par->PEXTDEV, 0x0000) & (1 << 6)) ?
 	    14318 : 13500;
diff -puN drivers/video/riva/nv_driver.c~nvidiafb-rivafb-switch-to-pci_get-refcounting drivers/video/riva/nv_driver.c
--- a/drivers/video/riva/nv_driver.c~nvidiafb-rivafb-switch-to-pci_get-refcounting
+++ a/drivers/video/riva/nv_driver.c
@@ -231,12 +231,14 @@ unsigned long riva_get_memlen(struct riv
 	case NV_ARCH_30:
 		if(chipset == NV_CHIP_IGEFORCE2) {
 
-			dev = pci_find_slot(0, 1);
+			dev = pci_get_bus_and_slot(0, 1);
 			pci_read_config_dword(dev, 0x7C, &amt);
+			pci_dev_put(dev);
 			memlen = (((amt >> 6) & 31) + 1) * 1024;
 		} else if (chipset == NV_CHIP_0x01F0) {
-			dev = pci_find_slot(0, 1);
+			dev = pci_get_bus_and_slot(0, 1);
 			pci_read_config_dword(dev, 0x84, &amt);
+			pci_dev_put(dev);
 			memlen = (((amt >> 4) & 127) + 1) * 1024;
 		} else {
 			switch ((NV_RD32(chip->PFB, 0x0000020C) >> 20) &
diff -puN drivers/video/riva/riva_hw.c~nvidiafb-rivafb-switch-to-pci_get-refcounting drivers/video/riva/riva_hw.c
--- a/drivers/video/riva/riva_hw.c~nvidiafb-rivafb-switch-to-pci_get-refcounting
+++ a/drivers/video/riva/riva_hw.c
@@ -1118,8 +1118,9 @@ static void nForceUpdateArbitrationSetti
     unsigned int uMClkPostDiv;
     struct pci_dev *dev;
 
-    dev = pci_find_slot(0, 3);
+    dev = pci_get_bus_and_slot(0, 3);
     pci_read_config_dword(dev, 0x6C, &uMClkPostDiv);
+    pci_dev_put(dev);
     uMClkPostDiv = (uMClkPostDiv >> 8) & 0xf;
 
     if(!uMClkPostDiv) uMClkPostDiv = 4;
@@ -1132,8 +1133,9 @@ static void nForceUpdateArbitrationSetti
     sim_data.enable_video   = 0;
     sim_data.enable_mp      = 0;
 
-    dev = pci_find_slot(0, 1);
+    dev = pci_get_bus_and_slot(0, 1);
     pci_read_config_dword(dev, 0x7C, &sim_data.memory_type);
+    pci_dev_put(dev);
     sim_data.memory_type    = (sim_data.memory_type >> 12) & 1;
 
     sim_data.memory_width   = 64;
@@ -2112,12 +2114,14 @@ static void nv10GetConfig
      * Fill in chip configuration.
      */
     if(chipset == NV_CHIP_IGEFORCE2) {
-        dev = pci_find_slot(0, 1);
+        dev = pci_get_bus_and_slot(0, 1);
         pci_read_config_dword(dev, 0x7C, &amt);
+        pci_dev_put(dev);
         chip->RamAmountKBytes = (((amt >> 6) & 31) + 1) * 1024;
     } else if(chipset == NV_CHIP_0x01F0) {
-        dev = pci_find_slot(0, 1);
+        dev = pci_get_bus_and_slot(0, 1);
         pci_read_config_dword(dev, 0x84, &amt);
+        pci_dev_put(dev);
         chip->RamAmountKBytes = (((amt >> 4) & 127) + 1) * 1024;
     } else {
         switch ((NV_RD32(chip->PFB, 0x0000020C) >> 20) & 0x000000FF)
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_acpi-restore-driver.patch
pata_pcmcia-recognize-2gb-compactflash-from-transcend.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
fix-old-scsi-adapter-crashes-with-cd-rom-take-2.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
