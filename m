From: akpm@linux-foundation.org
Subject: - radeonfb-use-pci-device-id-in-hex-for-name-string.patch removed from -mm tree
Date: Thu, 13 Sep 2007 04:31:41 -0700
Message-ID: <200709131131.l8DBVflS016425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbXIMLbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 07:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: use PCI device Id in hex for name string
has been removed from the -mm tree.  Its filename was
     radeonfb-use-pci-device-id-in-hex-for-name-string.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: radeonfb: use PCI device Id in hex for name string
From: Andreas Herrmann <aherrman@arcor.de>

.. instead of potentially using nonprintable characters.

I guess the former (odd) concatenation was used to construct name strings
that match the  "*_ATI_RADEON_??" macros in include/linux/pci_ids.h

The PCI Id in hex is much more convenient to use. E.g. it can easily be
verified against "lspci -nn" output.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-use-pci-device-id-in-hex-for-name-string drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-use-pci-device-id-in-hex-for-name-string
+++ a/drivers/video/aty/radeon_base.c
@@ -2184,9 +2184,8 @@ static int __devinit radeonfb_pci_regist
 	rinfo->lvds_timer.function = radeon_lvds_timer_func;
 	rinfo->lvds_timer.data = (unsigned long)rinfo;
 
-	strcpy(rinfo->name, "ATI Radeon XX ");
-	rinfo->name[11] = ent->device >> 8;
-	rinfo->name[12] = ent->device & 0xFF;
+	snprintf(rinfo->name, sizeof(rinfo->name),
+		 "ATI Radeon %x", ent->device & 0xffff);
 	rinfo->family = ent->driver_data & CHIP_FAMILY_MASK;
 	rinfo->chipset = pdev->device;
 	rinfo->has_CRTC2 = (ent->driver_data & CHIP_HAS_CRTC2) != 0;
_

Patches currently in -mm which might be from aherrman@arcor.de are

radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch
radeonfb-use-pci-device-id-in-hex-for-name-string.patch
