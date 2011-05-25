From: akpm@linux-foundation.org
Subject: [merged] mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:01 -0700
Message-ID: <201105252028.p4PKSOIU014739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152Ab1EYU27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: fail GFP_DMA allocations when ZONE_DMA is not configured
has been removed from the -mm tree.  Its filename was
     mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fail GFP_DMA allocations when ZONE_DMA is not configured
From: David Rientjes <rientjes@google.com>

The page allocator will improperly return a page from ZONE_NORMAL even
when __GFP_DMA is passed if CONFIG_ZONE_DMA is disabled.  The caller
expects DMA memory, perhaps for ISA devices with 16-bit address registers,
and may get higher memory resulting in undefined behavior.

This patch causes the page allocator to return NULL in such circumstances
with a warning emitted to the kernel log on the first occurrence.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured
+++ a/mm/page_alloc.c
@@ -2247,6 +2247,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 
 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
+#ifndef CONFIG_ZONE_DMA
+	if (WARN_ON_ONCE(gfp_mask & __GFP_DMA))
+		return NULL;
+#endif
 
 	/*
 	 * Check the zones suitable for the gfp_mask contain at least one
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
flex_array-avoid-divisions-when-accessing-elements.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

