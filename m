From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch added to -mm
 tree
Date: Thu, 09 Apr 2015 12:45:13 -0700
Message-ID: <5526d6c9.RTvOS5b0imL0V4cg%akpm__28179.7751122669$1428608727$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbbDITpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2015 15:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, schwidefsky@de.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use pmd_page() in follow_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-pmd_page-in-follow_huge_pmd mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-pmd_page-in-follow_huge_pmd
+++ a/mm/hugetlb.c
@@ -3865,8 +3865,7 @@ retry:
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

mm-hugetlb-use-pmd_page-in-follow_huge_pmd.patch
s390-remove-use-of-seq_printf-return-value.patch

