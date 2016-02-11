From: akpm@linux-foundation.org
Subject: +
 mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range.patch
 added to -mm tree
Date: Thu, 11 Feb 2016 14:05:30 -0800
Message-ID: <56bd05aa.VF6zEbv1QLBcFCPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbcBKWFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Feb 2016 17:05:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, Vineet.Gupta1@synopsys.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp/migration: switch from flush_tlb_range to flush_pmd_tlb_range
has been added to the -mm tree.  Its filename is
     mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp/migration: switch from flush_tlb_range to flush_pmd_tlb_range

We remove one instace of flush_tlb_range here.  That was added by
f714f4f20e59ea6eea ("mm: numa: call MMU notifiers on THP migration").  But
the pmdp_huge_clear_flush_notify should have done the require flush for
us.  Hence remove the extra flush.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   17 +++++++++++++++++
 mm/migrate.c                  |    8 +++++---
 mm/pgtable-generic.c          |   14 --------------
 3 files changed, 22 insertions(+), 17 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range
+++ a/include/asm-generic/pgtable.h
@@ -775,6 +775,23 @@ static inline int pmd_clear_huge(pmd_t *
 }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
+#ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/*
+ * ARCHes with special requirements for evicting THP backing TLB entries can
+ * implement this. Otherwise also, it can help optimize normal TLB flush in
+ * THP regime. stock flush_tlb_range() typically has optimization to nuke the
+ * entire TLB TLB if flush span is greater than a threshold, which will
+ * likely be true for a single huge page. Thus a single thp flush will
+ * invalidate the entire TLB which is not desitable.
+ * e.g. see arch/arc: flush_pmd_tlb_range
+ */
+#define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
+#else
+#define flush_pmd_tlb_range(vma, addr, end)	BUILD_BUG()
+#endif
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #ifndef io_remap_pfn_range
diff -puN mm/migrate.c~mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range mm/migrate.c
--- a/mm/migrate.c~mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range
+++ a/mm/migrate.c
@@ -1773,7 +1773,10 @@ int migrate_misplaced_transhuge_page(str
 		put_page(new_page);
 		goto out_fail;
 	}
-
+	/*
+	 * We are not sure a pending tlb flush here is for a huge page
+	 * mapping or not. Hence use the tlb range variant
+	 */
 	if (mm_tlb_flush_pending(mm))
 		flush_tlb_range(vma, mmun_start, mmun_end);
 
@@ -1829,12 +1832,11 @@ fail_putback:
 	page_add_anon_rmap(new_page, vma, mmun_start, true);
 	pmdp_huge_clear_flush_notify(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
-	flush_tlb_range(vma, mmun_start, mmun_end);
 	update_mmu_cache_pmd(vma, address, &entry);
 
 	if (page_count(page) != 2) {
 		set_pmd_at(mm, mmun_start, pmd, orig_entry);
-		flush_tlb_range(vma, mmun_start, mmun_end);
+		flush_pmd_tlb_range(vma, mmun_start, mmun_end);
 		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
 		update_mmu_cache_pmd(vma, address, &entry);
 		page_remove_rmap(new_page, true);
diff -puN mm/pgtable-generic.c~mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-migration-switch-from-flush_tlb_range-to-flush_pmd_tlb_range
+++ a/mm/pgtable-generic.c
@@ -84,20 +84,6 @@ pte_t ptep_clear_flush(struct vm_area_st
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
-
-/*
- * ARCHes with special requirements for evicting THP backing TLB entries can
- * implement this. Otherwise also, it can help optimize normal TLB flush in
- * THP regime. stock flush_tlb_range() typically has optimization to nuke the
- * entire TLB if flush span is greater than a threshold, which will
- * likely be true for a single huge page. Thus a single thp flush will
- * invalidate the entire TLB which is not desirable.
- * e.g. see arch/arc: flush_pmd_tlb_range
- */
-#define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
-#endif
