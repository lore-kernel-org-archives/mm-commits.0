From: akpm@linux-foundation.org
Subject: + tridentfb-add-tgui-9440-support.patch added to -mm tree
Date: Mon, 12 May 2008 15:41:53 -0700
Message-ID: <200805122241.m4CMfrRr012831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbYELWmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:42:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: add TGUI 9440 support
has been added to the -mm tree.  Its filename is
     tridentfb-add-tgui-9440-support.patch

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

tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
drivers-video-pnx4008-eliminate-double-free.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

