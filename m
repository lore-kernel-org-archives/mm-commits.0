From: akpm@linux-foundation.org
Subject: [folded] tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix.patch removed from -mm tree
Date: Thu, 01 Dec 2011 14:32:02 -0800
Message-ID: <201112012232.pB1MW2Cw004284@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47359 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab1LAWcH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 17:32:07 -0500
Received: by eekd41 with SMTP id d41so21065eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 14:32:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, john.stultz@linaro.org, sivanich@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix
has been removed from the -mm tree.  Its filename was
     tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix.patch

This patch was dropped because it was folded into tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix

remove unneeded check against NR_CPUS

Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode-fix
+++ a/kernel/time/tick-sched.c
@@ -856,7 +856,7 @@ static ssize_t sysfs_store_do_timer_cpu(
 	if (rv)
 		return rv;
 
-	if (new >= NR_CPUS || !cpu_online(new))
+	if (!cpu_online(new))
 		return -ERANGE;
 
 	*(unsigned int *)(ea->var) = new;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

