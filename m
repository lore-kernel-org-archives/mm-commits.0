From: akpm@linux-foundation.org
Subject: + pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch added to -mm tree
Date: Tue, 22 May 2012 12:24:18 -0700
Message-ID: <20120522192418.EAE7CA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39039 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2EVTYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 15:24:19 -0400
Received: by mail-gg0-f202.google.com with SMTP id h3so782187gge.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 12:24:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix
has been added to the -mm tree.  Its filename is
     pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch

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
Subject: pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix

tweak a few things, might be wrong, also insufficient!

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c          |    5 +++--
 kernel/pid_namespace.c |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix kernel/exit.c
--- a/kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix
+++ a/kernel/exit.c
@@ -74,8 +74,9 @@ static void __unhash_process(struct task
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
 
-		/* If we are the last child process in a pid namespace
-		 * to be reaped notify the child_reaper.
+		/*
+		 * If we are the last child process in a pid namespace to be
+		 * reaped, notify the child_reaper.
 		 */
 		parent = p->real_parent;
 		if ((task_active_pid_ns(p)->child_reaper == parent) &&
diff -puN kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix
+++ a/kernel/pid_namespace.c
@@ -199,6 +199,7 @@ void zap_pid_ns_processes(struct pid_nam
 		read_lock(&tasklist_lock);
 	}
 	read_unlock(&tasklist_lock);
+	set_current_state(TASK_RUNNING);
 
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
_
Subject: Subject: pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation-fix.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch
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
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-page_allocc-cleanups.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
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
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
fs-nls-add-apple-nls-fix.patch
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

