From: akpm@linux-foundation.org
Subject: + mm-writeback-correct-dirty-page-calculation-for-highmem.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 13:30:01 -0700
Message-ID: <57042049.afFD2u267TPK4U8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626AbcDEUaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 16:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/writeback: correct dirty page calculation for highmem
has been added to the -mm tree.  Its filename is
     mm-writeback-correct-dirty-page-calculation-for-highmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-writeback-correct-dirty-page-calculation-for-highmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-writeback-correct-dirty-page-calculation-for-highmem.patch

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
Subject: mm/writeback: correct dirty page calculation for highmem

ZONE_MOVABLE could be treated as highmem so we need to consider it for
accurate calculation of dirty pages.  And, in following patches, ZONE_CMA
will be introduced and it can be treated as highmem, too.  So, instead of
manually adding stat of ZONE_MOVABLE, looping all zones and check whether
the zone is highmem or not and add stat of the zone which can be treated
as highmem.

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

 mm/page-writeback.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-writeback-correct-dirty-page-calculation-for-highmem mm/page-writeback.c
--- a/mm/page-writeback.c~mm-writeback-correct-dirty-page-calculation-for-highmem
+++ a/mm/page-writeback.c
@@ -296,11 +296,15 @@ static unsigned long highmem_dirtyable_m
 #ifdef CONFIG_HIGHMEM
 	int node;
 	unsigned long x = 0;
+	int i;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z = &NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			struct zone *z = &NODE_DATA(node)->node_zones[i];
 
-		x += zone_dirtyable_memory(z);
+			if (is_highmem(z))
+				x += zone_dirtyable_memory(z);
+		}
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
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

