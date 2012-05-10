From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch removed from -mm tree
Date: Thu, 10 May 2012 13:47:32 -0700
Message-ID: <20120510204733.738DDA03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64923 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2EJUrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 May 2012 16:47:36 -0400
Received: by wibhn6 with SMTP id hn6so28736wib.1
        for <mm-commits@vger.kernel.org>; Thu, 10 May 2012 13:47:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() inside CONFIG_GENERIC_PENDING_IRQ
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/x86/kernel/apic/io_apic.c: move io_apic_level_ack_pending() inside CONFIG_GENERIC_PENDING_IRQ

x86_64 allnoconfig:

arch/x86/kernel/apic/io_apic.c:382: warning: 'io_apic_level_ack_pending' defined but not used

Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/io_apic.c |   47 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff -puN arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq arch/x86/kernel/apic/io_apic.c
--- a/arch/x86/kernel/apic/io_apic.c~arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq
+++ a/arch/x86/kernel/apic/io_apic.c
@@ -379,29 +379,6 @@ static void __io_apic_modify(unsigned in
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-		int pin;
-
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin*2);
-		/* Is the remote IRR bit set? */
-		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
-			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-			return true;
-		}
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return false;
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -2552,6 +2529,30 @@ static void ack_apic_edge(struct irq_dat
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
+
+static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		unsigned int reg;
+		int pin;
+
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin*2);
+		/* Is the remote IRR bit set? */
+		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+			return true;
+		}
+	}
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return false;
+}
+
 static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
 {
 	/* If we are moving the irq we need to mask it */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
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
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
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
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
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

