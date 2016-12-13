From: akpm@linux-foundation.org
Subject: [patch 084/123] mm: add cond_resched() in gather_pte_stats()
Date: Mon, 12 Dec 2016 16:44:47 -0800
Message-ID: <584f447f.DgOhWancwvn6GtPi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932380AbcLMAos (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, gerald.schaefer@de.ibm.com, mhocko@suse.com, rientjes@google.com

From: Hugh Dickins <hughd@google.com>
Subject: mm: add cond_resched() in gather_pte_stats()

The other pagetable walks in task_mmu.c have a cond_resched() after
walking their ptes: add a cond_resched() in gather_pte_stats() too, for
reading /proc/<id>/numa_maps.  Only pagemap_pmd_range() has a
cond_resched() in its (unusually expensive) pmd_trans_huge case: more
should probably be added, but leave them unchanged for now.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1612052157400.13021@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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
