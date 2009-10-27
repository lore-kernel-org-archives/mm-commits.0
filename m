From: akpm@linux-foundation.org
Subject: + page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch added to -mm tree
Date: Tue, 27 Oct 2009 13:19:16 -0700
Message-ID: <200910272019.n9RKJHNB017590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773AbZJ0UUg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 16:20:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, stable@kernel.org


The patch titled
     page allocator: Do not allow interrupts to use ALLOC_HARDER
has been added to the -mm tree.  Its filename is
     page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch

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
Subject: page allocator: Do not allow interrupts to use ALLOC_HARDER
From: Mel Gorman <mel@csn.ul.ie>

Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 ("page allocator:
calculate the alloc_flags for allocation only once") altered watermark
logic slightly by allowing rt_tasks that are handling an interrupt to set
ALLOC_HARDER.  This patch brings the watermark logic more in line with
2.6.30.

[rientjes@google.com: Spotted the problem]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/page_alloc.c~page-allocator-do-not-allow-interrupts-to-use-alloc_harder mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-allow-interrupts-to-use-alloc_harder
+++ a/mm/page_alloc.c
@@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)))
+	} else if (unlikely(rt_task(p)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-order-evictable-rescue-in-lru-putback.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
vmscan-force-kswapd-to-take-notice-faster-when-high-order-watermarks-are-being-hit.patch
linux-next.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
add-debugging-aid-for-memory-initialisation-problems.patch

