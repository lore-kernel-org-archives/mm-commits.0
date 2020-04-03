From: akpm@linux-foundation.org
Subject: [merged]
 mm-mapping_dirty_helpers-update-huge-page-table-entry-callbacks.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:06 -0700
Message-ID: <20200403203806.laEZuUojV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUiH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, steven.price@arm.com, thellstrom@vmware.com


The patch titled
     Subject: mm/mapping_dirty_helpers: update huge page-table entry callbacks
has been removed from the -mm tree.  Its filename was
     mm-mapping_dirty_helpers-update-huge-page-table-entry-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Hellstrom <thellstrom@vmware.com>
Subject: mm/mapping_dirty_helpers: update huge page-table entry callbacks

Following the update of pagewalk code commit a07984d48146 ("mm: pagewalk:
add p4d_entry() and pgd_entry()") we can modify the mapping_dirty_helpers'
huge page-table entry callbacks to avoid splitting when a huge pud or -pmd
is encountered.

Link: http://lkml.kernel.org/r/20200203154305.15045-1-thomas_os@shipmail.org
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |   42 +++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-update-huge-page-table-entry-callbacks
+++ a/mm/mapping_dirty_helpers.c
@@ -111,26 +111,60 @@ static int clean_record_pte(pte_t *pte,
 	return 0;
 }
 
-/* wp_clean_pmd_entry - The pagewalk pmd callback. */
+/*
+ * wp_clean_pmd_entry - The pagewalk pmd callback.
+ *
+ * Dirty-tracking should take place on the PTE level, so
+ * WARN() if encountering a dirty huge pmd.
+ * Furthermore, never split huge pmds, since that currently
+ * causes dirty info loss. The pagefault handler should do
+ * that if needed.
+ */
 static int wp_clean_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
-	/* Dirty-tracking should be handled on the pte level */
 	pmd_t pmdval = pmd_read_atomic(pmd);
 
+	if (!pmd_trans_unstable(&pmdval))
+		return 0;
+
+	if (pmd_none(pmdval)) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+
+	/* Huge pmd, present or migrated */
+	walk->action = ACTION_CONTINUE;
 	if (pmd_trans_huge(pmdval) || pmd_devmap(pmdval))
 		WARN_ON(pmd_write(pmdval) || pmd_dirty(pmdval));
 
 	return 0;
 }
 
-/* wp_clean_pud_entry - The pagewalk pud callback. */
+/*
+ * wp_clean_pud_entry - The pagewalk pud callback.
+ *
+ * Dirty-tracking should take place on the PTE level, so
+ * WARN() if encountering a dirty huge puds.
+ * Furthermore, never split huge puds, since that currently
+ * causes dirty info loss. The pagefault handler should do
+ * that if needed.
+ */
 static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
-	/* Dirty-tracking should be handled on the pte level */
 	pud_t pudval = READ_ONCE(*pud);
 
+	if (!pud_trans_unstable(&pudval))
+		return 0;
+
+	if (pud_none(pudval)) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+
+	/* Huge pud */
+	walk->action = ACTION_CONTINUE;
 	if (pud_trans_huge(pudval) || pud_devmap(pudval))
 		WARN_ON(pud_write(pudval) || pud_dirty(pudval));
 
_

Patches currently in -mm which might be from thellstrom@vmware.com are
