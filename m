From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 09 May 2012 13:38:43 -0700
Message-ID: <20120509203844.86782A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44967 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab2EIUis (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2012 16:38:48 -0400
Received: by wibhj13 with SMTP id hj13so42715wib.1
        for <mm-commits@vger.kernel.org>; Wed, 09 May 2012 13:38:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/ptrace.c     |   14 --------------
 arch/x86/xen/enlighten.c     |    7 -------
 drivers/base/regmap/regmap.c |    5 -----
 drivers/regulator/core.c     |    3 ---
 4 files changed, 29 deletions(-)

diff -puN arch/arm/kernel/ptrace.c~linux-next-git-rejects arch/arm/kernel/ptrace.c
--- a/arch/arm/kernel/ptrace.c~linux-next-git-rejects
+++ a/arch/arm/kernel/ptrace.c
@@ -922,20 +922,6 @@ asmlinkage int syscall_trace(int why, st
 
 	current_thread_info()->syscall = scno;
 
-<<<<<<< HEAD
-	/*
-	 * IP is used to denote syscall entry/exit:
-	 * IP = 0 -> entry, =1 -> exit
-	 */
-	ip = regs->ARM_ip;
-	regs->ARM_ip = why;
-
-	/* the 0x80 provides a way for the tracing parent to distinguish
-	   between a syscall stop and SIGTRAP delivery */
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
-=======
->>>>>>> linux-next/akpm-base
 	/*
 	 * IP is used to denote syscall entry/exit:
 	 * IP = 0 -> entry, =1 -> exit
diff -puN arch/x86/xen/enlighten.c~linux-next-git-rejects arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~linux-next-git-rejects
+++ a/arch/x86/xen/enlighten.c
@@ -885,8 +885,6 @@ static void set_xen_basic_apic_ops(void)
 	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
 	apic->set_apic_id = xen_set_apic_id;
 	apic->get_apic_id = xen_get_apic_id;
-<<<<<<< HEAD
-=======
 
 #ifdef CONFIG_SMP
 	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
@@ -895,7 +893,6 @@ static void set_xen_basic_apic_ops(void)
 	apic->send_IPI_all = xen_send_IPI_all;
 	apic->send_IPI_self = xen_send_IPI_self;
 #endif
->>>>>>> linux-next/akpm-base
 }
 
 #endif
@@ -1410,11 +1407,7 @@ asmlinkage void __init xen_start_kernel(
 
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
-<<<<<<< HEAD
-=======
-
 		xen_acpi_sleep_register();
->>>>>>> linux-next/akpm-base
 	}
 #ifdef CONFIG_PCI
 	/* PCI BIOS service won't work from a PV guest. */
diff -puN drivers/base/regmap/regmap.c~linux-next-git-rejects drivers/base/regmap/regmap.c
--- a/drivers/base/regmap/regmap.c~linux-next-git-rejects
+++ a/drivers/base/regmap/regmap.c
@@ -863,13 +863,8 @@ int regmap_bulk_read(struct regmap *map,
 			map->format.parse_val(val + i);
 	} else {
 		for (i = 0; i < val_count; i++) {
-<<<<<<< HEAD
-			unsigned int ival;
-			ret = regmap_read(map, reg + i, &ival);
-=======
 			ret = regmap_read(map, reg + (i * map->reg_stride),
 					  val + (i * val_bytes));
->>>>>>> linux-next/akpm-base
 			if (ret != 0)
 				return ret;
 			memcpy(val + (i * val_bytes), &ival, val_bytes);
diff -puN drivers/regulator/core.c~linux-next-git-rejects drivers/regulator/core.c
--- a/drivers/regulator/core.c~linux-next-git-rejects
+++ a/drivers/regulator/core.c
@@ -1463,7 +1463,6 @@ void devm_regulator_put(struct regulator
 			    devm_regulator_match, regulator);
 	if (rc == 0)
 		regulator_put(regulator);
-<<<<<<< HEAD
 	else
 		WARN_ON(rc);
 }
@@ -1476,8 +1475,6 @@ static int _regulator_can_change_status(
 
 	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_STATUS)
 		return 1;
-=======
->>>>>>> linux-next/akpm-base
 	else
 		WARN_ON(rc);
 }
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
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

