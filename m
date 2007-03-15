From: akpm@linux-foundation.org
Subject: + radeonfb-add-support-for-radeon-xpress-200m.patch added to -mm tree
Date: Thu, 15 Mar 2007 13:42:05 -0700
Message-ID: <200703152042.l2FKg5ut026015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbXCOUmK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 16:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhn98032@gmail.com, adaplas@pol.net, benh@kernel.crashing.org


The patch titled
     radeonfb: Add support for Radeon xpress 200m
has been added to the -mm tree.  Its filename is
     radeonfb-add-support-for-radeon-xpress-200m.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: radeonfb: Add support for Radeon xpress 200m
From: johan henriksson <jhn98032@gmail.com>

Added support for radeon xpress 200m(rs480).  Note that the card doesn't
like dynclk turned on.

Signed-off-by: Johan Henriksson <jhn98032@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/ati_ids.h     |    2 +-
 drivers/video/aty/radeon_base.c |    5 ++++-
 drivers/video/aty/radeon_pm.c   |   10 +++++++---
 drivers/video/aty/radeonfb.h    |    4 +++-
 4 files changed, 15 insertions(+), 6 deletions(-)

diff -puN drivers/video/aty/ati_ids.h~radeonfb-add-support-for-radeon-xpress-200m drivers/video/aty/ati_ids.h
--- a/drivers/video/aty/ati_ids.h~radeonfb-add-support-for-radeon-xpress-200m
+++ a/drivers/video/aty/ati_ids.h
@@ -209,4 +209,4 @@
 #define PCI_CHIP_R423_5D57              0x5D57
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
-
+#define PCI_CHIP_RS480_5955             0x5955
diff -puN drivers/video/aty/radeon_base.c~radeonfb-add-support-for-radeon-xpress-200m drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-add-support-for-radeon-xpress-200m
+++ a/drivers/video/aty/radeon_base.c
@@ -100,6 +100,8 @@
 	{ PCI_VENDOR_ID_ATI, id, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (flags) | (CHIP_FAMILY_##family) }
 
 static struct pci_device_id radeonfb_pci_table[] = {
+        /* Radeon Xpress 200m */
+	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility M6 */
 	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
@@ -1994,7 +1996,8 @@ static void radeon_identify_vram(struct 
 	/* framebuffer size */
         if ((rinfo->family == CHIP_FAMILY_RS100) ||
             (rinfo->family == CHIP_FAMILY_RS200) ||
-            (rinfo->family == CHIP_FAMILY_RS300)) {
+            (rinfo->family == CHIP_FAMILY_RS300) ||
+	    (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
 
diff -puN drivers/video/aty/radeon_pm.c~radeonfb-add-support-for-radeon-xpress-200m drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeonfb-add-support-for-radeon-xpress-200m
+++ a/drivers/video/aty/radeon_pm.c
@@ -2826,11 +2826,15 @@ void radeonfb_pm_init(struct radeonfb_in
 	rinfo->pm_reg = pci_find_capability(rinfo->pdev, PCI_CAP_ID_PM);
 
 	/* Enable/Disable dynamic clocks: TODO add sysfs access */
-	rinfo->dynclk = dynclk;
-	if (dynclk == 1) {
+	if (rinfo->family == CHIP_FAMILY_RS480)
+		rinfo->dynclk = -1;
+	else
+		rinfo->dynclk = dynclk;
+
+	if (rinfo->dynclk == 1) {
 		radeon_pm_enable_dynamic_mode(rinfo);
 		printk("radeonfb: Dynamic Clock Power Management enabled\n");
-	} else if (dynclk == 0) {
+	} else if (rinfo->dynclk == 0) {
 		radeon_pm_disable_dynamic_mode(rinfo);
 		printk("radeonfb: Dynamic Clock Power Management disabled\n");
 	}
diff -puN drivers/video/aty/radeonfb.h~radeonfb-add-support-for-radeon-xpress-200m drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-add-support-for-radeon-xpress-200m
+++ a/drivers/video/aty/radeonfb.h
@@ -48,6 +48,7 @@ enum radeon_family {
 	CHIP_FAMILY_RV350,
 	CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
 	CHIP_FAMILY_R420,     /* R420/R423/M18 */
+	CHIP_FAMILY_RS480,
 	CHIP_FAMILY_LAST,
 };
 
@@ -64,7 +65,8 @@ enum radeon_family {
 				((rinfo)->family == CHIP_FAMILY_RV350) || \
 				((rinfo)->family == CHIP_FAMILY_R350)  || \
 				((rinfo)->family == CHIP_FAMILY_RV380) || \
-				((rinfo)->family == CHIP_FAMILY_R420))
+				((rinfo)->family == CHIP_FAMILY_R420)  || \
+		                ((rinfo)->family == CHIP_FAMILY_RS480) )
 
 /*
  * Chip flags
_

Patches currently in -mm which might be from jhn98032@gmail.com are

radeonfb-add-support-for-radeon-xpress-200m.patch
