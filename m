From: akpm@linux-foundation.org
Subject: + mm-account-pud-page-tables.patch added to -mm tree
Date: Mon, 02 Oct 2017 15:08:10 -0700
Message-ID: <59d2b8ca.2sCRG6LES+LsCeVo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBWIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 18:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: account pud page tables
has been added to the -mm tree.  Its filename is
     mm-account-pud-page-tables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-account-pud-page-tables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-account-pud-page-tables.patch

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
Subject: mm: account pud page tables

On a machine with 5-level paging support a process can allocate
significant amount of memory and stay unnoticed by oom-killer and memory
cgroup.  The trick is to allocate a lot of PUD page tables.  We don't
account PUD page tables, only PMD and PTE.

We already addressed the same issue for PMD page tables, see dc6c9a35b66b
("mm: account pmd page tables to the process").  Introduction 5-level
paging bring the same issue for PUD page tables.

The patch expands accounting to PUD level.

Link: http://lkml.kernel.org/r/20171002080427.3320-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt   |    8 +++----
 arch/powerpc/mm/hugetlbpage.c |    1 
 arch/sparc/mm/hugetlbpage.c   |    1 
 fs/proc/task_mmu.c            |    5 +++-
 include/linux/mm.h            |   36 +++++++++++++++++++++++++++++---
 include/linux/mm_types.h      |    3 ++
 kernel/fork.c                 |    4 +++
 mm/debug.c                    |    6 +++--
 mm/memory.c                   |   15 ++++++++-----
 mm/oom_kill.c                 |    8 ++++---
 10 files changed, 68 insertions(+), 19 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~mm-account-pud-page-tables arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-account-pud-page-tables
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -433,6 +433,7 @@ static void hugetlb_free_pud_range(struc
 	pud = pud_offset(pgd, start);
 	pgd_clear(pgd);
 	pud_free_tlb(tlb, pud, start);
+	mm_dec_nr_puds(tlb->mm);
 }
 
 /*
diff -puN arch/sparc/mm/hugetlbpage.c~mm-account-pud-page-tables arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-account-pud-page-tables
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -471,6 +471,7 @@ static void hugetlb_free_pud_range(struc
 	pud = pud_offset(pgd, start);
 	pgd_clear(pgd);
 	pud_free_tlb(tlb, pud, start);
+	mm_dec_nr_puds(tlb->mm);
 }
 
 void hugetlb_free_pgd_range(struct mmu_gather *tlb,
diff -puN Documentation/sysctl/vm.txt~mm-account-pud-page-tables Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-account-pud-page-tables
+++ a/Documentation/sysctl/vm.txt
@@ -630,10 +630,10 @@ oom_dump_tasks
 
 Enables a system-wide task dump (excluding kernel threads) to be produced
 when the kernel performs an OOM-killing and includes such information as
-pid, uid, tgid, vm size, rss, nr_ptes, nr_pmds, swapents, oom_score_adj
-score, and name.  This is helpful to determine why the OOM killer was
-invoked, to identify the rogue task that caused it, and to determine why
-the OOM killer chose the task it did to kill.
+pid, uid, tgid, vm size, rss, nr_ptes, nr_pmds, nr_puds, swapents,
+oom_score_adj score, and name.  This is helpful to determine why the OOM
+killer was invoked, to identify the rogue task that caused it, and to
+determine why the OOM killer chose the task it did to kill.
 
 If this is set to zero, this information is suppressed.  On very
 large systems with thousands of tasks it may not be feasible to dump
diff -puN fs/proc/task_mmu.c~mm-account-pud-page-tables fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-account-pud-page-tables
+++ a/fs/proc/task_mmu.c
@@ -25,7 +25,7 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long text, lib, swap, ptes, pmds, anon, file, shmem;
+	unsigned long text, lib, swap, ptes, pmds, puds, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
 	anon = get_mm_counter(mm, MM_ANONPAGES);
@@ -51,6 +51,7 @@ void task_mem(struct seq_file *m, struct
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	ptes = PTRS_PER_PTE * sizeof(pte_t) * atomic_long_read(&mm->nr_ptes);
 	pmds = PTRS_PER_PMD * sizeof(pmd_t) * mm_nr_pmds(mm);
+	puds = PTRS_PER_PUD * sizeof(pmd_t) * mm_nr_puds(mm);
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
@@ -67,6 +68,7 @@ void task_mem(struct seq_file *m, struct
 		"VmLib:\t%8lu kB\n"
 		"VmPTE:\t%8lu kB\n"
 		"VmPMD:\t%8lu kB\n"
+		"VmPUD:\t%8lu kB\n"
 		"VmSwap:\t%8lu kB\n",
 		hiwater_vm << (PAGE_SHIFT-10),
 		total_vm << (PAGE_SHIFT-10),
@@ -81,6 +83,7 @@ void task_mem(struct seq_file *m, struct
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
 		ptes >> 10,
 		pmds >> 10,
+		puds >> 10,
 		swap << (PAGE_SHIFT-10));
 	hugetlb_report_usage(m, mm);
 }
diff -puN include/linux/mm.h~mm-account-pud-page-tables include/linux/mm.h
--- a/include/linux/mm.h~mm-account-pud-page-tables
+++ a/include/linux/mm.h
@@ -1598,14 +1598,44 @@ static inline int __p4d_alloc(struct mm_
 int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
 #endif
 
-#ifdef __PAGETABLE_PUD_FOLDED
+#if defined(__PAGETABLE_PUD_FOLDED) || !defined(CONFIG_MMU)
 static inline int __pud_alloc(struct mm_struct *mm, p4d_t *p4d,
 						unsigned long address)
 {
 	return 0;
 }
+
+static inline unsigned long mm_nr_puds(const struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void mm_nr_puds_init(struct mm_struct *mm) {}
+static inline void mm_inc_nr_puds(struct mm_struct *mm) {}
+static inline void mm_dec_nr_puds(struct mm_struct *mm) {}
+
 #else
 int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address);
+
+static inline void mm_nr_puds_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->nr_puds, 0);
+}
+
+static inline unsigned long mm_nr_puds(const struct mm_struct *mm)
+{
+	return atomic_long_read(&mm->nr_puds);
+}
+
+static inline void mm_inc_nr_puds(struct mm_struct *mm)
+{
+	atomic_long_inc(&mm->nr_puds);
+}
+
+static inline void mm_dec_nr_puds(struct mm_struct *mm)
+{
+	atomic_long_dec(&mm->nr_puds);
+}
 #endif
 
 #if defined(__PAGETABLE_PMD_FOLDED) || !defined(CONFIG_MMU)
@@ -1617,7 +1647,7 @@ static inline int __pmd_alloc(struct mm_
 
 static inline void mm_nr_pmds_init(struct mm_struct *mm) {}
 
-static inline unsigned long mm_nr_pmds(struct mm_struct *mm)
+static inline unsigned long mm_nr_pmds(const struct mm_struct *mm)
 {
 	return 0;
 }
@@ -1633,7 +1663,7 @@ static inline void mm_nr_pmds_init(struc
 	atomic_long_set(&mm->nr_pmds, 0);
 }
 
-static inline unsigned long mm_nr_pmds(struct mm_struct *mm)
+static inline unsigned long mm_nr_pmds(const struct mm_struct *mm)
 {
 	return atomic_long_read(&mm->nr_pmds);
 }
diff -puN include/linux/mm_types.h~mm-account-pud-page-tables include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-account-pud-page-tables
+++ a/include/linux/mm_types.h
@@ -404,6 +404,9 @@ struct mm_struct {
 #if CONFIG_PGTABLE_LEVELS > 2
 	atomic_long_t nr_pmds;			/* PMD page table pages */
 #endif
+#if CONFIG_PGTABLE_LEVELS > 3
+	atomic_long_t nr_puds;			/* PUD page table pages */
+#endif
 	int map_count;				/* number of VMAs */
 
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
diff -puN kernel/fork.c~mm-account-pud-page-tables kernel/fork.c
--- a/kernel/fork.c~mm-account-pud-page-tables
+++ a/kernel/fork.c
@@ -576,6 +576,9 @@ static void check_mm(struct mm_struct *m
 	if (mm_nr_pmds(mm))
 		pr_alert("BUG: non-zero nr_pmds on freeing mm: %ld\n",
 				mm_nr_pmds(mm));
+	if (mm_nr_puds(mm))
+		pr_alert("BUG: non-zero nr_puds on freeing mm: %ld\n",
+				mm_nr_puds(mm));
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	VM_BUG_ON_MM(mm->pmd_huge_pte, mm);
@@ -880,6 +883,7 @@ static struct mm_struct *mm_init(struct
 	mm->core_state = NULL;
 	atomic_long_set(&mm->nr_ptes, 0);
 	mm_nr_pmds_init(mm);
+	mm_nr_puds_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
 	mm->pinned_vm = 0;
diff -puN mm/debug.c~mm-account-pud-page-tables mm/debug.c
--- a/mm/debug.c~mm-account-pud-page-tables
+++ a/mm/debug.c
@@ -104,7 +104,8 @@ void dump_mm(const struct mm_struct *mm)
 		"get_unmapped_area %p\n"
 #endif
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
-		"pgd %p mm_users %d mm_count %d nr_ptes %lu nr_pmds %lu map_count %d\n"
+		"pgd %p mm_users %d mm_count %d\n"
+		"nr_ptes %lu nr_pmds %lu nr_puds %lu map_count %d\n"
 		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
 		"pinned_vm %lx data_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
@@ -135,7 +136,8 @@ void dump_mm(const struct mm_struct *mm)
 		mm->pgd, atomic_read(&mm->mm_users),
 		atomic_read(&mm->mm_count),
 		atomic_long_read((atomic_long_t *)&mm->nr_ptes),
-		mm_nr_pmds((struct mm_struct *)mm),
+		mm_nr_pmds(mm),
+		mm_nr_puds(mm),
 		mm->map_count,
 		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
 		mm->pinned_vm, mm->data_vm, mm->exec_vm, mm->stack_vm,
diff -puN mm/memory.c~mm-account-pud-page-tables mm/memory.c
--- a/mm/memory.c~mm-account-pud-page-tables
+++ a/mm/memory.c
@@ -506,6 +506,7 @@ static inline void free_pud_range(struct
 	pud = pud_offset(p4d, start);
 	p4d_clear(p4d);
 	pud_free_tlb(tlb, pud, start);
+	mm_dec_nr_puds(tlb->mm);
 }
 
 static inline void free_p4d_range(struct mmu_gather *tlb, pgd_t *pgd,
@@ -4144,15 +4145,17 @@ int __pud_alloc(struct mm_struct *mm, p4
 
 	spin_lock(&mm->page_table_lock);
 #ifndef __ARCH_HAS_5LEVEL_HACK
-	if (p4d_present(*p4d))		/* Another has populated it */
-		pud_free(mm, new);
-	else
+	if (!p4d_present(*p4d)) {
+		mm_inc_nr_puds(mm);
 		p4d_populate(mm, p4d, new);
-#else
-	if (pgd_present(*p4d))		/* Another has populated it */
+	} else	/* Another has populated it */
 		pud_free(mm, new);
-	else
+#else
+	if (!pgd_present(*p4d)) {
+		mm_inc_nr_puds(mm);
 		pgd_populate(mm, p4d, new);
+	} else	/* Another has populated it */
+		pud_free(mm, new);
 #endif /* __ARCH_HAS_5LEVEL_HACK */
 	spin_unlock(&mm->page_table_lock);
 	return 0;
diff -puN mm/oom_kill.c~mm-account-pud-page-tables mm/oom_kill.c
--- a/mm/oom_kill.c~mm-account-pud-page-tables
+++ a/mm/oom_kill.c
@@ -201,7 +201,8 @@ unsigned long oom_badness(struct task_st
 	 * task's rss, pagetable and swap space use.
 	 */
 	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
-		atomic_long_read(&p->mm->nr_ptes) + mm_nr_pmds(p->mm);
+		atomic_long_read(&p->mm->nr_ptes) + mm_nr_pmds(p->mm) +
+		mm_nr_puds(p->mm);
 	task_unlock(p);
 
 	/*
@@ -377,7 +378,7 @@ static void dump_tasks(struct mem_cgroup
 	struct task_struct *p;
 	struct task_struct *task;
 
-	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name\n");
+	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds nr_puds swapents oom_score_adj name\n");
 	rcu_read_lock();
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
@@ -393,11 +394,12 @@ static void dump_tasks(struct mem_cgroup
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %7ld %8lu         %5hd %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %7ld %7ld %8lu         %5hd %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
 			atomic_long_read(&task->mm->nr_ptes),
 			mm_nr_pmds(task->mm),
+			mm_nr_puds(task->mm),
 			get_mm_counter(task->mm, MM_SWAPENTS),
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-fix-typo-in-vm_mpx-definition.patch
mm-account-pud-page-tables.patch

