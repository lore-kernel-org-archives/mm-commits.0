From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-introduce-oom-reaper-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 11 Jan 2016 14:47:41 -0800
Message-ID: <5694310d.SO7VRR5LoD7gm3Li%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708AbcAKWrm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 17:47:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-oom-introduce-oom-reaper-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-oom-introduce-oom-reaper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-introduce-oom-reaper-checkpatch-fixes

Cc: Mel Gorman <mgorman@suse.de>

WARNING: line over 80 characters
#124: FILE: mm/memory.c:1107:
+					/* oom_reaper cannot tear down dirty pages */

WARNING: line over 80 characters
#125: FILE: mm/memory.c:1108:
+					if (unlikely(details && details->ignore_dirty))

WARNING: line over 80 characters
#245: FILE: mm/oom_kill.c:483:
+		wait_event_freezable(oom_reaper_wait, (mm = READ_ONCE(mm_to_reap)));

WARNING: Missing a blank line after declarations
#245: FILE: mm/oom_kill.c:483:
+		struct mm_struct *mm;
+		wait_event_freezable(oom_reaper_wait, (mm = READ_ONCE(mm_to_reap)));

WARNING: line over 80 characters
#301: FILE: mm/oom_kill.c:721:
+			 * We cannot use oom_reaper for the mm shared by this process

WARNING: line over 80 characters
#302: FILE: mm/oom_kill.c:722:
+			 * because it wouldn't get killed and so the memory might be

total: 0 errors, 6 warnings, 228 lines checked

./patches/mm-oom-introduce-oom-reaper.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    5 ++++-
 mm/oom_kill.c |   10 ++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-oom-introduce-oom-reaper-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-oom-introduce-oom-reaper-checkpatch-fixes
+++ a/mm/memory.c
@@ -1105,7 +1105,10 @@ again:
 
 			if (!PageAnon(page)) {
 				if (pte_dirty(ptent)) {
-					/* oom_reaper cannot tear down dirty pages */
+					/*
+					 * oom_reaper cannot tear down dirty
+					 * pages
+					 */
 					if (unlikely(details && details->ignore_dirty))
 						continue;
 					force_flush = 1;
diff -puN mm/oom_kill.c~mm-oom-introduce-oom-reaper-checkpatch-fixes mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-oom-reaper-checkpatch-fixes
+++ a/mm/oom_kill.c
@@ -481,7 +481,9 @@ static int oom_reaper(void *unused)
 {
 	while (true) {
 		struct mm_struct *mm;
-		wait_event_freezable(oom_reaper_wait, (mm = READ_ONCE(mm_to_reap)));
+
+		wait_event_freezable(oom_reaper_wait,
+				     (mm = READ_ONCE(mm_to_reap)));
 		oom_reap_vmas(mm);
 		WRITE_ONCE(mm_to_reap, NULL);
 	}
@@ -719,9 +721,9 @@ void oom_kill_process(struct oom_control
 		if (unlikely(p->flags & PF_KTHREAD) ||
 		    p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
 			/*
-			 * We cannot use oom_reaper for the mm shared by this process
-			 * because it wouldn't get killed and so the memory might be
-			 * still used.
+			 * We cannot use oom_reaper for the mm shared by this
+			 * process because it wouldn't get killed and so the
+			 * memory might be still used.
 			 */
 			can_oom_reap = false;
 			continue;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-fix-3.patch
mm-oom-introduce-oom-reaper-fix-4-fix.patch
mm-oom-introduce-oom-reaper-fix-5-fix.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

