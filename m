From: akpm@linux-foundation.org
Subject: + slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch added to -mm tree
Date: Tue, 04 Sep 2012 13:44:36 -0700
Message-ID: <20120904204437.C07F45C0079@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43619 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab2IDUok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 16:44:40 -0400
Received: by bkcjc3 with SMTP id jc3so371608bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 13:44:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, chuck.lever@oracle.com, davem@davemloft.net, js1304@gmail.com, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slab: do ClearSlabPfmemalloc() for all pages of slab
has been added to the -mm tree.  Its filename is
     slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: slab: do ClearSlabPfmemalloc() for all pages of slab

Right now, we call ClearSlabPfmemalloc() for first page of slab when we
clear SlabPfmemalloc flag.  This is fine for most swap-over-network use
cases as it is expected that order-0 pages are in use.  Unfortunately it
is possible that that __ac_put_obj() checks SlabPfmemalloc on a tail page
and while this is harmless, it is sloppy.  This patch ensures that the
head page is always used.

This problem was originally identified by Joonsoo Kim.

[js1304@gmail.com: Original implementation and problem identification]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-do-clearslabpfmemalloc-for-all-pages-of-slab mm/slab.c
--- a/mm/slab.c~slab-do-clearslabpfmemalloc-for-all-pages-of-slab
+++ a/mm/slab.c
@@ -1000,7 +1000,7 @@ static void *__ac_get_obj(struct kmem_ca
 		l3 = cachep->nodelists[numa_mem_id()];
 		if (!list_empty(&l3->slabs_free) && force_refill) {
 			struct slab *slabp = virt_to_slab(objp);
-			ClearPageSlabPfmemalloc(virt_to_page(slabp->s_mem));
+			ClearPageSlabPfmemalloc(virt_to_head_page(slabp->s_mem));
 			clear_obj_pfmemalloc(&objp);
 			recheck_pfmemalloc_active(cachep, ac);
 			return objp;
@@ -1032,7 +1032,7 @@ static void *__ac_put_obj(struct kmem_ca
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
-		struct page *page = virt_to_page(objp);
+		struct page *page = virt_to_head_page(objp);
 		if (PageSlabPfmemalloc(page))
 			set_obj_pfmemalloc(&objp);
 	}
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch
slab-fix-starting-index-for-finding-another-object.patch
slub-consider-pfmemalloc_match-in-get_partial_node.patch
include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch

