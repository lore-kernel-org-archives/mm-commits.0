From: akpm@linux-foundation.org
Subject: + fix-build-with-config_no_idle_hz=n.patch added to -mm tree
Date: Tue, 06 Mar 2007 01:26:48 -0800
Message-ID: <200703060926.l269QmXt017907@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030325AbXCFJ1F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 04:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, zach@vmware.com


The patch titled
     fix build with CONFIG_NO_IDLE_HZ=n
has been added to the -mm tree.  Its filename is
     fix-build-with-config_no_idle_hz=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix build with CONFIG_NO_IDLE_HZ=n
From: Andrew Morton <akpm@linux-foundation.org>

arch/i386/kernel/vmi.c: In function 'vmi_safe_halt':
arch/i386/kernel/vmi.c:262: warning: implicit declaration of function 'vmi_stop_hz_timer'
arch/i386/kernel/vmi.c:266: warning: implicit declaration of function 'vmi_account_time_restart_hz_timer'

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/vmi_time.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/asm-i386/vmi_time.h~fix-build-with-config_no_idle_hz=n include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~fix-build-with-config_no_idle_hz=n
+++ a/include/asm-i386/vmi_time.h
@@ -61,6 +61,14 @@ extern void apic_vmi_timer_interrupt(voi
 #ifdef CONFIG_NO_IDLE_HZ
 extern int vmi_stop_hz_timer(void);
 extern void vmi_account_time_restart_hz_timer(void);
+#else
+static inline int vmi_stop_hz_timer(void)
+{
+	return 0;
+}
+static inline void vmi_account_time_restart_hz_timer(void)
+{
+}
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
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
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
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
