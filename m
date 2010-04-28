From: akpm@linux-foundation.org
Subject: + revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits.patch added to -mm tree
Date: Wed, 28 Apr 2010 11:41:15 -0700
Message-ID: <201004281841.o3SIfFnc012821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232Ab0D1SrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, monstr@monstr.eu, stable@kernel.org, stefani@seibold.net


The patch titled
     revert "procfs: provide stack information for threads" and its fixup commits
has been added to the -mm tree.  Its filename is
     revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits.patch

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
Subject: revert "procfs: provide stack information for threads" and its fixup commits
From: Robin Holt <holt@sgi.com>

Originally, commit d899bf7b ("procfs: provide stack information for
threads") attempted to introduce a new feature for showing where the
threadstack was located and how many pages are being utilized by the
stack.

Commit c44972f1 ("procfs: disable per-task stack usage on NOMMU") was
applied to fix the NO_MMU case.

Commit 89240ba0 ("x86, fs: Fix x86 procfs stack information for threads on
64-bit") was applied to fix a bug in ia32 executables being loaded.

Commit 9ebd4eba7 ("procfs: fix /proc/<pid>/stat stack pointer for kernel
threads") was applied to fix a bug which had kernel threads printing a
userland stack address.

Commit 1306d603f ('proc: partially revert "procfs: provide stack
information for threads"') was then applied to revert the stack pages
being used to solve a significant performance regression.

This patch nearly undoes the effect of all these patches.

The reason for reverting these is it provides an unusable value in
field 28.  For x86_64, a fork will result in the task->stack_start
value being updated to the current user top of stack and not the stack
start address.  This unpredictability of the stack_start value makes
it worthless.  That includes the intended use of showing how much stack
space a thread has.

Other architectures will get different values.  As an example, ia64
gets 0.  The do_fork() and copy_process() functions appear to treat the
stack_start and stack_size parameters as architecture specific.

I only partially reverted c44972f1 ("procfs: disable per-task stack usage
on NOMMU") .  If I had completely reverted it, I would have had to change
mm/Makefile only build pagewalk.o when CONFIG_PROC_PAGE_MONITOR is
configured.  Since I could not test the builds without significant effort,
I decided to not change mm/Makefile.

I only partially reverted 89240ba0 ("x86, fs: Fix x86 procfs stack
information for threads on 64-bit") .  I left the KSTK_ESP() change in
place as that seemed worthwhile.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +--
 fs/compat.c                        |    2 --
 fs/exec.c                          |    2 --
 fs/proc/array.c                    |    3 +--
 fs/proc/task_mmu.c                 |   19 -------------------
 include/linux/sched.h              |    1 -
 kernel/fork.c                      |    2 --
 7 files changed, 2 insertions(+), 30 deletions(-)

diff -puN Documentation/filesystems/proc.txt~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/Documentation/filesystems/proc.txt
@@ -316,7 +316,7 @@ address           perms offset  dev   in
 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
 0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
-a7cb2000-a7eb2000 rw-p 00000000 00:00 0          [threadstack:001ff4b4]
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
 a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
@@ -352,7 +352,6 @@ is not associated with a file:
  [stack]                  = the stack of the main process
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
- [threadstack:xxxxxxxx]   = the stack of the thread, xxxxxxxx is the stack size
 
  or if empty, the mapping is anonymous.
 
diff -puN fs/compat.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits fs/compat.c
--- a/fs/compat.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/fs/compat.c
@@ -1531,8 +1531,6 @@ int compat_do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->stack_start = current->mm->start_stack;
-
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
diff -puN fs/exec.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits fs/exec.c
--- a/fs/exec.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/fs/exec.c
@@ -1387,8 +1387,6 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->stack_start = current->mm->start_stack;
-
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
diff -puN fs/proc/array.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits fs/proc/array.c
--- a/fs/proc/array.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/fs/proc/array.c
@@ -81,7 +81,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
-#include <linux/swapops.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -495,7 +494,7 @@ static int do_task_stat(struct seq_file 
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		(permitted && mm) ? task->stack_start : 0,
+		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
diff -puN fs/proc/task_mmu.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/fs/proc/task_mmu.c
@@ -247,25 +247,6 @@ static void show_map_vma(struct seq_file
 				} else if (vma->vm_start <= mm->start_stack &&
 					   vma->vm_end >= mm->start_stack) {
 					name = "[stack]";
-				} else {
-					unsigned long stack_start;
-					struct proc_maps_private *pmp;
-
-					pmp = m->private;
-					stack_start = pmp->task->stack_start;
-
-					if (vma->vm_start <= stack_start &&
-					    vma->vm_end >= stack_start) {
-						pad_len_spaces(m, len);
-						seq_printf(m,
-						 "[threadstack:%08lx]",
-#ifdef CONFIG_STACK_GROWSUP
-						 vma->vm_end - stack_start
-#else
-						 stack_start - vma->vm_start
-#endif
-						);
-					}
 				}
 			} else {
 				name = "[vdso]";
diff -puN include/linux/sched.h~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits include/linux/sched.h
--- a/include/linux/sched.h~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/include/linux/sched.h
@@ -1497,7 +1497,6 @@ struct task_struct {
 	/* bitmask of trace recursion */
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
-	unsigned long stack_start;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
 	struct memcg_batch_info {
 		int do_batch;	/* incremented when batch uncharge started */
diff -puN kernel/fork.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits kernel/fork.c
--- a/kernel/fork.c~revert-procfs-provide-stack-information-for-threads-and-its-fixup-commits
+++ a/kernel/fork.c
@@ -1114,8 +1114,6 @@ static struct task_struct *copy_process(
 
 	p->bts = NULL;
 
-	p->stack_start = stack_start;
