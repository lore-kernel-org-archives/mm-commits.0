From: akpm@linux-foundation.org
Subject: - intel_agp-add-support-for-g33-q33-and-q35-chipsets.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:24 -0700
Message-ID: <200706081735.l58HZOiW006361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030552AbXFHRgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     intel_agp: add support for G33, Q33 and Q35 chipsets
has been removed from the -mm tree.  Its filename was
     intel_agp-add-support-for-g33-q33-and-q35-chipsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel_agp: add support for G33, Q33 and Q35 chipsets
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

Add pci ids for G33, Q33 and Q35 chips, and update with new GTT size and
stolen mem size detect method on these chips.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/agp.h       |    6 ++
 drivers/char/agp/intel-agp.c |   79 ++++++++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 3 deletions(-)

diff -puN drivers/char/agp/agp.h~intel_agp-add-support-for-g33-q33-and-q35-chipsets drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h~intel_agp-add-support-for-g33-q33-and-q35-chipsets
+++ a/drivers/char/agp/agp.h
@@ -176,7 +176,7 @@ struct agp_bridge_data {
 #define I830_GMCH_MEM_MASK		0x1
 #define I830_GMCH_MEM_64M		0x1
 #define I830_GMCH_MEM_128M		0
-#define I830_GMCH_GMS_MASK		0x70
+#define I830_GMCH_GMS_MASK		0xF0
 #define I830_GMCH_GMS_DISABLED		0x00
 #define I830_GMCH_GMS_LOCAL		0x10
 #define I830_GMCH_GMS_STOLEN_512	0x20
@@ -231,6 +231,10 @@ struct agp_bridge_data {
 #define I965_PGETBL_SIZE_512KB	(0 << 1)
 #define I965_PGETBL_SIZE_256KB	(1 << 1)
 #define I965_PGETBL_SIZE_128KB	(2 << 1)
+#define G33_PGETBL_SIZE_MASK    (3 << 8)
+#define G33_PGETBL_SIZE_1M      (1 << 8)
+#define G33_PGETBL_SIZE_2M      (2 << 8)
+
 #define I810_DRAM_CTL		0x3000
 #define I810_DRAM_ROW_0		0x00000001
 #define I810_DRAM_ROW_0_SDRAM	0x00000001
diff -puN drivers/char/agp/intel-agp.c~intel_agp-add-support-for-g33-q33-and-q35-chipsets drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-add-support-for-g33-q33-and-q35-chipsets
+++ a/drivers/char/agp/intel-agp.c
@@ -22,6 +22,12 @@
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
 #define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
 #define PCI_DEVICE_ID_INTEL_82945GME_IG     0x27AE
+#define PCI_DEVICE_ID_INTEL_G33_HB          0x29C0
+#define PCI_DEVICE_ID_INTEL_G33_IG          0x29C2
+#define PCI_DEVICE_ID_INTEL_Q35_HB          0x29B0
+#define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
+#define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
+#define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
@@ -29,6 +35,9 @@
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
 
+#define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q33_HB)
 
 extern int agp_memory_reserved;
 
@@ -62,6 +71,8 @@ extern int agp_memory_reserved;
 #define I915_PTEADDR	0x1C
 #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
 #define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
+#define G33_GMCH_GMS_STOLEN_128M       (0x8 << 4)
+#define G33_GMCH_GMS_STOLEN_256M       (0x9 << 4)
 
 /* Intel 965G registers */
 #define I965_MSAC 0x62
@@ -455,6 +466,22 @@ static void intel_i830_init_gtt_entries(
 			size = 512;
 		}
 		size += 4; /* add in BIOS popup space */
+	} else if (IS_G33) {
+	/* G33's GTT size defined in gmch_ctrl */
+		switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
+		case G33_PGETBL_SIZE_1M:
+			size = 1024;
+			break;
+		case G33_PGETBL_SIZE_2M:
+			size = 2048;
+			break;
+		default:
+			printk(KERN_INFO PFX "Unknown page table size 0x%x, "
+				"assuming 512KB\n",
+				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
+			size = 512;
+		}
+		size += 4;
 	} else {
 		/* On previous hardware, the GTT size was just what was
 		 * required to map the aperture.
@@ -506,7 +533,8 @@ static void intel_i830_init_gtt_entries(
 			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
-			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || IS_I965 )
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    IS_I965 || IS_G33)
 				gtt_entries = MB(48) - KB(size);
 			else
 				gtt_entries = 0;
@@ -516,10 +544,24 @@ static void intel_i830_init_gtt_entries(
 			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
-			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB || IS_I965)
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    IS_I965 || IS_G33)
 				gtt_entries = MB(64) - KB(size);
 			else
 				gtt_entries = 0;
+			break;
+		case G33_GMCH_GMS_STOLEN_128M:
+			if (IS_G33)
+				gtt_entries = MB(128) - KB(size);
+			else
+				gtt_entries = 0;
+			break;
+		case G33_GMCH_GMS_STOLEN_256M:
+			if (IS_G33)
+				gtt_entries = MB(256) - KB(size);
+			else
+				gtt_entries = 0;
+			break;
 		default:
 			gtt_entries = 0;
 			break;
@@ -1726,6 +1768,30 @@ static const struct agp_bridge_driver in
 	.agp_type_to_mask_type  = agp_generic_type_to_mask_type,
 };
 
+static const struct agp_bridge_driver intel_g33_driver = {
+	.owner                  = THIS_MODULE,
+	.aperture_sizes         = intel_i830_sizes,
+	.size_type              = FIXED_APER_SIZE,
+	.num_aperture_sizes     = 4,
+	.needs_scratch_page     = TRUE,
+	.configure              = intel_i915_configure,
+	.fetch_size             = intel_i9xx_fetch_size,
+	.cleanup                = intel_i915_cleanup,
+	.tlb_flush              = intel_i810_tlbflush,
+	.mask_memory            = intel_i965_mask_memory,
+	.masks                  = intel_i810_masks,
+	.agp_enable             = intel_i810_agp_enable,
+	.cache_flush            = global_cache_flush,
+	.create_gatt_table      = intel_i915_create_gatt_table,
+	.free_gatt_table        = intel_i830_free_gatt_table,
+	.insert_memory          = intel_i915_insert_entries,
+	.remove_memory          = intel_i915_remove_entries,
+	.alloc_by_type          = intel_i830_alloc_by_type,
+	.free_by_type           = intel_i810_free_by_type,
+	.agp_alloc_page         = agp_generic_alloc_page,
+	.agp_destroy_page       = agp_generic_destroy_page,
+	.agp_type_to_mask_type  = intel_i830_type_to_mask_type,
+};
 
 static int find_gmch(u16 device)
 {
@@ -1806,6 +1872,12 @@ static const struct intel_driver_descrip
 		&intel_845_driver, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, "E7205", &intel_7505_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, "G33",
+		&intel_845_driver, &intel_g33_driver },
+	{ PCI_DEVICE_ID_INTEL_Q35_HB, PCI_DEVICE_ID_INTEL_Q35_IG, "Q35",
+		&intel_845_driver, &intel_g33_driver },
+	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, "Q33",
+		&intel_845_driver, &intel_g33_driver },
 	{ 0, 0, NULL, NULL, NULL }
 };
 
@@ -2153,6 +2225,9 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
+	ID(PCI_DEVICE_ID_INTEL_G33_HB),
+	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
+	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
 	{ }
 };
 
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

git-agpgart.patch
