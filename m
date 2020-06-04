From: akpm@linux-foundation.org
Subject: [merged]
 mm-workingset-let-cache-workingset-challenge-anon.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:20:49 -0700
Message-ID: <20200604172049.aGJfxEI9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRUv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: workingset: let cache workingset challenge anon
has been removed from the -mm tree.  Its filename was
     mm-workingset-let-cache-workingset-challenge-anon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: let cache workingset challenge anon

We activate cache refaults with reuse distances in pages smaller than the
size of the total cache.  This allows new pages with competitive access
frequencies to establish themselves, as well as challenge and potentially
displace pages on the active list that have gone cold.

However, that assumes that active cache can only replace other active
cache in a competition for the hottest memory.  This is not a great
default assumption.  The page cache might be thrashing while there are
enough completely cold and unused anonymous pages sitting around that we'd
only have to write to swap once to stop all IO from the cache.

Activate cache refaults when their reuse distance in pages is smaller than
the total userspace workingset, including anonymous pages.

Reclaim can still decide how to balance pressure among the two LRUs
depending on the IO situation.  Rotational drives will prefer avoiding
random IO from swap and go harder after cache.  But fundamentally, hot
cache should be able to compete with anon pages for a place in RAM.

Link: http://lkml.kernel.org/r/20200520232525.798933-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/workingset.c~mm-workingset-let-cache-workingset-challenge-anon
+++ a/mm/workingset.c
@@ -277,8 +277,8 @@ void workingset_refault(struct page *pag
 	struct mem_cgroup *eviction_memcg;
 	struct lruvec *eviction_lruvec;
 	unsigned long refault_distance;
+	unsigned long workingset_size;
 	struct pglist_data *pgdat;
-	unsigned long active_file;
 	struct mem_cgroup *memcg;
 	unsigned long eviction;
 	struct lruvec *lruvec;
@@ -310,7 +310,6 @@ void workingset_refault(struct page *pag
 		goto out;
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->inactive_age);
-	active_file = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
 
 	/*
 	 * Calculate the refault distance
@@ -345,10 +344,18 @@ void workingset_refault(struct page *pag
 
 	/*
 	 * Compare the distance to the existing workingset size. We
-	 * don't act on pages that couldn't stay resident even if all
-	 * the memory was available to the page cache.
+	 * don't activate pages that couldn't stay resident even if
+	 * all the memory was available to the page cache. Whether
+	 * cache can compete with anon or not depends on having swap.
 	 */
-	if (refault_distance > active_file)
+	workingset_size = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
+	if (mem_cgroup_get_nr_swap_pages(memcg) > 0) {
+		workingset_size += lruvec_page_state(eviction_lruvec,
+						     NR_INACTIVE_ANON);
+		workingset_size += lruvec_page_state(eviction_lruvec,
+						     NR_ACTIVE_ANON);
+	}
+	if (refault_distance > workingset_size)
 		goto out;
 
 	SetPageActive(page);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
