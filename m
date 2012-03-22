From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:20:06 -0700
Message-ID: <20120322202006.6E428A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43250 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759235Ab2CVUUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:07 -0400
Received: by qcsp5 with SMTP id p5so202059qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_unregister_event()
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: mm/memcontrol.c: remove redundant BUG_ON() in mem_cgroup_usage_unregister_event()

In the following code:

	if (type == _MEM)
		thresholds = &memcg->thresholds;
	else if (type == _MEMSWAP)
		thresholds = &memcg->memsw_thresholds;
	else
		BUG();

	BUG_ON(!thresholds);

The BUG_ON() seems redundant.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-remove-redundant-bug_on-in-mem_cgroup_usage_unregister_event
+++ a/mm/memcontrol.c
@@ -4467,12 +4467,6 @@ static void mem_cgroup_usage_unregister_
 	else
 		BUG();
 
-	/*
-	 * Something went wrong if we trying to unregister a threshold
-	 * if we don't have thresholds
-	 */
-	BUG_ON(!thresholds);
