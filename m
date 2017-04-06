From: akpm@linux-foundation.org
Subject: +
 mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
 added to -mm tree
Date: Thu, 06 Apr 2017 16:22:00 -0700
Message-ID: <58e6cd98.bXLMfMl5yDGf6UGJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755303AbdDFXWC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 19:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aryabinin@virtuozzo.com, boris.brezillon@free-electrons.com, cleech@redhat.com, davem@davemloft.net, edumazet@google.com, hannes@cmpxchg.org, jbacik@fb.com, lduncan@suse.com, mgorman@techsingularity.net, mhocko@suse.com, richard@nod.at, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent potential recursive reclaim due to clearing PF_MEMALLOC
has been added to the -mm tree.  Its filename is
     mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: prevent potential recursive reclaim due to clearing PF_MEMALLOC

Patch series "more robust PF_MEMALLOC handling"

This series aims to unify the setting and clearing of PF_MEMALLOC, which
prevents recursive reclaim.  There are some places that clear the flag
unconditionally from current->flags, which may result in clearing a
pre-existing flag.  This already resulted in a bug report that Patch 1
fixes (without the new helpers, to make backporting easier).  Patch 2
introduces the new helpers, modelled after existing memalloc_noio_* and
memalloc_nofs_* helpers, and converts mm core to use them.  Patches 3 and
4 convert non-mm code.



This patch (of 4):

__alloc_pages_direct_compact() sets PF_MEMALLOC to prevent deadlock during
page migration by lock_page() (see the comment in __unmap_and_move()). 
Then it unconditionally clears the flag, which can clear a pre-existing
PF_MEMALLOC flag and result in recursive reclaim.  This was not a problem
until commit a8161d1ed609 ("mm, page_alloc: restructure direct compaction
handling in slowpath"), because direct compation was called only after
direct reclaim, which was skipped when PF_MEMALLOC flag was set.

Even now it's only a theoretical issue, as the new callsite of
__alloc_pages_direct_compact() is reached only for costly orders and when
gfp_pfmemalloc_allowed() is true, which means either __GFP_NOMEMALLOC is
in gfp_flags or in_interrupt() is true.  There is no such known context,
but let's play it safe and make __alloc_pages_direct_compact() robust for
cases where PF_MEMALLOC is already set.

Fixes: a8161d1ed609 ("mm, page_alloc: restructure direct compaction handling in slowpath")
Link: http://lkml.kernel.org/r/20170405074700.29871-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc
+++ a/mm/page_alloc.c
@@ -3288,6 +3288,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		enum compact_priority prio, enum compact_result *compact_result)
 {
 	struct page *page;
+	unsigned int noreclaim_flag = current->flags & PF_MEMALLOC;
 
 	if (!order)
 		return NULL;
@@ -3295,7 +3296,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	current->flags |= PF_MEMALLOC;
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 									prio);
-	current->flags &= ~PF_MEMALLOC;
+	current->flags = (current->flags & ~PF_MEMALLOC) | noreclaim_flag;
 
 	if (*compact_result <= COMPACT_INACTIVE)
 		return NULL;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-reorder-fields-in-struct-compact_control.patch
mm-compaction-remove-redundant-watermark-check-in-compact_finished.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback.patch
mm-page_alloc-split-smallest-stolen-page-in-fallback-fix.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock.patch
mm-compaction-change-migrate_async_suitable-to-suitable_migration_source.patch
mm-compaction-add-migratetype-to-compact_control.patch
mm-compaction-restrict-async-compaction-to-pageblocks-of-same-migratetype.patch
mm-compaction-finish-whole-pageblock-to-reduce-fragmentation.patch
mm-prevent-potential-recursive-reclaim-due-to-clearing-pf_memalloc.patch
mm-introduce-memalloc_noreclaim_saverestore.patch
treewide-convert-pf_memalloc-manipulations-to-new-helpers.patch
mtd-nand-nandsim-convert-to-memalloc_noreclaim_.patch

