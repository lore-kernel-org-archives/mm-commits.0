From: akpm@linux-foundation.org
Subject: - tridentfb-add-tgui-9440-support.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:05 -0700
Message-ID: <200807242331.m6ONV506011592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756183AbYGXXbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: add TGUI 9440 support
has been removed from the -mm tree.  Its filename was
     tridentfb-add-tgui-9440-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: add TGUI 9440 support
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add support for TGUI 9440 chip.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   10 +++++++---
 include/video/trident.h   |    1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-add-tgui-9440-support drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-add-tgui-9440-support
+++ a/drivers/video/tridentfb.c
@@ -87,13 +87,15 @@ MODULE_PARM_DESC(crt, "Define if CRT is 
 
 static int is_oldclock(int id)
 {
-	return	(id == TGUI9660) ||
+	return	(id == TGUI9440) ||
+		(id == TGUI9660) ||
 		(id == CYBER9320);
 }
 
 static int is_oldprotect(int id)
 {
-	return	(id == TGUI9660) ||
+	return	(id == TGUI9440) ||
+		(id == TGUI9660) ||
 		(id == PROVIDIA9685) ||
 		(id == CYBER9320) ||
 		(id == CYBER9382) ||
@@ -1042,7 +1044,8 @@ static int tridentfb_set_par(struct fb_i
 	if (!is_xp(par->chip_id))
 		write3X4(par, Performance, read3X4(par, Performance) | 0x10);
 	/* MMIO & PCI read and write burst enable */
-	write3X4(par, PCIReg, read3X4(par, PCIReg) | 0x06);
+	if (par->chip_id != TGUI9440)
+		write3X4(par, PCIReg, read3X4(par, PCIReg) | 0x06);
 
 	/* convert from picoseconds to kHz */
 	vclk = PICOS2KHZ(info->var.pixclock);
@@ -1418,6 +1421,7 @@ static struct pci_device_id trident_devi
 	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEAi1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEAi1D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_TRIDENT,	CYBERBLADEE4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_TRIDENT,	TGUI9440, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_TRIDENT,	TGUI9660, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_TRIDENT,	IMAGE975, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_TRIDENT,	IMAGE985, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
diff -puN include/video/trident.h~tridentfb-add-tgui-9440-support include/video/trident.h
--- a/include/video/trident.h~tridentfb-add-tgui-9440-support
+++ a/include/video/trident.h
@@ -24,6 +24,7 @@
 #define CYBER9397DVD	0x939A
 #define CYBER9520	0x9520
 #define CYBER9525DVD	0x9525
+#define TGUI9440	0x9440
 #define TGUI9660	0x9660
 #define PROVIDIA9685	0x9685
 #define IMAGE975	0x9750
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

