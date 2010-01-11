From: akpm@linux-foundation.org
Subject: [merged] proc-revert-procfs-provide-stack-information-for-threads.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:28 -0800
Message-ID: <201001112018.o0BKISAk025491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab0AKUjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:39:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, akpm@linux-foundation.org, andi@firstfloor.org, ebiederm@xmission.com, mingo@elte.hu, randy.dunlap@oracle.


The patch titled
     proc: partially revert "procfs: provide stack information for threads"
has been removed from the -mm tree.  Its filename was
     proc-revert-procfs-provide-stack-information-for-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: partially revert "procfs: provide stack information for threads"
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Commit d899bf7b (procfs: provide stack information for threads) introduced
to show stack information in /proc/{pid}/status.  But it cause large
performance regression.  Unfortunately /proc/{pid}/status is used ps
command too and ps is one of most important component.  Because both to
take mmap_sem and page table walk are heavily operation.

If many process run, the ps performance is,

[before d899bf7b]

% perf stat ps >/dev/null

 Performance counter stats for 'ps':

     4090.435806  task-clock-msecs         #      0.032 CPUs
             229  context-switches         #      0.000 M/sec
               0  CPU-migrations           #      0.000 M/sec
             234  page-faults              #      0.000 M/sec
      8587565207  cycles                   #   2099.425 M/sec
      9866662403  instructions             #      1.149 IPC
      3789415411  cache-references         #    926.409 M/sec
        30419509  cache-misses             #      7.437 M/sec

   128.859521955  seconds time elapsed

[after d899bf7b]

% perf stat  ps  > /dev/null

 Performance counter stats for 'ps':

     4305.081146  task-clock-msecs         #      0.028 CPUs
             480  context-switches         #      0.000 M/sec
               2  CPU-migrations           #      0.000 M/sec
             237  page-faults              #      0.000 M/sec
      9021211334  cycles                   #   2095.480 M/sec
     10605887536  instructions             #      1.176 IPC
      3612650999  cache-references         #    839.160 M/sec
        23917502  cache-misses             #      5.556 M/sec

   152.277819582  seconds time elapsed

Thus, this patch revert it. Fortunately /proc/{pid}/task/{tid}/smaps
provide almost same information. we can use it.


Commit d899bf7b introduced two features:

 1) Add the annotattion of [thread stack: xxxx] mark to
    /proc/{pid}/task/{tid}/maps.
 2) Add StackUsage field to /proc/{pid}/status.

I only revert (2), because I haven't seen (1) cause regression.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 
 fs/proc/array.c                    |   89 ---------------------------
 2 files changed, 91 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-revert-procfs-provide-stack-information-for-threads Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-revert-procfs-provide-stack-information-for-threads
+++ a/Documentation/filesystems/proc.txt
@@ -177,7 +177,6 @@ read the file /proc/PID/status:
   CapBnd: ffffffffffffffff
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
-  Stack usage:    12 kB
 
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
@@ -231,7 +230,6 @@ Table 1-2: Contents of the statm files (
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
- Stack usage:                stack usage high water mark (round up to page size)
 ..............................................................................
 
 Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
diff -puN fs/proc/array.c~proc-revert-procfs-provide-stack-information-for-threads fs/proc/array.c
--- a/fs/proc/array.c~proc-revert-procfs-provide-stack-information-for-threads
+++ a/fs/proc/array.c
@@ -327,94 +327,6 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
-#ifdef CONFIG_MMU
-
-struct stack_stats {
-	struct vm_area_struct *vma;
-	unsigned long	startpage;
-	unsigned long	usage;
-};
-
-static int stack_usage_pte_range(pmd_t *pmd, unsigned long addr,
-				unsigned long end, struct mm_walk *walk)
-{
-	struct stack_stats *ss = walk->private;
-	struct vm_area_struct *vma = ss->vma;
-	pte_t *pte, ptent;
-	spinlock_t *ptl;
-	int ret = 0;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE) {
-		ptent = *pte;
-
-#ifdef CONFIG_STACK_GROWSUP
-		if (pte_present(ptent) || is_swap_pte(ptent))
-			ss->usage = addr - ss->startpage + PAGE_SIZE;
-#else
-		if (pte_present(ptent) || is_swap_pte(ptent)) {
-			ss->usage = ss->startpage - addr + PAGE_SIZE;
-			pte++;
-			ret = 1;
-			break;
-		}
-#endif
-	}
-	pte_unmap_unlock(pte - 1, ptl);
-	cond_resched();
-	return ret;
-}
-
-static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
-				struct task_struct *task)
-{
-	struct stack_stats ss;
-	struct mm_walk stack_walk = {
-		.pmd_entry = stack_usage_pte_range,
-		.mm = vma->vm_mm,
-		.private = &ss,
-	};
-
-	if (!vma->vm_mm || is_vm_hugetlb_page(vma))
-		return 0;
-
-	ss.vma = vma;
-	ss.startpage = task->stack_start & PAGE_MASK;
-	ss.usage = 0;
-
-#ifdef CONFIG_STACK_GROWSUP
-	walk_page_range(KSTK_ESP(task) & PAGE_MASK, vma->vm_end,
-		&stack_walk);
-#else
-	walk_page_range(vma->vm_start, (KSTK_ESP(task) & PAGE_MASK) + PAGE_SIZE,
-		&stack_walk);
-#endif
-	return ss.usage;
-}
-
-static inline void task_show_stack_usage(struct seq_file *m,
-						struct task_struct *task)
-{
-	struct vm_area_struct	*vma;
-	struct mm_struct	*mm = get_task_mm(task);
-
-	if (mm) {
-		down_read(&mm->mmap_sem);
-		vma = find_vma(mm, task->stack_start);
-		if (vma)
-			seq_printf(m, "Stack usage:\t%lu kB\n",
-				get_stack_usage_in_bytes(vma, task) >> 10);
-
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
-}
-#else
-static void task_show_stack_usage(struct seq_file *m, struct task_struct *task)
-{
-}
-#endif		/* CONFIG_MMU */
-
 static void task_cpus_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
@@ -445,7 +357,6 @@ int proc_pid_status(struct seq_file *m, 
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
-	task_show_stack_usage(m, task);
 	return 0;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

