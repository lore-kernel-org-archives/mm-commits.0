From: akpm@linux-foundation.org
Subject: + procfs-provide-stack-information-for-threads-v011.patch added to -mm tree
Date: Thu, 16 Jul 2009 13:42:57 -0700
Message-ID: <200907162042.n6GKgvr3006206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933322AbZGPUnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 16:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@xmission.com, mingo@elte.hu


The patch titled
     procfs-provide-stack-information-for-threads-v011
has been added to the -mm tree.  Its filename is
     procfs-provide-stack-information-for-threads-v011.patch

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
Subject: procfs-provide-stack-information-for-threads-v011
From: Stefani Seibold <stefani@seibold.net>

Changes since last posting:

 - fix compatibility with tools/perf/builtin-record.c in upstream kernel

The patch is against 2.6.30 and is tested on intel and ppc architectures.

ChangeLog:
 20. Jan 2009 V0.1
  - First Version for Kernel 2.6.28.1
 31. Mar 2009 V0.2
  - Ported to Kernel 2.6.29
 03. Jun 2009 V0.3
  - Ported to Kernel 2.6.30
  - Redesigned what was suggested by Ingo Molnar
  - the thread watch monitor is gone
  - the /proc/stackmon entry is also gone
  - slim down
 04. Jun 2009 V0.4
  - Redesigned everything that was suggested by Andrew Morton
  - slim down
 04. Jun 2009 V0.5
  - Code cleanup
 06. Jun 2009 V0.6
  - Fix missing mm->mmap_sem locking in function task_show_stack_usage()
  - Code cleanup
 10. Jun 2009 V0.7
  - update Documentation/filesystem/proc.txt
 10. Jun 2009 V0.8
  - change maps/smaps output, displays now the max. stack size
 24. Jun 2009 V0.9
  - use walk_page_range() to determinate the stack usage high water mark
  - include swapped pages to the stack usage high water mark count
 24. Jun 2009 V0.10
  - fix off by one bug
  - cleanup

 fs/exec.c                          |    2
 include/linux/sched.h              |    1
 kernel/fork.c                      |    2

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 -
 fs/proc/array.c                    |   74 +++++++++++++++++++--------
 fs/proc/task_mmu.c                 |    2 
 include/linux/sched.h              |    2 
 4 files changed, 58 insertions(+), 24 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-provide-stack-information-for-threads-v011 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-provide-stack-information-for-threads-v011
+++ a/Documentation/filesystems/proc.txt
@@ -309,7 +309,7 @@ address           perms offset  dev   in
 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
-a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [threadstack:001ff4b4]
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
 a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
@@ -345,7 +345,7 @@ is not associated with a file:
  [stack]                  = the stack of the main process
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
- [thread stack, xxxxxxxx] = the stack of the thread, xxxxxxxx is the stack size
+ [threadstack:xxxxxxxx]   = the stack of the thread, xxxxxxxx is the stack size
 
  or if empty, the mapping is anonymous.
 
diff -puN fs/proc/array.c~procfs-provide-stack-information-for-threads-v011 fs/proc/array.c
--- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v011
+++ a/fs/proc/array.c
@@ -82,6 +82,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/swapops.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -321,34 +322,67 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
-static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
-					struct task_struct *p)
-{
-	unsigned long	i;
-	struct page	*page;
-	unsigned long	stkpage;
+struct stack_stats {
+	struct vm_area_struct *vma;
+	unsigned long	startpage;
+	unsigned long	usage;
+};
 
-	stkpage = KSTK_ESP(p) & PAGE_MASK;
+static int stack_usage_pte_range(pmd_t *pmd, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	struct stack_stats *ss = walk->private;
+	struct vm_area_struct *vma = ss->vma;
+	pte_t *pte, ptent;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	for (; addr != end; pte++, addr += PAGE_SIZE) {
+		ptent = *pte;
 
 #ifdef CONFIG_STACK_GROWSUP
-	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
-
-		page = follow_page(vma, i-PAGE_SIZE, 0);
-
-		if (!IS_ERR(page) && page)
+		if (pte_present(ptent) || is_swap_pte(ptent))
+			ss->usage = addr - ss->startpage + PAGE_SIZE;
+#else
+		if (pte_present(ptent) || is_swap_pte(ptent)) {
+			ss->usage = ss->startpage - addr + PAGE_SIZE;
+			pte++;
+			ret = 1;
 			break;
+		}
+#endif
 	}
-	return i - (p->stack_start & PAGE_MASK);
-#else
-	for (i = vma->vm_start; i+PAGE_SIZE <= stkpage; i += PAGE_SIZE) {
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+	return ret;
+}
 
-		page = follow_page(vma, i, 0);
+static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
+				struct task_struct *task)
+{
+	struct stack_stats ss;
+	struct mm_walk stack_walk = {
+		.pmd_entry = stack_usage_pte_range,
+		.mm = vma->vm_mm,
+		.private = &ss,
+	};
+
+	if (!vma->vm_mm || is_vm_hugetlb_page(vma))
+		return 0;
+
+	ss.vma = vma;
+	ss.startpage = task->stack_start & PAGE_MASK;
+	ss.usage = 0;
 
-		if (!IS_ERR(page) && page)
-			break;
-	}
-	return (p->stack_start & PAGE_MASK) - i + PAGE_SIZE;
+#ifdef CONFIG_STACK_GROWSUP
+	walk_page_range(KSTK_ESP(task) & PAGE_MASK, vma->vm_end,
+		&stack_walk);
+#else
+	walk_page_range(vma->vm_start, (KSTK_ESP(task) & PAGE_MASK) + PAGE_SIZE,
+		&stack_walk);
 #endif
+	return ss.usage;
 }
 
 static inline void task_show_stack_usage(struct seq_file *m,
diff -puN fs/proc/task_mmu.c~procfs-provide-stack-information-for-threads-v011 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-provide-stack-information-for-threads-v011
+++ a/fs/proc/task_mmu.c
@@ -253,7 +253,7 @@ static void show_map_vma(struct seq_file
 					    vma->vm_end >= stack_start) {
 						pad_len_spaces(m, len);
 						seq_printf(m,
-						 "[thread stack: %08lx]",
+						 "[threadstack:%08lx]",
 #ifdef CONFIG_STACK_GROWSUP
 						 vma->vm_end - stack_start
 #else
diff -puN include/linux/sched.h~procfs-provide-stack-information-for-threads-v011 include/linux/sched.h
--- a/include/linux/sched.h~procfs-provide-stack-information-for-threads-v011
+++ a/include/linux/sched.h
@@ -1173,6 +1173,7 @@ struct sched_rt_entity {
 	/* rq "owned" by this entity/group: */
 	struct rt_rq		*my_q;
 #endif
+	unsigned long stack_start;
 };
 
 struct task_struct {
@@ -1495,7 +1496,6 @@ struct task_struct {
 	/* bitmask of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-	unsigned long stack_start;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
_

Patches currently in -mm which might be from stefani@seibold.net are

procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch

