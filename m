From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 038/166] mm: merge parameters for
 change_protection()
Date: Mon, 06 Apr 2020 20:05:45 -0700
Message-ID: <20200407030545.8Ao2GxjZU%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgDGDFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:05:50 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, torvalds@linux-foundation.org, xemul@openvz.org

From: Peter Xu <peterx@redhat.com>
Subject: mm: merge parameters for change_protection()

change_protection() was used by either the NUMA or mprotect() code,
there's one parameter for each of the callers (dirty_accountable and
prot_numa).  Further, these parameters are passed along the calls:

  - change_protection_range()
  - change_p4d_range()
  - change_pud_range()
  - change_pmd_range()
  - ...

Now we introduce a flag for change_protect() and all these helpers to
replace these parameters.  Then we can avoid passing multiple parameters
multiple times along the way.

More importantly, it'll greatly simplify the work if we want to introduce
any new parameters to change_protection().  In the follow up patches, a
new parameter for userfaultfd write protection will be introduced.

No functional change at all.

Link: http://lkml.kernel.org/r/20200220163112.11409-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 include/linux/mm.h      |   14 +++++++++++++-
 mm/huge_memory.c        |    3 ++-
 mm/mempolicy.c          |    2 +-
 mm/mprotect.c           |   29 ++++++++++++++++-------------
 5 files changed, 33 insertions(+), 17 deletions(-)

--- a/include/linux/huge_mm.h~mm-merge-parameters-for-change_protection
+++ a/include/linux/huge_mm.h
@@ -46,7 +46,7 @@ extern bool move_huge_pmd(struct vm_area
 			 pmd_t *old_pmd, pmd_t *new_pmd);
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
-			int prot_numa);
+			unsigned long cp_flags);
 vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
 				   pgprot_t pgprot, bool write);
 
--- a/include/linux/mm.h~mm-merge-parameters-for-change_protection
+++ a/include/linux/mm.h
@@ -1771,9 +1771,21 @@ extern unsigned long move_page_tables(st
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
 		bool need_rmap_locks);
+
+/*
+ * Flags used by change_protection().  For now we make it a bitmap so
+ * that we can pass in multiple flags just like parameters.  However
+ * for now all the callers are only use one of the flags at the same
+ * time.
+ */
+/* Whether we should allow dirty bit accounting */
+#define  MM_CP_DIRTY_ACCT                  (1UL << 0)
+/* Whether this protection change is for NUMA hints */
+#define  MM_CP_PROT_NUMA                   (1UL << 1)
+
 extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
-			      int dirty_accountable, int prot_numa);
+			      unsigned long cp_flags);
 extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
--- a/mm/huge_memory.c~mm-merge-parameters-for-change_protection
+++ a/mm/huge_memory.c
@@ -1979,13 +1979,14 @@ bool move_huge_pmd(struct vm_area_struct
  *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
  */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, pgprot_t newprot, int prot_numa)
+		unsigned long addr, pgprot_t newprot, unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
 	pmd_t entry;
 	bool preserve_write;
 	int ret;
+	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
--- a/mm/mempolicy.c~mm-merge-parameters-for-change_protection
+++ a/mm/mempolicy.c
@@ -627,7 +627,7 @@ unsigned long change_prot_numa(struct vm
 {
 	int nr_updated;
 
-	nr_updated = change_protection(vma, addr, end, PAGE_NONE, 0, 1);
+	nr_updated = change_protection(vma, addr, end, PAGE_NONE, MM_CP_PROT_NUMA);
 	if (nr_updated)
 		count_vm_numa_events(NUMA_PTE_UPDATES, nr_updated);
 
--- a/mm/mprotect.c~mm-merge-parameters-for-change_protection
+++ a/mm/mprotect.c
@@ -37,12 +37,14 @@
 
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa)
+		unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	unsigned long pages = 0;
 	int target_node = NUMA_NO_NODE;
+	bool dirty_accountable = cp_flags & MM_CP_DIRTY_ACCT;
+	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 
 	/*
 	 * Can be called with only the mmap_sem for reading by
@@ -188,7 +190,7 @@ static inline int pmd_none_or_clear_bad_
 
 static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
-		pgprot_t newprot, int dirty_accountable, int prot_numa)
+		pgprot_t newprot, unsigned long cp_flags)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -229,7 +231,7 @@ static inline unsigned long change_pmd_r
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
 				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-						newprot, prot_numa);
+							      newprot, cp_flags);
 
 				if (nr_ptes) {
 					if (nr_ptes == HPAGE_PMD_NR) {
@@ -244,7 +246,7 @@ static inline unsigned long change_pmd_r
 			/* fall through, the trans huge pmd just split */
 		}
 		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
-				 dirty_accountable, prot_numa);
+					      cp_flags);
 		pages += this_pages;
 next:
 		cond_resched();
@@ -260,7 +262,7 @@ next:
 
 static inline unsigned long change_pud_range(struct vm_area_struct *vma,
 		p4d_t *p4d, unsigned long addr, unsigned long end,
-		pgprot_t newprot, int dirty_accountable, int prot_numa)
+		pgprot_t newprot, unsigned long cp_flags)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -272,7 +274,7 @@ static inline unsigned long change_pud_r
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		pages += change_pmd_range(vma, pud, addr, next, newprot,
-				 dirty_accountable, prot_numa);
+					  cp_flags);
 	} while (pud++, addr = next, addr != end);
 
 	return pages;
@@ -280,7 +282,7 @@ static inline unsigned long change_pud_r
 
 static inline unsigned long change_p4d_range(struct vm_area_struct *vma,
 		pgd_t *pgd, unsigned long addr, unsigned long end,
-		pgprot_t newprot, int dirty_accountable, int prot_numa)
+		pgprot_t newprot, unsigned long cp_flags)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -292,7 +294,7 @@ static inline unsigned long change_p4d_r
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
 		pages += change_pud_range(vma, p4d, addr, next, newprot,
-				 dirty_accountable, prot_numa);
+					  cp_flags);
 	} while (p4d++, addr = next, addr != end);
 
 	return pages;
@@ -300,7 +302,7 @@ static inline unsigned long change_p4d_r
 
 static unsigned long change_protection_range(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa)
+		unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgd_t *pgd;
@@ -317,7 +319,7 @@ static unsigned long change_protection_r
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
 		pages += change_p4d_range(vma, pgd, addr, next, newprot,
-				 dirty_accountable, prot_numa);
+					  cp_flags);
 	} while (pgd++, addr = next, addr != end);
 
 	/* Only flush the TLB if we actually modified any entries: */
@@ -330,14 +332,15 @@ static unsigned long change_protection_r
 
 unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end, pgprot_t newprot,
-		       int dirty_accountable, int prot_numa)
+		       unsigned long cp_flags)
 {
 	unsigned long pages;
 
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot);
 	else
-		pages = change_protection_range(vma, start, end, newprot, dirty_accountable, prot_numa);
+		pages = change_protection_range(vma, start, end, newprot,
+						cp_flags);
 
 	return pages;
 }
@@ -459,7 +462,7 @@ success:
 	vma_set_page_prot(vma);
 
 	change_protection(vma, start, end, vma->vm_page_prot,
-			  dirty_accountable, 0);
+			  dirty_accountable ? MM_CP_DIRTY_ACCT : 0);
 
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
_
