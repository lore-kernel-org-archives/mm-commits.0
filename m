From: akpm@linux-foundation.org
Subject: + highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch added to -mm tree
Date: Mon, 05 Mar 2007 21:57:25 -0800
Message-ID: <200703060557.l265vPUS013823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965784AbXCFF5k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 00:57:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix
has been added to the -mm tree.  Its filename is
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix kernel/hrtimer.c
--- a/kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix
+++ a/kernel/hrtimer.c
@@ -1131,7 +1131,9 @@ static inline void run_hrtimer_queue(str
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
+#ifdef CONFIG_HIGH_RES_TIMERS
 		WARN_ON_ONCE(timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
+#endif
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
