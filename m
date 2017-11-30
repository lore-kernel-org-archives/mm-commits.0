From: akpm@linux-foundation.org
Subject: [patch 01/28] mm, memory_hotplug: do not back off draining pcp
 free pages from kworker context
Date: Wed, 29 Nov 2017 16:09:54 -0800
Message-ID: <5a1f4c52.AvBmfQnTOTzyZvRG%akpm__32261.1977150247$1512000614$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753417AbdK3AJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, mgorman@suse.de, stable@vger.kernel.org, tj@kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: do not back off draining pcp free pages from kworker context

drain_all_pages backs off when called from a kworker context since
0ccce3b924212 ("mm, page_alloc: drain per-cpu pages from workqueue
context") because the original IPI based pcp draining has been replaced by
a WQ based one and the check wanted to prevent from recursion and inter
workers dependencies.  This has made some sense at the time because the
system WQ has been used and one worker holding the lock could be blocked
while waiting for new workers to emerge which can be a problem under OOM
conditions.

Since then ce612879ddc7 ("mm: move pcp and lru-pcp draining into single
wq") has moved draining to a dedicated (mm_percpu_wq) WQ with a rescuer so
we shouldn't depend on any other WQ activity to make a forward progress so
calling drain_all_pages from a worker context is safe as long as this
doesn't happen from mm_percpu_wq itself which is not the case because all
workers are required to _not_ depend on any MM locks.

Why is this a problem in the first place?  ACPI driven memory hot-remove
(acpi_device_hotplug) is executed from the worker context.  We end up
calling __offline_pages to free all the pages and that requires both
lru_add_drain_all_cpuslocked and drain_all_pages to do their job otherwise
we can have dangling pages on pcp lists and fail the offline operation
(__test_page_isolated_in_pageblock would see a page with 0 ref.  count but
without PageBuddy set).

Fix the issue by removing the worker check in drain_all_pages. 
lru_add_drain_all_cpuslocked doesn't have this restriction so it works as
expected.

Link: http://lkml.kernel.org/r/20170828093341.26341-1-mhocko@kernel.org
Fixes: 0ccce3b924212 ("mm, page_alloc: drain per-cpu pages from workqueue context")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>	[4.11+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context
+++ a/mm/page_alloc.c
@@ -2507,10 +2507,6 @@ void drain_all_pages(struct zone *zone)
 	if (WARN_ON_ONCE(!mm_percpu_wq))
 		return;
 
-	/* Workqueues cannot recurse */
-	if (current->flags & PF_WQ_WORKER)
-		return;
