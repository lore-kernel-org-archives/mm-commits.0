From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:39:39 -0700
Message-ID: <20200403203939.EUXLpxZVV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDCUjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusznosek0@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/page_alloc.c: micro-optimisation Remove unnecessary branch
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: micro-optimisation Remove unnecessary branch

Previously if branch condition was false, the assignment was not executed.
The assignment can be safely executed even when the condition is false
and it is not incorrect as it assigns the value of 'nodemask' to
'ac.nodemask' which already has the same value.

So as the assignment can be executed unconditionally, the branch can be
removed.

Link: http://lkml.kernel.org/r/20200307225335.31300-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-micro-optimisation-remove-unnecessary-branch
+++ a/mm/page_alloc.c
@@ -4751,8 +4751,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
 	 */
-	if (unlikely(ac.nodemask != nodemask))
-		ac.nodemask = nodemask;
+	ac.nodemask = nodemask;
 
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch
