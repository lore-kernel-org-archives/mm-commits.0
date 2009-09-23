From: akpm@linux-foundation.org
Subject: [merged] procfs-provide-stack-information-for-threads-v08.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:49 -0700
Message-ID: <200909231956.n8NJunoj005655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956AbZIWUFb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@xmission.com, mingo@elte.hu, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     procfs: provide stack information for threads
has been removed from the -mm tree.  Its filename was
     procfs-provide-stack-information-for-threads-v08.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: provide stack information for threads
From: Stefani Seibold <stefani@seibold.net>

A patch to give a better overview of the userland application stack usage,
especially for embedded linux.

Currently you are only able to dump the main process/thread stack usage
which is showed in /proc/pid/status by the "VmStk" Value.  But you get no
information about the consumed stack memory of the the threads.

There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which marks
the vm mapping where the thread stack pointer reside with "[thread stack
xxxxxxxx]".  xxxxxxxx is the maximum size of stack.  This is a value
information, because libpthread doesn't set the start of the stack to the
top of the mapped area, depending of the pthread usage.

A sample output of /proc/<pid>/task/<tid>/maps looks like:

08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
a7d12000-a7d13000 ---p 00000000 00:00 0
a7d13000-a7f13000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
a7f13000-a7f14000 ---p 00000000 00:00 0
a7f14000-a7f36000 rw-p 00000000 00:00 0
a7f36000-a8069000 r-xp 00000000 03:00 4222       /lib/libc.so.6
a8069000-a806b000 r--p 00133000 03:00 4222       /lib/libc.so.6
a806b000-a806c000 rw-p 00135000 03:00 4222       /lib/libc.so.6
a806c000-a806f000 rw-p 00000000 00:00 0
a806f000-a8083000 r-xp 00000000 03:00 14462      /lib/libpthread.so.0
a8083000-a8084000 r--p 00013000 03:00 14462      /lib/libpthread.so.0
a8084000-a8085000 rw-p 00014000 03:00 14462      /lib/libpthread.so.0
a8085000-a8088000 rw-p 00000000 00:00 0
a8088000-a80a4000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
a80a4000-a80a5000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
a80a5000-a80a6000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
afaf5000-afb0a000 rw-p 00000000 00:00 0          [stack]
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]


Also there is a new entry "stack usage" in /proc/<pid>/{task/*,}/status
which will you give the current stack usage in kb.

A sample output of /proc/self/status looks like:

Name:	cat
State:	R (running)
Tgid:	507
Pid:	507
.
.
.
CapBnd:	fffffffffffffeff
voluntary_ctxt_switches:	0
nonvoluntary_ctxt_switches:	0
Stack usage:	12 kB

I also fixed stack base address in /proc/<pid>/{task/*,}/stat to the base
address of the associated thread stack and not the one of the main
process.  This makes more sense.

[akpm@linux-foundation.org: fs/proc/array.c now needs walk_page_range()]
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    5 +
 fs/exec.c                          |    2 
 fs/proc/array.c                    |   85 ++++++++++++++++++++++++++-
 fs/proc/task_mmu.c                 |   19 ++++++
 include/linux/sched.h              |    1 
 kernel/fork.c                      |    2 
 mm/Makefile                        |    4 -
 7 files changed, 114 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-provide-stack-information-for-threads-v08 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-provide-stack-information-for-threads-v08
+++ a/Documentation/filesystems/proc.txt
@@ -176,6 +176,7 @@ read the file /proc/PID/status:
   CapBnd: ffffffffffffffff
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
+  Stack usage:    12 kB
 
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
@@ -229,6 +230,7 @@ Table 1-2: Contents of the statm files (
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
+ Stack usage:                stack usage high water mark (round up to page size)
 ..............................................................................
 
 Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
@@ -307,7 +309,7 @@ address           perms offset  dev   in
 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
-a7cb2000-a7eb2000 rw-p 00000000 00:00 0
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [threadstack:001ff4b4]
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
 a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
@@ -343,6 +345,7 @@ is not associated with a file:
  [stack]                  = the stack of the main process
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
+ [threadstack:xxxxxxxx]   = the stack of the thread, xxxxxxxx is the stack size
 
  or if empty, the mapping is anonymous.
 
diff -puN fs/exec.c~procfs-provide-stack-information-for-threads-v08 fs/exec.c
--- a/fs/exec.c~procfs-provide-stack-information-for-threads-v08
+++ a/fs/exec.c
@@ -1357,6 +1357,8 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	current->stack_start = current->mm->start_stack;
+
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
diff -puN fs/proc/array.c~procfs-provide-stack-information-for-threads-v08 fs/proc/array.c
--- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v08
+++ a/fs/proc/array.c
@@ -82,6 +82,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/swapops.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -321,6 +322,87 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
+struct stack_stats {
+	struct vm_area_struct *vma;
+	unsigned long	startpage;
+	unsigned long	usage;
+};
+
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
+
+#ifdef CONFIG_STACK_GROWSUP
+		if (pte_present(ptent) || is_swap_pte(ptent))
+			ss->usage = addr - ss->startpage + PAGE_SIZE;
+#else
+		if (pte_present(ptent) || is_swap_pte(ptent)) {
+			ss->usage = ss->startpage - addr + PAGE_SIZE;
+			pte++;
+			ret = 1;
+			break;
+		}
+#endif
+	}
+	pte_unmap_unlock(pte - 1, ptl);
+	cond_resched();
+	return ret;
+}
+
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
+
+#ifdef CONFIG_STACK_GROWSUP
+	walk_page_range(KSTK_ESP(task) & PAGE_MASK, vma->vm_end,
+		&stack_walk);
+#else
+	walk_page_range(vma->vm_start, (KSTK_ESP(task) & PAGE_MASK) + PAGE_SIZE,
+		&stack_walk);
+#endif
+	return ss.usage;
+}
+
+static inline void task_show_stack_usage(struct seq_file *m,
+						struct task_struct *task)
+{
+	struct vm_area_struct	*vma;
+	struct mm_struct	*mm = get_task_mm(task);
+
+	if (mm) {
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, task->stack_start);
+		if (vma)
+			seq_printf(m, "Stack usage:\t%lu kB\n",
+				get_stack_usage_in_bytes(vma, task) >> 10);
+
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -340,6 +422,7 @@ int proc_pid_status(struct seq_file *m, 
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
+	task_show_stack_usage(m, task);
 	return 0;
 }
 
@@ -481,7 +564,7 @@ static int do_task_stat(struct seq_file 
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		(permitted && mm) ? mm->start_stack : 0,
+		(permitted) ? task->stack_start : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
diff -puN fs/proc/task_mmu.c~procfs-provide-stack-information-for-threads-v08 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-provide-stack-information-for-threads-v08
+++ a/fs/proc/task_mmu.c
@@ -243,6 +243,25 @@ static void show_map_vma(struct seq_file
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
 					name = "[stack]";
+				} else {
+					unsigned long stack_start;
+					struct proc_maps_private *pmp;
+
+					pmp = m->private;
+					stack_start = pmp->task->stack_start;
+
+					if (vma->vm_start <= stack_start &&
+					    vma->vm_end >= stack_start) {
+						pad_len_spaces(m, len);
+						seq_printf(m,
+						 "[threadstack:%08lx]",
+#ifdef CONFIG_STACK_GROWSUP
+						 vma->vm_end - stack_start
+#else
+						 stack_start - vma->vm_start
+#endif
+						);
+					}
 				}
 			} else {
 				name = "[vdso]";
diff -puN include/linux/sched.h~procfs-provide-stack-information-for-threads-v08 include/linux/sched.h
--- a/include/linux/sched.h~procfs-provide-stack-information-for-threads-v08
+++ a/include/linux/sched.h
@@ -1529,6 +1529,7 @@ struct task_struct {
 	/* bitmask of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
+	unsigned long stack_start;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff -puN kernel/fork.c~procfs-provide-stack-information-for-threads-v08 kernel/fork.c
--- a/kernel/fork.c~procfs-provide-stack-information-for-threads-v08
+++ a/kernel/fork.c
@@ -1095,6 +1095,8 @@ static struct task_struct *copy_process(
 
 	p->bts = NULL;
 
+	p->stack_start = stack_start;
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
 
diff -puN mm/Makefile~procfs-provide-stack-information-for-threads-v08 mm/Makefile
--- a/mm/Makefile~procfs-provide-stack-information-for-threads-v08
+++ a/mm/Makefile
@@ -11,10 +11,10 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o mmu_context.o $(mmu-y)
+			   page_isolation.o mm_init.o mmu_context.o \
+			   pagewalk.o $(mmu-y)
 obj-y += init-mm.o
 
-obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
linux-next.patch

