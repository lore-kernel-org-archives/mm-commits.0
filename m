From: akpm@linux-foundation.org
Subject: [merged] kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:01 -0700
Message-ID: <20120601193301.5E5FFA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58299 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2FATdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:02 -0400
Received: by ggeh3 with SMTP id h3so246003gge.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix printks
has been removed from the -mm tree.  Its filename was
     kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix printks

Use the module-wide pr_fmt() mechanism rather than open-coding "genirq: "
everywhere.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN kernel/irq/manage.c~kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks kernel/irq/manage.c
--- a/kernel/irq/manage.c~kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks
+++ a/kernel/irq/manage.c
@@ -7,6 +7,8 @@
  * This file contains driver APIs to the irq subsystem.
  */
 
+#define pr_fmt(fmt) "genirq: " fmt
+
 #include <linux/irq.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
@@ -565,7 +567,7 @@ int __irq_set_trigger(struct irq_desc *d
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
 		 */
-		pr_debug("genirq: No set_type function for IRQ %d (%s)\n", irq,
+		pr_debug("No set_type function for IRQ %d (%s)\n", irq,
 			 chip ? (chip->name ? : "unknown") : "unknown");
 		return 0;
 	}
@@ -600,7 +602,7 @@ int __irq_set_trigger(struct irq_desc *d
 		ret = 0;
 		break;
 	default:
-		pr_err("genirq: Setting trigger mode %lu for irq %u failed (%pF)\n",
+		pr_err("Setting trigger mode %lu for irq %u failed (%pF)\n",
 		       flags, irq, chip->irq_set_type);
 	}
 	if (unmask)
@@ -837,7 +839,7 @@ void exit_irq_thread(void)
 
 	action = kthread_data(tsk);
 
-	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
+	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
 	desc = irq_to_desc(action->irq);
@@ -1044,7 +1046,7 @@ __setup_irq(unsigned int irq, struct irq
 		 * has. The type flags are unreliable as the
 		 * underlying chip implementation can override them.
 		 */
-		pr_err("genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
+		pr_err("Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
 		       irq);
 		ret = -EINVAL;
 		goto out_mask;
@@ -1095,7 +1097,7 @@ __setup_irq(unsigned int irq, struct irq
 
 		if (nmsk != omsk)
 			/* hope the handler works with current  trigger mode */
-			pr_warning("genirq: irq %d uses trigger mode %u; requested %u\n",
+			pr_warning("irq %d uses trigger mode %u; requested %u\n",
 				   irq, nmsk, omsk);
 	}
 
@@ -1133,7 +1135,7 @@ __setup_irq(unsigned int irq, struct irq
 
 mismatch:
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
-		pr_err("genirq: Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
+		pr_err("Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
 		       irq, new->flags, new->name, old->flags, old->name);
 #ifdef CONFIG_DEBUG_SHIRQ
 		dump_stack();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
tmpfs-implement-numa-node-interleaving-fix.patch
tmpfs-implement-numa-node-interleaving-checkpatch-fixes.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
pidns-make-killed-children-autoreap.patch
fs-nls-add-apple-nls.patch
eventfd-change-int-to-__u64-in-eventfd_signal.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

