From: akpm@linux-foundation.org
Subject: + mm-thp-remove-cond_resched-from-__collapse_huge_page_copy.patch added to -mm tree
Date: Mon, 19 Jun 2017 14:12:36 -0700
Message-ID: <59483e44.SrE2O6p89oHKloxG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdFSVMh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 17:12:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, Larry.Finger@lwfinger.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove cond_resched from __collapse_huge_page_copy
has been added to the -mm tree.  Its filename is
     mm-thp-remove-cond_resched-from-__collapse_huge_page_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remove-cond_resched-from-__collapse_huge_page_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remove-cond_resched-from-__collapse_huge_page_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-remove-cond_resched-from-__collapse_huge_page_copy.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low.patch
mm-vmpressure-pass-through-notification-support.patch
mm-hugetlb-schedule-when-potentially-allocating-many-hugepages.patch
fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch

