From: akpm@linux-foundation.org
Subject: - fix-build-with-config_no_idle_hz=n.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:20:49 -0800
Message-ID: <200703070420.l274KoHs018841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161287AbXCGEVJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     fix build with CONFIG_NO_IDLE_HZ=n
has been removed from the -mm tree.  Its filename was
     fix-build-with-config_no_idle_hz=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
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
