From: akpm@linux-foundation.org
Subject: + x86-delay-early-cpu-initialization-until-cpuid-is-done.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:12:38 -0700
Message-ID: <200809022312.m82NCcS9017731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbYIBXNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, mingo@elte.hu, rct@gherkin.frus.com, tglx@linutronix.de, yhlu.kernel@gmail.com


The patch titled
     x86: delay early cpu initialization until cpuid is done
has been added to the -mm tree.  Its filename is
     x86-delay-early-cpu-initialization-until-cpuid-is-done.patch

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
Subject: x86: delay early cpu initialization until cpuid is done
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Move early cpu initialization after cpu early get cap so the early cpu
initialization can fix up cpu caps.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bob Tracy <rct@gherkin.frus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~x86-delay-early-cpu-initialization-until-cpuid-is-done arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~x86-delay-early-cpu-initialization-until-cpuid-is-done
+++ a/arch/x86/kernel/cpu/common.c
@@ -353,11 +353,11 @@ static void __init early_cpu_detect(void
 
 	get_cpu_vendor(c, 1);
 
+	early_get_cap(c);
+
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
-
-	early_get_cap(c);
 }
 
 /*
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

cirrusfb-check_par-fixes.patch
tdfxfb-fix-sdram-memory-size-detection.patch
tdfxfb-fix-frame-buffer-name-overrun.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
x86-delay-early-cpu-initialization-until-cpuid-is-done.patch
x86-move-mtrr-cpu-cap-setting-early-in-early_init_xxxx.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch
intelfb-support-945gme-as-used-in-asus-eee-901.patch

