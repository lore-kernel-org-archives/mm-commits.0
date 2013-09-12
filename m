From: akpm@linux-foundation.org
Subject: [merged] mm-move-pgtable-related-functions-to-right-place.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:25 -0700
Message-ID: <5232195d.3JUOFdqYJ6T9l10N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3ILTn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: [merged] mm-move-pgtable-related-functions-to-right-place.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,mgorman@suse.de,minchan@kernel.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:25 -0700


The patch titled
     Subject: mm: move pgtable related functions to right place
has been removed from the -mm tree.  Its filename was
     mm-move-pgtable-related-functions-to-right-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: move pgtable related functions to right place

pgtable related functions are mostly in pgtable-generic.c.
So move remaining functions from memory.c to pgtable-generic.c.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c          |   24 ------------------------
 mm/pgtable-generic.c |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN mm/memory.c~mm-move-pgtable-related-functions-to-right-place mm/memory.c
--- a/mm/memory.c~mm-move-pgtable-related-functions-to-right-place
+++ a/mm/memory.c
@@ -373,30 +373,6 @@ void tlb_remove_table(struct mmu_gather
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
 /*
- * If a p?d_bad entry is found while walking page tables, report
- * the error, before resetting entry to p?d_none.  Usually (but
- * very seldom) called out from the p?d_none_or_clear_bad macros.
- */
-
-void pgd_clear_bad(pgd_t *pgd)
-{
-	pgd_ERROR(*pgd);
-	pgd_clear(pgd);
-}
-
-void pud_clear_bad(pud_t *pud)
-{
-	pud_ERROR(*pud);
-	pud_clear(pud);
-}
-
-void pmd_clear_bad(pmd_t *pmd)
-{
-	pmd_ERROR(*pmd);
-	pmd_clear(pmd);
-}
-
-/*
  * Note: this doesn't free the actual pages themselves. That
  * has been handled earlier when unmapping all the memory regions.
  */
diff -puN mm/pgtable-generic.c~mm-move-pgtable-related-functions-to-right-place mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-move-pgtable-related-functions-to-right-place
+++ a/mm/pgtable-generic.c
@@ -10,6 +10,30 @@
 #include <asm/tlb.h>
 #include <asm-generic/pgtable.h>
 
+/*
+ * If a p?d_bad entry is found while walking page tables, report
+ * the error, before resetting entry to p?d_none.  Usually (but
+ * very seldom) called out from the p?d_none_or_clear_bad macros.
+ */
+
+void pgd_clear_bad(pgd_t *pgd)
+{
+	pgd_ERROR(*pgd);
+	pgd_clear(pgd);
+}
+
+void pud_clear_bad(pud_t *pud)
+{
+	pud_ERROR(*pud);
+	pud_clear(pud);
+}
+
+void pmd_clear_bad(pmd_t *pmd)
+{
+	pmd_ERROR(*pmd);
+	pmd_clear(pmd);
+}
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
  * Only sets the access flags (dirty, accessed), as well as write 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

