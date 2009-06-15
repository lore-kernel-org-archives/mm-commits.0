From: akpm@linux-foundation.org
Subject: + procfs-provide-stack-information-for-threads-v08.patch added to -mm tree
Date: Mon, 15 Jun 2009 15:02:05 -0700
Message-ID: <200906152202.n5FM25VD021536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935002AbZFOWCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 18:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, a.p.zijlstra@chello.nl, adobriyan@gmail.com, ebiederm@xmission.com, mingo@elte.hu


The patch titled
     procfs: provide stack information for threads
has been added to the -mm tree.  Its filename is
     procfs-provide-stack-information-for-threads-v08.patch

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

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    5 ++
 fs/exec.c                          |    2 +
 fs/proc/array.c                    |   51 ++++++++++++++++++++++++++-
 fs/proc/task_mmu.c                 |   19 ++++++++++
 include/linux/sched.h              |    1 
 kernel/fork.c                      |    2 +
 6 files changed, 78 insertions(+), 2 deletions(-)

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
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [thread stack: 001ff4b4]
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
 a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
@@ -343,6 +345,7 @@ is not associated with a file:
  [stack]                  = the stack of the main process
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
+ [thread stack, xxxxxxxx] = the stack of the thread, xxxxxxxx is the stack size
 
  or if empty, the mapping is anonymous.
 
diff -puN fs/exec.c~procfs-provide-stack-information-for-threads-v08 fs/exec.c
--- a/fs/exec.c~procfs-provide-stack-information-for-threads-v08
+++ a/fs/exec.c
@@ -1344,6 +1344,8 @@ int do_execve(char * filename,
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
@@ -321,6 +321,54 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
+static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
+					struct task_struct *p)
+{
+	unsigned long	i;
+	struct page	*page;
+	unsigned long	stkpage;
+
+	stkpage = KSTK_ESP(p) & PAGE_MASK;
+
+#ifdef CONFIG_STACK_GROWSUP
+	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
+
+		page = follow_page(vma, i-PAGE_SIZE, 0);
+
+		if (!IS_ERR(page) && page)
+			break;
+	}
+	return i - (p->stack_start & PAGE_MASK);
+#else
+	for (i = vma->vm_start; i+PAGE_SIZE <= stkpage; i += PAGE_SIZE) {
+
+		page = follow_page(vma, i, 0);
+
+		if (!IS_ERR(page) && page)
+			break;
+	}
+	return (p->stack_start & PAGE_MASK) - i + PAGE_SIZE;
+#endif
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
@@ -340,6 +388,7 @@ int proc_pid_status(struct seq_file *m, 
 	task_show_regs(m, task);
 #endif
 	task_context_switch_counts(m, task);
+	task_show_stack_usage(m, task);
 	return 0;
 }
 
@@ -481,7 +530,7 @@ static int do_task_stat(struct seq_file 
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
@@ -242,6 +242,25 @@ static void show_map_vma(struct seq_file
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
+						 "[thread stack: %08lx]",
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
@@ -1460,6 +1460,7 @@ struct task_struct {
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
 
_

Patches currently in -mm which might be from stefani@seibold.net are

proctxt-update-kernel-filesystem-proctxt-documentation.patch
procfs-provide-stack-information-for-threads-v08.patch

