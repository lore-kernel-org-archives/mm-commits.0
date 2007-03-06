From: akpm@linux-foundation.org
Subject: - x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:52:37 -0800
Message-ID: <200703061052.l26Aqb6s020323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35254 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964875AbXCFKwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:52:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, ebiederm@xmission.com, mingo@elte.hu, yinghai.lu@amd.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy
has been removed from the -mm tree.  Its filename was
     x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch

This patch was dropped because it was folded into x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch

------------------------------------------------------
Subject: x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai.lu@amd.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy
+++ a/arch/x86_64/kernel/io_apic.c
@@ -681,17 +681,14 @@ static int __assign_irq_vector(int irq, 
 			domain = vector_allocation_domain(cpu);
 			if (cpus_equal(domain, cfg->domain)) {
 #ifdef CONFIG_SMP
-				/* we don't need lock for desc here
-				   for apic_flat can not be used with CONFIG_HOTPLUG_CPU
-				   others only have one cpu set in domain or affinity
+				/*
+				 * We don't need lock for desc here for
+				 * apic_flat can not be used with
+				 * CONFIG_HOTPLUG_CPU others only have one cpu
+				 * set in domain or affinity
 				 */
-				int equal;
-				struct irq_desc *desc;
-				desc = irq_desc + irq;
-				equal = cpus_equal(tmp, desc->affinity);
-				if (equal) {
+				if (cpus_equal(tmp, irq_desc[irq].affinity))
 					return 0;
-				}
 #else
 				return 0;
 #endif
@@ -745,8 +742,6 @@ next:
 		return 0;
 	}
 	return -ENOSPC;
-
-
 }
 
 static int assign_irq_vector(int irq, cpumask_t mask)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
git-input.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume.patch
sis900-warning-fixes.patch
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
