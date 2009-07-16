From: akpm@linux-foundation.org
Subject: [to-be-updated] page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch removed from -mm tree
Date: Thu, 16 Jul 2009 12:49:13 -0700
Message-ID: <200907161949.n6GJnD5R020667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932901AbZGPTuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 15:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: Ensure that processes that have been OOM killed exit the page allocator
has been removed from the -mm tree.  Its filename was
     page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: Ensure that processes that have been OOM killed exit the page allocator
From: Mel Gorman <mel@csn.ul.ie>

Processes that have been OOM killed set the thread flag TIF_MEMDIE.  A
process such as this is expected to exit the page allocator but in the
event it happens to have set __GFP_NOFAIL, it potentially loops
forever.

This patch checks TIF_MEMDIE when deciding whether to loop again in the
page allocator.  Such a process will now return NULL after direct
reclaim and OOM killing have both been considered as options.  The
potential problem is that a __GFP_NOFAIL allocation can still return
failure so callers must still handle getting returned NULL.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/page_alloc.c~page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator
+++ a/mm/page_alloc.c
@@ -1552,6 +1552,10 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 			return 0;
 	}
 
+	/* Do not loop if this process has been OOM-killed */
+	if (test_thread_flag(TIF_MEMDIE))
+		return 0;
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
@@ -1836,6 +1840,10 @@ rebalance:
 						!(gfp_mask & __GFP_NOFAIL))
 				goto nopage;
 
+			/* Do not loop if this process has been OOM-killed */
+			if (test_thread_flag(TIF_MEMDIE))
+				goto nopage;
+
 			goto restart;
 		}
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-clean-up-page_remove_rmap.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch
net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
add-debugging-aid-for-memory-initialisation-problems.patch

