From: akpm@linux-foundation.org
Subject: [patch 028/123] mm/hugetlb.c: use huge_pte_lock instead of
 opencoding the lock
Date: Mon, 12 Dec 2016 16:41:59 -0800
Message-ID: <584f43d7.qmMA0aGyE50fjlB8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbcLMAmA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:42:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com

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
@@ -3713,8 +3713,7 @@ retry:
 		vma_end_reservation(h, vma, address);
 	}
 
-	ptl = huge_pte_lockptr(h, mm, ptep);
-	spin_lock(ptl);
+	ptl = huge_pte_lock(h, mm, ptep);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
 	if (idx >= size)
 		goto backout;
@@ -4332,8 +4331,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!spte)
 		goto out;
 
-	ptl = huge_pte_lockptr(hstate_vma(vma), mm, spte);
-	spin_lock(ptl);
+	ptl = huge_pte_lock(hstate_vma(vma), mm, spte);
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
_
