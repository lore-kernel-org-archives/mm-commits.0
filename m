From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 14:12:22 -0800
Message-ID: <54dd2546.QegBYa+7NsL0N6er%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbBLWMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:12:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.przywara@arm.com, mel@csn.ul.ie, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm/mm: fix compiler warning in pmdp_invalidate() (in -next)
has been removed from the -mm tree.  Its filename was
     mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix.patch

This patch was dropped because it was folded into mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch

------------------------------------------------------
From: Andre Przywara <andre.przywara@arm.com>
Subject: arm/mm: fix compiler warning in pmdp_invalidate() (in -next)

Commit ff61d185f4e7 ("mm: convert p[te|md]_mknonnuma and remaining
page table manipulations") removed a check in
mm/pgtable-generic.c:pmdp_invalidate(), which leaves the
pmd_mknotpresent macro the only user of the entry variable.
For ARM/LPAE we use a constant 0 without referencing the argument to
mark this condition, so the entry variable is no longer used here:

mm/pgtable-generic.c: In function 'pmdp_invalidate':
mm/pgtable-generic.c:195:8: warning: unused variable 'entry' [-Wunused-variable]
  pmd_t entry = *pmdp;
        ^

Replace the ARM macro implementation with a static inline function to
get rid of this warning.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -257,7 +257,10 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
 /* represent a notpresent pmd by zero, this is used by pmdp_invalidate */
-#define pmd_mknotpresent(pmd)	(__pmd(0))
+static inline pmd_t pmd_mknotpresent(pmd_t pmd)
+{
+	return 0;
+}
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
_

Patches currently in -mm which might be from andre.przywara@arm.com are

mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations-fix-fix.patch

