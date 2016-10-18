From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch added to
 -mm tree
Date: Tue, 18 Oct 2016 11:36:18 -0700
Message-ID: <58066ba2.6Po1x+tTywKmVql7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034332AbcJRSgT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 14:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, jstancek@redhat.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, mpe@ellerman.id.au, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: use the right pte val for compare in hugetlb_cow
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/hugetlb.c: use the right pte val for compare in hugetlb_cow

We cannot use the pte value used in set_pte_at for pte_same comparison,
because archs like ppc64, filter/add new pte flag in set_pte_at. Instead
fetch the pte value inside hugetlb_cow. We are comparing pte value to
make sure the pte didn't change since we dropped the page table lock.
hugetlb_cow get called with page table lock held, and we can take a copy
of the pte value before we drop the page table lock.

With hugetlbfs, we optimize the MAP_PRIVATE write fault path with no
previous mapping (huge_pte_none entries), by forcing a cow in the fault
path. This avoid take an addition fault to covert a read-only mapping
to read/write. Here we were comparing a recently instantiated pte (via
set_pte_at) to the pte values from linux page table. As explained above
on ppc64 such pte_same check returned wrong result, resulting in us
taking an additional fault on ppc64.

Fixes: 6a119eae942c ("powerpc/mm: Add a _PAGE_PTE bit")
Link: http://lkml.kernel.org/r/20161018154245.18023-1-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reported-by: Jan Stancek <jstancek@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow
+++ a/mm/hugetlb.c
@@ -3386,15 +3386,17 @@ static void unmap_ref_private(struct mm_
  * Keep the pte_same checks anyway to make transition from the mutex easier.
  */
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep, pte_t pte,
-			struct page *pagecache_page, spinlock_t *ptl)
+		       unsigned long address, pte_t *ptep,
+		       struct page *pagecache_page, spinlock_t *ptl)
 {
+	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
 	int ret = 0, outside_reserve = 0;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
+	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
 retry_avoidcopy:
@@ -3668,7 +3670,7 @@ retry:
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, page, ptl);
+		ret = hugetlb_cow(mm, vma, address, ptep, page, ptl);
 	}
 
 	spin_unlock(ptl);
@@ -3822,8 +3824,8 @@ int hugetlb_fault(struct mm_struct *mm,
 
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!huge_pte_write(entry)) {
-			ret = hugetlb_cow(mm, vma, address, ptep, entry,
-					pagecache_page, ptl);
+			ret = hugetlb_cow(mm, vma, address, ptep,
+					  pagecache_page, ptl);
 			goto out_put_page;
 		}
 		entry = huge_pte_mkdirty(entry);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch

