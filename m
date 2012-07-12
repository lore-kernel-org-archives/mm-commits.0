From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-fix-section-usemap-placement-calculation.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:43 -0700
Message-ID: <20120712193743.A8FAE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:63937 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab2GLTho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:44 -0400
Received: by yenl3 with SMTP id l3so265970yen.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: sparse: fix section usemap placement calculation
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-section-usemap-placement-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: sparse: fix section usemap placement calculation

238305b ("mm: remove sparsemem allocation details from the bootmem
allocator") introduced a bug in the allocation goal calculation that put
section usemaps not in the same section as the node descriptors, creating
unnecessary hotplug dependencies between them:

[    0.000000] node 0 must be removed before remove section 16399
[    0.000000] node 1 must be removed before remove section 16399
[    0.000000] node 2 must be removed before remove section 16399
[    0.000000] node 3 must be removed before remove section 16399
[    0.000000] node 4 must be removed before remove section 16399
[    0.000000] node 5 must be removed before remove section 16399
[    0.000000] node 6 must be removed before remove section 16399

The reason is that it applies PAGE_SECTION_MASK to the physical address of
the node descriptor when finding a suitable place to put the usemap, when
this mask is actually intended to be used with PFNs.  Because the PFN mask
is wider, the target address will point beyond the wanted section holding
the node descriptor and the node must be offlined before the section
holding the usemap can go.

Fix this by extending the mask to address width before use.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparse-fix-section-usemap-placement-calculation mm/sparse.c
--- a/mm/sparse.c~mm-sparse-fix-section-usemap-placement-calculation
+++ a/mm/sparse.c
@@ -287,7 +287,7 @@ sparse_early_usemaps_alloc_pgdat_section
 	 * from the same section as the pgdat where possible to avoid
 	 * this problem.
 	 */
-	goal = __pa(pgdat) & PAGE_SECTION_MASK;
+	goal = __pa(pgdat) & (PAGE_SECTION_MASK << PAGE_SHIFT);
 	host_pgdat = NODE_DATA(early_pfn_to_nid(goal >> PAGE_SHIFT));
 	return __alloc_bootmem_node_nopanic(host_pgdat, size,
 					    SMP_CACHE_BYTES, goal);
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

