From: akpm@linux-foundation.org
Subject: - maps2-move-clear_refs-code-to-task_mmuc.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:36:26 -0700
Message-ID: <200710162136.l9GLaQPi018576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966031AbXJPVsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, jeremy@goop.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     maps: move clear_refs code to task_mmu.c
has been removed from the -mm tree.  Its filename was
     maps2-move-clear_refs-code-to-task_mmuc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: maps: move clear_refs code to task_mmu.c
From: Matt Mackall <mpm@selenic.com>

This puts all the clear_refs code where it belongs and probably lets things
compile on MMU-less systems as well.

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   36 -------------------------------
 fs/proc/internal.h      |    6 -----
 fs/proc/task_mmu.c      |   44 +++++++++++++++++++++++++++++++-------
 include/linux/proc_fs.h |    1 
 4 files changed, 37 insertions(+), 50 deletions(-)

diff -puN fs/proc/base.c~maps2-move-clear_refs-code-to-task_mmuc fs/proc/base.c
--- a/fs/proc/base.c~maps2-move-clear_refs-code-to-task_mmuc
+++ a/fs/proc/base.c
@@ -713,42 +713,6 @@ static const struct file_operations proc
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
diff -puN fs/proc/internal.h~maps2-move-clear_refs-code-to-task_mmuc fs/proc/internal.h
--- a/fs/proc/internal.h~maps2-move-clear_refs-code-to-task_mmuc
+++ a/fs/proc/internal.h
@@ -54,11 +54,7 @@ extern int proc_pid_statm(struct task_st
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
 
diff -puN fs/proc/task_mmu.c~maps2-move-clear_refs-code-to-task_mmuc fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-move-clear_refs-code-to-task_mmuc
+++ a/fs/proc/task_mmu.c
@@ -297,19 +297,47 @@ static int show_smap(struct seq_file *m,
 
 static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
 
-void clear_refs_smap(struct mm_struct *mm)
+static ssize_t clear_refs_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
 {
+	struct task_struct *task;
+	char buffer[13], *end;
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
diff -puN include/linux/proc_fs.h~maps2-move-clear_refs-code-to-task_mmuc include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~maps2-move-clear_refs-code-to-task_mmuc
+++ a/include/linux/proc_fs.h
@@ -115,7 +115,6 @@ int proc_pid_readdir(struct file * filp,
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
 char *task_mem(struct mm_struct *, char *);
-void clear_refs_smap(struct mm_struct *mm);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
 void de_put(struct proc_dir_entry *de);
_

Patches currently in -mm which might be from mpm@selenic.com are

origin.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-return-length-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-end-address-calculation.patch
maps2-add-proc-pid-pagemap-interface-fix-proc-pid-pagemap-header-copy-to-userspace.patch
maps2-add-proc-kpagemap-interface.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
lib-sortc-optimization.patch
sparse-pointer-use-of-zero-as-null.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
