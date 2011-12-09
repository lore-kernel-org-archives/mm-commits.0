From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fixup.patch removed from -mm tree
Date: Fri, 09 Dec 2011 11:56:27 -0800
Message-ID: <201112091956.pB9JuSwQ002595@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bw0-f74.google.com ([209.85.214.74]:42753 "EHLO
	mail-bw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LIT4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 14:56:32 -0500
Received: by bkas6 with SMTP id s6so69193bka.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 11:56:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-fixup
has been removed from the -mm tree.  Its filename was
     linux-next-fixup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-fixup

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN fs/proc/stat.c~linux-next-fixup fs/proc/stat.c
--- a/fs/proc/stat.c~linux-next-fixup
+++ a/fs/proc/stat.c
@@ -22,29 +22,27 @@
 #define arch_idle_time(cpu) 0
 #endif
 
-static cputime64_t get_idle_time(int cpu)
+static u64 get_idle_time(int cpu)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
-	cputime64_t idle;
+	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL) {
 		/* !NO_HZ so we can rely on cpustat.idle */
-		idle = kstat_cpu(cpu).cpustat.idle;
-		idle = cputime64_add(idle, arch_idle_time(cpu));
+		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+		idle += arch_idle_time(cpu);
 	} else
 		idle = nsecs_to_jiffies64(1000 * idle_time);
 
 	return idle;
 }
 
-static cputime64_t get_iowait_time(int cpu)
+static u64 get_iowait_time(int cpu)
 {
-	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
-	cputime64_t iowait;
+	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ so we can rely on cpustat.iowait */
-		iowait = kstat_cpu(cpu).cpustat.iowait;
+		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
 		iowait = nsecs_to_jiffies64(1000 * iowait_time);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
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
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
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
selftests-new-very-basic-kernel-selftests-directory.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

