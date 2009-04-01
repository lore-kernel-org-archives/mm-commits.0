From: akpm@linux-foundation.org
Subject: [nacked] mm-remove-struct-mm_struct-exe_file-et-al.patch removed from -mm tree
Date: Wed, 01 Apr 2009 09:33:39 -0700
Message-ID: <200904011633.n31GXdW6004829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763378AbZDAQkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 12:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de, matthltc@us.ibm.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     mm: remove struct mm_struct::exe_file et al
has been removed from the -mm tree.  Its filename was
     mm-remove-struct-mm_struct-exe_file-et-al.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove struct mm_struct::exe_file et al
From: Alexey Dobriyan <adobriyan@gmail.com>

Commit 925d1c401fa6cfd0df5d2e37da8981494ccdec07 ("procfs task exe
symlink").  introduced struct mm_struct::exe_file and struct
mm_struct::num_exe_file_vmas.

The rationale is weak: unifying MMU and no-MMU version of /proc/*/exe
code.  For this a) struct mm_struct becomes bigger, b) mmap/munmap/exit
become slower, c) patch adds more code than removes in fact.

->exe_file maybe well defined, but doesn't make sense always.  After
original executable is unmapped, /proc/*/exe will still report it and,
more importantly, pin corresponding struct file.

->num_exe_file_vmas is even worse -- it just counts number of executable
file-backed VMAs even if those VMAs aren't related to ->exe_file.

After commit 8feae13110d60cc6287afabc2887366b0eb226c2 aka "NOMMU: Make
VMAs per MM as for MMU-mode linux" no-MMU kernels also maintain list of
VMAs in ->mmap, so we can switch back for MMU version of /proc/*/exe.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c         |    3 -
 fs/exec.c                |    2 
 fs/proc/base.c           |  105 ++++++++++---------------------------
 include/linux/mm.h       |   12 ----
 include/linux/mm_types.h |    6 --
 include/linux/proc_fs.h  |   20 -------
 kernel/fork.c            |    3 -
 mm/mmap.c                |   22 +------
 mm/nommu.c               |   16 -----
 9 files changed, 37 insertions(+), 152 deletions(-)

diff -puN fs/binfmt_flat.c~mm-remove-struct-mm_struct-exe_file-et-al fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/fs/binfmt_flat.c
@@ -531,8 +531,7 @@ static int load_flat_file(struct linux_b
 		DBG_FLT("BINFMT_FLAT: ROM mapping of file (we hope)\n");
 
 		down_write(&current->mm->mmap_sem);
-		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
-				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
+		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC, MAP_PRIVATE, 0);
 		up_write(&current->mm->mmap_sem);
 		if (!textpos  || textpos >= (unsigned long) -4096) {
 			if (!textpos)
diff -puN fs/exec.c~mm-remove-struct-mm_struct-exe_file-et-al fs/exec.c
--- a/fs/exec.c~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/fs/exec.c
@@ -965,8 +965,6 @@ int flush_old_exec(struct linux_binprm *
 	if (retval)
 		goto out;
 
-	set_mm_exe_file(bprm->mm, bprm->file);
-
 	/*
 	 * Release all of the old mmap stuff
 	 */
diff -puN fs/proc/base.c~mm-remove-struct-mm_struct-exe_file-et-al fs/proc/base.c
--- a/fs/proc/base.c~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/fs/proc/base.c
@@ -202,6 +202,36 @@ static int proc_root_link(struct inode *
 	return result;
 }
 
+static int proc_exe_link(struct inode *inode, struct path *path)
+{
+	struct task_struct *tsk;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+
+	tsk = get_proc_task(inode);
+	if (!tsk)
+		return -ENOENT;
+	mm = get_task_mm(tsk);
+	put_task_struct(tsk);
+	if (!mm)
+		return -ENOENT;
+
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
+			*path = vma->vm_file->f_path;
+			path_get(&vma->vm_file->f_path);
+
+			up_read(&mm->mmap_sem);
+			mmput(mm);
+			return 0;
+		}
+	}
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+	return -ENOENT;
+}
+
 /*
  * Return zero if current may access user memory in @task, -error if not.
  */
@@ -1249,81 +1279,6 @@ static const struct file_operations proc
 
 #endif
 
-/*
- * We added or removed a vma mapping the executable. The vmas are only mapped
- * during exec and are not mapped with the mmap system call.
- * Callers must hold down_write() on the mm's mmap_sem for these
- */
-void added_exe_file_vma(struct mm_struct *mm)
-{
-	mm->num_exe_file_vmas++;
-}
-
-void removed_exe_file_vma(struct mm_struct *mm)
-{
-	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){
-		fput(mm->exe_file);
-		mm->exe_file = NULL;
-	}
-
-}
-
-void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
-{
-	if (new_exe_file)
-		get_file(new_exe_file);
-	if (mm->exe_file)
-		fput(mm->exe_file);
-	mm->exe_file = new_exe_file;
-	mm->num_exe_file_vmas = 0;
-}
-
-struct file *get_mm_exe_file(struct mm_struct *mm)
-{
-	struct file *exe_file;
-
-	/* We need mmap_sem to protect against races with removal of
-	 * VM_EXECUTABLE vmas */
-	down_read(&mm->mmap_sem);
-	exe_file = mm->exe_file;
-	if (exe_file)
-		get_file(exe_file);
-	up_read(&mm->mmap_sem);
-	return exe_file;
-}
-
-void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
-{
-	/* It's safe to write the exe_file pointer without exe_file_lock because
-	 * this is called during fork when the task is not yet in /proc */
-	newmm->exe_file = get_mm_exe_file(oldmm);
-}
-
-static int proc_exe_link(struct inode *inode, struct path *exe_path)
-{
-	struct task_struct *task;
-	struct mm_struct *mm;
-	struct file *exe_file;
-
-	task = get_proc_task(inode);
-	if (!task)
-		return -ENOENT;
-	mm = get_task_mm(task);
-	put_task_struct(task);
-	if (!mm)
-		return -ENOENT;
-	exe_file = get_mm_exe_file(mm);
-	mmput(mm);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
-		return 0;
-	} else
-		return -ENOENT;
-}
-
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
diff -puN include/linux/mm.h~mm-remove-struct-mm_struct-exe_file-et-al include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/include/linux/mm.h
@@ -1123,18 +1123,6 @@ extern void exit_mmap(struct mm_struct *
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
-#ifdef CONFIG_PROC_FS
-/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
-extern void added_exe_file_vma(struct mm_struct *mm);
-extern void removed_exe_file_vma(struct mm_struct *mm);
-#else
-static inline void added_exe_file_vma(struct mm_struct *mm)
-{}
-
-static inline void removed_exe_file_vma(struct mm_struct *mm)
-{}
-#endif /* CONFIG_PROC_FS */
-
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
diff -puN include/linux/mm_types.h~mm-remove-struct-mm_struct-exe_file-et-al include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/include/linux/mm_types.h
@@ -269,12 +269,6 @@ struct mm_struct {
 	 */
 	struct task_struct *owner;
 #endif
-
-#ifdef CONFIG_PROC_FS
-	/* store ref to file /proc/<pid>/exe symlink points to */
-	struct file *exe_file;
-	unsigned long num_exe_file_vmas;
-#endif
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
diff -puN include/linux/proc_fs.h~mm-remove-struct-mm_struct-exe_file-et-al include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/include/linux/proc_fs.h
@@ -189,12 +189,6 @@ extern void proc_net_remove(struct net *
 extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 	struct proc_dir_entry *parent);
 
-/* While the {get|set|dup}_mm_exe_file functions are for mm_structs, they are
- * only needed to implement /proc/<pid>|self/exe so we define them here. */
-extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
-extern struct file *get_mm_exe_file(struct mm_struct *mm);
-extern void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm);
-
 #else
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
@@ -245,20 +239,6 @@ static inline int pid_ns_prepare_proc(st
 static inline void pid_ns_release_proc(struct pid_namespace *ns)
 {
 }
-
-static inline void set_mm_exe_file(struct mm_struct *mm,
-				   struct file *new_exe_file)
-{}
-
-static inline struct file *get_mm_exe_file(struct mm_struct *mm)
-{
-	return NULL;
-}
-
-static inline void dup_mm_exe_file(struct mm_struct *oldmm,
-	       			   struct mm_struct *newmm)
-{}
-
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
diff -puN kernel/fork.c~mm-remove-struct-mm_struct-exe_file-et-al kernel/fork.c
--- a/kernel/fork.c~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/kernel/fork.c
@@ -487,7 +487,6 @@ void mmput(struct mm_struct *mm)
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
 		exit_mmap(mm);
-		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -610,8 +609,6 @@ struct mm_struct *dup_mm(struct task_str
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
-	dup_mm_exe_file(oldmm, mm);
-
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
diff -puN mm/mmap.c~mm-remove-struct-mm_struct-exe_file-et-al mm/mmap.c
--- a/mm/mmap.c~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/mm/mmap.c
@@ -236,11 +236,8 @@ static struct vm_area_struct *remove_vma
 	might_sleep();
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file) {
+	if (vma->vm_file)
 		fput(vma->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(vma->vm_mm);
-	}
 	mpol_put(vma_policy(vma));
 	kmem_cache_free(vm_area_cachep, vma);
 	return next;
@@ -637,11 +634,8 @@ again:			remove_next = 1 + (end > next->
 		spin_unlock(&mapping->i_mmap_lock);
 
 	if (remove_next) {
-		if (file) {
+		if (file)
 			fput(file);
-			if (next->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(mm);
-		}
 		mm->map_count--;
 		mpol_put(vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
@@ -1196,8 +1190,6 @@ munmap_back:
 		error = file->f_op->mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
-		if (vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
 	} else if (vm_flags & VM_SHARED) {
 		error = shmem_zero_setup(vma);
 		if (error)
@@ -1853,11 +1845,8 @@ int split_vma(struct mm_struct * mm, str
 	}
 	vma_set_policy(new, pol);
 
-	if (new->vm_file) {
+	if (new->vm_file)
 		get_file(new->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			added_exe_file_vma(mm);
-	}
 
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
@@ -2204,11 +2193,8 @@ struct vm_area_struct *copy_vma(struct v
 			new_vma->vm_start = addr;
 			new_vma->vm_end = addr + len;
 			new_vma->vm_pgoff = pgoff;
-			if (new_vma->vm_file) {
+			if (new_vma->vm_file)
 				get_file(new_vma->vm_file);
-				if (vma->vm_flags & VM_EXECUTABLE)
-					added_exe_file_vma(mm);
-			}
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
 				new_vma->vm_ops->open(new_vma);
 			vma_link(mm, new_vma, prev, rb_link, rb_parent);
diff -puN mm/nommu.c~mm-remove-struct-mm_struct-exe_file-et-al mm/nommu.c
--- a/mm/nommu.c~mm-remove-struct-mm_struct-exe_file-et-al
+++ a/mm/nommu.c
@@ -719,11 +719,8 @@ static void delete_vma(struct mm_struct 
 	kenter("%p", vma);
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
-	if (vma->vm_file) {
+	if (vma->vm_file)
 		fput(vma->vm_file);
-		if (vma->vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
-	}
 	put_nommu_region(vma->vm_region);
 	kmem_cache_free(vm_area_cachep, vma);
 }
@@ -1216,10 +1213,6 @@ unsigned long do_mmap_pgoff(struct file 
 		get_file(file);
 		vma->vm_file = file;
 		get_file(file);
-		if (vm_flags & VM_EXECUTABLE) {
-			added_exe_file_vma(current->mm);
-			vma->vm_mm = current->mm;
-		}
 	}
 
 	down_write(&nommu_region_sem);
@@ -1357,11 +1350,8 @@ share:
 error_put_region:
 	__put_nommu_region(region);
 	if (vma) {
-		if (vma->vm_file) {
+		if (vma->vm_file)
 			fput(vma->vm_file);
-			if (vma->vm_flags & VM_EXECUTABLE)
-				removed_exe_file_vma(vma->vm_mm);
-		}
 		kmem_cache_free(vm_area_cachep, vma);
 	}
 	kleave(" = %d [pr]", ret);
@@ -1373,8 +1363,6 @@ error:
 	fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
 	fput(vma->vm_file);
-	if (vma->vm_flags & VM_EXECUTABLE)
-		removed_exe_file_vma(vma->vm_mm);
 	kmem_cache_free(vm_area_cachep, vma);
 	kleave(" = %d", ret);
 	return ret;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
memdup_user-introduce.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
mm-remove-struct-mm_struct-exe_file-et-al.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

