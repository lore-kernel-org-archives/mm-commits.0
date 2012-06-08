From: akpm@linux-foundation.org
Subject: [folded] nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch removed from -mm tree
Date: Fri, 08 Jun 2012 14:38:21 -0700
Message-ID: <20120608213821.B84D2A02BF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64536 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508Ab2FHViY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 17:38:24 -0400
Received: by were53 with SMTP id e53so129786wer.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 14:38:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, mingo@elte.hu, msb@chromium.org, rjw@sisk.pl, snanda@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch

This patch was dropped because it was folded into nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -320,7 +320,6 @@ extern int proc_dowatchdog_thresh(struct
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 void lockup_detector_init(void);
-void lockup_detector_bootcpu_resume(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -334,6 +333,11 @@ static inline void touch_all_softlockup_
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
  * On exit from suspend we force an offline->online transition on the boot CPU
  * so that the PMU state that was lost while in suspended state gets set up
@@ -610,6 +611,7 @@ void lockup_detector_bootcpu_resume(void
 	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 }
+#endif
 
 void __init lockup_detector_init(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
nmi-watchdog-quiet-down-the-boot-messages-checkpatch-fixes.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

