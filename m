From: akpm@linux-foundation.org
Subject: [patch 28/41] hugetlb: fix nr_pmds accounting with shared page
 tables
Date: Fri, 24 Jun 2016 14:49:51 -0700
Message-ID: <576daaff.oOqVitlYpYfj4d2t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbcFXVtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, zhongjiang@huawei.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: hugetlb: fix nr_pmds accounting with shared page tables

We account HugeTLB's shared page table to all processes who share it.
The accounting happens during huge_pmd_share().

If somebody populates pud entry under us, we should decrease pagetable's
refcount and decrease nr_pmds of the process.

By mistake, I increase nr_pmds again in this case. :-/
It will lead to "BUG: non-zero nr_pmds on freeing mm: 2" on process'
exit.

Let's fix this by increasing nr_pmds only when we're sure that the page
table will be used.

Link: http://lkml.kernel.org/r/20160617122506.GC6534@node.shutemov.name
Fixes: dc6c9a35b66b ("mm: account pmd page tables to the process")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: zhongjiang <zhongjiang@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-nr_pmds-accounting-with-shared-page-tables mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-nr_pmds-accounting-with-shared-page-tables
+++ a/mm/hugetlb.c
@@ -4228,7 +4228,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 		if (saddr) {
 			spte = huge_pte_offset(svma->vm_mm, saddr);
 			if (spte) {
-				mm_inc_nr_pmds(mm);
 				get_page(virt_to_page(spte));
 				break;
 			}
@@ -4243,9 +4242,9 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		mm_inc_nr_pmds(mm);
 	} else {
 		put_page(virt_to_page(spte));
-		mm_inc_nr_pmds(mm);
 	}
 	spin_unlock(ptl);
 out:
_
