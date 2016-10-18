From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch added to
 -mm tree
Date: Tue, 18 Oct 2016 13:48:36 -0700
Message-ID: <58068aa4.EINI/D/NsT5lzfHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965377AbcJRUsh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 16:48:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: use huge_pte_lock instead of opencoding the lock
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch

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
Subject: mm/hugetlb.c: use huge_pte_lock instead of opencoding the lock

No functional change by this patch.

Link: http://lkml.kernel.org/r/20161018090234.22574-1-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock
+++ a/mm/hugetlb.c
@@ -3648,8 +3648,7 @@ retry:
 		vma_end_reservation(h, vma, address);
 	}
 
-	ptl = huge_pte_lockptr(h, mm, ptep);
-	spin_lock(ptl);
+	ptl = huge_pte_lock(h, mm, ptep);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
 	if (idx >= size)
 		goto backout;
@@ -4266,8 +4265,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!spte)
 		goto out;
 
-	ptl = huge_pte_lockptr(hstate_vma(vma), mm, spte);
-	spin_lock(ptl);
+	ptl = huge_pte_lock(hstate_vma(vma), mm, spte);
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-use-the-right-pte-val-for-compare-in-hugetlb_cow.patch
mm-hugetlb-use-huge_pte_lock-instead-of-opencoding-the-lock.patch

