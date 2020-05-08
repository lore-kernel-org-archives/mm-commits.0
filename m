From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
 added to -mm tree
Date: Fri, 08 May 2020 16:19:32 -0700
Message-ID: <20200508231932.szx9Y2EUn%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXTe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:19:34 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: move out cgroup swaprate throttling
has been added to the -mm tree.  Its filename is
     mm-memcontrol-move-out-cgroup-swaprate-throttling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-move-out-cgroup-swaprate-throttling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: move out cgroup swaprate throttling

The cgroup swaprate throttling is about matching new anon allocations to
the rate of available IO when that is being throttled.  It's the io
controller hooking into the VM, rather than a memory controller thing.

Rename mem_cgroup_throttle_swaprate() to cgroup_throttle_swaprate(), and
drop the @memcg argument which is only used to check whether the preceding
page charge has succeeded and the fault is proceeding.

We could decouple the call from mem_cgroup_try_charge() here as well, but
that would cause unnecessary churn: the following patches convert all
callsites to a new charge API and we'll decouple as we go along.

Link: http://lkml.kernel.org/r/20200508183105.225460-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++----
 mm/memcontrol.c      |    5 ++---
 mm/swapfile.c        |   14 +++++++-------
 3 files changed, 11 insertions(+), 14 deletions(-)

--- a/include/linux/swap.h~mm-memcontrol-move-out-cgroup-swaprate-throttling
+++ a/include/linux/swap.h
@@ -650,11 +650,9 @@ static inline int mem_cgroup_swappiness(
 #endif
 
 #if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-extern void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg, int node,
-					 gfp_t gfp_mask);
+extern void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask);
 #else
-static inline void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg,
-						int node, gfp_t gfp_mask)
+static inline void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 {
 }
 #endif
--- a/mm/memcontrol.c~mm-memcontrol-move-out-cgroup-swaprate-throttling
+++ a/mm/memcontrol.c
@@ -6493,12 +6493,11 @@ out:
 int mem_cgroup_try_charge_delay(struct page *page, struct mm_struct *mm,
 			  gfp_t gfp_mask, struct mem_cgroup **memcgp)
 {
-	struct mem_cgroup *memcg;
 	int ret;
 
 	ret = mem_cgroup_try_charge(page, mm, gfp_mask, memcgp);
-	memcg = *memcgp;
-	mem_cgroup_throttle_swaprate(memcg, page_to_nid(page), gfp_mask);
+	if (*memcgp)
+		cgroup_throttle_swaprate(page, gfp_mask);
 	return ret;
 }
 
--- a/mm/swapfile.c~mm-memcontrol-move-out-cgroup-swaprate-throttling
+++ a/mm/swapfile.c
@@ -3743,11 +3743,12 @@ static void free_swap_count_continuation
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-void mem_cgroup_throttle_swaprate(struct mem_cgroup *memcg, int node,
-				  gfp_t gfp_mask)
+void cgroup_throttle_swaprate(struct page *page, gfp_t gfp_mask)
 {
 	struct swap_info_struct *si, *next;
-	if (!(gfp_mask & __GFP_IO) || !memcg)
+	int nid = page_to_nid(page);
+
+	if (!(gfp_mask & __GFP_IO))
 		return;
 
 	if (!blk_cgroup_congested())
@@ -3761,11 +3762,10 @@ void mem_cgroup_throttle_swaprate(struct
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[node],
-				  avail_lists[node]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid],
+				  avail_lists[nid]) {
 		if (si->bdev) {
-			blkcg_schedule_throttle(bdev_get_queue(si->bdev),
-						true);
+			blkcg_schedule_throttle(bdev_get_queue(si->bdev), true);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
