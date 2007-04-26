From: akpm@linux-foundation.org
Subject: + pm2fb-3dlabs-permedia-2v-reference-board-added.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:25 -0700
Message-ID: <200704260033.l3Q0XPd1017018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423440AbXDZAd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: 3dlabs Permedia 2V reference board added
has been added to the -mm tree.  Its filename is
     pm2fb-3dlabs-permedia-2v-reference-board-added.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: 3dlabs Permedia 2V reference board added
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds support for 3dlabs Permedia reference board.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-3dlabs-permedia-2v-reference-board-added drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-3dlabs-permedia-2v-reference-board-added
+++ a/drivers/video/pm2fb.c
@@ -1117,20 +1117,31 @@ static int __devinit pm2fb_probe(struct 
 		default_par->mem_control, default_par->boot_address,
 		default_par->mem_config);
 
+	default_par->memclock = CVPPC_MEMCLOCK;
 	if(default_par->mem_control == 0 &&
 		default_par->boot_address == 0x31 &&
-		default_par->mem_config == 0x259fffff &&
-		pdev->subsystem_vendor == 0x1048 &&
-		pdev->subsystem_device == 0x0a31) {
-		DPRINTK("subsystem_vendor: %04x, subsystem_device: %04x\n",
-			pdev->subsystem_vendor, pdev->subsystem_device);
-		DPRINTK("We have not been initialized by VGA BIOS "
-			"and are running on an Elsa Winner 2000 Office\n");
-		DPRINTK("Initializing card timings manually...\n");
+		default_par->mem_config == 0x259fffff) {
 		default_par->mem_control=0;
 		default_par->boot_address=0x20;
 		default_par->mem_config=0xe6002021;
-		default_par->memclock=100000;
+		if (pdev->subsystem_vendor == 0x1048 &&
+			pdev->subsystem_device == 0x0a31) {
+			DPRINTK("subsystem_vendor: %04x, subsystem_device: %04x\n",
+				pdev->subsystem_vendor, pdev->subsystem_device);
+			DPRINTK("We have not been initialized by VGA BIOS "
+				"and are running on an Elsa Winner 2000 Office\n");
+			DPRINTK("Initializing card timings manually...\n");
+			default_par->memclock=70000;
+		}
+		if (pdev->subsystem_vendor == 0x3d3d &&
+			pdev->subsystem_device == 0x0100) {
+			DPRINTK("subsystem_vendor: %04x, subsystem_device: %04x\n",
+				pdev->subsystem_vendor, pdev->subsystem_device);
+			DPRINTK("We have not been initialized by VGA BIOS "
+				"and are running on an 3dlabs reference board\n");
+			DPRINTK("Initializing card timings manually...\n");
+			default_par->memclock=70000;
+		}
 	}
 
 	/* Now work out how big lfb is going to be. */
@@ -1148,7 +1159,6 @@ static int __devinit pm2fb_probe(struct 
 		default_par->fb_size=0x800000;
 		break;
 	}
-	default_par->memclock = CVPPC_MEMCLOCK;
 	pm2fb_fix.smem_start = pci_resource_start(pdev, 1);
 	pm2fb_fix.smem_len = default_par->fb_size;
 
@@ -1242,6 +1252,9 @@ static struct pci_device_id pm2fb_id_tab
 	{ PCI_VENDOR_ID_3DLABS, PCI_DEVICE_ID_3DLABS_PERMEDIA2V,
 	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
 	  0xff0000, 0 },
+	{ PCI_VENDOR_ID_3DLABS, PCI_DEVICE_ID_3DLABS_PERMEDIA2V,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_NOT_DEFINED_VGA << 8,
+	  0xff00, 0 },
 	{ 0, }
 };
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
