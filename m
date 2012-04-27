From: akpm@linux-foundation.org
Subject: + nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch added to -mm tree
Date: Fri, 27 Apr 2012 14:13:24 -0700
Message-ID: <20120427211325.11FFDA042D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48992 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2D0VN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 17:13:27 -0400
Received: by wgbdt11 with SMTP id dt11so63291wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 14:13:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, snanda@chromium.org


The patch titled
     Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
has been added to the -mm tree.  Its filename is
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch

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
Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix

make lockup_detector_bootcpu_resume() conditional on CONFIG_SUSPEND

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sameer Nanda <snanda@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 +++++-
 kernel/watchdog.c     |    2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix include/linux/sched.h
--- a/include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
+++ a/include/linux/sched.h
@@ -317,7 +317,6 @@ extern int proc_dowatchdog_thresh(struct
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 void lockup_detector_init(void);
-void lockup_detector_bootcpu_resume(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -331,6 +330,11 @@ static inline void touch_all_softlockup_
 static inline void lockup_detector_init(void)
 {
 }
+#endif
+
+#if defined(CONFIG_LOCKUP_DETECTOR) && defined(CONFIG_SUSPEND)
+void lockup_detector_bootcpu_resume(void);
+#else
 static inline void lockup_detector_bootcpu_resume(void)
 {
 }
diff -puN kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix kernel/watchdog.c
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
+++ a/kernel/watchdog.c
@@ -597,6 +597,7 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
+#ifdef CONFIG_SUSPEND
 /*
  * On entry to suspend we force an offline->online transition on the boot CPU so
  * that PMU state is available to that CPU when it comes back online after
@@ -609,6 +610,7 @@ void lockup_detector_bootcpu_resume(void
 	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 }
+#endif
 
 void __init lockup_detector_init(void)
 {
_
Subject: Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
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
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
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
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

