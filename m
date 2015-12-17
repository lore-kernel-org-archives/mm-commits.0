From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-oom-reaper-checkpatch-fixes.patch added to -mm tree
Date: Wed, 16 Dec 2015 16:51:02 -0800
Message-ID: <567206f6.Eqz8Q76uH8KAUG16%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbbLQAvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2015 19:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-introduce-oom-reaper-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-oom-reaper-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-oom-reaper-checkpatch-fixes.patch

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
@@ -1104,7 +1104,10 @@ again:
 
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
@@ -480,7 +480,9 @@ static int oom_reaper(void *unused)
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
@@ -718,9 +720,9 @@ void oom_kill_process(struct oom_control
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
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-printk-introduce-new-format-string-for-flags-fix-2.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mm-oom-introduce-oom-reaper-checkpatch-fixes.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
include-linux-propertyh-fix-build-issues-with-gcc-444.patch
include-linux-propertyh-fix-build-issues-with-gcc-444-fix.patch
fs-overlayfs-superc-needs-pagemaph.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

