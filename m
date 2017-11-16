From: akpm@linux-foundation.org
Subject: [patch 072/131] mm: introduce wrappers to access
 mm->nr_ptes
Date: Wed, 15 Nov 2017 17:35:37 -0800
Message-ID: <20171116013537.s_E4tCOhm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39644 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933032AbdKPBfi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce wrappers to access mm->nr_ptes

Let's add wrappers for ->nr_ptes with the same interface as for nr_pmd and
nr_pud.

The patch also makes nr_ptes accounting dependent onto CONFIG_MMU.  Page
table accounting doesn't make sense if you don't have page tables.

It's preparation for consolidation of page-table counters in mm_struct.

Link: http://lkml.kernel.org/r/20171006100651.44742-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pgd.c           |    2 +-
 arch/sparc/mm/hugetlbpage.c |    2 +-
 arch/unicore32/mm/pgd.c     |    2 +-
 fs/proc/task_mmu.c          |    2 +-
 include/linux/mm.h          |   32 ++++++++++++++++++++++++++++++++
 include/linux/mm_types.h    |    2 ++
 kernel/fork.c               |    6 +++---
 mm/debug.c                  |    2 +-
 mm/huge_memory.c            |   10 +++++-----
 mm/khugepaged.c             |    2 +-
 mm/memory.c                 |    8 ++++----
 mm/oom_kill.c               |    5 ++---
 12 files changed, 54 insertions(+), 21 deletions(-)

diff -puN arch/arm/mm/pgd.c~mm-introduce-wrappers-to-access-mm-nr_ptes arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/arch/arm/mm/pgd.c
@@ -141,7 +141,7 @@ void pgd_free(struct mm_struct *mm, pgd_
 	pte = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
 	pte_free(mm, pte);
-	atomic_long_dec(&mm->nr_ptes);
+	mm_dec_nr_ptes(mm);
 no_pmd:
 	pud_clear(pud);
 	pmd_free(mm, pmd);
diff -puN arch/sparc/mm/hugetlbpage.c~mm-introduce-wrappers-to-access-mm-nr_ptes arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -397,7 +397,7 @@ static void hugetlb_free_pte_range(struc
 
 	pmd_clear(pmd);
 	pte_free_tlb(tlb, token, addr);
-	atomic_long_dec(&tlb->mm->nr_ptes);
+	mm_dec_nr_ptes(tlb->mm);
 }
 
 static void hugetlb_free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
diff -puN arch/unicore32/mm/pgd.c~mm-introduce-wrappers-to-access-mm-nr_ptes arch/unicore32/mm/pgd.c
--- a/arch/unicore32/mm/pgd.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/arch/unicore32/mm/pgd.c
@@ -97,7 +97,7 @@ void free_pgd_slow(struct mm_struct *mm,
 	pte = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
 	pte_free(mm, pte);
-	atomic_long_dec(&mm->nr_ptes);
+	mm_dec_nr_ptes(mm);
 	pmd_free(mm, pmd);
 	mm_dec_nr_pmds(mm);
 free:
diff -puN fs/proc/task_mmu.c~mm-introduce-wrappers-to-access-mm-nr_ptes fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/fs/proc/task_mmu.c
@@ -50,7 +50,7 @@ void task_mem(struct seq_file *m, struct
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
 	swap = get_mm_counter(mm, MM_SWAPENTS);
-	ptes = PTRS_PER_PTE * sizeof(pte_t) * atomic_long_read(&mm->nr_ptes);
+	ptes = PTRS_PER_PTE * sizeof(pte_t) * mm_nr_ptes(mm);
 	pmds = PTRS_PER_PMD * sizeof(pmd_t) * mm_nr_pmds(mm);
 	puds = PTRS_PER_PUD * sizeof(pud_t) * mm_nr_puds(mm);
 	seq_printf(m,
diff -puN include/linux/mm.h~mm-introduce-wrappers-to-access-mm-nr_ptes include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/include/linux/mm.h
@@ -1680,6 +1680,38 @@ static inline void mm_dec_nr_pmds(struct
 }
 #endif
 
+#ifdef CONFIG_MMU
+static inline void mm_nr_ptes_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->nr_ptes, 0);
+}
+
+static inline unsigned long mm_nr_ptes(const struct mm_struct *mm)
+{
+	return atomic_long_read(&mm->nr_ptes);
+}
+
+static inline void mm_inc_nr_ptes(struct mm_struct *mm)
+{
+	atomic_long_inc(&mm->nr_ptes);
+}
+
+static inline void mm_dec_nr_ptes(struct mm_struct *mm)
+{
+	atomic_long_dec(&mm->nr_ptes);
+}
+#else
+static inline void mm_nr_ptes_init(struct mm_struct *mm) {}
+
+static inline unsigned long mm_nr_ptes(const struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void mm_inc_nr_ptes(struct mm_struct *mm) {}
+static inline void mm_dec_nr_ptes(struct mm_struct *mm) {}
+#endif
+
 int __pte_alloc(struct mm_struct *mm, pmd_t *pmd, unsigned long address);
 int __pte_alloc_kernel(pmd_t *pmd, unsigned long address);
 
diff -puN include/linux/mm_types.h~mm-introduce-wrappers-to-access-mm-nr_ptes include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/include/linux/mm_types.h
@@ -401,7 +401,9 @@ struct mm_struct {
 	 */
 	atomic_t mm_count;
 
+#ifdef CONFIG_MMU
 	atomic_long_t nr_ptes;			/* PTE page table pages */
+#endif
 #if CONFIG_PGTABLE_LEVELS > 2
 	atomic_long_t nr_pmds;			/* PMD page table pages */
 #endif
diff -puN kernel/fork.c~mm-introduce-wrappers-to-access-mm-nr_ptes kernel/fork.c
--- a/kernel/fork.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/kernel/fork.c
@@ -817,7 +817,7 @@ static struct mm_struct *mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
-	atomic_long_set(&mm->nr_ptes, 0);
+	mm_nr_ptes_init(mm);
 	mm_nr_pmds_init(mm);
 	mm_nr_puds_init(mm);
 	mm->map_count = 0;
@@ -873,9 +873,9 @@ static void check_mm(struct mm_struct *m
 					  "mm:%p idx:%d val:%ld\n", mm, i, x);
 	}
 
-	if (atomic_long_read(&mm->nr_ptes))
+	if (mm_nr_ptes(mm))
 		pr_alert("BUG: non-zero nr_ptes on freeing mm: %ld\n",
-				atomic_long_read(&mm->nr_ptes));
+				mm_nr_ptes(mm));
 	if (mm_nr_pmds(mm))
 		pr_alert("BUG: non-zero nr_pmds on freeing mm: %ld\n",
 				mm_nr_pmds(mm));
diff -puN mm/debug.c~mm-introduce-wrappers-to-access-mm-nr_ptes mm/debug.c
--- a/mm/debug.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/mm/debug.c
@@ -136,7 +136,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->mmap_base, mm->mmap_legacy_base, mm->highest_vm_end,
 		mm->pgd, atomic_read(&mm->mm_users),
 		atomic_read(&mm->mm_count),
-		atomic_long_read((atomic_long_t *)&mm->nr_ptes),
+		mm_nr_ptes(mm),
 		mm_nr_pmds(mm),
 		mm_nr_puds(mm),
 		mm->map_count,
diff -puN mm/huge_memory.c~mm-introduce-wrappers-to-access-mm-nr_ptes mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/mm/huge_memory.c
@@ -606,7 +606,7 @@ static int __do_huge_pmd_anonymous_page(
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		atomic_long_inc(&vma->vm_mm->nr_ptes);
+		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 	}
@@ -662,7 +662,7 @@ static bool set_huge_zero_page(pgtable_t
 	if (pgtable)
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
-	atomic_long_inc(&mm->nr_ptes);
+	mm_inc_nr_ptes(mm);
 	return true;
 }
 
@@ -747,7 +747,7 @@ static void insert_pfn_pmd(struct vm_are
 
 	if (pgtable) {
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
-		atomic_long_inc(&mm->nr_ptes);
+		mm_inc_nr_ptes(mm);
 	}
 
 	set_pmd_at(mm, addr, pmd, entry);
@@ -978,7 +978,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	get_page(src_page);
 	page_dup_rmap(src_page, true);
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-	atomic_long_inc(&dst_mm->nr_ptes);
+	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
@@ -1695,7 +1695,7 @@ static inline void zap_deposited_table(s
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pte_free(mm, pgtable);
-	atomic_long_dec(&mm->nr_ptes);
+	mm_dec_nr_ptes(mm);
 }
 
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
diff -puN mm/khugepaged.c~mm-introduce-wrappers-to-access-mm-nr_ptes mm/khugepaged.c
--- a/mm/khugepaged.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/mm/khugepaged.c
@@ -1270,7 +1270,7 @@ static void retract_page_tables(struct a
 			_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			spin_unlock(ptl);
 			up_write(&vma->vm_mm->mmap_sem);
-			atomic_long_dec(&vma->vm_mm->nr_ptes);
+			mm_dec_nr_ptes(vma->vm_mm);
 			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
 		}
 	}
diff -puN mm/memory.c~mm-introduce-wrappers-to-access-mm-nr_ptes mm/memory.c
--- a/mm/memory.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/mm/memory.c
@@ -438,7 +438,7 @@ static void free_pte_range(struct mmu_ga
 	pgtable_t token = pmd_pgtable(*pmd);
 	pmd_clear(pmd);
 	pte_free_tlb(tlb, token, addr);
-	atomic_long_dec(&tlb->mm->nr_ptes);
+	mm_dec_nr_ptes(tlb->mm);
 }
 
 static inline void free_pmd_range(struct mmu_gather *tlb, pud_t *pud,
@@ -666,7 +666,7 @@ int __pte_alloc(struct mm_struct *mm, pm
 
 	ptl = pmd_lock(mm, pmd);
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
-		atomic_long_inc(&mm->nr_ptes);
+		mm_inc_nr_ptes(mm);
 		pmd_populate(mm, pmd, new);
 		new = NULL;
 	}
@@ -3238,7 +3238,7 @@ static int pte_alloc_one_map(struct vm_f
 			goto map_pte;
 		}
 
-		atomic_long_inc(&vma->vm_mm->nr_ptes);
+		mm_inc_nr_ptes(vma->vm_mm);
 		pmd_populate(vma->vm_mm, vmf->pmd, vmf->prealloc_pte);
 		spin_unlock(vmf->ptl);
 		vmf->prealloc_pte = NULL;
@@ -3297,7 +3297,7 @@ static void deposit_prealloc_pte(struct
 	 * We are going to consume the prealloc table,
 	 * count that as nr_ptes.
 	 */
-	atomic_long_inc(&vma->vm_mm->nr_ptes);
+	mm_inc_nr_ptes(vma->vm_mm);
 	vmf->prealloc_pte = NULL;
 }
 
diff -puN mm/oom_kill.c~mm-introduce-wrappers-to-access-mm-nr_ptes mm/oom_kill.c
--- a/mm/oom_kill.c~mm-introduce-wrappers-to-access-mm-nr_ptes
+++ a/mm/oom_kill.c
@@ -221,8 +221,7 @@ unsigned long oom_badness(struct task_st
 	 * task's rss, pagetable and swap space use.
 	 */
 	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
-		atomic_long_read(&p->mm->nr_ptes) + mm_nr_pmds(p->mm) +
-		mm_nr_puds(p->mm);
+		mm_nr_ptes(p->mm) + mm_nr_pmds(p->mm) + mm_nr_puds(p->mm);
 	task_unlock(p);
 
 	/*
@@ -417,7 +416,7 @@ static void dump_tasks(struct mem_cgroup
 		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %7ld %7ld %8lu         %5hd %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-			atomic_long_read(&task->mm->nr_ptes),
+			mm_nr_ptes(task->mm),
 			mm_nr_pmds(task->mm),
 			mm_nr_puds(task->mm),
 			get_mm_counter(task->mm, MM_SWAPENTS),
_
