From: akpm@linux-foundation.org
Subject: + mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:27:24 -0700
Message-ID: <20120712212724.78207100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65470 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab2GLV10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:27:26 -0400
Received: by qcqs25 with SMTP id s25so281726qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:27:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux.com, a.p.zijlstra@chello.nl, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, mgorman@suse.de, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: mm: slub: optimise the SLUB fast path to avoid pfmemalloc checks
has been added to the -mm tree.  Its filename is
     mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2271,11 +2271,11 @@ new_slab:
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
@@ -2327,8 +2327,7 @@ redo:
 
 	object = c->freelist;
 	page = c->page;
-	if (unlikely(!object || !node_match(page, node)
-					!pfmemalloc_match(page, gfpflags)))
+	if (unlikely(!object || !node_match(page, node)))
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
_
Subject: Subject: mm: slub: optimise the SLUB fast path to avoid pfmemalloc checks

Patches currently in -mm which might be from cl@linux.com are

linux-next.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch

