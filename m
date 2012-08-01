From: akpm@linux-foundation.org
Subject: [merged] mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:15:38 -0700
Message-ID: <20120801201539.536A2200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50406 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2HAUPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:15:42 -0400
Received: by bkcjc3 with SMTP id jc3so345240bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:15:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, a.p.zijlstra@chello.nl, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, mgorman@suse.de, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: optimise the SLUB fast path to avoid pfmemalloc checks
has been removed from the -mm tree.  Its filename was
     mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: mm: slub: optimise the SLUB fast path to avoid pfmemalloc checks

This patch removes the check for pfmemalloc from the alloc hotpath and
puts the logic after the election of a new per cpu slab.  For a pfmemalloc
page we do not use the fast path but force the use of the slow path which
is also used for the debug case.

This has the side-effect of weakening pfmemalloc processing in the
following way;

1. A process that is allocating for network swap calls __slab_alloc.
   pfmemalloc_match is true so the freelist is loaded and c->freelist is
   now pointing to a pfmemalloc page.

2. A process that is attempting normal allocations calls slab_alloc,
   finds the pfmemalloc page on the freelist and uses it because it did
   not check pfmemalloc_match()

The patch allows non-pfmemalloc allocations to use pfmemalloc pages with
the kmalloc slabs being the most vunerable caches on the grounds they
are most likely to have a mix of pfmemalloc and !pfmemalloc requests. A
later patch will still protect the system as processes will get throttled
if the pfmemalloc reserves get depleted but performance will not degrade
as smoothly.

[mgorman@suse.de: Expanded changelog]
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks mm/slub.c
--- a/mm/slub.c~mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks
+++ a/mm/slub.c
@@ -2281,11 +2281,11 @@ new_slab:
 	}
 
 	page = c->page;
-	if (likely(!kmem_cache_debug(s)))
+	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
 		goto load_freelist;
 
 	/* Only entered in the debug case */
-	if (!alloc_debug_processing(s, page, freelist, addr))
+	if (kmem_cache_debug(s) && !alloc_debug_processing(s, page, freelist, addr))
 		goto new_slab;	/* Slab failed checks. Next slab needed */
 
 	deactivate_slab(s, page, get_freepointer(s, freelist));
@@ -2337,8 +2337,7 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node) ||
-					!pfmemalloc_match(page, gfpflags)))
+	if (unlikely(!object || !node_match(page, node)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch

