From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 118/128] mm: add functions to track page directory
 modifications
Date: Tue, 02 Jun 2020 13:17:17 -0700
Message-ID: <20200602201717.hX4FBbk1B%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBURT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:17:19 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, jroedel@suse.de, linux-mm@kvack.org, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org

From: Joerg Roedel <jroedel@suse.de>
Subject: mm: add functions to track page directory modifications

Patch series "mm: Get rid of vmalloc_sync_(un)mappings()", v3.

After the recent issue with vmalloc and tracing code[1] on x86 and a long
history of previous issues related to the vmalloc_sync_mappings()
interface, I thought the time has come to remove it.  Please see [2], [3],
and [4] for some other issues in the past.

The patches add tracking of page-table directory changes to the vmalloc
and ioremap code.  Depending on which page-table levels changes have been
made, a new per-arch function is called: arch_sync_kernel_mappings().

On x86-64 with 4-level paging, this function will not be called more than
64 times in a systems runtime (because vmalloc-space takes 64 PGD entries
which are only populated, but never cleared).

As a side effect this also allows to get rid of vmalloc faults on x86,
making it safe to touch vmalloc'ed memory in the page-fault handler.  Note
that this potentially includes per-cpu memory.


This patch (of 7):

Add page-table allocation functions which will keep track of changed
directory entries.  They are needed for new PGD, P4D, PUD, and PMD entries
and will be used in vmalloc and ioremap code to decide whether any changes
in the kernel mappings need to be synchronized between page-tables in the
system.

Link: http://lkml.kernel.org/r/20200515140023.25469-1-joro@8bytes.org
Link: http://lkml.kernel.org/r/20200515140023.25469-2-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/5level-fixup.h |    5 +-
 include/asm-generic/pgtable.h      |   23 +++++++++++++
 include/linux/mm.h                 |   46 +++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 2 deletions(-)

--- a/include/asm-generic/5level-fixup.h~mm-add-functions-to-track-page-directory-modifications
+++ a/include/asm-generic/5level-fixup.h
@@ -17,8 +17,9 @@
 	((unlikely(pgd_none(*(p4d))) && __pud_alloc(mm, p4d, address)) ? \
 		NULL : pud_offset(p4d, address))
 
-#define p4d_alloc(mm, pgd, address)	(pgd)
-#define p4d_offset(pgd, start)		(pgd)
+#define p4d_alloc(mm, pgd, address)		(pgd)
+#define p4d_alloc_track(mm, pgd, address, mask)	(pgd)
+#define p4d_offset(pgd, start)			(pgd)
 
 #ifndef __ASSEMBLY__
 static inline int p4d_none(p4d_t p4d)
--- a/include/asm-generic/pgtable.h~mm-add-functions-to-track-page-directory-modifications
+++ a/include/asm-generic/pgtable.h
@@ -1213,6 +1213,29 @@ static inline bool arch_has_pfn_modify_c
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
 #endif
 
+/*
+ * Page Table Modification bits for pgtbl_mod_mask.
+ *
+ * These are used by the p?d_alloc_track*() set of functions an in the generic
+ * vmalloc/ioremap code to track at which page-table levels entries have been
+ * modified. Based on that the code can better decide when vmalloc and ioremap
+ * mapping changes need to be synchronized to other page-tables in the system.
+ */
+#define		__PGTBL_PGD_MODIFIED	0
+#define		__PGTBL_P4D_MODIFIED	1
+#define		__PGTBL_PUD_MODIFIED	2
+#define		__PGTBL_PMD_MODIFIED	3
+#define		__PGTBL_PTE_MODIFIED	4
+
+#define		PGTBL_PGD_MODIFIED	BIT(__PGTBL_PGD_MODIFIED)
+#define		PGTBL_P4D_MODIFIED	BIT(__PGTBL_P4D_MODIFIED)
+#define		PGTBL_PUD_MODIFIED	BIT(__PGTBL_PUD_MODIFIED)
+#define		PGTBL_PMD_MODIFIED	BIT(__PGTBL_PMD_MODIFIED)
+#define		PGTBL_PTE_MODIFIED	BIT(__PGTBL_PTE_MODIFIED)
+
+/* Page-Table Modification Mask */
+typedef unsigned int pgtbl_mod_mask;
+
 #endif /* !__ASSEMBLY__ */
 
 #ifndef io_remap_pfn_range
--- a/include/linux/mm.h~mm-add-functions-to-track-page-directory-modifications
+++ a/include/linux/mm.h
@@ -2087,13 +2087,54 @@ static inline pud_t *pud_alloc(struct mm
 	return (unlikely(p4d_none(*p4d)) && __pud_alloc(mm, p4d, address)) ?
 		NULL : pud_offset(p4d, address);
 }
+
+static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
+				     unsigned long address,
+				     pgtbl_mod_mask *mod_mask)
+
+{
+	if (unlikely(pgd_none(*pgd))) {
+		if (__p4d_alloc(mm, pgd, address))
+			return NULL;
+		*mod_mask |= PGTBL_PGD_MODIFIED;
+	}
+
+	return p4d_offset(pgd, address);
+}
+
 #endif /* !__ARCH_HAS_5LEVEL_HACK */
 
+static inline pud_t *pud_alloc_track(struct mm_struct *mm, p4d_t *p4d,
+				     unsigned long address,
+				     pgtbl_mod_mask *mod_mask)
+{
+	if (unlikely(p4d_none(*p4d))) {
+		if (__pud_alloc(mm, p4d, address))
+			return NULL;
+		*mod_mask |= PGTBL_P4D_MODIFIED;
+	}
+
+	return pud_offset(p4d, address);
+}
+
 static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 {
 	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
 		NULL: pmd_offset(pud, address);
 }
+
+static inline pmd_t *pmd_alloc_track(struct mm_struct *mm, pud_t *pud,
+				     unsigned long address,
+				     pgtbl_mod_mask *mod_mask)
+{
+	if (unlikely(pud_none(*pud))) {
+		if (__pmd_alloc(mm, pud, address))
+			return NULL;
+		*mod_mask |= PGTBL_PUD_MODIFIED;
+	}
+
+	return pmd_offset(pud, address);
+}
 #endif /* CONFIG_MMU */
 
 #if USE_SPLIT_PTE_PTLOCKS
@@ -2209,6 +2250,11 @@ static inline void pgtable_pte_page_dtor
 	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd))? \
 		NULL: pte_offset_kernel(pmd, address))
 
+#define pte_alloc_kernel_track(pmd, address, mask)			\
+	((unlikely(pmd_none(*(pmd))) &&					\
+	  (__pte_alloc_kernel(pmd) || ({*(mask)|=PGTBL_PMD_MODIFIED;0;})))?\
+		NULL: pte_offset_kernel(pmd, address))
+
 #if USE_SPLIT_PMD_PTLOCKS
 
 static struct page *pmd_to_page(pmd_t *pmd)
_
