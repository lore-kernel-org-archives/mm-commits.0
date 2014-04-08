From: akpm@linux-foundation.org
Subject: [merged] mmnuma-reorganize-change_pmd_range.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 13:31:39 -0700
Message-ID: <53445cab.dY4VW4BWXiqrebhQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, peterz@infradead.org, gang.xing@hp.com, chegu_vinod@hp.com, aarcange@redhat.com, riel@redhat.com

Subject: [merged] mmnuma-reorganize-change_pmd_range.patch removed from -mm tree
To: riel@redhat.com,aarcange@redhat.com,chegu_vinod@hp.com,gang.xing@hp.com,peterz@infradead.org,rientjes@google.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:31:39 -0700


The patch titled
     Subject: mm,numa: reorganize change_pmd_range()
has been removed from the -mm tree.  Its filename was
     mmnuma-reorganize-change_pmd_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm,numa: reorganize change_pmd_range()

Reorganize the order of ifs in change_pmd_range a little, in preparation
for the next patch.

[akpm@linux-foundation.org: fix indenting, per David]
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/mprotect.c~mmnuma-reorganize-change_pmd_range mm/mprotect.c
--- a/mm/mprotect.c~mmnuma-reorganize-change_pmd_range
+++ a/mm/mprotect.c
@@ -118,6 +118,8 @@ static inline unsigned long change_pmd_r
 		unsigned long this_pages;
 
 		next = pmd_addr_end(addr, end);
+		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
+			continue;
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
@@ -133,10 +135,9 @@ static inline unsigned long change_pmd_r
 					continue;
 				}
 			}
-			/* fall through */
+			/* fall through, the trans huge pmd just split */
 		}
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
+		VM_BUG_ON(pmd_trans_huge(*pmd));
 		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa);
 		pages += this_pages;
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

