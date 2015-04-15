From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:07:41 -0700
Message-ID: <552eb6fd.wm4mrfoLQL84Iosj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbbDOTHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use pmd_page() in follow_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm/hugetlb: use pmd_page() in follow_huge_pmd()

commit 61f77eda "mm/hugetlb: reduce arch dependent code around
follow_huge_*" broke follow_huge_pmd() on s390, where pmd and pte layout
differ and using pte_page() on a huge pmd will return wrong results. 
Using pmd_page() instead fixes this.

All architectures that were touched by commit 61f77eda have pmd_page()
defined, so this should not break anything on other architectures.

Fixes: 61f77eda "mm/hugetlb: reduce arch dependent code around follow_huge_*"
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-pmd_page-in-follow_huge_pmd mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-pmd_page-in-follow_huge_pmd
+++ a/mm/hugetlb.c
@@ -3735,8 +3735,7 @@ retry:
 	if (!pmd_huge(*pmd))
 		goto out;
 	if (pmd_present(*pmd)) {
-		page = pte_page(*(pte_t *)pmd) +
-			((address & ~PMD_MASK) >> PAGE_SHIFT);
+		page = pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
 		if (flags & FOLL_GET)
 			get_page(page);
 	} else {
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch
s390-remove-use-of-seq_printf-return-value.patch

