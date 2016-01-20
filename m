From: akpm@linux-foundation.org
Subject: + proc-revert-proc-pid-maps-annotation.patch added to -mm tree
Date: Tue, 19 Jan 2016 21:28:19 -0800
Message-ID: <569f1af3.gCCOQE8IX1FIGIbG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbcATF2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 00:28:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kirill@shutemov.name, shli@fb.com, siddhesh.poyarekar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: revert /proc/<pid>/maps [stack:TID] annotation
has been added to the -mm tree.  Its filename is
     proc-revert-proc-pid-maps-annotation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-revert-proc-pid-maps-annotation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-revert-proc-pid-maps-annotation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: proc: revert /proc/<pid>/maps [stack:TID] annotation

b764375 ("procfs: mark thread stack correctly in proc/<pid>/maps") added
[stack:TID] annotation to /proc/<pid>/maps.  Finding the task of a stack
VMA requires walking the entire thread list, turning this into quadratic
behavior: a thousand threads means a thousand stacks, so the rendering of
/proc/<pid>/maps needs to look at a million threads.  The cost is not in
proportion to the usefulness as described in the patch.

Drop the [stack:TID] annotation to make /proc/<pid>/maps (and
/proc/<pid>/numa_maps) usable again for higher thread counts.

The [stack] annotation inside /proc/<pid>/task/<tid>/maps is retained, as
identifying the stack VMA there is an O(1) operation.

Siddesh said:

: The end users needed a way to identify thread stacks programmatically and
: there wasn't a way to do that.  I'm afraid I no longer remember (or have
: access to the resources that would aid my memory since I changed
: employers) the details of their requirement.  However, I did do this on my
: own time because I thought it was an interesting project for me and nobody
: really gave any feedback then as to its utility, so as far as I am
: concerned you could roll back the main thread maps information since the
: information is available in the thread-specific files.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 +--
 fs/proc/task_mmu.c                 |   66 +++++++++------------------
 fs/proc/task_nommu.c               |   48 +++++++------------
 include/linux/mm.h                 |    3 -
 mm/util.c                          |   27 -----------
 5 files changed, 47 insertions(+), 106 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-revert-proc-pid-maps-annotation Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-revert-proc-pid-maps-annotation
+++ a/Documentation/filesystems/proc.txt
@@ -356,7 +356,7 @@ address           perms offset  dev   in
 a7cb1000-a7cb2000 ---p 00000000 00:00 0
 a7cb2000-a7eb2000 rw-p 00000000 00:00 0
 a7eb2000-a7eb3000 ---p 00000000 00:00 0
-a7eb3000-a7ed5000 rw-p 00000000 00:00 0          [stack:1001]
+a7eb3000-a7ed5000 rw-p 00000000 00:00 0
 a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
 a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
 a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
@@ -388,7 +388,6 @@ is not associated with a file:
 
  [heap]                   = the heap of the program
  [stack]                  = the stack of the main process
- [stack:1001]             = the stack of the thread with tid 1001
  [vdso]                   = the "virtual dynamic shared object",
                             the kernel system call handler
 
@@ -396,10 +395,8 @@ is not associated with a file:
 
 The /proc/PID/task/TID/maps is a view of the virtual memory from the viewpoint
 of the individual tasks of a process. In this file you will see a mapping marked
-as [stack] if that task sees it as a stack. This is a key difference from the
-content of /proc/PID/maps, where you will see all mappings that are being used
-as stack by all of those tasks. Hence, for the example above, the task-level
-map, i.e. /proc/PID/task/TID/maps for thread 1001 will look like this:
+as [stack] if that task sees it as a stack. Hence, for the example above, the
+task-level map, i.e. /proc/PID/task/TID/maps for thread 1001 will look like this:
 
 08048000-08049000 r-xp 00000000 03:00 8312       /opt/test
 08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
diff -puN fs/proc/task_mmu.c~proc-revert-proc-pid-maps-annotation fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-revert-proc-pid-maps-annotation
+++ a/fs/proc/task_mmu.c
@@ -259,23 +259,29 @@ static int do_maps_open(struct inode *in
 				sizeof(struct proc_maps_private));
 }
 
-static pid_t pid_of_stack(struct proc_maps_private *priv,
-				struct vm_area_struct *vma, bool is_pid)
+/*
+ * Indicate if the VMA is a stack for the given task; for
+ * /proc/PID/maps that is the stack of the main task.
+ */
+static int is_stack(struct proc_maps_private *priv,
+		    struct vm_area_struct *vma, int is_pid)
 {
-	struct inode *inode = priv->inode;
-	struct task_struct *task;
-	pid_t ret = 0;
+	int stack = 0;
+
+	if (is_pid) {
+		stack = vma->vm_start <= vma->vm_mm->start_stack &&
+			vma->vm_end >= vma->vm_mm->start_stack;
+	} else {
+		struct inode *inode = priv->inode;
+		struct task_struct *task;
 
-	rcu_read_lock();
-	task = pid_task(proc_pid(inode), PIDTYPE_PID);
-	if (task) {
-		task = task_of_stack(task, vma, is_pid);
+		rcu_read_lock();
+		task = pid_task(proc_pid(inode), PIDTYPE_PID);
 		if (task)
-			ret = task_pid_nr_ns(task, inode->i_sb->s_fs_info);
+			stack = vma_is_stack_for_task(vma, task);
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
-
-	return ret;
+	return stack;
 }
 
 static void
@@ -335,8 +341,6 @@ show_map_vma(struct seq_file *m, struct 
 
 	name = arch_vma_name(vma);
 	if (!name) {
-		pid_t tid;
-
 		if (!mm) {
 			name = "[vdso]";
 			goto done;
@@ -348,21 +352,8 @@ show_map_vma(struct seq_file *m, struct 
 			goto done;
 		}
 
-		tid = pid_of_stack(priv, vma, is_pid);
-		if (tid != 0) {
-			/*
-			 * Thread stack in /proc/PID/task/TID/maps or
-			 * the main process stack.
-			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack)) {
-				name = "[stack]";
-			} else {
-				/* Thread stack in /proc/PID/maps */
-				seq_pad(m, ' ');
-				seq_printf(m, "[stack:%d]", tid);
-			}
-		}
+		if (is_stack(priv, vma, is_pid))
+			name = "[stack]";
 	}
 
 done:
@@ -1617,19 +1608,8 @@ static int show_numa_map(struct seq_file
 		seq_file_path(m, file, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
-	} else {
-		pid_t tid = pid_of_stack(proc_priv, vma, is_pid);
-		if (tid != 0) {
-			/*
-			 * Thread stack in /proc/PID/task/TID/maps or
-			 * the main process stack.
-			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack))
-				seq_puts(m, " stack");
-			else
-				seq_printf(m, " stack:%d", tid);
-		}
+	} else if (is_stack(proc_priv, vma, is_pid)) {
+		seq_puts(m, " stack");
 	}
 
 	if (is_vm_hugetlb_page(vma))
diff -puN fs/proc/task_nommu.c~proc-revert-proc-pid-maps-annotation fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-revert-proc-pid-maps-annotation
+++ a/fs/proc/task_nommu.c
@@ -123,23 +123,25 @@ unsigned long task_statm(struct mm_struc
 	return size;
 }
 
-static pid_t pid_of_stack(struct proc_maps_private *priv,
-				struct vm_area_struct *vma, bool is_pid)
+static int is_stack(struct proc_maps_private *priv,
+		    struct vm_area_struct *vma, int is_pid)
 {
-	struct inode *inode = priv->inode;
-	struct task_struct *task;
-	pid_t ret = 0;
-
-	rcu_read_lock();
-	task = pid_task(proc_pid(inode), PIDTYPE_PID);
-	if (task) {
-		task = task_of_stack(task, vma, is_pid);
+	int stack = 0;
+
+	if (is_pid) {
+		stack = vma->vm_start <= mm->start_stack &&
+			vma->vm_end >= mm->start_stack;
+	} else {
+		struct inode *inode = priv->inode;
+		struct task_struct *task;
+
+		rcu_read_lock();
+		task = pid_task(proc_pid(inode), PIDTYPE_PID);
 		if (task)
-			ret = task_pid_nr_ns(task, inode->i_sb->s_fs_info);
+			stack = vma_is_stack_for_task(vma, task);
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
-
-	return ret;
+	return stack;
 }
 
 /*
@@ -181,21 +183,9 @@ static int nommu_vma_show(struct seq_fil
 	if (file) {
 		seq_pad(m, ' ');
 		seq_file_path(m, file, "");
-	} else if (mm) {
-		pid_t tid = pid_of_stack(priv, vma, is_pid);
-
-		if (tid != 0) {
-			seq_pad(m, ' ');
-			/*
-			 * Thread stack in /proc/PID/task/TID/maps or
-			 * the main process stack.
-			 */
-			if (!is_pid || (vma->vm_start <= mm->start_stack &&
-			    vma->vm_end >= mm->start_stack))
-				seq_printf(m, "[stack]");
-			else
-				seq_printf(m, "[stack:%d]", tid);
-		}
+	} else if (mm && is_stack(priv, vma, is_pid)) {
+		seq_pad(m, ' ');
+		seq_printf(m, "[stack]");
 	}
 
 	seq_putc(m, '\n');
diff -puN include/linux/mm.h~proc-revert-proc-pid-maps-annotation include/linux/mm.h
--- a/include/linux/mm.h~proc-revert-proc-pid-maps-annotation
+++ a/include/linux/mm.h
@@ -1343,8 +1343,7 @@ static inline int stack_guard_page_end(s
 		!vma_growsup(vma->vm_next, addr);
 }
 
-extern struct task_struct *task_of_stack(struct task_struct *task,
-				struct vm_area_struct *vma, bool in_group);
+int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff -puN mm/util.c~proc-revert-proc-pid-maps-annotation mm/util.c
--- a/mm/util.c~proc-revert-proc-pid-maps-annotation
+++ a/mm/util.c
@@ -260,36 +260,11 @@ void __vma_link_list(struct mm_struct *m
 }
 
 /* Check if the vma is being used as a stack by this task */
-static int vm_is_stack_for_task(struct task_struct *t,
-				struct vm_area_struct *vma)
+int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *t)
 {
 	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
 }
 
-/*
- * Check if the vma is being used as a stack.
- * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task. Returns the task_struct of the task
- * that the vma is stack for. Must be called under rcu_read_lock().
- */
-struct task_struct *task_of_stack(struct task_struct *task,
-				struct vm_area_struct *vma, bool in_group)
-{
-	if (vm_is_stack_for_task(task, vma))
-		return task;
-
-	if (in_group) {
-		struct task_struct *t;
-
-		for_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma))
-				return t;
-		}
-	}
-
-	return NULL;
-}
-
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

