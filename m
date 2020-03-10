From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch added to
 -mm tree
Date: Mon, 09 Mar 2020 19:56:53 -0700
Message-ID: <20200310025653.8mfUR4dec%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgCJC4y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 22:56:54 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusznosek0@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/page_alloc.c: micro-optimisation Remove unnecessary branch
has been added to the -mm tree.  Its filename is
     mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4764,8 +4764,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
 	 */
-	if (unlikely(ac.nodemask != nodemask))
-		ac.nodemask = nodemask;
+	ac.nodemask = nodemask;
 
 	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-micro-optimisation-save-two-branches-on-hot-page-allocation-path.patch
mm-page_allocc-micro-optimisation-remove-unnecessary-branch.patch
mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch
mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
