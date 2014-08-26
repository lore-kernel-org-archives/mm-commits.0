From: akpm@linux-foundation.org
Subject: + proc-maps-make-vm_is_stack-logic-namespace-friendly.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:42:19 -0700
Message-ID: <53fd1b5b.L/XiEcW/6tNaVZqA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:36609 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaHZXmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:42:20 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so2492335obc.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:42:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gerg@uclinux.org, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/maps: make vm_is_stack() logic namespace-friendly
has been added to the -mm tree.  Its filename is
     proc-maps-make-vm_is_stack-logic-namespace-friendly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-maps-make-vm_is_stack-logic-namespace-friendly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: proc/maps: make vm_is_stack() logic namespace-friendly

- Rename vm_is_stack() to task_of_stack() and change it to return
  "struct task_struct *" rather than the global (and thus wrong in
  general) pid_t.

- Add the new pid_of_stack() helper which calls task_of_stack() and
  uses the right namespace to report the correct pid_t.

  Unfortunately we need to define this helper twice, in task_mmu.c
  and in task_nommu.c. perhaps it makes sense to add fs/proc/util.c
  and move at least pid_of_stack/task_of_stack there to avoid the
  code duplication.

- Change show_map_vma() and show_numa_map() to use the new helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c   |   25 +++++++++++++++++++++----
 fs/proc/task_nommu.c |   21 ++++++++++++++++++++-
 include/linux/mm.h   |    4 ++--
 mm/util.c            |   23 ++++++++---------------
 4 files changed, 51 insertions(+), 22 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-maps-make-vm_is_stack-logic-namespace-friendly fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-maps-make-vm_is_stack-logic-namespace-friendly
+++ a/fs/proc/task_mmu.c
@@ -262,13 +262,31 @@ static int do_maps_open(struct inode *in
 				sizeof(struct proc_maps_private));
 }
 
+static pid_t pid_of_stack(struct proc_maps_private *priv,
+				struct vm_area_struct *vma, bool is_pid)
+{
+	struct inode *inode = priv->inode;
+	struct task_struct *task;
+	pid_t ret = 0;
+
+	rcu_read_lock();
+	task = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (task) {
+		task = task_of_stack(task, vma, is_pid);
+		if (task)
+			ret = task_pid_nr_ns(task, inode->i_sb->s_fs_info);
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static void
 show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
@@ -333,8 +351,7 @@ show_map_vma(struct seq_file *m, struct
 			goto done;
 		}
 
-		tid = vm_is_stack(task, vma, is_pid);
-
+		tid = pid_of_stack(priv, vma, is_pid);
 		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
@@ -1438,7 +1455,7 @@ static int show_numa_map(struct seq_file
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
 	} else {
-		pid_t tid = vm_is_stack(task, vma, is_pid);
+		pid_t tid = pid_of_stack(proc_priv, vma, is_pid);
 		if (tid != 0) {
 			/*
 			 * Thread stack in /proc/PID/task/TID/maps or
diff -puN fs/proc/task_nommu.c~proc-maps-make-vm_is_stack-logic-namespace-friendly fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-maps-make-vm_is_stack-logic-namespace-friendly
+++ a/fs/proc/task_nommu.c
@@ -123,6 +123,25 @@ unsigned long task_statm(struct mm_struc
 	return size;
 }
 
+static pid_t pid_of_stack(struct proc_maps_private *priv,
+				struct vm_area_struct *vma, bool is_pid)
+{
+	struct inode *inode = priv->inode;
+	struct task_struct *task;
+	pid_t ret = 0;
+
+	rcu_read_lock();
+	task = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (task) {
+		task = task_of_stack(task, vma, is_pid);
+		if (task)
+			ret = task_pid_nr_ns(task, inode->i_sb->s_fs_info);
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * display a single VMA to a sequenced file
  */
@@ -163,7 +182,7 @@ static int nommu_vma_show(struct seq_fil
 		seq_pad(m, ' ');
 		seq_path(m, &file->f_path, "");
 	} else if (mm) {
-		pid_t tid = vm_is_stack(priv->task, vma, is_pid);
+		pid_t tid = pid_of_stack(priv, vma, is_pid);
 
 		if (tid != 0) {
 			seq_pad(m, ' ');
diff -puN include/linux/mm.h~proc-maps-make-vm_is_stack-logic-namespace-friendly include/linux/mm.h
--- a/include/linux/mm.h~proc-maps-make-vm_is_stack-logic-namespace-friendly
+++ a/include/linux/mm.h
@@ -1248,8 +1248,8 @@ static inline int stack_guard_page_end(s
 		!vma_growsup(vma->vm_next, addr);
 }
 
-extern pid_t
-vm_is_stack(struct task_struct *task, struct vm_area_struct *vma, int in_group);
+extern struct task_struct *task_of_stack(struct task_struct *task,
+				struct vm_area_struct *vma, bool in_group);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
diff -puN mm/util.c~proc-maps-make-vm_is_stack-logic-namespace-friendly mm/util.c
--- a/mm/util.c~proc-maps-make-vm_is_stack-logic-namespace-friendly
+++ a/mm/util.c
@@ -200,32 +200,25 @@ static int vm_is_stack_for_task(struct t
 /*
  * Check if the vma is being used as a stack.
  * If is_group is non-zero, check in the entire thread group or else
- * just check in the current task. Returns the pid of the task that
- * the vma is stack for.
+ * just check in the current task. Returns the task_struct of the task
+ * that the vma is stack for. Must be called under rcu_read_lock().
  */
-pid_t vm_is_stack(struct task_struct *task,
-		  struct vm_area_struct *vma, int in_group)
+struct task_struct *task_of_stack(struct task_struct *task,
+				struct vm_area_struct *vma, bool in_group)
 {
-	pid_t ret = 0;
-
 	if (vm_is_stack_for_task(task, vma))
-		return task->pid;
+		return task;
 
 	if (in_group) {
 		struct task_struct *t;
 
-		rcu_read_lock();
 		for_each_thread(task, t) {
-			if (vm_is_stack_for_task(t, vma)) {
-				ret = t->pid;
-				goto done;
-			}
+			if (vm_is_stack_for_task(t, vma))
+				return t;
 		}
-done:
-		rcu_read_unlock();
 	}
 
-	return ret;
+	return NULL;
 }
 
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
_

Patches currently in -mm which might be from oleg@redhat.com are

prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

