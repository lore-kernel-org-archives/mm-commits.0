From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-fix-numa-node-file-count-error-in-replace_page_cache.patch added to -mm
 tree
Date: Fri, 08 May 2020 16:19:21 -0700
Message-ID: <20200508231921.J1VJp4WZs%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:19:23 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: fix NUMA node file count error in replace_page_cache()
has been added to the -mm tree.  Its filename is
     mm-fix-numa-node-file-count-error-in-replace_page_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-numa-node-file-count-error-in-replace_page_cache.patch

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
Subject: mm: fix NUMA node file count error in replace_page_cache()

Patch series "mm: memcontrol: charge swapin pages on instantiation", v2.

This patch series reworks memcg to charge swapin pages directly at
swapin time, rather than at fault time, which may be much later, or
not happen at all.

Changes in version 2:
- prevent double charges on pre-allocated hugepages in khugepaged
- leave shmem swapcache when charging fails to avoid double IO (Joonsoo)
- fix temporary accounting bug by switching rmap<->commit (Joonsoo)
- fix double swap charge bug in cgroup1/cgroup2 code gating
- simplify swapin error checking (Joonsoo)
- mm: memcontrol: document the new swap control behavior (Alex)
- review tags

The delayed swapin charging scheme we have right now causes problems:

- Alex's per-cgroup lru_lock patches rely on pages that have been
  isolated from the LRU to have a stable page->mem_cgroup; otherwise
  the lock may change underneath him. Swapcache pages are charged only
  after they are added to the LRU, and charging doesn't follow the LRU
  isolation protocol.

- Joonsoo's anon workingset patches need a suitable LRU at the time
  the page enters the swap cache and displaces the non-resident
  info. But the correct LRU is only available after charging.

- It's a containment hole / DoS vector. Users can trigger arbitrarily
  large swap readahead using MADV_WILLNEED. The memory is never
  charged unless somebody actually touches it.

- It complicates the page->mem_cgroup stabilization rules

In order to charge pages directly at swapin time, the memcg code base
needs to be prepared, and several overdue cleanups become a necessity:

To charge pages at swapin time, we need to always have cgroup
ownership tracking of swap records. We also cannot rely on
page->mapping to tell apart page types at charge time, because that's
only set up during a page fault.

To eliminate the page->mapping dependency, memcg needs to ditch its
private page type counters (MEMCG_CACHE, MEMCG_RSS, NR_SHMEM) in favor
of the generic vmstat counters and accounting sites, such as
NR_FILE_PAGES, NR_ANON_MAPPED etc.

To switch to generic vmstat counters, the charge sequence must be
adjusted such that page->mem_cgroup is set up by the time these
counters are modified.

The series is structured as follows:

1. Bug fixes
2. Decoupling charging from rmap
3. Swap controller integration into memcg
4. Direct swapin charging


This patch (of 19):

When replacing one page with another one in the cache, we have to decrease
the file count of the old page's NUMA node and increase the one of the new
NUMA node, otherwise the old node leaks the count and the new node
eventually underflows its counter.

Link: http://lkml.kernel.org/r/20200508183105.225460-1-hannes@cmpxchg.org
Link: http://lkml.kernel.org/r/20200508183105.225460-2-hannes@cmpxchg.org
Fixes: 74d609585d8b ("page cache: Add and replace pages using the XArray")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-fix-numa-node-file-count-error-in-replace_page_cache
+++ a/mm/filemap.c
@@ -808,11 +808,11 @@ int replace_page_cache_page(struct page
 	old->mapping = NULL;
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!PageHuge(old))
-		__dec_node_page_state(new, NR_FILE_PAGES);
+		__dec_node_page_state(old, NR_FILE_PAGES);
 	if (!PageHuge(new))
 		__inc_node_page_state(new, NR_FILE_PAGES);
 	if (PageSwapBacked(old))
-		__dec_node_page_state(new, NR_SHMEM);
+		__dec_node_page_state(old, NR_SHMEM);
 	if (PageSwapBacked(new))
 		__inc_node_page_state(new, NR_SHMEM);
 	xas_unlock_irqrestore(&xas, flags);
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
