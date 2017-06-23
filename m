From: akpm@linux-foundation.org
Subject: [patch 1/8] mm, thp: remove cond_resched from
 __collapse_huge_page_copy
Date: Fri, 23 Jun 2017 15:08:38 -0700
Message-ID: <594d9166.5vRQjk05MKcN6M/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754602AbdFWWIj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:08:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rientjes@google.com, Larry.Finger@lwfinger.net, mhocko@suse.com, vbabka@suse.cz

From: David Rientjes <rientjes@google.com>
Subject: mm, thp: remove cond_resched from __collapse_huge_page_copy

This is a partial revert of commit 338a16ba1549 ("mm, thp: copying user
pages must schedule on collapse") which added a cond_resched() to
__collapse_huge_page_copy().

On x86 with CONFIG_HIGHPTE, __collapse_huge_page_copy is called in atomic
context and thus scheduling is not possible.  This is only a possible
config on arm and i386.

Although need_resched has been shown to be set for over 100 jiffies while
doing the iteration in __collapse_huge_page_copy, this is better than
doing

	if (in_atomic())
		cond_resched()

to cover only non-CONFIG_HIGHPTE configs.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1706191341550.97821@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/khugepaged.c~mm-thp-remove-cond_resched-from-__collapse_huge_page_copy mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-remove-cond_resched-from-__collapse_huge_page_copy
+++ a/mm/khugepaged.c
@@ -652,7 +652,6 @@ static void __collapse_huge_page_copy(pt
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
-		cond_resched();
 	}
 }
 
_
