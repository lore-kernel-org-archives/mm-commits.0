From: akpm@linux-foundation.org
Subject: + intel_agp-pci-id-update-for-intel-965gm.patch added to -mm tree
Date: Tue, 10 Apr 2007 13:38:40 -0700
Message-ID: <200704102038.l3AKceO3016745@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44305 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXDJUi6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 16:38:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk


The patch titled
     intel_agp: PCI id update for Intel 965GM
has been added to the -mm tree.  Its filename is
     intel_agp-pci-id-update-for-intel-965gm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel_agp: PCI id update for Intel 965GM
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

Update PCI id info for Intel 965GM chipset.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-pci-id-update-for-intel-965gm drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-pci-id-update-for-intel-965gm
+++ a/drivers/char/agp/intel-agp.c
@@ -18,11 +18,14 @@
 #define PCI_DEVICE_ID_INTEL_82965Q_IG       0x2992
 #define PCI_DEVICE_ID_INTEL_82965G_HB       0x29A0
 #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
+#define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
+#define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB)
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
 
 
 extern int agp_memory_reserved;
@@ -1919,7 +1922,13 @@ static int __devinit agp_intel_probe(str
 			bridge->driver = &intel_845_driver;
 		name = "965G";
 		break;
-
+	case PCI_DEVICE_ID_INTEL_82965GM_HB:
+		if (find_i830(PCI_DEVICE_ID_INTEL_82965GM_IG))
+			bridge->driver = &intel_i965_driver;
+		else
+			bridge->driver = &intel_845_driver;
+		name = "965GM";
+		break;
 	case PCI_DEVICE_ID_INTEL_7505_0:
 		bridge->driver = &intel_7505_driver;
 		name = "E7505";
@@ -2078,6 +2087,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_82965G_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
+	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
 	{ }
 };
 
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

intel_agp-pci-id-update-for-intel-965gm.patch
