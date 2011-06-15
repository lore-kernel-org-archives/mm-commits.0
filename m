From: akpm@linux-foundation.org
Subject: + mm-memory-failurec-fix-page-isolated-count-mismatch.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:15 -0700
Message-ID: <201106150124.p5F1OWOK031950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448Ab1FOBZl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, andi@firstfloor.org, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm/memory-failure.c: fix page isolated count mismatch
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-fix-page-isolated-count-mismatch.patch

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
Subject: mm/memory-failure.c: fix page isolated count mismatch
From: Minchan Kim <minchan.kim@gmail.com>

Pages isolated for migration are accounted with the vmstat counters
NR_ISOLATE_[ANON|FILE].  Callers of migrate_pages() are expected to
increment these counters when pages are isolated from the LRU.  Once the
pages have been migrated, they are put back on the LRU or freed and the
isolated count is decremented.

Memory failure is not properly accounting for pages it isolates causing
the NR_ISOLATED counters to be negative.  On SMP builds, this goes
unnoticed as negative counters are treated as 0 due to expected per-cpu
drift.  On UP builds, the counter is treated by too_many_isolated() as a
large value causing processes to enter D state during page reclaim or
compaction.  This patch accounts for pages isolated by memory failure
correctly.

[mel@csn.ul.ie: rewrote changelog]
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-fix-page-isolated-count-mismatch mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-fix-page-isolated-count-mismatch
+++ a/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/mm_inline.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1468,7 +1469,8 @@ int soft_offline_page(struct page *page,
 	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
