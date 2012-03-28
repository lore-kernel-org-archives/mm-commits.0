From: akpm@linux-foundation.org
Subject: [folded] smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch removed from -mm tree
Date: Wed, 28 Mar 2012 14:30:52 -0700
Message-ID: <20120328213052.B0233A0496@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34776 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2C1Vax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 17:30:53 -0400
Received: by ggnd2 with SMTP id d2so191681ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 14:30:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gilad@benyossef.com, mina86@mina86.com, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
has been removed from the -mm tree.  Its filename was
     smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch

This patch was dropped because it was folded into smp-add-func-to-ipi-cpus-based-on-parameter-func.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix

- avoid double-evaluation of `info' (per Michal)
- parenthesise evaluation of `cond_func'

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix include/linux/smp.h
--- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
+++ a/include/linux/smp.h
@@ -168,10 +168,11 @@ static inline int up_smp_call_function(s
  */
 #define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
 	do {							\
+		void *__info = (info);				\
 		preempt_disable();				\
-		if (cond_func(0, info)) {			\
+		if ((cond_func)(0, __info)) {			\
 			local_irq_disable();			\
-			(func)(info);				\
+			(func)(__info);				\
 			local_irq_enable();			\
 		}						\
 		preempt_enable();				\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
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

