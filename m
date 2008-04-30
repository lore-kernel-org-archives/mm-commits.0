From: akpm@linux-foundation.org
Subject: - procfs-task-exe-symlink.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:42 -0700
Message-ID: <200804300545.m3U5jgLi029531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760529AbYD3GW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de, hugh@veritas.com, oleg@tv-sign.ru, viro@zeniv.linux.org.uk, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     procfs task exe symlink
has been removed from the -mm tree.  Its filename was
     procfs-task-exe-symlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs task exe symlink
From: Matt Helsley <matthltc@us.ibm.com>

The kernel implements readlink of /proc/pid/exe by getting the file from
the first executable VMA.  Then the path to the file is reconstructed and
reported as the result.

Because of the VMA walk the code is slightly different on nommu systems. 
This patch avoids separate /proc/pid/exe code on nommu systems.  Instead of
walking the VMAs to find the first executable file-backed VMA we store a
reference to the exec'd file in the mm_struct.

That reference would prevent the filesystem holding the executable file
from being unmounted even after unmapping the VMAs.  So we track the number
of VM_EXECUTABLE VMAs and drop the new reference when the last one is
unmapped.  This avoids pinning the mounted filesystem.

[akpm@linux-foundation.org: improve comments]
[yamamoto@valinux.co.jp: fix dup_mmap]
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Howells <dhowells@redhat.com>
Cc:"Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c         |    3 -
 fs/exec.c                |    2 
 fs/proc/base.c           |   75 +++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h       |    1 
 fs/proc/task_mmu.c       |   34 ----------------
 fs/proc/task_nommu.c     |   34 ----------------
 include/linux/mm.h       |   13 ++++++
 include/linux/mm_types.h |    6 ++
 include/linux/proc_fs.h  |   20 +++++++++
 kernel/fork.c            |    3 +
 mm/mmap.c                |   24 +++++++++--
 mm/nommu.c               |   23 ++++++++---
 12 files changed, 157 insertions(+), 81 deletions(-)

diff -puN fs/binfmt_flat.c~procfs-task-exe-symlink fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~procfs-task-exe-symlink
+++ a/fs/binfmt_flat.c
@@ -531,7 +531,8 @@ static int load_flat_file(struct linux_b
 		DBG_FLT("BINFMT_FLAT: ROM mapping of file (we hope)\n");
 
 		down_write(&current->mm->mmap_sem);
-		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC, MAP_PRIVATE, 0);
+		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
+				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
 		up_write(&current->mm->mmap_sem);
 		if (!textpos  || textpos >= (unsigned long) -4096) {
 			if (!textpos)
diff -puN fs/exec.c~procfs-task-exe-symlink fs/exec.c
--- a/fs/exec.c~procfs-task-exe-symlink
+++ a/fs/exec.c
@@ -964,6 +964,8 @@ int flush_old_exec(struct linux_binprm *
 	if (retval)
 		goto out;
 
+	set_mm_exe_file(bprm->mm, bprm->file);
+
 	/*
 	 * Release all of the old mmap stuff
 	 */
diff -puN fs/proc/base.c~procfs-task-exe-symlink fs/proc/base.c
--- a/fs/proc/base.c~procfs-task-exe-symlink
+++ a/fs/proc/base.c
@@ -1181,6 +1181,81 @@ static const struct file_operations proc
 
 #endif
 
+/*
+ * We added or removed a vma mapping the executable. The vmas are only mapped
+ * during exec and are not mapped with the mmap system call.
+ * Callers must hold down_write() on the mm's mmap_sem for these
+ */
+void added_exe_file_vma(struct mm_struct *mm)
+{
+	mm->num_exe_file_vmas++;
+}
+
+void removed_exe_file_vma(struct mm_struct *mm)
+{
+	mm->num_exe_file_vmas--;
+	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){
+		fput(mm->exe_file);
+		mm->exe_file = NULL;
+	}
+
+}
+
+void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
+{
+	if (new_exe_file)
+		get_file(new_exe_file);
+	if (mm->exe_file)
+		fput(mm->exe_file);
+	mm->exe_file = new_exe_file;
+	mm->num_exe_file_vmas = 0;
+}
+
+struct file *get_mm_exe_file(struct mm_struct *mm)
+{
+	struct file *exe_file;
+
+	/* We need mmap_sem to protect against races with removal of
+	 * VM_EXECUTABLE vmas */
+	down_read(&mm->mmap_sem);
+	exe_file = mm->exe_file;
+	if (exe_file)
+		get_file(exe_file);
+	up_read(&mm->mmap_sem);
+	return exe_file;
+}
+
+void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
+{
+	/* It's safe to write the exe_file pointer without exe_file_lock because
+	 * this is called during fork when the task is not yet in /proc */
+	newmm->exe_file = get_mm_exe_file(oldmm);
+}
+
+static int proc_exe_link(struct inode *inode, struct path *exe_path)
+{
+	struct task_struct *task;
+	struct mm_struct *mm;
+	struct file *exe_file;
+
+	task = get_proc_task(inode);
+	if (!task)
+		return -ENOENT;
+	mm = get_task_mm(task);
+	put_task_struct(task);
+	if (!mm)
+		return -ENOENT;
+	exe_file = get_mm_exe_file(mm);
+	mmput(mm);
+	if (exe_file) {
+		*exe_path = exe_file->f_path;
+		path_get(&exe_file->f_path);
+		fput(exe_file);
+		return 0;
+	} else
+		return -ENOENT;
+}
+
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
diff -puN fs/proc/internal.h~procfs-task-exe-symlink fs/proc/internal.h
--- a/fs/proc/internal.h~procfs-task-exe-symlink
+++ a/fs/proc/internal.h
@@ -48,7 +48,6 @@ extern int maps_protect;
 
 extern void create_seq_entry(char *name, mode_t mode,
 				const struct file_operations *f);
-extern int proc_exe_link(struct inode *, struct path *);
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
diff -puN fs/proc/task_mmu.c~procfs-task-exe-symlink fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-task-exe-symlink
+++ a/fs/proc/task_mmu.c
@@ -75,40 +75,6 @@ int task_statm(struct mm_struct *mm, int
 	return mm->total_vm;
 }
 
-int proc_exe_link(struct inode *inode, struct path *path)
-{
-	struct vm_area_struct * vma;
-	int result = -ENOENT;
-	struct task_struct *task = get_proc_task(inode);
-	struct mm_struct * mm = NULL;
-
-	if (task) {
-		mm = get_task_mm(task);
-		put_task_struct(task);
-	}
-	if (!mm)
-		goto out;
-	down_read(&mm->mmap_sem);
-
-	vma = mm->mmap;
-	while (vma) {
-		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file)
-			break;
-		vma = vma->vm_next;
-	}
-
-	if (vma) {
-		*path = vma->vm_file->f_path;
-		path_get(&vma->vm_file->f_path);
-		result = 0;
-	}
-
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-out:
-	return result;
-}
-
 static void pad_len_spaces(struct seq_file *m, int len)
 {
 	len = 25 + sizeof(void*) * 6 - len;
diff -puN fs/proc/task_nommu.c~procfs-task-exe-symlink fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-task-exe-symlink
+++ a/fs/proc/task_nommu.c
@@ -103,40 +103,6 @@ int task_statm(struct mm_struct *mm, int
 	return size;
 }
 
-int proc_exe_link(struct inode *inode, struct path *path)
-{
-	struct vm_list_struct *vml;
-	struct vm_area_struct *vma;
-	struct task_struct *task = get_proc_task(inode);
-	struct mm_struct *mm = get_task_mm(task);
-	int result = -ENOENT;
-
-	if (!mm)
-		goto out;
-	down_read(&mm->mmap_sem);
-
-	vml = mm->context.vmlist;
-	vma = NULL;
-	while (vml) {
-		if ((vml->vma->vm_flags & VM_EXECUTABLE) && vml->vma->vm_file) {
-			vma = vml->vma;
-			break;
-		}
-		vml = vml->next;
-	}
-
-	if (vma) {
-		*path = vma->vm_file->f_path;
-		path_get(&vma->vm_file->f_path);
-		result = 0;
-	}
-
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-out:
-	return result;
-}
-
 /*
  * display mapping lines for a particular process's /proc/pid/maps
  */
diff -puN include/linux/mm.h~procfs-task-exe-symlink include/linux/mm.h
--- a/include/linux/mm.h~procfs-task-exe-symlink
+++ a/include/linux/mm.h
@@ -1066,6 +1066,19 @@ extern void unlink_file_vma(struct vm_ar
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
 extern void exit_mmap(struct mm_struct *);
+
+#ifdef CONFIG_PROC_FS
+/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
+extern void added_exe_file_vma(struct mm_struct *mm);
+extern void removed_exe_file_vma(struct mm_struct *mm);
+#else
+static inline void added_exe_file_vma(struct mm_struct *mm)
+{}
+
+static inline void removed_exe_file_vma(struct mm_struct *mm)
+{}
+#endif /* CONFIG_PROC_FS */
+
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
diff -puN include/linux/mm_types.h~procfs-task-exe-symlink include/linux/mm_types.h
--- a/include/linux/mm_types.h~procfs-task-exe-symlink
+++ a/include/linux/mm_types.h
@@ -226,6 +226,12 @@ struct mm_struct {
 	struct task_struct *owner;	/* The thread group leader that */
 					/* owns the mm_struct.		*/
 #endif
+
+#ifdef CONFIG_PROC_FS
+	/* store ref to file /proc/<pid>/exe symlink points to */
+	struct file *exe_file;
+	unsigned long num_exe_file_vmas;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */
diff -puN include/linux/proc_fs.h~procfs-task-exe-symlink include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~procfs-task-exe-symlink
+++ a/include/linux/proc_fs.h
@@ -9,7 +9,6 @@
 
 struct net;
 struct completion;
-
 /*
  * The proc filesystem constants/structures
  */
@@ -206,6 +205,12 @@ extern void proc_net_remove(struct net *
 extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 	struct proc_dir_entry *parent);
 
+/* While the {get|set|dup}_mm_exe_file functions are for mm_structs, they are
+ * only needed to implement /proc/<pid>|self/exe so we define them here. */
+extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
+extern struct file *get_mm_exe_file(struct mm_struct *mm);
+extern void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm);
+
 #else
 
 #define proc_root_driver NULL
@@ -255,6 +260,19 @@ static inline void pid_ns_release_proc(s
 {
 }
 
+static inline void set_mm_exe_file(struct mm_struct *mm,
+				   struct file *new_exe_file)
+{}
+
+static inline struct file *get_mm_exe_file(struct mm_struct *mm)
+{
+	return NULL;
+}
+
+static inline void dup_mm_exe_file(struct mm_struct *oldmm,
+	       			   struct mm_struct *newmm)
+{}
+
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
diff -puN kernel/fork.c~procfs-task-exe-symlink kernel/fork.c
--- a/kernel/fork.c~procfs-task-exe-symlink
+++ a/kernel/fork.c
@@ -431,6 +431,7 @@ void mmput(struct mm_struct *mm)
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
 		exit_mmap(mm);
+		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -543,6 +544,8 @@ struct mm_struct *dup_mm(struct task_str
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
+	dup_mm_exe_file(oldmm, mm);
+
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
diff -puN mm/mmap.c~procfs-task-exe-symlink mm/mmap.c
--- a/mm/mmap.c~procfs-task-exe-symlink
+++ a/mm/mmap.c
@@ -230,8 +230,11 @@ static struct vm_area_struct *remove_vma
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file)
+	if (vma->vm_file) {
 		fput(vma->vm_file);
+		if (vma->vm_flags & VM_EXECUTABLE)
+			removed_exe_file_vma(vma->vm_mm);
+	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
@@ -623,8 +626,11 @@ again:			remove_next = 1 + (end > next->
 		spin_unlock(&mapping->i_mmap_lock);
 
 	if (remove_next) {
-		if (file)
+		if (file) {
 			fput(file);
+			if (next->vm_flags & VM_EXECUTABLE)
+				removed_exe_file_vma(mm);
+		}
 		mm->map_count--;
 		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
@@ -1154,6 +1160,8 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
+		if (vm_flags & VM_EXECUTABLE)
+			added_exe_file_vma(mm);
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
@@ -1185,6 +1193,8 @@ munmap_back:
 		mpol_put(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
 		fput(file);
+		if (vm_flags & VM_EXECUTABLE)
+			removed_exe_file_vma(mm);
 	} else {
 		vma_link(mm, vma, prev, rb_link, rb_parent);
 		file = vma->vm_file;
@@ -1817,8 +1827,11 @@ int split_vma(struct mm_struct * mm, str
 	}
 	vma_set_policy(new, pol);
 
-	if (new->vm_file)
+	if (new->vm_file) {
 		get_file(new->vm_file);
+		if (vma->vm_flags & VM_EXECUTABLE)
+			added_exe_file_vma(mm);
+	}
 
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
@@ -2135,8 +2148,11 @@ struct vm_area_struct *copy_vma(struct v
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
-			if (new_vma->vm_file)
+			if (new_vma->vm_file) {
 				get_file(new_vma->vm_file);
+				if (vma->vm_flags & VM_EXECUTABLE)
+					added_exe_file_vma(mm);
+			}
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
 				new_vma->vm_ops->open(new_vma);
 			vma_link(mm, new_vma, prev, rb_link, rb_parent);
diff -puN mm/nommu.c~procfs-task-exe-symlink mm/nommu.c
--- a/mm/nommu.c~procfs-task-exe-symlink
+++ a/mm/nommu.c
@@ -966,8 +966,13 @@ unsigned long do_mmap_pgoff(struct file 
 
 	INIT_LIST_HEAD(&vma->anon_vma_node);
 	atomic_set(&vma->vm_usage, 1);
-	if (file)
+	if (file) {
 		get_file(file);
+		if (vm_flags & VM_EXECUTABLE) {
+			added_exe_file_vma(current->mm);
+			vma->vm_mm = current->mm;
+		}
+	}
 	vma->vm_file	= file;
 	vma->vm_flags	= vm_flags;
 	vma->vm_start	= addr;
@@ -1022,8 +1027,11 @@ unsigned long do_mmap_pgoff(struct file 
 	up_write(&nommu_vma_sem);
 	kfree(vml);
 	if (vma) {
-		if (vma->vm_file)
+		if (vma->vm_file) {
 			fput(vma->vm_file);
+			if (vma->vm_flags & VM_EXECUTABLE)
+				removed_exe_file_vma(vma->vm_mm);
+		}
 		kfree(vma);
 	}
 	return ret;
@@ -1053,7 +1061,7 @@ EXPORT_SYMBOL(do_mmap_pgoff);
 /*
  * handle mapping disposal for uClinux
  */
-static void put_vma(struct vm_area_struct *vma)
+static void put_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	if (vma) {
 		down_write(&nommu_vma_sem);
@@ -1075,8 +1083,11 @@ static void put_vma(struct vm_area_struc
 			realalloc -= kobjsize(vma);
 			askedalloc -= sizeof(*vma);
 
-			if (vma->vm_file)
+			if (vma->vm_file) {
 				fput(vma->vm_file);
+				if (vma->vm_flags & VM_EXECUTABLE)
+					removed_exe_file_vma(mm);
+			}
 			kfree(vma);
 		}
 
@@ -1113,7 +1124,7 @@ int do_munmap(struct mm_struct *mm, unsi
  found:
 	vml = *parent;
 
-	put_vma(vml->vma);
+	put_vma(mm, vml->vma);
 
 	*parent = vml->next;
 	realalloc -= kobjsize(vml);
@@ -1158,7 +1169,7 @@ void exit_mmap(struct mm_struct * mm)
 
 		while ((tmp = mm->context.vmlist)) {
 			mm->context.vmlist = tmp->next;
-			put_vma(tmp->vma);
+			put_vma(mm, tmp->vma);
 
 			realalloc -= kobjsize(tmp);
 			askedalloc -= sizeof(*tmp);
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

origin.patch
devpts-factor-out-pty-index-allocation.patch
devpts-factor-out-pty-index-allocation-fix.patch

