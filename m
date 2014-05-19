From: akpm@linux-foundation.org
Subject: +
 vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch added to
 -mm tree
Date: Mon, 19 May 2014 14:27:51 -0700
Message-ID: <537a7757.bOwSX/i3+qm0X33X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaESV1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 17:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz

Subject: + vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch added to -mm tree
To: mhocko@suse.cz,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,klamm@yandex-team.ru,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 14:27:51 -0700


The patch titled
     Subject: vmscan: memcg: check whether the low limit should be ignored
has been added to the -mm tree.  Its filename is
     vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmscan: memcg: check whether the low limit should be ignored

Low-limit (aka guarantee) is ignored when there is no group scanned during
the first round of __shink_zone.  This approach doesn't work when multiple
reclaimers race and reclaim the same hierarchy (e.g.  kswapd vs.  direct
reclaim or multiple tasks hitting the hard limit) because memcg iterator
makes sure that multiple reclaimers are interleaved in the hierarchy. 
This means that some reclaimers can see 0 scanned groups although there
are groups which are above the low-limit and they were reclaimed on behalf
of other reclaimers.  This leads to a premature low-limit break.

This patch adds mem_cgroup_all_within_guarantee() which will check whether
all the groups in the reclaimed hierarchy are within their low limit and
shrink_zone will allow the fallback reclaim only when that is true.  This
alone is still not sufficient however because it would lead to another
problem.  If a reclaimer constantly fails to scan anything because it sees
only groups within their guarantees while others do the reclaim then the
reclaim priority would drop down very quickly.  shrink_zone has to be
careful to preserve scan at least one group semantic so __shrink_zone has
to be retried until at least one group is scanned.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 mm/memcontrol.c            |   13 +++++++++++++
 mm/vmscan.c                |   17 ++++++++++++-----
 3 files changed, 30 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-memcg-check-whether-the-low-limit-should-be-ignored include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-memcg-check-whether-the-low-limit-should-be-ignored
+++ a/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ bool task_in_mem_cgroup(struct task_stru
 
 extern bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
+extern bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
@@ -296,6 +297,10 @@ static inline bool mem_cgroup_within_gua
 {
 	return false;
 }
+static inline bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
+{
+	return false;
+}
 
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
diff -puN mm/memcontrol.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored
+++ a/mm/memcontrol.c
@@ -2821,6 +2821,19 @@ bool mem_cgroup_within_guarantee(struct
 	return false;
 }
 
+bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, root)
+		if (!mem_cgroup_within_guarantee(iter, root)) {
+			mem_cgroup_iter_break(root, iter);
+			return false;
+		}
+
+	return true;
+}
+
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg = NULL;
diff -puN mm/vmscan.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored mm/vmscan.c
--- a/mm/vmscan.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored
+++ a/mm/vmscan.c
@@ -2311,13 +2311,20 @@ static unsigned __shrink_zone(struct zon
 
 static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
-	if (!__shrink_zone(zone, sc, true)) {
+	bool honor_guarantee = true;
+
+	while (!__shrink_zone(zone, sc, honor_guarantee)) {
 		/*
-		 * First round of reclaim didn't find anything to reclaim
-		 * because of the memory guantees for all memcgs in the
-		 * reclaim target so try again and ignore guarantees this time.
+		 * The previous round of reclaim didn't find anything to scan
+		 * because
+		 * a) the whole reclaimed hierarchy is within guarantee so
+		 *    we fallback to ignore the guarantee because other option
+		 *    would be the OOM
+		 * b) multiple reclaimers are racing and so the first round
+		 *    should be retried
 		 */
-		__shrink_zone(zone, sc, false);
+		if (mem_cgroup_all_within_guarantee(sc->target_mem_cgroup))
+			honor_guarantee = false;
 	}
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

memcg-fix-swapcache-charge-from-kernel-thread-context.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

