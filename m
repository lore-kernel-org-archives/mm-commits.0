From: akpm@linux-foundation.org
Subject: [folded] smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:30:47 -0700
Message-ID: <20120328213047.CE69EA0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39525 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1Vau (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:30:50 -0400
Received: by wibhj13 with SMTP id hj13so81438wib.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:30:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gilad@benyossef.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
has been removed from the -mm tree.  Its filename was
     smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch

This patch was dropped because it was folded into smp-add-func-to-ipi-cpus-based-on-parameter-func.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-fix

s/gfpflags/gfp_flags/

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |   20 ++++++++++----------
 kernel/smp.c        |    8 ++++----
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix include/linux/smp.h
--- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
+++ a/include/linux/smp.h
@@ -115,7 +115,7 @@ void on_each_cpu_mask(const struct cpuma
  */
 void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
-		gfp_t gfpflags);
+		gfp_t gfp_flags);
 
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
@@ -162,15 +162,15 @@ static inline int up_smp_call_function(s
 			local_irq_enable();		\
 		}					\
 	} while (0)
-#define on_each_cpu_cond(cond_func, func, info, wait, gfpflags) \
-	do {						\
-		preempt_disable();			\
-		if (cond_func(0, info)) {		\
-			local_irq_disable();		\
-			(func)(info);			\
-			local_irq_enable();		\
-		}					\
-		preempt_enable();			\
+#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
+	do {							\
+		preempt_disable();				\
+		if (cond_func(0, info)) {			\
+			local_irq_disable();			\
+			(func)(info);				\
+			local_irq_enable();			\
+		}						\
+		preempt_enable();				\
 	} while (0)
 
 static inline void smp_send_reschedule(int cpu) { }
diff -puN kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix kernel/smp.c
--- a/kernel/smp.c~smp-add-func-to-ipi-cpus-based-on-parameter-func-fix
+++ a/kernel/smp.c
@@ -746,7 +746,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * @info:	An arbitrary pointer to pass to both functions.
  * @wait:	If true, wait (atomically) until function has
  *		completed on other CPUs.
- * @gfpflags:	GFP flags to use when allocating the cpumask
+ * @gfp_flags:	GFP flags to use when allocating the cpumask
  *		used internally by the function.
  *
  * The function might sleep if the GFP flags indicates a non
@@ -757,14 +757,14 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  */
 void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 			smp_call_func_t func, void *info, bool wait,
-			gfp_t gfpflags)
+			gfp_t gfp_flags)
 {
 	cpumask_var_t cpus;
 	int cpu, ret;
 
-	might_sleep_if(gfpflags & __GFP_WAIT);
+	might_sleep_if(gfp_flags & __GFP_WAIT);
 
-	if (likely(zalloc_cpumask_var(&cpus, (gfpflags|__GFP_NOWARN)))) {
+	if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
 		preempt_disable();
 		for_each_online_cpu(cpu)
 			if (cond_func(cpu, info))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

