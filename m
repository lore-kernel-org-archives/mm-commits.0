From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cleanup-pte_alloc-interfaces-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 13:55:57 -0700
Message-ID: <56eb19dd.0Xiib9xPsFvrrRER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437AbcCQUz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudeep.holla@arm.com, kirill.shutemov@linux.intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix build for arm64 hugetlbpage
has been removed from the -mm tree.  Its filename was
     mm-cleanup-pte_alloc-interfaces-fix.patch

This patch was dropped because it was folded into mm-cleanup-pte_alloc-interfaces.patch

------------------------------------------------------
From: Sudeep Holla <sudeep.holla@arm.com>
Subject: mm: fix build for arm64 hugetlbpage

Commit ("mm: cleanup *pte_alloc* interfaces") redefined pte_alloc_map()
using pte_alloc() and fixed all the callsites.  However arm64 callsite
seem to have got missed.  This patch fixes the same and thereby fixing the
following build error.

arch/arm64/mm/hugetlbpage.c: In function 'huge_pte_alloc':
arch/arm64/mm/hugetlbpage.c:127:42: error: macro "pte_alloc_map" passed 4 arguments, but takes just 3
   pte = pte_alloc_map(mm, NULL, pmd, addr);
                                          ^
arch/arm64/mm/hugetlbpage.c:127:9: error: 'pte_alloc_map' undeclared (first use in this function)
   pte = pte_alloc_map(mm, NULL, pmd, addr);
         ^
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm64/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces-fix arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~mm-cleanup-pte_alloc-interfaces-fix
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -124,7 +124,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 		 * will be no pte_unmap() to correspond with this
 		 * pte_alloc_map().
 		 */
-		pte = pte_alloc_map(mm, NULL, pmd, addr);
+		pte = pte_alloc_map(mm, pmd, addr);
 	} else if (sz == PMD_SIZE) {
 		if (IS_ENABLED(CONFIG_ARCH_WANT_HUGE_PMD_SHARE) &&
 		    pud_none(*pud))
_

Patches currently in -mm which might be from sudeep.holla@arm.com are

mm-cleanup-pte_alloc-interfaces.patch

