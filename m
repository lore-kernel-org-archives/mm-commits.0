From: akpm@linux-foundation.org
Subject: + proc-revert-procfs-provide-stack-information-for-threads.patch added to -mm tree
Date: Thu, 07 Jan 2010 13:52:54 -0800
Message-ID: <201001072152.o07Lqsjd019649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183Ab0AGVx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 16:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, akpm@linux-foundation.org, andi@firstfloor.org, ebiederm@xmission.com, mingo@elte.hu, randy.dunlap@oracle.com, stefani@seibold.net


The patch titled
     proc: revert "procfs: provide stack information for threads"
has been added to the -mm tree.  Its filename is
     proc-revert-procfs-provide-stack-information-for-threads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: revert "procfs: provide stack information for threads"
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
