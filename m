From: akpm@linux-foundation.org
Subject: + mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch added to -mm tree
Date: Mon, 24 Jan 2011 13:38:22 -0800
Message-ID: <201101242138.p0OLcM4s011904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab1AXVjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 16:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: fix deferred congestion timeout if preferred zone is not allowed
has been added to the -mm tree.  Its filename is
     mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch

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
Subject: mm: fix deferred congestion timeout if preferred zone is not allowed
From: David Rientjes <rientjes@google.com>

Before 0e093d99763e ("writeback: do not sleep on the congestion queue if
there are no congested BDIs or if significant congestion is not being
encountered in the current zone"), preferred_zone was only used for NUMA
statistics, to determine the zoneidx from which to allocate from given the
type requested, and whether to utilize memory compaction.

wait_iff_congested(), though, uses preferred_zone to determine if the
congestion wait should be deferred because its dirty pages are backed by a
congested bdi.  This incorrectly defers the timeout and busy loops in the
page allocator with various cond_resched() calls if preferred_zone is not
allowed in the current context, usually consuming 100% of a cpu.

This patch ensures preferred_zone is an allowed zone in the fastpath
depending on whether current is constrained by its cpuset or nodes in its
mempolicy (when the nodemask passed is non-NULL).  This is correct since
the fastpath allocation always passes ALLOC_CPUSET when trying to allocate
memory.  In the slowpath, this patch resets preferred_zone to the first
zone of the allowed type when the allocation is not constrained by
current's cpuset, i.e.  it does not pass ALLOC_CPUSET.

This patch also ensures preferred_zone is from the set of allowed nodes
when called from within direct reclaim since allocations are always
constrained by cpusets in this context (it is blockable).

Both of these uses of cpuset_current_mems_allowed are protected by
get_mems_allowed().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++++-
 mm/vmscan.c     |    3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed
+++ a/mm/page_alloc.c
@@ -2034,6 +2034,14 @@ restart:
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
+	/*
+	 * Find the true preferred zone if the allocation is unconstrained by
+	 * cpusets.
+	 */
+	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask)
+		first_zones_zonelist(zonelist, high_zoneidx, NULL,
+					&preferred_zone);
+
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -2192,7 +2200,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 
 	get_mems_allowed();
 	/* The preferred zone is used for statistics later */
-	first_zones_zonelist(zonelist, high_zoneidx, nodemask, &preferred_zone);
+	first_zones_zonelist(zonelist, high_zoneidx,
+				nodemask ? : &cpuset_current_mems_allowed,
+				&preferred_zone);
 	if (!preferred_zone) {
 		put_mems_allowed();
 		return NULL;
diff -puN mm/vmscan.c~mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed
+++ a/mm/vmscan.c
@@ -2083,7 +2083,8 @@ static unsigned long do_try_to_free_page
 			struct zone *preferred_zone;
 
 			first_zones_zonelist(zonelist, gfp_zone(sc->gfp_mask),
-							NULL, &preferred_zone);
+						&cpuset_current_mems_allowed,
+						&preferred_zone);
 			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/10);
 		}
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
jbd-remove-dependency-on-__gfp_nofail.patch

