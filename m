From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:55 -0700
Message-ID: <20121009181356.6A9F620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33221 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2JISN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:59 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so285733wib.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

In many places !pmd_present has been converted to pmd_none.  For pmds
that's equivalent and pmd_none is quicker so using pmd_none is better.

However (unless we delete pmd_present) we should provide an accurate
pmd_present too.  This will avoid the risk of code thinking the pmd is non
present because it's under __split_huge_page_map, see the pmd_mknotpresent
there and the comment above it.

If the page has been mprotected as PROT_NONE, it would also lead to a
pmd_present false negative in the same way as the race with
split_huge_page.

Because the PSE bit stays on at all times (both during split_huge_page and
when the _PAGE_PROTNONE bit get set), we could only check for the PSE bit,
but checking the PROTNONE bit too is still good to remember pmd_present
must always keep PROT_NONE into account.

This explains a not reproducible BUG_ON that was seldom reported on the
lists.

The same issue is in pmd_large, it would go wrong with both PROT_NONE and
if it races with split_huge_page.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp
+++ a/arch/x86/include/asm/pgtable.h
@@ -146,8 +146,7 @@ static inline unsigned long pmd_pfn(pmd_
 
 static inline int pmd_large(pmd_t pte)
 {
-	return (pmd_flags(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
-		(_PAGE_PSE | _PAGE_PRESENT);
+	return pmd_flags(pte) & _PAGE_PSE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -415,7 +414,13 @@ static inline int pte_hidden(pte_t pte)
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_PRESENT;
+	/*
+	 * Checking for _PAGE_PSE is needed too because
+	 * split_huge_page will temporarily clear the present bit (but
+	 * the _PAGE_PSE flag will remain set at all times while the
+	 * _PAGE_PRESENT bit is clear).
+	 */
+	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
 static inline int pmd_none(pmd_t pmd)
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

