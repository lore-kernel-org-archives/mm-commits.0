From: akpm@linux-foundation.org
Subject: +
 mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch added to -mm tree
Date: Tue, 05 Apr 2016 13:30:06 -0700
Message-ID: <5704204e.11aCPHHcg40K3YSx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626AbcDEUaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: make nr_free_highpages() handles all highmem zones by itself
has been added to the -mm tree.  Its filename is
     mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/highmem: make nr_free_highpages() handles all highmem zones by itself

nr_free_highpages() manually adds statistics per each highmem zone and
returns a total value for them.  Whenever we add a new highmem zone, we
need to consider this function and it's really troublesome.  Make it
handle all highmem zones by itself.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/highmem.c~mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself mm/highmem.c
--- a/mm/highmem.c~mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself
+++ a/mm/highmem.c
@@ -112,16 +112,12 @@ EXPORT_PER_CPU_SYMBOL(__kmap_atomic_idx)
 
 unsigned int nr_free_highpages (void)
 {
-	pg_data_t *pgdat;
+	struct zone *zone;
 	unsigned int pages = 0;
 
-	for_each_online_pgdat(pgdat) {
-		pages += zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
-			NR_FREE_PAGES);
-		if (zone_movable_is_highmem())
-			pages += zone_page_state(
-					&pgdat->node_zones[ZONE_MOVABLE],
-					NR_FREE_PAGES);
+	for_each_populated_zone(zone) {
+		if (is_highmem(zone))
+			pages += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
 	return pages;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

