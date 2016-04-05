From: akpm@linux-foundation.org
Subject: + mm-page_alloc-correct-highmem-memory-statistics.patch added to
 -mm tree
Date: Tue, 05 Apr 2016 13:30:04 -0700
Message-ID: <5704204c.deDTpKoBgLzyy0RX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626AbcDEUaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: correct highmem memory statistics
has been added to the -mm tree.  Its filename is
     mm-page_alloc-correct-highmem-memory-statistics.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-correct-highmem-memory-statistics.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-correct-highmem-memory-statistics.patch

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
Subject: mm/page_alloc: correct highmem memory statistics

ZONE_MOVABLE could be treated as highmem so we need to consider it for
accurate statistics.  And, in following patches, ZONE_CMA will be
introduced and it can be treated as highmem, too.  So, instead of manually
adding stat of ZONE_MOVABLE, looping all zones and check whether the zone
is highmem or not and add stat of the zone which can be treated as
highmem.

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

 mm/page_alloc.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-correct-highmem-memory-statistics mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-correct-highmem-memory-statistics
+++ a/mm/page_alloc.c
@@ -3820,6 +3820,8 @@ void si_meminfo_node(struct sysinfo *val
 {
 	int zone_type;		/* needs to be signed */
 	unsigned long managed_pages = 0;
+	unsigned long managed_highpages = 0;
+	unsigned long free_highpages = 0;
 	pg_data_t *pgdat = NODE_DATA(nid);
 
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
@@ -3828,12 +3830,19 @@ void si_meminfo_node(struct sysinfo *val
 	val->sharedram = node_page_state(nid, NR_SHMEM);
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
-	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
-	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
-			NR_FREE_PAGES);
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (is_highmem(zone)) {
+			managed_highpages += zone->managed_pages;
+			free_highpages += zone_page_state(zone, NR_FREE_PAGES);
+		}
+	}
+	val->totalhigh = managed_highpages;
+	val->freehigh = free_highpages;
 #else
-	val->totalhigh = 0;
-	val->freehigh = 0;
+	val->totalhigh = managed_highpages;
+	val->freehigh = free_highpages;
 #endif
 	val->mem_unit = PAGE_SIZE;
 }
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

