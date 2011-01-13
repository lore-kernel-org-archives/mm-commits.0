From: akpm@linux-foundation.org
Subject: [merged] proc-use-unsigned-long-inside-proc-statm.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:30 -0800
Message-ID: <201101132011.p0DKBBIM030133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933687Ab1AMULm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: use unsigned long inside /proc/*/statm
has been removed from the -mm tree.  Its filename was
     proc-use-unsigned-long-inside-proc-statm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: use unsigned long inside /proc/*/statm
From: Alexey Dobriyan <adobriyan@gmail.com>

/proc/*/statm code needlessly truncates data from unsigned long to int.
One needs only 8+ TB of RAM to make truncation visible.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c      |    6 +++---
 fs/proc/internal.h   |    3 ++-
 fs/proc/task_mmu.c   |    5 +++--
 fs/proc/task_nommu.c |    7 ++++---
 4 files changed, 12 insertions(+), 9 deletions(-)

diff -puN fs/proc/array.c~proc-use-unsigned-long-inside-proc-statm fs/proc/array.c
--- a/fs/proc/array.c~proc-use-unsigned-long-inside-proc-statm
+++ a/fs/proc/array.c
@@ -535,15 +535,15 @@ int proc_tgid_stat(struct seq_file *m, s
 int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
-	int size = 0, resident = 0, shared = 0, text = 0, lib = 0, data = 0;
+	unsigned long size = 0, resident = 0, shared = 0, text = 0, data = 0;
 	struct mm_struct *mm = get_task_mm(task);
 
 	if (mm) {
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
-	seq_printf(m, "%d %d %d %d %d %d %d\n",
-			size, resident, shared, text, lib, data, 0);
+	seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
+			size, resident, shared, text, data);
 
 	return 0;
 }
diff -puN fs/proc/internal.h~proc-use-unsigned-long-inside-proc-statm fs/proc/internal.h
--- a/fs/proc/internal.h~proc-use-unsigned-long-inside-proc-statm
+++ a/fs/proc/internal.h
@@ -96,7 +96,8 @@ extern spinlock_t proc_subdir_lock;
 struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
-int task_statm(struct mm_struct *, int *, int *, int *, int *);
+unsigned long task_statm(struct mm_struct *,
+	unsigned long *, unsigned long *, unsigned long *, unsigned long *);
 void task_mem(struct seq_file *, struct mm_struct *);
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
diff -puN fs/proc/task_mmu.c~proc-use-unsigned-long-inside-proc-statm fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-use-unsigned-long-inside-proc-statm
+++ a/fs/proc/task_mmu.c
@@ -66,8 +66,9 @@ unsigned long task_vsize(struct mm_struc
 	return PAGE_SIZE * mm->total_vm;
 }
 
-int task_statm(struct mm_struct *mm, int *shared, int *text,
-	       int *data, int *resident)
+unsigned long task_statm(struct mm_struct *mm,
+			 unsigned long *shared, unsigned long *text,
+			 unsigned long *data, unsigned long *resident)
 {
 	*shared = get_mm_counter(mm, MM_FILEPAGES);
 	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
diff -puN fs/proc/task_nommu.c~proc-use-unsigned-long-inside-proc-statm fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-use-unsigned-long-inside-proc-statm
+++ a/fs/proc/task_nommu.c
@@ -92,13 +92,14 @@ unsigned long task_vsize(struct mm_struc
 	return vsize;
 }
 
-int task_statm(struct mm_struct *mm, int *shared, int *text,
-	       int *data, int *resident)
+unsigned long task_statm(struct mm_struct *mm,
+			 unsigned long *shared, unsigned long *text,
+			 unsigned long *data, unsigned long *resident)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *p;
-	int size = kobjsize(mm);
+	unsigned long size = kobjsize(mm);
 
 	down_read(&mm->mmap_sem);
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p)) {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

