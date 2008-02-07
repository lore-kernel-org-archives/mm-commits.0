From: akpm@linux-foundation.org
Subject: + procfs-task-exe-symlink.patch added to -mm tree
Date: Wed, 06 Feb 2008 18:06:12 -0800
Message-ID: <200802070205.m1725run011072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758207AbYBGCHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 21:07:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthltc@us.ibm.com, dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de, hugh@veritas.com, oleg@tv-sign.ru, viro@zeniv.linux.org.uk


The patch titled
     procfs task exe symlink
has been added to the -mm tree.  Its filename is
     procfs-task-exe-symlink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: David Howells <dhowells@redhat.com>
Cc:"Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c         |    3 +
 fs/exec.c                |    3 +
 fs/proc/base.c           |   73 +++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h       |    1 
 fs/proc/task_mmu.c       |   34 -----------------
 fs/proc/task_nommu.c     |   34 -----------------
 include/linux/mm.h       |   13 ++++++
 include/linux/mm_types.h |    6 +++
 include/linux/proc_fs.h  |   20 +++++++++-
 kernel/fork.c            |    2 +
 mm/mmap.c                |   24 ++++++++++--
 mm/nommu.c               |   15 ++++++-
 12 files changed, 150 insertions(+), 78 deletions(-)

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
@@ -965,6 +965,9 @@ int flush_old_exec(struct linux_binprm *
 	retval = unshare_files();
 	if (retval)
 		goto out;
+
+	set_mm_exe_file(bprm->mm, bprm->file);
+
 	/*
 	 * Release all of the old mmap stuff
 	 */
diff -puN fs/proc/base.c~procfs-task-exe-symlink fs/proc/base.c
--- a/fs/proc/base.c~procfs-task-exe-symlink
+++ a/fs/proc/base.c
@@ -1147,6 +1147,79 @@ static const struct file_operations proc
 
 #endif
 
+/* We added or removed a vma mapping the executable. The vmas are only mapped
+ * during exec and are not mapped with the mmap system call.
+ * Callers must hold the mm's mmap_sem for these */
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
@@ -1028,6 +1028,19 @@ extern void unlink_file_vma(struct vm_ar
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
@@ -228,6 +228,12 @@ struct mm_struct {
 #ifdef CONFIG_CGROUP_MEM_CONT
 	struct mem_cgroup *mem_cgroup;
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
@@ -209,6 +208,12 @@ extern void proc_net_remove(struct net *
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
@@ -258,6 +263,19 @@ static inline void pid_ns_release_proc(s
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
@@ -410,6 +410,7 @@ void mmput(struct mm_struct *mm)
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
 		exit_mmap(mm);
+		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -526,6 +527,7 @@ static struct mm_struct *dup_mm(struct t
 	if (err)
 		goto free_pt;
 
+	dup_mm_exe_file(oldmm, mm);
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
 
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
 	mpol_free(vma_policy(vma));
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
 		mpol_free(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
@@ -1155,6 +1161,8 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
+		if (vm_flags & VM_EXECUTABLE)
+			added_exe_file_vma(mm);
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
@@ -1192,6 +1200,8 @@ munmap_back:
 			if (correct_wcount)
 				atomic_inc(&inode->i_writecount);
 			fput(file);
+			if (vm_flags & VM_EXECUTABLE)
+				removed_exe_file_vma(mm);
 		}
 		mpol_free(vma_policy(vma));
 		kmem_cache_free(vm_area_cachep, vma);
@@ -1820,8 +1830,11 @@ int split_vma(struct mm_struct * mm, str
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
@@ -2138,8 +2151,11 @@ struct vm_area_struct *copy_vma(struct v
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
@@ -962,8 +962,11 @@ unsigned long do_mmap_pgoff(struct file 
 
 	INIT_LIST_HEAD(&vma->anon_vma_node);
 	atomic_set(&vma->vm_usage, 1);
-	if (file)
+	if (file) {
 		get_file(file);
+		if (vm_flags & VM_EXECUTABLE)
+			added_exe_file_vma(mm);
+	}
 	vma->vm_file	= file;
 	vma->vm_flags	= vm_flags;
 	vma->vm_start	= addr;
@@ -1018,8 +1021,11 @@ unsigned long do_mmap_pgoff(struct file 
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
@@ -1071,8 +1077,11 @@ static void put_vma(struct vm_area_struc
 			realalloc -= kobjsize(vma);
 			askedalloc -= sizeof(*vma);
 
-			if (vma->vm_file)
+			if (vma->vm_file) {
 				fput(vma->vm_file);
+				if (vma->vm_flags & VM_EXECUTABLE)
+					removed_exe_file_vma(vma->vm_mm);
+			}
 			kfree(vma);
 		}
 
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
