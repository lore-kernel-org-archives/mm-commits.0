From: akpm@linux-foundation.org
Subject: - maps4-move-clear_refs-code-to-task_mmuc.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:31:10 -0800
Message-ID: <200802052230.m15MUpxX012111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932305AbYBEWnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, haveblue@us.ibm.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps4: move clear_refs code to task_mmu.c
has been removed from the -mm tree.  Its filename was
     maps4-move-clear_refs-code-to-task_mmuc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maps4: move clear_refs code to task_mmu.c
From: Matt Mackall <mpm@selenic.com>

This puts all the clear_refs code where it belongs and probably lets things
compile on MMU-less systems as well.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   40 ----------------------------------
 fs/proc/internal.h      |    6 -----
 fs/proc/task_mmu.c      |   44 +++++++++++++++++++++++++++++++-------
 include/linux/proc_fs.h |    3 +-
 4 files changed, 39 insertions(+), 54 deletions(-)

diff -puN fs/proc/base.c~maps4-move-clear_refs-code-to-task_mmuc fs/proc/base.c
--- a/fs/proc/base.c~maps4-move-clear_refs-code-to-task_mmuc
+++ a/fs/proc/base.c
@@ -88,10 +88,6 @@
  *	in /proc for a task before it execs a suid executable.
  */
 
-
-/* Worst case buffer size needed for holding an integer. */
-#define PROC_NUMBUF 13
-
 struct pid_entry {
 	char *name;
 	int len;
@@ -935,42 +931,6 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
-#ifdef CONFIG_MMU
-static ssize_t clear_refs_write(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
-	struct mm_struct *mm;
-
-	memset(buffer, 0, sizeof(buffer));
-	if (count > sizeof(buffer) - 1)
-		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
-	if (!simple_strtol(buffer, &end, 0))
-		return -EINVAL;
-	if (*end == '\n')
-		end++;
-	task = get_proc_task(file->f_path.dentry->d_inode);
-	if (!task)
-		return -ESRCH;
-	mm = get_task_mm(task);
-	if (mm) {
-		clear_refs_smap(mm);
-		mmput(mm);
-	}
-	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
-}
-
-static struct file_operations proc_clear_refs_operations = {
-	.write		= clear_refs_write,
-};
-#endif
-
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
diff -puN fs/proc/internal.h~maps4-move-clear_refs-code-to-task_mmuc fs/proc/internal.h
--- a/fs/proc/internal.h~maps4-move-clear_refs-code-to-task_mmuc
+++ a/fs/proc/internal.h
@@ -56,11 +56,7 @@ extern int proc_pid_statm(struct task_st
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
-
-extern const struct file_operations proc_maps_operations;
-extern const struct file_operations proc_numa_maps_operations;
-extern const struct file_operations proc_smaps_operations;
-
+extern const struct file_operations proc_clear_refs_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
 
diff -puN fs/proc/task_mmu.c~maps4-move-clear_refs-code-to-task_mmuc fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps4-move-clear_refs-code-to-task_mmuc
+++ a/fs/proc/task_mmu.c
@@ -323,19 +323,47 @@ static int show_smap(struct seq_file *m,
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
 
-void clear_refs_smap(struct mm_struct *mm)
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
 {
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 
-	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
-		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
-					&clear_refs_walk, vma);
-	flush_tlb_mm(mm);
-	up_read(&mm->mmap_sem);
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	if (!simple_strtol(buffer, &end, 0))
+		return -EINVAL;
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	mm = get_task_mm(task);
+	if (mm) {
+		down_read(&mm->mmap_sem);
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (!is_vm_hugetlb_page(vma))
+				walk_page_range(mm, vma->vm_start, vma->vm_end,
+						&clear_refs_walk, vma);
+		flush_tlb_mm(mm);
+		up_read(&mm->mmap_sem);
+		mmput(mm);
+	}
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
 }
 
+const struct file_operations proc_clear_refs_operations = {
+	.write		= clear_refs_write,
+};
+
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
diff -puN include/linux/proc_fs.h~maps4-move-clear_refs-code-to-task_mmuc include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~maps4-move-clear_refs-code-to-task_mmuc
+++ a/include/linux/proc_fs.h
@@ -19,6 +19,8 @@ struct completion;
  */
 #define FIRST_PROCESS_ENTRY 256
 
+/* Worst case buffer size needed for holding an integer. */
+#define PROC_NUMBUF 13
 
 /*
  * We always define these enumerators
@@ -117,7 +119,6 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct mm_struct *mm);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
 void de_put(struct proc_dir_entry *de);
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-clean-up-checkpatch-complaints-fix.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
random-add-async-notification-support-to-dev-random.patch
