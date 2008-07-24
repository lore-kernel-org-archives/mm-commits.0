From: akpm@linux-foundation.org
Subject: - tridentfb-fix-hi-color-modes-for-tgui-9440.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:13 -0700
Message-ID: <200807242331.m6ONVDAm011604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbYGXXbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix hi-color modes for TGUI 9440
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-hi-color-modes-for-tgui-9440.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: fix hi-color modes for TGUI 9440
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The TGUI 9440 requires doubling clock for 16bpp (hi-color) modes.

The patch also moves back enable_mmio() call to the right position.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-hi-color-modes-for-tgui-9440 drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-hi-color-modes-for-tgui-9440
+++ a/drivers/video/tridentfb.c
@@ -835,6 +835,8 @@ static int tridentfb_check_var(struct fb
 	/* check color depth */
 	if (bpp == 24)
 		bpp = var->bits_per_pixel = 32;
+	if (par->chip_id == TGUI9440 && bpp == 32)
+		return -EINVAL;
 	/* check whether resolution fits on panel and in memory */
 	if (par->flatpanel && nativex && var->xres > nativex)
 		return -EINVAL;
@@ -881,7 +883,7 @@ static int tridentfb_check_var(struct fb
 
 	switch (par->chip_id) {
 	case TGUI9440:
-		ramdac = 90000;
+		ramdac = (bpp >= 16) ? 45000 : 90000;
 		break;
 	case CYBER9320:
 	case TGUI9660:
@@ -1081,12 +1083,6 @@ static int tridentfb_set_par(struct fb_i
 	if (par->chip_id != TGUI9440)
 		write3X4(par, PCIReg, read3X4(par, PCIReg) | 0x06);
 
-	/* convert from picoseconds to kHz */
-	vclk = PICOS2KHZ(info->var.pixclock);
-	if (bpp == 32)
-		vclk *= 2;
-	set_vclk(par, vclk);
-
 	vga_mm_wseq(par->io_virt, 0, 3);
 	vga_mm_wseq(par->io_virt, 1, 1); /* set char clock 8 dots wide */
 	/* enable 4 maps because needed in chain4 mode */
@@ -1094,10 +1090,16 @@ static int tridentfb_set_par(struct fb_i
 	vga_mm_wseq(par->io_virt, 3, 0);
 	vga_mm_wseq(par->io_virt, 4, 0x0E); /* memory mode enable bitmaps ?? */
 
+	/* convert from picoseconds to kHz */
+	vclk = PICOS2KHZ(info->var.pixclock);
+
 	/* divide clock by 2 if 32bpp chain4 mode display and CPU path */
 	tmp = read3CE(par, MiscExtFunc) & 0xF0;
-	if (bpp == 32)
+	if (bpp == 32 || (par->chip_id == TGUI9440 && bpp == 16)) {
 		tmp |= 8;
+		vclk *= 2;
+	}
+	set_vclk(par, vclk);
 	write3CE(par, MiscExtFunc, tmp | 0x12);
 	write3CE(par, 0x5, 0x40);	/* no CGA compat, allow 256 col */
 	write3CE(par, 0x6, 0x05);	/* graphics mode */
@@ -1361,6 +1363,8 @@ static int __devinit trident_pci_probe(s
 	tridentfb_fix.smem_start = pci_resource_start(dev, 0);
 	tridentfb_fix.smem_len = get_memsize(default_par);
 
+	enable_mmio();
+
 	if (!request_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len, "tridentfb")) {
 		debug("request_mem_region failed!\n");
 		disable_mmio(info->par);
@@ -1368,8 +1372,6 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap1;
 	}
 
-	enable_mmio();
