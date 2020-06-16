From: akpm@linux-foundation.org
Subject: + mm-memory-fix-io-cost-for-anonymous-page.patch added to
 -mm tree
Date: Tue, 16 Jun 2020 11:39:01 -0700
Message-ID: <20200616183901.VRFpL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgFPSjC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 14:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@surriel.com, minchan.kim@gmail.com, mhocko@suse.com, js1304@gmail.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com


The patch titled
     Subject: mm/memory: fix IO cost for anonymous page
has been added to the -mm tree.  Its filename is
     mm-memory-fix-io-cost-for-anonymous-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-fix-io-cost-for-anonymous-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-fix-io-cost-for-anonymous-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/memory: fix IO cost for anonymous page

With synchronous IO swap device, swap-in is directly handled in fault
code.  Since IO cost notation isn't added there, with synchronous IO swap
device, LRU balancing could be wrongly biased.  Fix it to count it in
fault code.

Link: http://lkml.kernel.org/r/1592288204-27734-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory.c~mm-memory-fix-io-cost-for-anonymous-page
+++ a/mm/memory.c
@@ -3143,6 +3143,14 @@ vm_fault_t do_swap_page(struct vm_fault
 				if (err)
 					goto out_page;
 
+				/*
+				 * XXX: Move to lru_cache_add() when it
+				 * supports new vs putback
+				 */
+				spin_lock_irq(&page_pgdat(page)->lru_lock);
+				lru_note_cost_page(page);
+				spin_unlock_irq(&page_pgdat(page)->lru_lock);
+
 				lru_cache_add(page);
 				swap_readpage(page, true);
 			}
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
mm-memory-fix-io-cost-for-anonymous-page.patch
