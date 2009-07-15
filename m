From: akpm@linux-foundation.org
Subject: + page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator-resend.patch added to -mm tree
Date: Wed, 15 Jul 2009 13:30:27 -0700
Message-ID: <200907152030.n6FKURIt013672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283AbZGOUa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 16:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, npiggin@suse.de, rientjes@google.com


The patch titled
     page-allocator: ensure that processes that have been OOM killed exit the page allocator
has been added to the -mm tree.  Its filename is
     page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator-resend.patch

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
Subject: page-allocator: ensure that processes that have been OOM killed exit the page allocator
From: Mel Gorman <mel@csn.ul.ie>

Processes that have been OOM killed set the thread flag TIF_MEMDIE.  A
process such as this is expected to exit the page allocator but
potentially, it loops forever.  This patch checks TIF_MEMDIE when deciding
whether to loop again in the page allocator.  If set, and __GFP_NOFAIL is
not specified then the loop will exit on the assumption it's no longer
important for the process to make forward progress.  Note that a process
that has just been OOM-killed will still loop at least one more time
retrying the allocation before the thread flag is checked.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/page_alloc.c~page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator-resend mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator-resend
+++ a/mm/page_alloc.c
@@ -1544,6 +1544,14 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 	if (gfp_mask & __GFP_NORETRY)
 		return 0;
 
+	/* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
+	if (test_thread_flag(TIF_MEMDIE)) {
+		if (gfp_mask & __GFP_NOFAIL)
+			WARN(1, "Potential infinite loop with __GFP_NOFAIL");
+		else
+			return 0;
+	}
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator-resend.patch
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
add-debugging-aid-for-memory-initialisation-problems.patch

