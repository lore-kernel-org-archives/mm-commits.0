From: akpm@linux-foundation.org
Subject: + page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:06:24 -0700
Message-ID: <200906291906.n5TJ6OeK013547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbZF2THR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, rientjes@google.com


The patch titled
     page-allocator: Ensure that processes that have been OOM killed exit the page allocator
has been added to the -mm tree.  Its filename is
     page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch

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
@@ -1539,6 +1539,10 @@ should_alloc_retry(gfp_t gfp_mask, unsig
 	if (gfp_mask & __GFP_NORETRY)
 		return 0;
 
+	/* Do not loop if this process has been OOM-killed */
+	if (test_thread_flag(TIF_MEMDIE))
+		return 0;
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
@@ -1823,6 +1827,10 @@ rebalance:
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

page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
add-debugging-aid-for-memory-initialisation-problems.patch

