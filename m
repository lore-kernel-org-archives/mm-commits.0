From: akpm@linux-foundation.org
Subject: + mm-sparse-fix-section-usemap-placement-calculation.patch added to -mm tree
Date: Tue, 10 Jul 2012 15:32:14 -0700
Message-ID: <20120710223215.1946D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:38599 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2GJWcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 18:32:17 -0400
Received: by weyr1 with SMTP id r1so22935wey.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 15:32:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hannes@cmpxchg.org


The patch titled
     Subject: mm: sparse: fix section usemap placement calculation
has been added to the -mm tree.  Its filename is
     mm-sparse-fix-section-usemap-placement-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: sparse: fix section usemap placement calculation

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
mm-sparse-fix-section-usemap-placement-calculation.patch
mm-sparse-fix-usemap-allocation-above-node-descriptor-section.patch
memblock-free-allocated-memblock_reserved_regions-later.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

