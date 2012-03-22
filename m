From: akpm@linux-foundation.org
Subject: [merged] thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:20:12 -0700
Message-ID: <20120322202012.74B48A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34436 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab2CVUUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:14 -0400
Received: by eekc41 with SMTP id c41so136682eek.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: add HPAGE_PMD_* definitions for !CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: thp: add HPAGE_PMD_* definitions for !CONFIG_TRANSPARENT_HUGEPAGE

These macros will be used in a later patch, where all usages are expected
to be optimized away without #ifdef CONFIG_TRANSPARENT_HUGEPAGE.  But to
detect unexpected usages, we convert the existing BUG() to BUILD_BUG().

[akpm@linux-foundation.org: fix build in mm/pgtable-generic.c]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   11 ++++++-----
 mm/pgtable-generic.c    |    5 +++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/huge_mm.h~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage
+++ a/include/linux/huge_mm.h
@@ -51,6 +51,9 @@ extern pmd_t *page_check_address_pmd(str
 				     unsigned long address,
 				     enum page_check_address_pmd_flag flag);
 
+#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
+#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT HPAGE_SHIFT
 #define HPAGE_PMD_MASK HPAGE_MASK
@@ -102,8 +105,6 @@ extern void __split_huge_page_pmd(struct
 		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
 		       pmd_trans_huge(*____pmd));			\
 	} while (0)
-#define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
-#define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 #if HPAGE_PMD_ORDER > MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -158,9 +159,9 @@ static inline struct page *compound_tran
 	return page;
 }
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
-#define HPAGE_PMD_SHIFT ({ BUG(); 0; })
-#define HPAGE_PMD_MASK ({ BUG(); 0; })
-#define HPAGE_PMD_SIZE ({ BUG(); 0; })
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
 
diff -puN mm/pgtable-generic.c~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage
+++ a/mm/pgtable-generic.c
@@ -70,10 +70,11 @@ int pmdp_clear_flush_young(struct vm_are
 			   unsigned long address, pmd_t *pmdp)
 {
 	int young;
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+#else
 	BUG();
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
 	if (young)
 		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
linux-next.patch

