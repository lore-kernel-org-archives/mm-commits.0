From: akpm@linux-foundation.org
Subject: [patch 05/18] mm/mempolicy: fix NUMA_INTERLEAVE_HIT counter
Date: Fri, 13 Oct 2017 15:57:43 -0700
Message-ID: <59e144e7.VJna3vrsowNWIx5S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdJMW5p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, kemi.wang@intel.com, mgorman@techsingularity.net

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/mempolicy: fix NUMA_INTERLEAVE_HIT counter

3a321d2a3dde81214 ("mm: change the call sites of numa statistics items")
separated NUMA counters from zone counters, but the NUMA_INTERLEAVE_HIT
call site wasn't updated to use the new interface.  So
alloc_page_interleave() actually increments NR_ZONE_INACTIVE_FILE instead
of NUMA_INTERLEAVE_HIT.

Fix this by using __inc_numa_state() interface to increment
NUMA_INTERLEAVE_HIT.

Link: http://lkml.kernel.org/r/20171003191003.8573-1-aryabinin@virtuozzo.com
Fixes: 3a321d2a3dde ("mm: change the call sites of numa statistics items")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Kemi Wang <kemi.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-fix-numa_interleave_hit-counter mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-fix-numa_interleave_hit-counter
+++ a/mm/mempolicy.c
@@ -1920,8 +1920,11 @@ static struct page *alloc_page_interleav
 	struct page *page;
 
 	page = __alloc_pages(gfp, order, nid);
-	if (page && page_to_nid(page) == nid)
-		inc_zone_page_state(page, NUMA_INTERLEAVE_HIT);
+	if (page && page_to_nid(page) == nid) {
+		preempt_disable();
+		__inc_numa_state(page_zone(page), NUMA_INTERLEAVE_HIT);
+		preempt_enable();
+	}
 	return page;
 }
 
_
