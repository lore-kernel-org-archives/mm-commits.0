From: akpm@linux-foundation.org
Subject: + mm-introduce-page_vma_mapped_walk.patch added to -mm tree
Date: Tue, 31 Jan 2017 16:10:03 -0800
Message-ID: <5891275b.nrXibVFM320cbgru%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdBAAKP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:10:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce page_vma_mapped_walk()
has been added to the -mm tree.  Its filename is
     mm-introduce-page_vma_mapped_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-page_vma_mapped_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-page_vma_mapped_walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce page_vma_mapped_walk()

Introduce a new interface to check if a page is mapped into a vma.  It
aims to address shortcomings of page_check_address{,_transhuge}.

Existing interface is not able to handle PTE-mapped THPs: it only finds
the first PTE.  The rest lefted unnoticed.

page_vma_mapped_walk() iterates over all possible mapping of the page in
the vma.

Link: http://lkml.kernel.org/r/20170129173858.45174-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   26 +++++
 mm/Makefile          |    6 -
 mm/huge_memory.c     |    9 +
 mm/page_vma_mapped.c |  188 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 224 insertions(+), 5 deletions(-)

diff -puN include/linux/rmap.h~mm-introduce-page_vma_mapped_walk include/linux/rmap.h
--- a/include/linux/rmap.h~mm-introduce-page_vma_mapped_walk
+++ a/include/linux/rmap.h
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/rwsem.h>
 #include <linux/memcontrol.h>
+#include <linux/highmem.h>
 
 /*
  * The anon_vma heads a list of private "related" vmas, to scan if
@@ -232,6 +233,31 @@ static inline bool page_check_address_tr
 }
 #endif
 
+/* Avoid racy checks */
+#define PVMW_SYNC		(1 << 0)
+/* Look for migarion entries rather than present PTEs */
+#define PVMW_MIGRATION		(1 << 1)
+
+struct page_vma_mapped_walk {
+	struct page *page;
+	struct vm_area_struct *vma;
+	unsigned long address;
+	pmd_t *pmd;
+	pte_t *pte;
+	spinlock_t *ptl;
+	unsigned int flags;
+};
+
+static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
+{
+	if (pvmw->pte)
+		pte_unmap(pvmw->pte);
+	if (pvmw->ptl)
+		spin_unlock(pvmw->ptl);
+}
+
+bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw);
+
 /*
  * Used by swapoff to help locate where page is expected in vma.
  */
diff -puN mm/Makefile~mm-introduce-page_vma_mapped_walk mm/Makefile
--- a/mm/Makefile~mm-introduce-page_vma_mapped_walk
+++ a/mm/Makefile
@@ -23,8 +23,10 @@ KCOV_INSTRUMENT_vmstat.o := n
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= gup.o highmem.o memory.o mincore.o \
-			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o pgtable-generic.o
+			   mlock.o mmap.o mprotect.o mremap.o msync.o \
+			   page_vma_mapped.o pagewalk.o pgtable-generic.o \
+			   rmap.o vmalloc.o
+
 
 ifdef CONFIG_CROSS_MEMORY_ATTACH
 mmu-$(CONFIG_MMU)	+= process_vm_access.o
diff -puN mm/huge_memory.c~mm-introduce-page_vma_mapped_walk mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-page_vma_mapped_walk
+++ a/mm/huge_memory.c
@@ -2129,9 +2129,12 @@ static void freeze_page(struct page *pag
 static void unfreeze_page(struct page *page)
 {
 	int i;
-
-	for (i = 0; i < HPAGE_PMD_NR; i++)
-		remove_migration_ptes(page + i, page + i, true);
+	if (PageTransHuge(page)) {
+		remove_migration_ptes(page, page, true);
+	} else {
+		for (i = 0; i < HPAGE_PMD_NR; i++)
+			remove_migration_ptes(page + i, page + i, true);
+	}
 }
 
 static void __split_huge_page_tail(struct page *head, int tail,
diff -puN /dev/null mm/page_vma_mapped.c
--- /dev/null
+++ a/mm/page_vma_mapped.c
@@ -0,0 +1,188 @@
+#include <linux/mm.h>
+#include <linux/rmap.h>
+#include <linux/hugetlb.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+
+#include "internal.h"
+
+static inline bool check_pmd(struct page_vma_mapped_walk *pvmw)
+{
+	pmd_t pmde;
+	/*
+	 * Make sure we don't re-load pmd between present and !trans_huge check.
+	 * We need a consistent view.
+	 */
+	pmde = READ_ONCE(*pvmw->pmd);
+	return pmd_present(pmde) && !pmd_trans_huge(pmde);
+}
+
+static inline bool not_found(struct page_vma_mapped_walk *pvmw)
+{
+	page_vma_mapped_walk_done(pvmw);
+	return false;
+}
+
+static bool map_pte(struct page_vma_mapped_walk *pvmw)
+{
+	pvmw->pte = pte_offset_map(pvmw->pmd, pvmw->address);
+	if (!(pvmw->flags & PVMW_SYNC)) {
+		if (pvmw->flags & PVMW_MIGRATION) {
+			if (!is_swap_pte(*pvmw->pte))
+				return false;
+		} else {
+			if (!pte_present(*pvmw->pte))
+				return false;
+		}
+	}
+	pvmw->ptl = pte_lockptr(pvmw->vma->vm_mm, pvmw->pmd);
+	spin_lock(pvmw->ptl);
+	return true;
+}
+
+static bool check_pte(struct page_vma_mapped_walk *pvmw)
+{
+	if (pvmw->flags & PVMW_MIGRATION) {
+#ifdef CONFIG_MIGRATION
+		swp_entry_t entry;
+		if (!is_swap_pte(*pvmw->pte))
+			return false;
+		entry = pte_to_swp_entry(*pvmw->pte);
+		if (!is_migration_entry(entry))
+			return false;
+		if (migration_entry_to_page(entry) - pvmw->page >=
+				hpage_nr_pages(pvmw->page)) {
+			return false;
+		}
+		if (migration_entry_to_page(entry) < pvmw->page)
+			return false;
+#else
+		WARN_ON_ONCE(1);
+#endif
+	} else {
+		if (!pte_present(*pvmw->pte))
+			return false;
+
+		/* THP can be referenced by any subpage */
+		if (pte_page(*pvmw->pte) - pvmw->page >=
+				hpage_nr_pages(pvmw->page)) {
+			return false;
+		}
+		if (pte_page(*pvmw->pte) < pvmw->page)
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * page_vma_mapped_walk - check if @pvmw->page is mapped in @pvmw->vma at
+ * @pvmw->address
+ * @pvmw: pointer to struct page_vma_mapped_walk. page, vma, address and flags
+ * must be set. pmd, pte and ptl must be NULL.
+ *
+ * Returns true if the page is mapped in the vma. @pvmw->pmd and @pvmw->pte point
+ * to relevant page table entries. @pvmw->ptl is locked. @pvmw->address is
+ * adjusted if needed (for PTE-mapped THPs).
+ *
+ * If @pvmw->pmd is set but @pvmw->pte is not, you have found PMD-mapped page
+ * (usually THP). For PTE-mapped THP, you should run page_vma_mapped_walk() in
+ * a loop to find all PTEs that map the THP.
+ *
+ * For HugeTLB pages, @pvmw->pte is set to the relevant page table entry
+ * regardless of which page table level the page is mapped at. @pvmw->pmd is
+ * NULL.
+ *
+ * Retruns false if there are no more page table entries for the page in
+ * the vma. @pvmw->ptl is unlocked and @pvmw->pte is unmapped.
+ *
+ * If you need to stop the walk before page_vma_mapped_walk() returned false,
+ * use page_vma_mapped_walk_done(). It will do the housekeeping.
+ */
+bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
+{
+	struct mm_struct *mm = pvmw->vma->vm_mm;
+	struct page *page = pvmw->page;
+	pgd_t *pgd;
+	pud_t *pud;
+
+	/* The only possible pmd mapping has been handled on last iteration */
+	if (pvmw->pmd && !pvmw->pte)
+		return not_found(pvmw);
+
+	/* Only for THP, seek to next pte entry makes sense */
+	if (pvmw->pte) {
+		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
+			return not_found(pvmw);
+		goto next_pte;
+	}
+
+	if (unlikely(PageHuge(pvmw->page))) {
+		/* when pud is not present, pte will be NULL */
+		pvmw->pte = huge_pte_offset(mm, pvmw->address);
+		if (!pvmw->pte)
+			return false;
+
+		pvmw->ptl = huge_pte_lockptr(page_hstate(page), mm, pvmw->pte);
+		spin_lock(pvmw->ptl);
+		if (!check_pte(pvmw))
+			return not_found(pvmw);
+		return true;
+	}
+restart:
+	pgd = pgd_offset(mm, pvmw->address);
+	if (!pgd_present(*pgd))
+		return false;
+	pud = pud_offset(pgd, pvmw->address);
+	if (!pud_present(*pud))
+		return false;
+	pvmw->pmd = pmd_offset(pud, pvmw->address);
+	if (pmd_trans_huge(*pvmw->pmd)) {
+		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+		if (!pmd_present(*pvmw->pmd))
+			return not_found(pvmw);
+		if (likely(pmd_trans_huge(*pvmw->pmd))) {
+			if (pvmw->flags & PVMW_MIGRATION)
+				return not_found(pvmw);
+			if (pmd_page(*pvmw->pmd) != page)
+				return not_found(pvmw);
+			return true;
+		} else {
+			/* THP pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		}
+	} else {
+		if (!check_pmd(pvmw))
+			return false;
+	}
+	if (!map_pte(pvmw))
+		goto next_pte;
+	while (1) {
+		if (check_pte(pvmw))
+			return true;
+next_pte:	do {
+			pvmw->address += PAGE_SIZE;
+			if (pvmw->address >=
+					__vma_address(pvmw->page, pvmw->vma) +
+					hpage_nr_pages(pvmw->page) * PAGE_SIZE)
+				return not_found(pvmw);
+			/* Did we cross page table boundary? */
+			if (pvmw->address % PMD_SIZE == 0) {
+				pte_unmap(pvmw->pte);
+				if (pvmw->ptl) {
+					spin_unlock(pvmw->ptl);
+					pvmw->ptl = NULL;
+				}
+				goto restart;
+			} else {
+				pvmw->pte++;
+			}
+		} while (pte_none(*pvmw->pte));
+
+		if (!pvmw->ptl) {
+			pvmw->ptl = pte_lockptr(mm, pvmw->pmd);
+			spin_lock(pvmw->ptl);
+		}
+	}
+}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-sleeping-function-called-from-invalid-context-shmem_undo_range.patch
mm-drop-zap_details-ignore_dirty.patch
mm-drop-zap_details-check_swap_entries.patch
mm-drop-unused-argument-of-zap_page_range.patch
oom-reaper-use-madvise_dontneed-logic-to-decide-if-unmap-the-vma.patch
uprobes-split-thps-before-trying-replace-them.patch
mm-introduce-page_vma_mapped_walk.patch
mm-fix-handling-pte-mapped-thps-in-page_referenced.patch
mm-fix-handling-pte-mapped-thps-in-page_idle_clear_pte_refs.patch
mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch
mm-convert-page_mkclean_one-to-use-page_vma_mapped_walk.patch
mm-convert-try_to_unmap_one-to-use-page_vma_mapped_walk.patch
mm-ksm-convert-write_protect_page-to-use-page_vma_mapped_walk.patch
mm-uprobes-convert-__replace_page-to-use-page_vma_mapped_walk.patch
mm-convert-page_mapped_in_vma-to-use-page_vma_mapped_walk.patch
mm-drop-page_check_address_transhuge.patch
mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

