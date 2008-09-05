From: akpm@linux-foundation.org
Subject: + cirrusfb-fix-16bpp-modes.patch added to -mm tree
Date: Fri, 05 Sep 2008 14:55:57 -0700
Message-ID: <200809052155.m85Ltv6T022249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbYIEV43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2008 17:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: fix 16bpp modes
has been added to the -mm tree.  Its filename is
     cirrusfb-fix-16bpp-modes.patch

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
Subject: cirrusfb: fix 16bpp modes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The 16bpp mode did not work on the Cirrus cards as the visual type was set
to DIRECTCOLOR instead of TRUECOLOR.  The Alpine family used one incorrect
register setting so this 16bpp modes generated wrong horizontal frequency.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-16bpp-modes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-16bpp-modes
+++ a/drivers/video/cirrusfb.c
@@ -657,7 +657,7 @@ static int cirrusfb_decode_var(const str
 	case 16:
 	case 32:
 		info->fix.line_length = var->xres_virtual * maxclockidx;
-		info->fix.visual = FB_VISUAL_DIRECTCOLOR;
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
 		break;
 
 	default:
@@ -1178,10 +1178,7 @@ static int cirrusfb_set_par_foo(struct f
 
 		case BT_ALPINE:
 			DPRINTK(" (for GD543x)\n");
-			if (var->xres >= 1024)
-				vga_wseq(regbase, CL_SEQR7, 0xa7);
-			else
-				vga_wseq(regbase, CL_SEQR7, 0xa3);
+			vga_wseq(regbase, CL_SEQR7, 0xa7);
 			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			break;
 
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

