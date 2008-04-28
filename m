From: akpm@linux-foundation.org
Subject: - radeonfb-use-pci-device-id-in-hex-for-name-string.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:15 -0700
Message-ID: <200804282158.m3SLwFcY018477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965095AbYD1V61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: use PCI device id in hex for name string
has been removed from the -mm tree.  Its filename was
     radeonfb-use-pci-device-id-in-hex-for-name-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: use PCI device id in hex for name string
From: Andreas Herrmann <aherrman@arcor.de>

Additionally provide PCI device id in character format if possible.  (The
printable characters were commonly used to identify the cards.)

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-use-pci-device-id-in-hex-for-name-string drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-use-pci-device-id-in-hex-for-name-string
+++ a/drivers/video/aty/radeon_base.c
@@ -57,6 +57,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -2158,6 +2159,7 @@ static int __devinit radeonfb_pci_regist
 	struct fb_info *info;
 	struct radeonfb_info *rinfo;
 	int ret;
+	unsigned char c1, c2;
 
 	RTRACE("radeonfb_pci_register BEGIN\n");
 	
@@ -2185,9 +2187,15 @@ static int __devinit radeonfb_pci_regist
 	rinfo->lvds_timer.function = radeon_lvds_timer_func;
 	rinfo->lvds_timer.data = (unsigned long)rinfo;
 
-	strcpy(rinfo->name, "ATI Radeon XX ");
-	rinfo->name[11] = ent->device >> 8;
-	rinfo->name[12] = ent->device & 0xFF;
+	c1 = ent->device >> 8;
+	c2 = ent->device & 0xff;
+	if (isprint(c1) && isprint(c2))
+		snprintf(rinfo->name, sizeof(rinfo->name),
+			 "ATI Radeon %x \"%c%c\"", ent->device & 0xffff, c1, c2);
+	else
+		snprintf(rinfo->name, sizeof(rinfo->name),
+			 "ATI Radeon %x", ent->device & 0xffff);
+
 	rinfo->family = ent->driver_data & CHIP_FAMILY_MASK;
 	rinfo->chipset = pdev->device;
 	rinfo->has_CRTC2 = (ent->driver_data & CHIP_HAS_CRTC2) != 0;
_

Patches currently in -mm which might be from aherrman@arcor.de are

origin.patch

