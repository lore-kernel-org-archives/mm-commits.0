From: akpm@linux-foundation.org
Subject: [folded] procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:20:52 -0700
Message-ID: <20120321232052.8C990A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34634 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2CUXUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 19:20:53 -0400
Received: by yenq2 with SMTP id q2so273079yen.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:20:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siddhesh.poyarekar@gmail.com, adobriyan@gmail.com, jamie@shareable.org, kosaki.motohiro@gmail.com, mpm@selenic.com, msalter@redhat.com, oleg@redhat.com, paul.gortmaker@windriver.com, vapier@gentoo.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
has been removed from the -mm tree.  Its filename was
     procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3.patch

This patch was dropped because it was folded into procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3

Following is the updated patch with requested changes incorporated.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   36 +++++++++++++---
 fs/proc/task_mmu.c                 |   59 ++++++++++++++++++---------
 fs/proc/task_nommu.c               |   11 ++++-
 mm/memory.c                        |   38 -----------------
 mm/nommu.c                         |   40 ------------------
 mm/util.c                          |   41 ++++++++++++++++++
 6 files changed, 121 insertions(+), 104 deletions(-)

diff -puN Documentation/filesystems/proc.txt~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
+++ a/Documentation/filesystems/proc.txt
@@ -325,7 +325,7 @@ address           perms offset  dev   in
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
 a7cb2000-a7eb2000 rw-p 00000000 00:00 0
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
-a7eb3000-a7ed5000 rw-p 00000000 00:00 0
+a7eb3000-a7ed5000 rw-p 00000000 00:00 0          [stack:1001]
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
 a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
 a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
@@ -337,7 +337,7 @@ a8024000-a8027000 rw-p 00000000 00:00 0
 a8027000-a8043000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
 a8043000-a8044000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
 a8044000-a8045000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
-aff35000-aff4a000 rw-p 00000000 00:00 0          [stack:1001]
+aff35000-aff4a000 rw-p 00000000 00:00 0          [stack]
 ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
 
 where "address" is the address space in the process that it occupies, "perms"
@@ -356,8 +356,8 @@ The "pathname" shows the name associated
 is not associated with a file:
 
  [heap]                   = the heap of the program
- [stack:1001]             = the mapping is used as a stack by the thread
-                            with tid 1001
+ [stack]                  = the stack of the main process
+ [stack:1001]             = the stack of the thread with tid 1001
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
 
@@ -365,9 +365,31 @@ is not associated with a file:
 
 The /proc/PID/task/TID/maps is a view of the virtual memory from the viewpoint
 of the individual tasks of a process. In this file you will see a mapping marked
-as [stack:TID] only if that task sees it as a stack. This is a key difference
-from the content of /proc/PID/maps, where you will see all mappings that are
-being used as stack by all of those tasks.
+as [stack] if that task sees it as a stack. This is a key difference from the
+content of /proc/PID/maps, where you will see all mappings that are being used
+as stack by all of those tasks. Hence, for the example above, the task-level
+map, i.e. /proc/PID/task/TID/maps for thread 1001 will look like this:
+
+08048000-08049000 r-xp 00000000 03:00 8312       /opt/test
+08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
+0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
+a7cb1000-a7cb2000 ---p 00000000 00:00 0
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0
+a7eb2000-a7eb3000 ---p 00000000 00:00 0
+a7eb3000-a7ed5000 rw-p 00000000 00:00 0          [stack]
+a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
+a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
+a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
+a800b000-a800e000 rw-p 00000000 00:00 0
+a800e000-a8022000 r-xp 00000000 03:00 14462      /lib/libpthread.so.0
+a8022000-a8023000 r--p 00013000 03:00 14462      /lib/libpthread.so.0
+a8023000-a8024000 rw-p 00014000 03:00 14462      /lib/libpthread.so.0
+a8024000-a8027000 rw-p 00000000 00:00 0
+a8027000-a8043000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
+a8043000-a8044000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
+a8044000-a8045000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
+aff35000-aff4a000 rw-p 00000000 00:00 0
+ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
 
 The /proc/PID/smaps is an extension based on maps, showing the memory
 consumption for each of the process's mappings. For each of mappings there
diff -puN fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
+++ a/fs/proc/task_mmu.c
@@ -222,7 +222,7 @@ show_map_vma(struct seq_file *m, struct 
 	unsigned long start, end;
 	dev_t dev = 0;
 	int len;
-	const char *name;
+	const char *name = NULL;
 
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
@@ -256,33 +256,47 @@ show_map_vma(struct seq_file *m, struct 
 	if (file) {
 		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "\n");
-		goto out;
+		goto done;
 	}
 
 	name = arch_vma_name(vma);
 	if (!name) {
-		if (mm) {
-			if (vma->vm_start <= mm->brk &&
-					vma->vm_end >= mm->start_brk) {
-				name = "[heap]";
-			} else {
-				pid_t tid;
+		pid_t tid;
 
-				tid = vm_is_stack(task, vma, is_pid);
-				if (tid != 0) {
-					pad_len_spaces(m, len);
-					seq_printf(m, "[stack:%d]", tid);
-				}
-			}
-		} else {
+		if (!mm) {
 			name = "[vdso]";
+			goto done;
+		}
+
+		if (vma->vm_start <= mm->brk &&
+		    vma->vm_end >= mm->start_brk) {
+			name = "[heap]";
+			goto done;
+		}
+
+		tid = vm_is_stack(task, vma, is_pid);
+
+		if (tid !=0) {
+			/*
+			 * Thread stack in /proc/PID/task/TID/maps or
+			 * the main process stack.
+			 */
+			if (!is_pid || (vma->vm_start <= mm->start_stack &&
+			    vma->vm_end >= mm->start_stack)) {
+				name = "[stack]";
+			} else {
+				/* Thread stack in /proc/PID/maps */
+				pad_len_spaces(m, len);
+				seq_printf(m, "[stack:%d]", tid);
+			}
 		}
 	}
+
+done:
 	if (name) {
 		pad_len_spaces(m, len);
 		seq_puts(m, name);
 	}
-out:
 	seq_putc(m, '\n');
 }
 
@@ -1147,8 +1161,17 @@ static int show_numa_map(struct seq_file
 		seq_printf(m, " heap");
 	} else {
 		pid_t tid = vm_is_stack(proc_priv->task, vma, is_pid);
-		if (tid != 0)
-			seq_printf(m, " stack:%d", tid);
+		if (tid !=0) {
+			/*
+			 * Thread stack in /proc/PID/task/TID/maps or
+			 * the main process stack.
+			 */
+			if (!is_pid || (vma->vm_start <= mm->start_stack &&
+			    vma->vm_end >= mm->start_stack))
+				seq_printf(m, " stack");
+			else
+				seq_printf(m, " stack:%d", tid);
+		}
 	}
 
 	if (is_vm_hugetlb_page(vma))
diff -puN fs/proc/task_nommu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
+++ a/fs/proc/task_nommu.c
@@ -171,9 +171,18 @@ static int nommu_vma_show(struct seq_fil
 		seq_path(m, &file->f_path, "");
 	} else if (mm) {
 		pid_t tid = vm_is_stack(priv->task, vma, is_pid);
+
 		if (tid != 0) {
 			pad_len_spaces(m, len);
-			seq_printf(m, "[stack:%d]", tid);
+			/*
+			 * Thread stack in /proc/PID/task/TID/maps or
+			 * the main process stack.
+			 */
+			if (!is_pid || (vma->vm_start <= mm->start_stack &&
+			    vma->vm_end >= mm->start_stack))
+				seq_printf(m, "[stack]");
+			else
+				seq_printf(m, "[stack:%d]", tid);
 		}
 	}
 
diff -puN mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 mm/memory.c
--- a/mm/memory.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
+++ a/mm/memory.c
@@ -57,7 +57,6 @@
 #include <linux/swapops.h>
 #include <linux/elf.h>
 #include <linux/gfp.h>
-#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -113,13 +112,6 @@ __setup("norandmaps", disable_randmaps);
 unsigned long zero_pfn __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
 
-/* Check if the vma is being used as a stack by this task */
-static int vm_is_stack_for_task(struct task_struct *t,
-				struct vm_area_struct *vma)
-{
-	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
-}
-
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
@@ -3907,36 +3899,6 @@ void print_vma_addr(char *prefix, unsign
 	up_read(&current->mm->mmap_sem);
 }
 
-/*
- * Check if the vma is being used as a stack.
- * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task. Returns the pid of the task that
- * the vma is stack for.
- */
-pid_t vm_is_stack(struct task_struct *task,
-		  struct vm_area_struct *vma, int in_group)
-{
-	pid_t ret = 0;
-
-	if (vm_is_stack_for_task(task, vma))
-		return task->pid;
-
-	if (in_group) {
-		struct task_struct *t = task;
-		rcu_read_lock();
-		while_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma)) {
-				ret = t->pid;
-				goto done;
-			}
-		}
-	}
-
-done:
-	rcu_read_unlock();
-	return ret;
-}
-
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void)
 {
diff -puN mm/nommu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 mm/nommu.c
--- a/mm/nommu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
+++ a/mm/nommu.c
@@ -29,7 +29,6 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
-#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
@@ -2095,42 +2094,3 @@ int nommu_shrink_inode_mappings(struct i
 	up_write(&nommu_region_sem);
 	return 0;
 }
-
-/* Check if the vma is being used as a stack by this task */
-static int vm_is_stack_for_task(struct task_struct *t,
-				struct vm_area_struct *vma)
-{
-	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
-}
-
-/*
- * Check if the vma is being used as a stack.
- * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task. Returns the pid of the task that
- * the vma is stack for.
- */
-pid_t vm_is_stack(struct task_struct *task,
-		  struct vm_area_struct *vma, int in_group)
-{
-	pid_t ret = 0;
-
-	if (vm_is_stack_for_task(task, vma))
-		return task->pid;
-
-	if (in_group) {
-		struct task_struct *t;
-		rcu_read_lock();
-		t = list_first_entry_rcu(&task->thread_group,
-					 struct task_struct, thread_group);
-		do {
-			if (vm_is_stack_for_task(t, vma)) {
-				ret = t->pid;
-				goto done;
-			}
-		} while_each_thread(task, t);
-done:
-		rcu_read_unlock();
-	}
-
-	return ret;
-}
diff -puN mm/util.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 mm/util.c
--- a/mm/util.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
+++ a/mm/util.c
@@ -239,6 +239,47 @@ void __vma_link_list(struct mm_struct *m
 		next->vm_prev = vma;
 }
 
+/* Check if the vma is being used as a stack by this task */
+static int vm_is_stack_for_task(struct task_struct *t,
+				struct vm_area_struct *vma)
+{
+	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
+}
+
+/*
+ * Check if the vma is being used as a stack.
+ * If is_group is non-zero, check in the entire thread group or else
+ * just check in the current task. Returns the pid of the task that
+ * the vma is stack for.
+ */
+pid_t vm_is_stack(struct task_struct *task,
+		  struct vm_area_struct *vma, int in_group)
+{
+	pid_t ret = 0;
+
+	if (vm_is_stack_for_task(task, vma))
+		return task->pid;
+
+	if (in_group) {
+		struct task_struct *t;
+		rcu_read_lock();
+		if (!pid_alive(task))
+			goto done;
+
+		t = task;
+		do {
+			if (vm_is_stack_for_task(t, vma)) {
+				ret = t->pid;
+				goto done;
+			}
+		} while_each_thread(task, t);
+done:
+		rcu_read_unlock();
+	}
+
+	return ret;
+}
+
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from siddhesh.poyarekar@gmail.com are

procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3-checkpatch-fixes.patch

