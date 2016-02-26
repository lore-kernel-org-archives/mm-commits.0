From: akpm@linux-foundation.org
Subject: + mm-cleanup-pte_alloc-interfaces-fix.patch added to -mm tree
Date: Fri, 26 Feb 2016 13:48:18 -0800
Message-ID: <56d0c822.skJFMaOW1ptR8BeH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbcBZVsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 16:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudeep.holla@arm.com, kirill.shutemov@linux.intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix build for arm64 hugetlbpage
has been added to the -mm tree.  Its filename is
     mm-cleanup-pte_alloc-interfaces-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-pte_alloc-interfaces-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-pte_alloc-interfaces-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-cleanup-pte_alloc-interfaces-fix.patch

