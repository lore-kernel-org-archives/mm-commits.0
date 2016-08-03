From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-huge_pte_alloc-bug_on.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:10:51 -0700
Message-ID: <57a233ab.UlEZUrtlu85jSzjL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbcHCSVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:21:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, n-horiguchi@ah.jp.nec.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix huge_pte_alloc BUG_ON
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-huge_pte_alloc-bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, hugetlb: fix huge_pte_alloc BUG_ON

Zhong Jiang has reported a BUG_ON from huge_pte_alloc hitting when he runs
his database load with memory online and offline running in parallel.  The
reason is that huge_pmd_share might detect a shared pmd which is currently
migrated and so it has migration pte which is !pte_huge.

There doesn't seem to be any easy way to prevent from the race and in fact
seeing the migration swap entry is not harmful.  Both callers of
huge_pte_alloc are prepared to handle them.  copy_hugetlb_page_range will
copy the swap entry and make it COW if needed.  hugetlb_fault will back
off and so the page fault is retries if the page is still under migration
and waits for its completion in hugetlb_fault.

That means that the BUG_ON is wrong and we should update it.  Let's simply
check that all present ptes are pte_huge instead.

Link: http://lkml.kernel.org/r/20160721074340.GA26398@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: zhongjiang <zhongjiang@huawei.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-huge_pte_alloc-bug_on mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-huge_pte_alloc-bug_on
+++ a/mm/hugetlb.c
@@ -4310,7 +4310,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 				pte = (pte_t *)pmd_alloc(mm, pud, addr);
 		}
 	}
-	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
+	BUG_ON(pte && pte_present(*pte) && !pte_huge(*pte));
 
 	return pte;
 }
_

Patches currently in -mm which might be from mhocko@suse.com are


