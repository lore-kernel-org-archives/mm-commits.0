From: akpm@linux-foundation.org
Subject: + mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch added to -mm tree
Date: Mon, 24 Jan 2011 13:30:54 -0800
Message-ID: <201101242130.p0OLUt1u011620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529Ab1AXVcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 16:32:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator
has been added to the -mm tree.  Its filename is
     mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator
From: David Rientjes <rientjes@google.com>

0e093d99763e (writeback: do not sleep on the congestion queue if there are
no congested BDIs or if significant congestion is not being encountered in
the current zone) uncovered a livelock in the page allocator that resulted
in tasks infinitely looping trying to find memory and kswapd running at
100% cpu.

The issue occurs because drain_all_pages() is called immediately following
direct reclaim when no memory is freed and try_to_free_pages() returns
non-zero because all zones in the zonelist do not have their
all_unreclaimable flag set.

When draining the per-cpu pagesets back to the buddy allocator for each
zone, the zone->pages_scanned counter is cleared to avoid erroneously
setting zone->all_unreclaimable later.  The problem is that no pages may
actually be drained and, thus, the unreclaimable logic never fails direct
reclaim so the oom killer may be invoked.

This apparently only manifested after wait_iff_congested() was introduced
and the zone was full of anonymous memory that would not congest the
backing store.  The page allocator would infinitely loop if there were no
other tasks waiting to be scheduled and clear zone->pages_scanned because
of drain_all_pages() as the result of this change before kswapd could scan
enough pages to trigger the reclaim logic.  Additionally, with every loop
of the page allocator and in the reclaim path, kswapd would be kicked and
would end up running at 100% cpu.  In this scenario, current and kswapd
are all running continuously with kswapd incrementing zone->pages_scanned
and current clearing it.

The problem is even more pronounced when current swaps some of its memory
to swap cache and the reclaimable logic then considers all active
anonymous memory in the all_unreclaimable logic, which requires a much
higher zone->pages_scanned value for try_to_free_pages() to return zero
that is never attainable in this scenario.

Before wait_iff_congested(), the page allocator would incur an
unconditional timeout and allow kswapd to elevate zone->pages_scanned to a
level that the oom killer would be called the next time it loops.

The fix is to only attempt to drain pcp pages if there is actually a
quantity to be drained.  The unconditional clearing of zone->pages_scanned
in free_pcppages_bulk() need not be changed since other callers already
ensure that draining will occur.  This patch ensures that
free_pcppages_bulk() will actually free memory before calling into it from
drain_all_pages() so zone->pages_scanned is only cleared if appropriate.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator
+++ a/mm/page_alloc.c
@@ -1088,8 +1088,10 @@ static void drain_pages(unsigned int cpu
 		pset = per_cpu_ptr(zone->pageset, cpu);
 
 		pcp = &pset->pcp;
-		free_pcppages_bulk(zone, pcp->count, pcp);
-		pcp->count = 0;
+		if (pcp->count) {
+			free_pcppages_bulk(zone, pcp->count, pcp);
+			pcp->count = 0;
+		}
 		local_irq_restore(flags);
 	}
 }
_

Patches currently in -mm which might be from rientjes@google.com are

mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
jbd-remove-dependency-on-__gfp_nofail.patch

