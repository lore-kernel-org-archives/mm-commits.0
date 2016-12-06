From: akpm@linux-foundation.org
Subject: + mm-add-cond_resched-in-gather_pte_stats.patch added to -mm tree
Date: Tue, 06 Dec 2016 13:32:51 -0800
Message-ID: <58472e83.N2i0B0RlqKLcXcQU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbcLFVco (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 16:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, gerald.schaefer@de.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add cond_resched() in gather_pte_stats()
has been added to the -mm tree.  Its filename is
     mm-add-cond_resched-in-gather_pte_stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-cond_resched-in-gather_pte_stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-cond_resched-in-gather_pte_stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: add cond_resched() in gather_pte_stats()

The other pagetable walks in task_mmu.c have a cond_resched() after
walking their ptes: add a cond_resched() in gather_pte_stats() too, for
reading /proc/<id>/numa_maps.  Only pagemap_pmd_range() has a
cond_resched() in its (unusually expensive) pmd_trans_huge case: more
should probably be added, but leave them unchanged for now.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052157400.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/task_mmu.c~mm-add-cond_resched-in-gather_pte_stats fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-add-cond_resched-in-gather_pte_stats
+++ a/fs/proc/task_mmu.c
@@ -1588,6 +1588,7 @@ static int gather_pte_stats(pmd_t *pmd,
 
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	pte_unmap_unlock(orig_pte, ptl);
+	cond_resched();
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from hughd@google.com are

mm-add-three-more-cond_resched-in-swapoff.patch
mm-add-cond_resched-in-gather_pte_stats.patch

