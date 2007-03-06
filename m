From: akpm@linux-foundation.org
Subject: - speedup-divides-by-cpu_power-in-scheduler-up-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:18:23 -0800
Message-ID: <200703060118.l261IP7i007430@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751AbXCFBTx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:19:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dada1@cosmosbay.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     speedup-divides-by-cpu_power-in-scheduler-up-fix
has been removed from the -mm tree.  Its filename was
     speedup-divides-by-cpu_power-in-scheduler-up-fix.patch

This patch was dropped because it was folded into speedup-divides-by-cpu_power-in-scheduler.patch

------------------------------------------------------
Subject: speedup-divides-by-cpu_power-in-scheduler-up-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/sched.c:189: warning: 'struct sched_group' declared inside parameter list
kernel/sched.c:189: warning: its scope is only this definition or declaration, which is probably not what you want
kernel/sched.c: In function 'sg_div_cpu_power':
kernel/sched.c:191: error: dereferencing pointer to incomplete type
kernel/sched.c: At top level:
kernel/sched.c:198: warning: 'struct sched_group' declared inside parameter list
kernel/sched.c: In function 'sg_inc_cpu_power':
kernel/sched.c:200: error: dereferencing pointer to incomplete type
kernel/sched.c:201: error: dereferencing pointer to incomplete type
kernel/sched.c:201: error: dereferencing pointer to incomplete type

Please see Documentation/SubmitChecklist?

Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched.c~speedup-divides-by-cpu_power-in-scheduler-up-fix kernel/sched.c
--- a/kernel/sched.c~speedup-divides-by-cpu_power-in-scheduler-up-fix
+++ a/kernel/sched.c
@@ -182,6 +182,7 @@ static unsigned int static_prio_timeslic
 		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
 }
 
+#ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
  * Since cpu_power is a 'constant', we can use a reciprocal divide.
@@ -200,6 +201,7 @@ static inline void sg_inc_cpu_power(stru
 	sg->__cpu_power += val;
 	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
 }
+#endif
 
 /*
  * task_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
