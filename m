From: akpm@linux-foundation.org
Subject: - radeonfb-xpress-200m-rc410-support-patch.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:37 -0700
Message-ID: <200710162044.l9GKibZa016162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935392AbXJPVYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:24:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sellout@beautyisfleeting.com, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Radeonfb Xpress 200M RC410 support
has been removed from the -mm tree.  Its filename was
     radeonfb-xpress-200m-rc410-support-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Radeonfb Xpress 200M RC410 support
From: Sellout Bessie <sellout@beautyisfleeting.com>

Make radeonfb work ith the 200m Xpress RC410.  In my tests it was terribly
unstable and would freeze until I set a refresh rate in the kernel argument
to 75.

e.g video=radeonfb:1280x800@75

Now it is rock solid.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/ati_ids.h     |    1 +
 drivers/video/aty/radeon_base.c |    3 +++
 drivers/video/aty/radeonfb.h    |    4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/ati_ids.h~radeonfb-xpress-200m-rc410-support-patch drivers/video/aty/ati_ids.h
--- a/drivers/video/aty/ati_ids.h~radeonfb-xpress-200m-rc410-support-patch
+++ a/drivers/video/aty/ati_ids.h
@@ -188,6 +188,7 @@
 #define PCI_CHIP_MACH64VT		0x5654
 #define PCI_CHIP_MACH64VU		0x5655
 #define PCI_CHIP_MACH64VV		0x5656
+#define PCI_CHIP_RC410_5A62             0x5A62
 #define PCI_CHIP_RS300_5834		0x5834
 #define PCI_CHIP_RS300_5835		0x5835
 #define PCI_CHIP_RS300_5836		0x5836
diff -puN drivers/video/aty/radeon_base.c~radeonfb-xpress-200m-rc410-support-patch drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-xpress-200m-rc410-support-patch
+++ a/drivers/video/aty/radeon_base.c
@@ -145,6 +145,8 @@ static struct pci_device_id radeonfb_pci
 	/* 9000/Pro */
 	CHIP_DEF(PCI_CHIP_RV250_If,	RV250,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV250_Ig,	RV250,	CHIP_HAS_CRTC2),
+
+	CHIP_DEF(PCI_CHIP_RC410_5A62,   RC410,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility 9100 IGP (U3) */
 	CHIP_DEF(PCI_CHIP_RS300_5835,	RS300,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RS350_7835,	RS300,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
@@ -1999,6 +2001,7 @@ static void radeon_identify_vram(struct 
         if ((rinfo->family == CHIP_FAMILY_RS100) ||
             (rinfo->family == CHIP_FAMILY_RS200) ||
             (rinfo->family == CHIP_FAMILY_RS300) ||
+            (rinfo->family == CHIP_FAMILY_RC410) ||
 	    (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
diff -puN drivers/video/aty/radeonfb.h~radeonfb-xpress-200m-rc410-support-patch drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-xpress-200m-rc410-support-patch
+++ a/drivers/video/aty/radeonfb.h
@@ -48,6 +48,7 @@ enum radeon_family {
 	CHIP_FAMILY_RV350,
 	CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
 	CHIP_FAMILY_R420,     /* R420/R423/M18 */
+	CHIP_FAMILY_RC410,
 	CHIP_FAMILY_RS480,
 	CHIP_FAMILY_LAST,
 };
@@ -66,7 +67,8 @@ enum radeon_family {
 				((rinfo)->family == CHIP_FAMILY_R350)  || \
 				((rinfo)->family == CHIP_FAMILY_RV380) || \
 				((rinfo)->family == CHIP_FAMILY_R420)  || \
-		                ((rinfo)->family == CHIP_FAMILY_RS480) )
+                               ((rinfo)->family == CHIP_FAMILY_RC410) || \
+                               ((rinfo)->family == CHIP_FAMILY_RS480))
 
 /*
  * Chip flags
_

Patches currently in -mm which might be from sellout@beautyisfleeting.com are

origin.patch
