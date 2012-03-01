From: akpm@linux-foundation.org
Subject: + procfs-mark-stack-vma-with-pid-of-the-owning-task.patch added to -mm tree
Date: Thu, 01 Mar 2012 15:17:35 -0800
Message-ID: <20120301231735.25FB6A02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:59055 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab2CAXRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Mar 2012 18:17:36 -0500
Received: by vbnl22 with SMTP id l22so152870vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Mar 2012 15:17:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siddhesh.poyarekar@gmail.com, adobriyan@gmail.com, jamie@shareable.org, kosaki.motohiro@gmail.com, mpm@selenic.com, oleg@redhat.com, vapier@gentoo.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: procfs: Mark stack vma with pid of the owning task
has been added to the -mm tree.  Its filename is
     procfs-mark-stack-vma-with-pid-of-the-owning-task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: procfs: Mark stack vma with pid of the owning task

This is a usability tweak to the earlier patch to mark thread stack vmas
based on which vma a task is using as stack.  With this patch, each marked
stack is also marked with the pid of the task to make things that little
bit easier while troubleshooting issues.  I have tested to confirm that
this does not break current procps behaviour.  Thanks Mike Frysinger
<vapier@gentoo.org> for the idea.

An example output of cat /proc/self/maps with this patch:

$ cat /proc/self/maps
00400000-0040b000 r-xp 00000000 fd:00 1048598                            /bin/cat
0060a000-0060b000 r--p 0000a000 fd:00 1048598                            /bin/cat
0060b000-0060c000 rw-p 0000b000 fd:00 1048598                            /bin/cat
02370000-02391000 rw-p 00000000 00:00 0                                  [heap]
7fc8fbf93000-7fc9023b6000 r--p 00000000 fd:00 1714381                    /usr/lib/locale/locale-archive
7fc9023b6000-7fc902561000 r-xp 00000000 fd:00 2097482                    /lib64/libc-2.14.90.so
7fc902561000-7fc902761000 ---p 001ab000 fd:00 2097482                    /lib64/libc-2.14.90.so
7fc902761000-7fc902765000 r--p 001ab000 fd:00 2097482                    /lib64/libc-2.14.90.so
7fc902765000-7fc902767000 rw-p 001af000 fd:00 2097482                    /lib64/libc-2.14.90.so
7fc902767000-7fc90276c000 rw-p 00000000 00:00 0
7fc90276c000-7fc90278e000 r-xp 00000000 fd:00 2097348                    /lib64/ld-2.14.90.so
7fc90295f000-7fc902962000 rw-p 00000000 00:00 0
7fc90298c000-7fc90298d000 rw-p 00000000 00:00 0
7fc90298d000-7fc90298e000 r--p 00021000 fd:00 2097348                    /lib64/ld-2.14.90.so
7fc90298e000-7fc90298f000 rw-p 00022000 fd:00 2097348                    /lib64/ld-2.14.90.so
7fc90298f000-7fc902990000 rw-p 00000000 00:00 0
7fff5fb8d000-7fff5fbae000 rw-p 00000000 00:00 0                          [stack:2663]
7fff5fbff000-7fff5fc00000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   12 ++++++------
 fs/proc/task_mmu.c                 |   16 ++++++++++++----
 fs/proc/task_nommu.c               |    5 +++--
 include/linux/mm.h                 |    2 +-
 mm/memory.c                        |   13 +++++++------
 5 files changed, 29 insertions(+), 19 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-mark-stack-vma-with-pid-of-the-owning-task Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-mark-stack-vma-with-pid-of-the-owning-task
+++ a/Documentation/filesystems/proc.txt
@@ -337,7 +337,7 @@ a8024000-a8027000 rw-p 00000000 00:00 0
 a8027000-a8043000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
 a8043000-a8044000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
 a8044000-a8045000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
-aff35000-aff4a000 rw-p 00000000 00:00 0          [stack]
+aff35000-aff4a000 rw-p 00000000 00:00 0          [stack:1001]
 ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
 
 where "address" is the address space in the process that it occupies, "perms"
@@ -356,8 +356,8 @@ The "pathname" shows the name associated
 is not associated with a file:
 
  [heap]                   = the heap of the program
- [stack]                  = the mapping is used as a stack by one
-                            of the threads of the process
+ [stack:1001]             = the mapping is used as a stack by the thread
+                            with tid 1001
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
 
@@ -365,9 +365,9 @@ is not associated with a file:
 
 The /proc/PID/task/TID/maps is a view of the virtual memory from the viewpoint
 of the individual tasks of a process. In this file you will see a mapping marked
-as [stack] only if that task sees it as a stack. This is a key difference from
-the content of /proc/PID/maps, where you will see all mappings that are being
-used as stack by all of those tasks.
+as [stack:TID] only if that task sees it as a stack. This is a key difference
+from the content of /proc/PID/maps, where you will see all mappings that are
+being used as stack by all of those tasks.
 
 The /proc/PID/smaps is an extension based on maps, showing the memory
 consumption for each of the process's mappings. For each of mappings there
diff -puN fs/proc/task_mmu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task
+++ a/fs/proc/task_mmu.c
@@ -262,8 +262,14 @@ show_map_vma(struct seq_file *m, struct 
 				if (vma->vm_start <= mm->brk &&
 						vma->vm_end >= mm->start_brk) {
 					name = "[heap]";
-				} else if (vm_is_stack(task, vma, is_pid)) {
-					name = "[stack]";
+				} else {
+					pid_t tid =
+						vm_is_stack(task, vma, is_pid);
+					if (tid != 0) {
+						pad_len_spaces(m, len);
+						seq_printf(m, "[stack:%d]",
+								tid);
+					}
 				}
 			} else {
 				name = "[vdso]";
@@ -1123,8 +1129,10 @@ static int show_numa_map(struct seq_file
 		seq_path(m, &file->f_path, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_printf(m, " heap");
-	} else if (vm_is_stack(proc_priv->task, vma, is_pid)) {
-		seq_printf(m, " stack");
+	} else {
+		pid_t tid = vm_is_stack(proc_priv->task, vma, is_pid);
+		if (tid != 0)
+			seq_printf(m, " stack:%d", tid);
 	}
 
 	if (is_vm_hugetlb_page(vma))
diff -puN fs/proc/task_nommu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-mark-stack-vma-with-pid-of-the-owning-task
+++ a/fs/proc/task_nommu.c
@@ -170,9 +170,10 @@ static int nommu_vma_show(struct seq_fil
 		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "");
 	} else if (mm) {
-		if (vm_is_stack(priv->task, vma, is_pid))
+		pid_t tid = vm_is_stack(priv->task, vma, is_pid);
+		if (tid != 0) {
 			pad_len_spaces(m, len);
-			seq_puts(m, "[stack]");
+			seq_printf(m, "[stack:%d]", tid);
 		}
 	}
 
diff -puN include/linux/mm.h~procfs-mark-stack-vma-with-pid-of-the-owning-task include/linux/mm.h
--- a/include/linux/mm.h~procfs-mark-stack-vma-with-pid-of-the-owning-task
+++ a/include/linux/mm.h
@@ -1041,7 +1041,7 @@ static inline int stack_guard_page_end(s
 		!vma_growsup(vma->vm_next, addr);
 }
 
-extern int
+extern pid_t
 vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
diff -puN mm/memory.c~procfs-mark-stack-vma-with-pid-of-the-owning-task mm/memory.c
--- a/mm/memory.c~procfs-mark-stack-vma-with-pid-of-the-owning-task
+++ a/mm/memory.c
@@ -3901,22 +3901,23 @@ void print_vma_addr(char *prefix, unsign
 /*
  * Check if the vma is being used as a stack.
  * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task.
+ * just check in the current task. Returns the pid of the task that
+ * the vma is stack for.
  */
-int vm_is_stack(struct task_struct *task,
-		struct vm_area_struct *vma, int in_group)
+pid_t vm_is_stack(struct task_struct *task,
+		  struct vm_area_struct *vma, int in_group)
 {
-	int ret = 0;
+	pid_t ret = 0;
 
 	if (vm_is_stack_for_task(task, vma))
-		return 1;
+		return task->pid;
 
 	if (in_group) {
 		struct task_struct *t = task;
 		rcu_read_lock();
 		while_each_thread(task, t) {
 			if (vm_is_stack_for_task(t, vma)) {
-				ret = 1;
+				ret = t->pid;
 				goto done;
 			}
 		}
_
Subject: Subject: procfs: Mark stack vma with pid of the owning task

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-checkpatch-fixes.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-take-rcu-read-lock-when-iterating-through-thread-group.patch
procfs-mark-stack-vma-with-pid-of-the-owning-task.patch
procfs-mark-stack-vma-with-pid-of-the-owning-task-fix.patch

