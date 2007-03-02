From: akpm@linux-foundation.org
Subject: + speedup-divides-by-cpu_power-in-scheduler-up-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 21:59:28 -0800
Message-ID: <200703020601.l2261381001792@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44247 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422930AbXCBGCV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 01:02:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dada1@cosmosbay.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     speedup-divides-by-cpu_power-in-scheduler-up-fix
has been added to the -mm tree.  Its filename is
     speedup-divides-by-cpu_power-in-scheduler-up-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
