From: akpm@linux-foundation.org
Subject: + cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch added to -mm tree
Date: Fri, 05 Sep 2008 14:55:42 -0700
Message-ID: <200809052155.m85LtgqG022240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbYIEV4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 17:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: fix up debug printk types
has been added to the -mm tree.  Its filename is
     cirrusfb-eliminate-crt-registers-from-global-structure-fix-up-debug-printk-types.patch

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
atmel_lcdfb-fix-oops-in-rmmod-when-framebuffer-fails-to-register.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
sched-fix-compilation-with-gcc-346.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
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

