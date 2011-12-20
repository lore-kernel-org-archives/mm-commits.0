From: akpm@linux-foundation.org
Subject: [folded] cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch removed from -mm tree
Date: Mon, 19 Dec 2011 17:07:55 -0800
Message-ID: <20111220010755.E284F10005D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:40807 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1LTBH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2011 20:07:57 -0500
Received: by ggnv2 with SMTP id v2so788532ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2011 17:07:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com, paul@paulmenage.org, rientjes@google.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix
has been removed from the -mm tree.  Its filename was
     cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch

This patch was dropped because it was folded into cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix

Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   13 +++++++++++++
 mm/mempolicy.c  |   12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff -puN kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix
+++ a/kernel/cpuset.c
@@ -123,6 +123,19 @@ static inline struct cpuset *task_cs(str
 			    struct cpuset, css);
 }
 
+#ifdef CONFIG_NUMA
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return task->mempolicy;
+}
+#else
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return false;
+}
+#endif
+
+
 /* bits in struct cpuset flags field */
 typedef enum {
 	CS_CPU_EXCLUSIVE,
diff -puN mm/mempolicy.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix mm/mempolicy.c
--- a/mm/mempolicy.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix
+++ a/mm/mempolicy.c
@@ -137,18 +137,6 @@ static const struct mempolicy_operations
 			enum mpol_rebind_step step);
 } mpol_ops[MPOL_MAX];
 
-#ifdef CONFIG_NUMA
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return task->mempolicy;
-}
-#else
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return false;
-}
-#endif
-
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(const nodemask_t *nodemask)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller-fix.patch
leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

