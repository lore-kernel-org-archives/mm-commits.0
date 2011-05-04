From: akpm@linux-foundation.org
Subject: + mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch added to -mm tree
Date: Wed, 04 May 2011 13:50:29 -0700
Message-ID: <201105042050.p44KoUM5013173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810Ab1EDUvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2011 16:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     mm: fail GFP_DMA allocations when ZONE_DMA is not configured
has been added to the -mm tree.  Its filename is
     mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch

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
@@ -2246,6 +2246,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 
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

linux-next.patch
arch-mm-filter-disallowed-nodes-from-arch-specific-show_mem-functions.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-increase-reclaim_distance-to-30.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-rename-alloc_pages_exact.patch
mm-make-new-alloc_pages_exact.patch
mm-reuse-__free_pages_exact-in-__alloc_pages_exact.patch
mm-thp-optimize-memcg-charge-in-khugepaged.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
alpha-mm-set-all-online-nodes-in-n_normal_memory.patch
m32r-mm-set-all-online-nodes-in-n_normal_memory.patch
mm-fail-gfp_dma-allocations-when-zone_dma-is-not-configured.patch
flex_array-avoid-divisions-when-accessing-elements.patch
jbd-remove-dependency-on-__gfp_nofail.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

