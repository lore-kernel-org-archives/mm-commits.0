From: akpm@linux-foundation.org
Subject: + revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch added to -mm tree
Date: Fri, 11 Sep 2009 13:58:16 -0700
Message-ID: <200909112058.n8BKwG4Z014125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918AbZIKU7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Sep 2009 16:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, geert@linux-m68k.org, greg@kroah.com, stable@kernel.org


The patch titled
     Revert "Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct""
has been added to the -mm tree.  Its filename is
     revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Revert "Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct""
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 0753ba01 (mm: revert "oom: move oom_adj value") reverted some
regression patch. but it didn't revert one oom retrieved driver patch.

Then, it made build error to the driver. This reverts commit
a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b too and fixes the build error.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/android/lowmemorykiller.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/staging/android/lowmemorykiller.c~revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -99,21 +99,19 @@ static int lowmem_shrink(int nr_to_scan,
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		if (!p->mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = mm->oom_adj;
+		oom_adj = p->oomkilladj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(mm);
+		tasksize = get_mm_rss(p->mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
revert-staging-android-lowmemorykillerc-fix-it-for-oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
lowmemorykiller-fix-build-error-to-move-oom_adj.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-introduce-page_lru_base_type-fix.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
mm-do-batched-scans-for-mem_cgroup.patch
mm-vmscan-remove-page_queue_congested-comment.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
kcore-use-registerd-physmem-information-ia64-fix.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

