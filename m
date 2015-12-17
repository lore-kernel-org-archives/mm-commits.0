From: akpm@linux-foundation.org
Subject: + mm-oom-rework-oom-detection-checkpatch-fixes.patch added to -mm tree
Date: Wed, 16 Dec 2015 16:50:55 -0800
Message-ID: <567206ef.s2hGKzgrw5reZe9D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbbLQAu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2015 19:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-rework-oom-detection-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-oom-rework-oom-detection-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-rework-oom-detection-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-rework-oom-detection-checkpatch-fixes.patch

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
Subject: mm-oom-rework-oom-detection-checkpatch-fixes

Cc: David Rientjes <rientjes@google.com>

WARNING: line over 80 characters
#99: FILE: mm/page_alloc.c:2965:
+ * zone list (with a backoff mechanism which is a function of no_progress_loops).

WARNING: line over 80 characters
#129: FILE: mm/page_alloc.c:2995:
+	 * Keep reclaiming pages while there is a chance this will lead somewhere.

WARNING: line over 80 characters
#134: FILE: mm/page_alloc.c:3000:
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx, ac->nodemask) {

WARNING: line over 80 characters
#138: FILE: mm/page_alloc.c:3004:
+		available -= DIV_ROUND_UP(no_progress_loops * available, MAX_RECLAIM_RETRIES);

WARNING: line over 80 characters
#142: FILE: mm/page_alloc.c:3008:
+		 * Would the allocation succeed if we reclaimed the whole available?

WARNING: line over 80 characters
#146: FILE: mm/page_alloc.c:3012:
+			/* Wait for some write requests to complete then retry */

total: 0 errors, 6 warnings, 202 lines checked

./patches/mm-oom-rework-oom-detection.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-oom-rework-oom-detection-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-rework-oom-detection-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3005,7 +3005,8 @@ static inline bool is_thp_gfp_mask(gfp_t
  * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
  * pages) and no_progress_loops (number of reclaim rounds without any progress
  * in a row) is considered as well as the reclaimable pages on the applicable
- * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ * zone list (with a backoff mechanism which is a function of
+ * no_progress_loops).
  *
  * Returns true if a retry is viable or false to enter the oom path.
  */
@@ -3035,24 +3036,27 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	}
 
 	/*
-	 * Keep reclaiming pages while there is a chance this will lead somewhere.
-	 * If none of the target zones can satisfy our allocation request even
-	 * if all reclaimable pages are considered then we are screwed and have
-	 * to go OOM.
+	 * Keep reclaiming pages while there is a chance this will lead
+	 * somewhere.  If none of the target zones can satisfy our allocation
+	 * request even if all reclaimable pages are considered then we are
+	 * screwed and have to go OOM.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx, ac->nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+			ac->high_zoneidx, ac->nodemask) {
 		unsigned long available;
 
 		available = zone_reclaimable_pages(zone);
-		available -= DIV_ROUND_UP(no_progress_loops * available, MAX_RECLAIM_RETRIES);
+		available -= DIV_ROUND_UP(no_progress_loops * available,
+					  MAX_RECLAIM_RETRIES);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 
 		/*
-		 * Would the allocation succeed if we reclaimed the whole available?
+		 * Would the allocation succeed if we reclaimed the whole
+		 * available?
 		 */
 		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
 				ac->high_zoneidx, alloc_flags, available)) {
-			/* Wait for some write requests to complete then retry */
+			/* Wait for some writes to complete then retry */
 			wait_iff_congested(zone, BLK_RW_ASYNC, HZ/50);
 			return true;
 		}
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

