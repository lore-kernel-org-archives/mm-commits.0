From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 117/155] mm/page_alloc.c: micro-optimisation
 Remove unnecessary branch
Date: Wed, 01 Apr 2020 21:09:53 -0700
Message-ID: <20200402040953.riSFcn3-G%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728455AbgDBEJy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:54 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
