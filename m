From: akpm@linux-foundation.org
Subject: + radeonfb-use-pci-device-id-in-hex-for-name-string.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:33:12 -0800
Message-ID: <200803060633.m266XC9H012838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592AbYCFGdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:33:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org


The patch titled
     radeonfb: use PCI device id in hex for name string
has been added to the -mm tree.  Its filename is
     radeonfb-use-pci-device-id-in-hex-for-name-string.patch

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

radeonfb-use-pci-device-id-in-hex-for-name-string.patch

