From: akpm@linux-foundation.org
Subject: [merged] thp-add-pmd_modify.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:54 -0800
Message-ID: <201101142250.p0EMoiX9005435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901Ab1ANWu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add pmd_modify
has been removed from the -mm tree.  Its filename was
     thp-add-pmd_modify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add pmd_modify
From: Johannes Weiner <hannes@cmpxchg.org>

Add pmd_modify() for use with mprotect() on huge pmds.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h       |   10 ++++++++++
 arch/x86/include/asm/pgtable_types.h |    1 +
 2 files changed, 11 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~thp-add-pmd_modify arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~thp-add-pmd_modify
+++ a/arch/x86/include/asm/pgtable.h
@@ -325,6 +325,16 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte(val);
 }
 
+static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
+{
+	pmdval_t val = pmd_val(pmd);
+
+	val &= _HPAGE_CHG_MASK;
+	val |= massage_pgprot(newprot) & ~_HPAGE_CHG_MASK;
+
+	return __pmd(val);
+}
+
 /* mprotect needs to preserve PAT bits when updating vm_page_prot */
 #define pgprot_modify pgprot_modify
 static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
diff -puN arch/x86/include/asm/pgtable_types.h~thp-add-pmd_modify arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~thp-add-pmd_modify
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -72,6 +72,7 @@
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

