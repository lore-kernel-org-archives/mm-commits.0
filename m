From: akpm@linux-foundation.org
Subject: - cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:54:26 -0700
Message-ID: <200810152354.m9FNsQL8024124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797AbYJOXy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix up debug printk types
has been removed from the -mm tree.  Its filename was
     cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch

This patch was dropped because it was folded into cirrusfb-eliminate-crt-registers-from-global-structure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix up debug printk types
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix debug printk types mismatch after my earlier changes.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types
+++ a/drivers/video/cirrusfb.c
@@ -818,21 +818,21 @@ static int cirrusfb_set_par_foo(struct f
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
 
 	/* if debugging is enabled, all parameters get output before writing */
-	DPRINTK("CRT0: %ld\n", htotal);
+	DPRINTK("CRT0: %d\n", htotal);
 	vga_wcrt(regbase, VGA_CRTC_H_TOTAL, htotal);
 
-	DPRINTK("CRT1: %ld\n", hdispend);
+	DPRINTK("CRT1: %d\n", hdispend);
 	vga_wcrt(regbase, VGA_CRTC_H_DISP, hdispend);
 
-	DPRINTK("CRT2: %ld\n", var->xres / 8);
+	DPRINTK("CRT2: %d\n", var->xres / 8);
 	vga_wcrt(regbase, VGA_CRTC_H_BLANK_START, var->xres / 8);
 
 	/*  + 128: Compatible read */
-	DPRINTK("CRT3: 128+%ld\n", (htotal + 5) % 32);
+	DPRINTK("CRT3: 128+%d\n", (htotal + 5) % 32);
 	vga_wcrt(regbase, VGA_CRTC_H_BLANK_END,
 		 128 + ((htotal + 5) % 32));
 
-	DPRINTK("CRT4: %ld\n", hsyncstart);
+	DPRINTK("CRT4: %d\n", hsyncstart);
 	vga_wcrt(regbase, VGA_CRTC_H_SYNC_START, hsyncstart);
 
 	tmp = hsyncend % 32;
@@ -841,7 +841,7 @@ static int cirrusfb_set_par_foo(struct f
 	DPRINTK("CRT5: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_H_SYNC_END, tmp);
 
-	DPRINTK("CRT6: %ld\n", vtotal & 0xff);
+	DPRINTK("CRT6: %d\n", vtotal & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_TOTAL, vtotal & 0xff);
 
 	tmp = 16;		/* LineCompare bit #9 */
@@ -870,19 +870,19 @@ static int cirrusfb_set_par_foo(struct f
 	DPRINTK("CRT9: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_MAX_SCAN, tmp);
 
-	DPRINTK("CRT10: %ld\n", vsyncstart & 0xff);
+	DPRINTK("CRT10: %d\n", vsyncstart & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_START, vsyncstart & 0xff);
 
-	DPRINTK("CRT11: 64+32+%ld\n", vsyncend % 16);
+	DPRINTK("CRT11: 64+32+%d\n", vsyncend % 16);
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, vsyncend % 16 + 64 + 32);
 
-	DPRINTK("CRT12: %ld\n", vdispend & 0xff);
+	DPRINTK("CRT12: %d\n", vdispend & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_DISP_END, vdispend & 0xff);
 
-	DPRINTK("CRT15: %ld\n", (vdispend + 1) & 0xff);
+	DPRINTK("CRT15: %d\n", (vdispend + 1) & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_BLANK_START, (vdispend + 1) & 0xff);
 
-	DPRINTK("CRT16: %ld\n", vtotal & 0xff);
+	DPRINTK("CRT16: %d\n", vtotal & 0xff);
 	vga_wcrt(regbase, VGA_CRTC_V_BLANK_END, vtotal & 0xff);
 
 	DPRINTK("CRT18: 0xff\n");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
neofb-reduce-panning-function.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
cirrusfb-use-modedb-and-add-mode_option-parameter-2nd-rev.patch
cirrusfb-add-__devinit-attribute-to-probing-functions.patch
cirrusfb-eliminate-crt-registers-from-global-structure.patch
cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch
cirrusfb-drop-clock-fields-from-cirrusfb_regs-structure.patch
cirrusfb-add-noaccel-module-parameter.patch
cirrusfb-fix-16bpp-modes.patch
cirrusfb-do-not-change-mclk-for-alpine-chips.patch
atmel_lcdfb-disallow-setting-larger-resolution-than-the-framebuffer-memory-can-handle.patch
vgacon-vgacon_scrolldelta-simplification.patch
fbdev-ignore-vesa-modes-if-framebuffer-does-not-support-them.patch
matroxfb-support-g200ev-chip.patch
fbdev-add-new-tmio-framebuffer-driver.patch

