From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-the-range-check-for-backward-merging.patch added to -mm tree
Date: Fri, 08 Jan 2010 15:21:12 -0800
Message-ID: <201001082321.o08NLCeS020238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab0AHXWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 18:22:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ki@epsilou.com, cl@linux-foundation.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mm/page_alloc: fix the range check for backward merging
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-the-range-check-for-backward-merging.patch

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
Subject: mm/page_alloc: fix the range check for backward merging
From: Kazuhisa Ichikawa <ki@epsilou.com>

The current check for 'backward merging' within add_active_range() does
not seem correct.  start_pfn must be compared against
early_node_map[i].start_pfn (and NOT against .end_pfn) to find out whether
the new region is backward-mergeable with the existing range.

Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-the-range-check-for-backward-merging mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-the-range-check-for-backward-merging
+++ a/mm/page_alloc.c
@@ -3937,7 +3937,7 @@ void __init add_active_range(unsigned in
 		}
 
 		/* Merge backward if suitable */
-		if (start_pfn < early_node_map[i].end_pfn &&
+		if (start_pfn < early_node_map[i].start_pfn &&
 				end_pfn >= early_node_map[i].start_pfn) {
 			early_node_map[i].start_pfn = start_pfn;
 			return;
_

Patches currently in -mm which might be from ki@epsilou.com are

mm-page_alloc-fix-the-range-check-for-backward-merging.patch

