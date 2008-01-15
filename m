From: akpm@linux-foundation.org
Subject: + intel_agp-add-new-chipset-ids.patch added to -mm tree
Date: Tue, 15 Jan 2008 02:04:12 -0800
Message-ID: <200801151003.m0FA3qk2010095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYAOKEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 05:04:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, airlied@linux.ie


The patch titled
     intel_agp: add new chipset ids
has been added to the -mm tree.  Its filename is
     intel_agp-add-new-chipset-ids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_agp: add new chipset ids
From: Zhenyu Wang <zhenyu.z.wang@intel.com>

This one adds new pci ids for Intel intergrated graphics chipset, with gtt
table access change on it and new gtt table size definition.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h       |    3 +++
 drivers/char/agp/intel-agp.c |   31 ++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff -puN drivers/char/agp/agp.h~intel_agp-add-new-chipset-ids drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~intel_agp-add-new-chipset-ids
+++ a/drivers/char/agp/agp.h
@@ -236,6 +236,9 @@ struct agp_bridge_data {
 #define I965_PGETBL_SIZE_512KB	(0 << 1)
 #define I965_PGETBL_SIZE_256KB	(1 << 1)
 #define I965_PGETBL_SIZE_128KB	(2 << 1)
+#define I965_PGETBL_SIZE_1MB	(3 << 1)
+#define I965_PGETBL_SIZE_2MB	(4 << 1)
+#define I965_PGETBL_SIZE_1_5MB	(5 << 1)
 #define G33_PGETBL_SIZE_MASK    (3 << 8)
 #define G33_PGETBL_SIZE_1M      (1 << 8)
 #define G33_PGETBL_SIZE_2M      (2 << 8)
diff -puN drivers/char/agp/intel-agp.c~intel_agp-add-new-chipset-ids drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-add-new-chipset-ids
+++ a/drivers/char/agp/intel-agp.c
@@ -30,13 +30,16 @@
 #define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
 #define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
+#define PCI_DEVICE_ID_INTEL_IGD_HB          0x2A40
+#define PCI_DEVICE_ID_INTEL_IGD_IG          0x2A42
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB)
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_HB)
 
 #define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -471,6 +474,15 @@ static void intel_i830_init_gtt_entries(
 		case I965_PGETBL_SIZE_512KB:
 			size = 512;
 			break;
+		case I965_PGETBL_SIZE_1MB:
+			size = 1024;
+			break;
+		case I965_PGETBL_SIZE_2MB:
+			size = 2048;
+			break;
+		case I965_PGETBL_SIZE_1_5MB:
+			size = 1024 + 512;
+			break;
 		default:
 			printk(KERN_INFO PFX "Unknown page table size, "
 			       "assuming 512KB\n");
@@ -1130,6 +1142,7 @@ static int intel_i965_create_gatt_table(
        struct aper_size_info_fixed *size;
        int num_entries;
        u32 temp;
+       int gtt_offset, gtt_size;
 
        size = agp_bridge->current_size;
        page_order = size->page_order;
@@ -1139,13 +1152,18 @@ static int intel_i965_create_gatt_table(
        pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 
        temp &= 0xfff00000;
-       intel_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
 
-	if (!intel_private.gtt)
-		return -ENOMEM;
+       if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_HB)
+	       gtt_offset = gtt_size = MB(2);
+       else
+	       gtt_offset = gtt_size = KB(512);
+
+       intel_private.gtt = ioremap((temp + gtt_offset) , gtt_size);
 
+       if (!intel_private.gtt)
+	       return -ENOMEM;
 
-       intel_private.registers = ioremap(temp,128 * 4096);
+       intel_private.registers = ioremap(temp, 128 * 4096);
        if (!intel_private.registers) {
 		iounmap(intel_private.gtt);
 		return -ENOMEM;
@@ -2040,6 +2058,8 @@ static const struct intel_driver_descrip
 		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
 		NULL, &intel_g33_driver },
+	{ PCI_DEVICE_ID_INTEL_IGD_HB, PCI_DEVICE_ID_INTEL_IGD_IG, 0,
+	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
@@ -2399,6 +2419,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_G33_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
+	ID(PCI_DEVICE_ID_INTEL_IGD_HB),
 	{ }
 };
 
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

intel_agp-add-new-chipset-ids.patch
