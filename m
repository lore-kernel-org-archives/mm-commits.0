From: akpm@linux-foundation.org
Subject: - tridentfb-improved-register-values-on-tgui-9680.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:03 -0700
Message-ID: <200807242331.m6ONV3fA011585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756682AbYGXXbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: improved register values on TGUI 9680
has been removed from the -mm tree.  Its filename was
     tridentfb-improved-register-values-on-tgui-9680.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: improved register values on TGUI 9680
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Improved values for some registers after Xorg Trident driver.  The main
problem was that values set by BIOS have been ignored.

This patch completely remove random pixels ("snow") on the TGUI 9680 and
9440 (not supported yet by the driver).  It does not help with the "snow"
on 3DImage and Blade3D cards.

There is also small improvement in timing calculations (hblank start and
vblank start)

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   29 +++++++++++++++++++++++------
 include/video/trident.h   |    1 +
 2 files changed, 24 insertions(+), 6 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-improved-register-values-on-tgui-9680 drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-improved-register-values-on-tgui-9680
+++ a/drivers/video/tridentfb.c
@@ -87,7 +87,17 @@ MODULE_PARM_DESC(crt, "Define if CRT is 
 
 static int is_oldclock(int id)
 {
-	return (id == TGUI9660);
+	return	(id == TGUI9660) ||
+		(id == CYBER9320);
+}
+
+static int is_oldprotect(int id)
+{
+	return	(id == TGUI9660) ||
+		(id == PROVIDIA9685) ||
+		(id == CYBER9320) ||
+		(id == CYBER9382) ||
+		(id == CYBER9385);
 }
 
 static int is_blade(int id)
@@ -143,6 +153,7 @@ static int iscyber(int id)
 
 	case CYBER9320:
 	case TGUI9660:
+	case PROVIDIA9685:
 	case IMAGE975:
 	case IMAGE985:
 	case BLADE3D:
@@ -905,14 +916,14 @@ static int tridentfb_set_par(struct fb_i
 	hsyncend = (var->xres + var->right_margin + var->hsync_len) / 8 - 1;
 	htotal = (var->xres + var->left_margin + var->right_margin +
 		  var->hsync_len) / 8 - 5;
-	hblankstart = hdispend + 2;
+	hblankstart = hdispend + 1;
 	hblankend = htotal + 3;
 
 	vdispend = var->yres - 1;
 	vsyncstart = var->yres + var->lower_margin;
 	vsyncend = vsyncstart + var->vsync_len;
 	vtotal = var->upper_margin + vsyncend - 2;
-	vblankstart = vdispend + 2;
+	vblankstart = vdispend + 1;
 	vblankend = vtotal;
 
 	crtc_unlock(par);
@@ -1020,15 +1031,18 @@ static int tridentfb_set_par(struct fb_i
 
 	write3X4(par, PixelBusReg, tmp);
 
-	tmp = 0x10;
+	tmp = read3X4(par, DRAMControl);
+	if (!is_oldprotect(par->chip_id))
+		tmp |= 0x10;
 	if (iscyber(par->chip_id))
 		tmp |= 0x20;
 	write3X4(par, DRAMControl, tmp);	/* both IO, linear enable */
 
 	write3X4(par, InterfaceSel, read3X4(par, InterfaceSel) | 0x40);
-	write3X4(par, Performance, 0x92);
+	if (!is_xp(par->chip_id))
+		write3X4(par, Performance, read3X4(par, Performance) | 0x10);
 	/* MMIO & PCI read and write burst enable */
-	write3X4(par, PCIReg, 0x07);
+	write3X4(par, PCIReg, read3X4(par, PCIReg) | 0x06);
 
 	/* convert from picoseconds to kHz */
 	vclk = PICOS2KHZ(info->var.pixclock);
@@ -1230,6 +1244,9 @@ static int __devinit trident_pci_probe(s
 		revision = vga_io_rseq(RevisionID);
 
 		switch (revision) {
+		case 0x21:
+			chip_id = PROVIDIA9685;
+			break;
 		case 0x22:
 		case 0x23:
 			chip_id = CYBER9397;
diff -puN include/video/trident.h~tridentfb-improved-register-values-on-tgui-9680 include/video/trident.h
--- a/include/video/trident.h~tridentfb-improved-register-values-on-tgui-9680
+++ a/include/video/trident.h
@@ -25,6 +25,7 @@
 #define CYBER9520	0x9520
 #define CYBER9525DVD	0x9525
 #define TGUI9660	0x9660
+#define PROVIDIA9685	0x9685
 #define IMAGE975	0x9750
 #define IMAGE985	0x9850
 #define BLADE3D		0x9880
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

