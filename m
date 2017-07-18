From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-__get_user_pages-ignores-certain-follow_hugetlb_page-errors.patch added to -mm tree
Date: Tue, 18 Jul 2017 14:54:31 -0700
Message-ID: <596e8397.dd0bKEGWHP5y7oBY%akpm__39377.2265445024$1500414887$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdGRVyc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 17:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com, james.morse@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, stable@vger.kernel.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: __get_user_pages ignores certain follow_hugetlb_page errors
has been added to the -mm tree.  Its filename is
     mm-hugetlb-__get_user_pages-ignores-certain-follow_hugetlb_page-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-__get_user_pages-ignores-certain-follow_hugetlb_page-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-__get_user_pages-ignores-certain-follow_hugetlb_page-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: mm/hugetlb.c: __get_user_pages ignores certain follow_hugetlb_page errors

9a291a7c9428 ("mm/hugetlb: report -EHWPOISON not -EFAULT when
FOLL_HWPOISON is specified") causes __get_user_pages to ignore certain
errors from follow_hugetlb_page.  After such error, __get_user_pages
subsequently calls faultin_page on the same VMA and start address that
follow_hugetlb_page failed on instead of returning the error immediately
as it should.

In follow_hugetlb_page, when hugetlb_fault returns a value covered under
VM_FAULT_ERROR, follow_hugetlb_page returns it without setting nr_pages to
0 as __get_user_pages expects in this case, which causes the following to
happen in __get_user_pages: the "while (nr_pages)" check succeeds, we skip
the "if (!vma..." check because we got a VMA the last time around, we find
no page with follow_page_mask, and we call faultin_page, which calls
hugetlb_fault for the second time.

This issue also slightly changes how __get_user_pages works.  Before, it
only returned error if it had made no progress (i = 0).  But now,
follow_hugetlb_page can clobber "i" with an error code since its new
return path doesn't check for progress.  So if "i" is nonzero before a
failing call to follow_hugetlb_page, that indication of progress is lost
and __get_user_pages can return error even if some pages were successfully
pinned.

To fix this, change follow_hugetlb_page so that it updates nr_pages,
allowing __get_user_pages to fail immediately and restoring the "error
only if no progress" behavior to __get_user_pages.

Tested that __get_user_pages returns when expected on error from
hugetlb_fault in follow_hugetlb_page.

Fixes: 9a291a7c9428 ("mm/hugetlb: report -EHWPOISON not -EFAULT when FOLL_HWPOISON is specified")
Link: http://lkml.kernel.org/r/1500406795-58462-1-git-send-email-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: James Morse <james.morse@arm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: <stable@vger.kernel.org>	[4.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-__get_user_pages-ignores-certain-follow_hugetlb_page-errors mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-__get_user_pages-ignores-certain-follow_hugetlb_page-errors
+++ a/mm/hugetlb.c
@@ -4078,6 +4078,7 @@ long follow_hugetlb_page(struct mm_struc
 	unsigned long vaddr = *position;
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
+	int err = -EFAULT;
 
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -4154,11 +4155,7 @@ long follow_hugetlb_page(struct mm_struc
 			}
 			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
 			if (ret & VM_FAULT_ERROR) {
-				int err = vm_fault_to_errno(ret, flags);
-
-				if (err)
-					return err;
