From: akpm@linux-foundation.org
Subject: + tridentfb-fix-console-freeze-when-switching-from-x11.patch added to -mm tree
Date: Tue, 20 May 2008 02:18:23 -0700
Message-ID: <200805200918.m4K9IN6B015177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758433AbYETJSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:18:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: fix console freeze when switching from X11
has been added to the -mm tree.  Its filename is
     tridentfb-fix-console-freeze-when-switching-from-x11.patch

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
Subject: tridentfb: fix console freeze when switching from X11
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes two problems when acceleration is enabled:

 - console switch from the Xorg locks up the computer
   because the Xorg code locks some registers and disables
   the mmio mode, so reenable these in the
   tridentfb_set_par() and enable_mmio()

 - blacklist the Image975 chipset from setting PCI burst
   mode. This helps with random lock ups of the
   framebuffer on this chip. The same fix is probably
   needed for the Xorg as well.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-console-freeze-when-switching-from-x11 drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-console-freeze-when-switching-from-x11
+++ a/drivers/video/tridentfb.c
@@ -558,13 +558,15 @@ static inline void write3CE(struct tride
 	vga_mm_wgfx(par->io_virt, reg, val);
 }
 
-static void enable_mmio(void)
+static void enable_mmio(struct tridentfb_par *par)
 {
 	/* Goto New Mode */
 	vga_io_rseq(0x0B);
 
 	/* Unprotect registers */
 	vga_io_wseq(NewMode1, 0x80);
+	if (!is_oldprotect(par->chip_id))
+		vga_io_wseq(Protection, 0x92);
 
 	/* Enable MMIO */
 	outb(PCIReg, 0x3D4);
@@ -578,6 +580,8 @@ static void disable_mmio(struct tridentf
 
 	/* Unprotect registers */
 	vga_mm_wseq(par->io_virt, NewMode1, 0x80);
+	if (!is_oldprotect(par->chip_id))
+		vga_mm_wseq(par->io_virt, Protection, 0x92);
 
 	/* Disable MMIO */
 	t_outb(par, PCIReg, 0x3D4);
@@ -995,6 +999,7 @@ static int tridentfb_set_par(struct fb_i
 		vblankend /= 2;
 	}
 
+	enable_mmio(par);
 	crtc_unlock(par);
 	write3CE(par, CyberControl, 8);
 	tmp = 0xEB;
@@ -1116,7 +1121,7 @@ static int tridentfb_set_par(struct fb_i
 	if (!is_xp(par->chip_id))
 		write3X4(par, Performance, read3X4(par, Performance) | 0x10);
 	/* MMIO & PCI read and write burst enable */
-	if (par->chip_id != TGUI9440)
+	if (par->chip_id != TGUI9440 && par->chip_id != IMAGE975)
 		write3X4(par, PCIReg, read3X4(par, PCIReg) | 0x06);
 
 	vga_mm_wseq(par->io_virt, 0, 3);
@@ -1403,7 +1408,7 @@ static int __devinit trident_pci_probe(s
 		goto out_unmap1;
 	}
 
-	enable_mmio();
+	enable_mmio(default_par);
 
 	/* setup framebuffer memory */
 	tridentfb_fix.smem_start = pci_resource_start(dev, 0);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

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
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

