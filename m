From: akpm@linux-foundation.org
Subject: [merged] mm-consolidate-page-table-accounting.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:02:25 -0800
Message-ID: <20171116200225.7vvViopSt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964820AbdKPUC0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: consolidate page table accounting
has been removed from the -mm tree.  Its filename was
     mm-consolidate-page-table-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: consolidate page table accounting

Currently, we account page tables separately for each page table level,
but that's redundant -- we only make use of total memory allocated to page
tables for oom_badness calculation.  We also provide the information to
userspace, but it has dubious value there too.

This patch switches page table accounting to single counter.

mm->pgtables_bytes is now used to account all page table levels.  We use
bytes, because page table size for different levels of page table tree may
be different.

The change has user-visible effect: we don't have VmPMD and VmPUD reported
in /proc/[pid]/status.  Not sure if anybody uses them.  (As alternative,
we can always report 0 kB for them.)

OOM-killer report is also slightly changed: we now report pgtables_bytes
instead of nr_ptes, nr_pmd, nr_puds.

Apart from reducing number of counters per-mm, the benefit is that we now
calculate oom_badness() more correctly for machines which have different
size of page tables depending on level or where page tables are less than
a page in size.

The only downside can be debuggability because we do not know which page
table level could leak.  But I do not remember many bugs that would be
caught by separate counters so I wouldn't lose sleep over this.

[akpm@linux-foundation.org: fix mm/huge_memory.c]
Link: http://lkml.kernel.org/r/20171006100651.44742-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
[kirill.shutemov@linux.intel.com: fix build]
  Link: http://lkml.kernel.org/r/20171016150113.ikfxy3e7zzfvsr4w@black.fi.intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    1 
 Documentation/sysctl/vm.txt        |    8 +--
 fs/proc/task_mmu.c                 |   11 -----
 include/linux/mm.h                 |   58 +++++----------------------
 include/linux/mm_types.h           |    8 ---
 kernel/fork.c                      |   16 +------
 mm/debug.c                         |    7 ---
 mm/huge_memory.c                   |    2 
 mm/oom_kill.c                      |   14 ++----
 9 files changed, 32 insertions(+), 93 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-consolidate-page-table-accounting Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-consolidate-page-table-accounting
+++ a/Documentation/filesystems/proc.txt
@@ -250,7 +250,6 @@ Table 1-2: Contents of the status files
  VmExe                       size of text segment
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
- VmPMD                       size of second level page tables
  VmSwap                      amount of swap used by anonymous private data
                              (shmem swap usage is not included)
  HugetlbPages                size of hugetlb memory portions
diff -puN Documentation/sysctl/vm.txt~mm-consolidate-page-table-accounting Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-consolidate-page-table-accounting
+++ a/Documentation/sysctl/vm.txt
@@ -629,10 +629,10 @@ oom_dump_tasks
 
 Enables a system-wide task dump (excluding kernel threads) to be produced
 when the kernel performs an OOM-killing and includes such information as
-pid, uid, tgid, vm size, rss, nr_ptes, nr_pmds, nr_puds, swapents,
-oom_score_adj score, and name.  This is helpful to determine why the OOM
-killer was invoked, to identify the rogue task that caused it, and to
-determine why the OOM killer chose the task it did to kill.
+pid, uid, tgid, vm size, rss, pgtables_bytes, swapents, oom_score_adj
+score, and name.  This is helpful to determine why the OOM killer was
+invoked, to identify the rogue task that caused it, and to determine why
+the OOM killer chose the task it did to kill.
 
 If this is set to zero, this information is suppressed.  On very
 large systems with thousands of tasks it may not be feasible to dump
diff -puN fs/proc/task_mmu.c~mm-consolidate-page-table-accounting fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-consolidate-page-table-accounting
+++ a/fs/proc/task_mmu.c
@@ -26,7 +26,7 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long text, lib, swap, ptes, pmds, puds, anon, file, shmem;
+	unsigned long text, lib, swap, anon, file, shmem;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
 	anon = get_mm_counter(mm, MM_ANONPAGES);
@@ -50,9 +50,6 @@ void task_mem(struct seq_file *m, struct
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
 	swap = get_mm_counter(mm, MM_SWAPENTS);
-	ptes = PTRS_PER_PTE * sizeof(pte_t) * mm_nr_ptes(mm);
-	pmds = PTRS_PER_PMD * sizeof(pmd_t) * mm_nr_pmds(mm);
-	puds = PTRS_PER_PUD * sizeof(pud_t) * mm_nr_puds(mm);
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
@@ -68,8 +65,6 @@ void task_mem(struct seq_file *m, struct
 		"VmExe:\t%8lu kB\n"
 		"VmLib:\t%8lu kB\n"
 		"VmPTE:\t%8lu kB\n"
-		"VmPMD:\t%8lu kB\n"
-		"VmPUD:\t%8lu kB\n"
 		"VmSwap:\t%8lu kB\n",
 		hiwater_vm << (PAGE_SHIFT-10),
 		total_vm << (PAGE_SHIFT-10),
@@ -82,9 +77,7 @@ void task_mem(struct seq_file *m, struct
 		shmem << (PAGE_SHIFT-10),
 		mm->data_vm << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
-		ptes >> 10,
-		pmds >> 10,
-		puds >> 10,
+		mm_pgtables_bytes(mm) >> 10,
 		swap << (PAGE_SHIFT-10));
 	hugetlb_report_usage(m, mm);
 }
diff -puN include/linux/mm.h~mm-consolidate-page-table-accounting include/linux/mm.h
--- a/include/linux/mm.h~mm-consolidate-page-table-accounting
+++ a/include/linux/mm.h
@@ -1605,37 +1605,20 @@ static inline int __pud_alloc(struct mm_
 {
 	return 0;
 }
-
-static inline unsigned long mm_nr_puds(const struct mm_struct *mm)
-{
-	return 0;
-}
-
-static inline void mm_nr_puds_init(struct mm_struct *mm) {}
 static inline void mm_inc_nr_puds(struct mm_struct *mm) {}
 static inline void mm_dec_nr_puds(struct mm_struct *mm) {}
 
 #else
 int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address);
 
-static inline void mm_nr_puds_init(struct mm_struct *mm)
-{
-	atomic_long_set(&mm->nr_puds, 0);
-}
-
-static inline unsigned long mm_nr_puds(const struct mm_struct *mm)
-{
-	return atomic_long_read(&mm->nr_puds);
-}
-
 static inline void mm_inc_nr_puds(struct mm_struct *mm)
 {
-	atomic_long_inc(&mm->nr_puds);
+	atomic_long_add(PTRS_PER_PUD * sizeof(pud_t), &mm->pgtables_bytes);
 }
 
 static inline void mm_dec_nr_puds(struct mm_struct *mm)
 {
-	atomic_long_dec(&mm->nr_puds);
+	atomic_long_sub(PTRS_PER_PUD * sizeof(pud_t), &mm->pgtables_bytes);
 }
 #endif
 
@@ -1646,64 +1629,47 @@ static inline int __pmd_alloc(struct mm_
 	return 0;
 }
 
-static inline void mm_nr_pmds_init(struct mm_struct *mm) {}
-
-static inline unsigned long mm_nr_pmds(const struct mm_struct *mm)
-{
-	return 0;
-}
-
 static inline void mm_inc_nr_pmds(struct mm_struct *mm) {}
 static inline void mm_dec_nr_pmds(struct mm_struct *mm) {}
 
 #else
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
 
-static inline void mm_nr_pmds_init(struct mm_struct *mm)
-{
-	atomic_long_set(&mm->nr_pmds, 0);
-}
-
-static inline unsigned long mm_nr_pmds(const struct mm_struct *mm)
-{
-	return atomic_long_read(&mm->nr_pmds);
-}
-
 static inline void mm_inc_nr_pmds(struct mm_struct *mm)
 {
-	atomic_long_inc(&mm->nr_pmds);
+	atomic_long_add(PTRS_PER_PMD * sizeof(pmd_t), &mm->pgtables_bytes);
 }
 
 static inline void mm_dec_nr_pmds(struct mm_struct *mm)
 {
-	atomic_long_dec(&mm->nr_pmds);
+	atomic_long_sub(PTRS_PER_PMD * sizeof(pmd_t), &mm->pgtables_bytes);
 }
 #endif
 
 #ifdef CONFIG_MMU
-static inline void mm_nr_ptes_init(struct mm_struct *mm)
+static inline void mm_pgtables_bytes_init(struct mm_struct *mm)
 {
-	atomic_long_set(&mm->nr_ptes, 0);
+	atomic_long_set(&mm->pgtables_bytes, 0);
 }
 
-static inline unsigned long mm_nr_ptes(const struct mm_struct *mm)
+static inline unsigned long mm_pgtables_bytes(const struct mm_struct *mm)
 {
-	return atomic_long_read(&mm->nr_ptes);
+	return atomic_long_read(&mm->pgtables_bytes);
 }
 
 static inline void mm_inc_nr_ptes(struct mm_struct *mm)
 {
-	atomic_long_inc(&mm->nr_ptes);
+	atomic_long_add(PTRS_PER_PTE * sizeof(pte_t), &mm->pgtables_bytes);
 }
 
 static inline void mm_dec_nr_ptes(struct mm_struct *mm)
 {
-	atomic_long_dec(&mm->nr_ptes);
+	atomic_long_sub(PTRS_PER_PTE * sizeof(pte_t), &mm->pgtables_bytes);
 }
 #else
-static inline void mm_nr_ptes_init(struct mm_struct *mm) {}
 
-static inline unsigned long mm_nr_ptes(const struct mm_struct *mm)
+static inline void mm_pgtables_bytes_init(struct mm_struct *mm) {}
+static inline unsigned long mm_pgtables_bytes(const struct mm_struct *mm)
 {
 	return 0;
 }
diff -puN include/linux/mm_types.h~mm-consolidate-page-table-accounting include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-consolidate-page-table-accounting
+++ a/include/linux/mm_types.h
@@ -402,13 +402,7 @@ struct mm_struct {
 	atomic_t mm_count;
 
 #ifdef CONFIG_MMU
-	atomic_long_t nr_ptes;			/* PTE page table pages */
-#endif
-#if CONFIG_PGTABLE_LEVELS > 2
-	atomic_long_t nr_pmds;			/* PMD page table pages */
-#endif
-#if CONFIG_PGTABLE_LEVELS > 3
-	atomic_long_t nr_puds;			/* PUD page table pages */
+	atomic_long_t pgtables_bytes;		/* PTE page table pages */
 #endif
 	int map_count;				/* number of VMAs */
 
diff -puN kernel/fork.c~mm-consolidate-page-table-accounting kernel/fork.c
--- a/kernel/fork.c~mm-consolidate-page-table-accounting
+++ a/kernel/fork.c
@@ -817,9 +817,7 @@ static struct mm_struct *mm_init(struct
 	init_rwsem(&mm->mmap_sem);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
-	mm_nr_ptes_init(mm);
-	mm_nr_pmds_init(mm);
-	mm_nr_puds_init(mm);
+	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
 	mm->pinned_vm = 0;
@@ -873,15 +871,9 @@ static void check_mm(struct mm_struct *m
 					  "mm:%p idx:%d val:%ld\n", mm, i, x);
 	}
 
-	if (mm_nr_ptes(mm))
-		pr_alert("BUG: non-zero nr_ptes on freeing mm: %ld\n",
-				mm_nr_ptes(mm));
-	if (mm_nr_pmds(mm))
-		pr_alert("BUG: non-zero nr_pmds on freeing mm: %ld\n",
-				mm_nr_pmds(mm));
-	if (mm_nr_puds(mm))
-		pr_alert("BUG: non-zero nr_puds on freeing mm: %ld\n",
-				mm_nr_puds(mm));
+	if (mm_pgtables_bytes(mm))
+		pr_alert("BUG: non-zero pgtables_bytes on freeing mm: %ld\n",
+				mm_pgtables_bytes(mm));
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	VM_BUG_ON_MM(mm->pmd_huge_pte, mm);
diff -puN mm/debug.c~mm-consolidate-page-table-accounting mm/debug.c
--- a/mm/debug.c~mm-consolidate-page-table-accounting
+++ a/mm/debug.c
@@ -105,8 +105,7 @@ void dump_mm(const struct mm_struct *mm)
 		"get_unmapped_area %p\n"
 #endif
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
-		"pgd %p mm_users %d mm_count %d\n"
-		"nr_ptes %lu nr_pmds %lu nr_puds %lu map_count %d\n"
+		"pgd %p mm_users %d mm_count %d pgtables_bytes %lu map_count %d\n"
 		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
 		"pinned_vm %lx data_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
@@ -136,9 +135,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->mmap_base, mm->mmap_legacy_base, mm->highest_vm_end,
 		mm->pgd, atomic_read(&mm->mm_users),
 		atomic_read(&mm->mm_count),
-		mm_nr_ptes(mm),
-		mm_nr_pmds(mm),
-		mm_nr_puds(mm),
+		mm_pgtables_bytes(mm),
 		mm->map_count,
 		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
 		mm->pinned_vm, mm->data_vm, mm->exec_vm, mm->stack_vm,
diff -puN mm/huge_memory.c~mm-consolidate-page-table-accounting mm/huge_memory.c
--- a/mm/huge_memory.c~mm-consolidate-page-table-accounting
+++ a/mm/huge_memory.c
@@ -942,7 +942,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		atomic_long_inc(&dst_mm->nr_ptes);
+		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 		ret = 0;
diff -puN mm/oom_kill.c~mm-consolidate-page-table-accounting mm/oom_kill.c
--- a/mm/oom_kill.c~mm-consolidate-page-table-accounting
+++ a/mm/oom_kill.c
@@ -221,7 +221,7 @@ unsigned long oom_badness(struct task_st
 	 * task's rss, pagetable and swap space use.
 	 */
 	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
-		mm_nr_ptes(p->mm) + mm_nr_pmds(p->mm) + mm_nr_puds(p->mm);
+		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
 	/*
@@ -389,15 +389,15 @@ static void select_bad_process(struct oo
  * Dumps the current memory state of all eligible tasks.  Tasks not in the same
  * memcg, not in the same cpuset, or bound to a disjoint set of mempolicy nodes
  * are not shown.
- * State information includes task's pid, uid, tgid, vm size, rss, nr_ptes,
- * swapents, oom_score_adj value, and name.
+ * State information includes task's pid, uid, tgid, vm size, rss,
+ * pgtables_bytes, swapents, oom_score_adj value, and name.
  */
 static void dump_tasks(struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *task;
 
-	pr_info("[ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds nr_puds swapents oom_score_adj name\n");
+	pr_info("[ pid ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
 	rcu_read_lock();
 	for_each_process(p) {
 		if (oom_unkillable_task(p, memcg, nodemask))
@@ -413,12 +413,10 @@ static void dump_tasks(struct mem_cgroup
 			continue;
 		}
 
-		pr_info("[%5d] %5d %5d %8lu %8lu %7ld %7ld %7ld %8lu         %5hd %s\n",
+		pr_info("[%5d] %5d %5d %8lu %8lu %8ld %8lu         %5hd %s\n",
 			task->pid, from_kuid(&init_user_ns, task_uid(task)),
 			task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-			mm_nr_ptes(task->mm),
-			mm_nr_pmds(task->mm),
-			mm_nr_puds(task->mm),
+			mm_pgtables_bytes(task->mm),
 			get_mm_counter(task->mm, MM_SWAPENTS),
 			task->signal->oom_score_adj, task->comm);
 		task_unlock(task);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-add-infrastructure-for-get_user_pages_fast-benchmarking.patch

