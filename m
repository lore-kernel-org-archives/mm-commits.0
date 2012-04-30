From: akpm@linux-foundation.org
Subject: + kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:56:27 -0700
Message-ID: <20120430235627.AFA5EA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:46543 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab2D3X43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:56:29 -0400
Received: by ghbz15 with SMTP id z15so404604ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:56:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de


The patch titled
     Subject: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix printks
has been added to the -mm tree.  Its filename is
     kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -566,7 +568,7 @@ int __irq_set_trigger(struct irq_desc *d
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
 		 */
-		pr_debug("genirq: No set_type function for IRQ %d (%s)\n", irq,
+		pr_debug("No set_type function for IRQ %d (%s)\n", irq,
 			 chip ? (chip->name ? : "unknown") : "unknown");
 		return 0;
 	}
@@ -601,7 +603,7 @@ int __irq_set_trigger(struct irq_desc *d
 		ret = 0;
 		break;
 	default:
-		pr_err("genirq: Setting trigger mode %lu for irq %u failed (%pF)\n",
+		pr_err("Setting trigger mode %lu for irq %u failed (%pF)\n",
 		       flags, irq, chip->irq_set_type);
 	}
 	if (unmask)
@@ -785,7 +787,7 @@ static void irq_thread_dtor(struct task_
 
 	action = kthread_data(tsk);
 
-	pr_err("genirq: exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
+	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
 
 
@@ -1042,7 +1044,7 @@ __setup_irq(unsigned int irq, struct irq
 		 * has. The type flags are unreliable as the
 		 * underlying chip implementation can override them.
 		 */
-		pr_err("genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
+		pr_err("Threaded irq requested with handler=NULL and !ONESHOT for irq %d\n",
 		       irq);
 		ret = -EINVAL;
 		goto out_mask;
@@ -1093,7 +1095,7 @@ __setup_irq(unsigned int irq, struct irq
 
 		if (nmsk != omsk)
 			/* hope the handler works with current  trigger mode */
-			pr_warning("genirq: irq %d uses trigger mode %u; requested %u\n",
+			pr_warning("irq %d uses trigger mode %u; requested %u\n",
 				   irq, nmsk, omsk);
 	}
 
@@ -1131,7 +1133,7 @@ __setup_irq(unsigned int irq, struct irq
 
 mismatch:
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
-		pr_err("genirq: Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
+		pr_err("Flags mismatch irq %d. %08x (%s) vs. %08x (%s)\n",
 		       irq, new->flags, new->name, old->flags, old->name);
 #ifdef CONFIG_DEBUG_SHIRQ
 		dump_stack();
_
Subject: Subject: kernel/irq/manage.c: use the pr_foo() infrastructure to prefix printks

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

