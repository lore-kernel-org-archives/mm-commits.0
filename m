From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-huge_pte_alloc-bug_on.patch added to -mm tree
Date: Mon, 01 Aug 2016 11:57:23 -0700
Message-ID: <579f9b93.m/yIzJ5RroVfcrhl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbcHAS5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 14:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, n-horiguchi@ah.jp.nec.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix huge_pte_alloc BUG_ON
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-huge_pte_alloc-bug_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-huge_pte_alloc-bug_on.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-huge_pte_alloc-bug_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-fix-huge_pte_alloc-bug_on.patch

