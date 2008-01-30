From: akpm@linux-foundation.org
Subject: - fix-procfs-task-exe-symlink.patch removed from -mm tree
Date: Wed, 30 Jan 2008 15:41:28 -0800
Message-ID: <200801302341.m0UNfScI030751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYA3XsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 18:48:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de, oleg@tv-sign.ru, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix procfs task exe symlink
has been removed from the -mm tree.  Its filename was
     fix-procfs-task-exe-symlink.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix procfs task exe symlink
From: Matt Helsley <matthltc@us.ibm.com>

The kernel implements readlink of /proc/pid/exe by getting the file from
the first executable VMA.  Then the path to the file is reconstructed and
reported as the result.  While this method is often correct it does not
always identify the correct path.

Some applications may play games with the executable mappings.  Al Viro
mentioned an example where the executable region is copied and subsequently
unmapped.  In this case the kernel wanders down the VMA list to the next
file-backed, executable VMA -- which is not necessarily the destination of
the copy.  Worse, any transformation of the executable could conceivably
take place and the symlink could be deceptive.  In this case, since we
can't be certain what is being executed it might be better to simply
"delete" the symlink.

Another scenario where the symlink might be broken includes some potential
implementations of checkpoint/restart.  If restart is implemented as a
loader application then it will be reported in the symlink instead of the
application being restarted.  This would break restarted Java applications
for example (see the java example below).

For executables on the stackable MVFS filesystem the current procfs methods
for implementing a task's exe symlink do not point to the correct file and
applications relying on the symlink fail (see the java example below).

So there are multiple ways in which a task's exe symlink in /proc can break
using the current VMA walk method.

This patch tries to address the case of running Java installed on an MVFS
filesystem.  However the patch solves the problems with the symlink for
more than just MVFS.

Java uses the /proc/self/exe symlink to determine JAVAHOME by reading the
link and trimming the path.  This breaks under MVFS because MVFS
reorganizes files and directories to enable versioning and stores these on
a filesystem lower in the "stack".  This is further complicated by the need
for efficient IO because reads and mapping of the file must access the file
contents from the "lower" filesystem.  The symlink points to the
mapped/read file and not the MVFS file.  Because MVFS utilizes a different
organization of the files in the lower filesystem the symlink cannot be
used to correctly determine JAVAHOME.  This could be a problem for any
stacking filesystem which reorganizes files and directories -- though I
don't know of another besides MVFS.

	Top FS (e.g. MVFS)		Lower FS (e.g. ext3)
	/foo/bar/jvm/bin/java		/qux/baz/java
	/foo/bar/jvm/lib		/bee/buzz

When the executable file is opened MVFS returns its own file struct.  When
the MVFS file is subsequently mmap'd or read MVFS transforms the path to
/qux/baz/java, opens, and uses the contents of the lower filesystem's file
to satisfy the read or the mmap.

Since the bytes of the java executable are at /qux/baz/java, /proc/self/exe
points to /qux/baz/java instead of /foo/bar/jvm/bin/java.  Hence JAVAHOME
points to the wrong directory and Java subsequently fails to find the files
it needs to run.

To solve the problem this patch changes the way that the kernel resolves a
task's exe symlink.  Instead of walking the VMAs to find the first
executable file-backed VMA we store a reference to the exec'd file in the
mm_struct -- /foo/bar/jvm/bin/java in the example above.

That reference would prevent the filesystem holding the executable file
from being unmounted even if the VMA(s) were unmapped.  So we track the
number of VMAs that mapped the executable file during exec.  Then we drop
the new reference on exit or when the last such VMA is unmapped.  This
avoids pinning the filesystem.

A minor added benefit of this approach is we no longer need separate code
to offer this symlink on mmu-less systems.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc:"Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c          |    3 -
 fs/exec.c                 |    2 
 fs/proc/base.c            |   77 ++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h        |    1 
 fs/proc/task_mmu.c        |   34 ---------------
 fs/proc/task_nommu.c      |   34 ---------------
 include/linux/init_task.h |    8 +++
 include/linux/mm.h        |   22 ++++++++++
 include/linux/mm_types.h  |    7 +++
 include/linux/proc_fs.h   |   14 ++++++
 kernel/fork.c             |    3 +
 mm/mmap.c                 |   22 ++++++++--
 mm/nommu.c                |   15 +++++--
 13 files changed, 164 insertions(+), 78 deletions(-)

diff -puN fs/binfmt_flat.c~fix-procfs-task-exe-symlink fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~fix-procfs-task-exe-symlink
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
diff -puN fs/exec.c~fix-procfs-task-exe-symlink fs/exec.c
--- a/fs/exec.c~fix-procfs-task-exe-symlink
+++ a/fs/exec.c
@@ -1024,6 +1024,8 @@ int flush_old_exec(struct linux_binprm *
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
 
+	get_file(bprm->file);
+	set_mm_exe_file(current->mm, bprm->file);
 	return 0;
 
 mmap_failed:
diff -puN fs/proc/base.c~fix-procfs-task-exe-symlink fs/proc/base.c
--- a/fs/proc/base.c~fix-procfs-task-exe-symlink
+++ a/fs/proc/base.c
@@ -1144,6 +1144,83 @@ static const struct file_operations proc
 
 #endif
 
+/* We added or removed a vma mapping the executable. The vmas are only mapped
+ * during exec and are not mapped with the mmap system call.
+ * Callers must _not_ hold the mm's exe_file_lock for these */
+void added_exe_file_vma(struct mm_struct *mm)
+{
+	spin_lock(&mm->exe_file_lock);
+	mm->num_exe_file_vmas++;
+	spin_unlock(&mm->exe_file_lock);
+}
+
+void removed_exe_file_vma(struct mm_struct *mm)
+{
+	struct file *exe_file = NULL;
+
+	spin_lock(&mm->exe_file_lock);
+	mm->num_exe_file_vmas--;
+	if (mm->num_exe_file_vmas == 0) {
+		exe_file = mm->exe_file;
+		mm->exe_file = NULL;
+	}
+	spin_unlock(&mm->exe_file_lock);
+
+	if (exe_file)
+		fput(exe_file);
+}
+
+/* Takes a reference to new_exe_file from caller -- does not get a new
+ * reference; only puts old ones */
+void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
+{
+	struct file *old_exe_file;
+
+	spin_lock(&mm->exe_file_lock);
+	old_exe_file = mm->exe_file;
+	mm->exe_file = new_exe_file;
+	mm->num_exe_file_vmas = 0;
+	spin_unlock(&mm->exe_file_lock);
+	if (old_exe_file)
+		fput(old_exe_file);
+}
+
+struct file *get_mm_exe_file(struct mm_struct *mm)
+{
+	struct file *exe_file;
+
+	spin_lock(&mm->exe_file_lock);
+	exe_file = mm->exe_file;
+	if (exe_file)
+		get_file(exe_file);
+	spin_unlock(&mm->exe_file_lock);
+	return exe_file;
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
diff -puN fs/proc/internal.h~fix-procfs-task-exe-symlink fs/proc/internal.h
--- a/fs/proc/internal.h~fix-procfs-task-exe-symlink
+++ a/fs/proc/internal.h
@@ -48,7 +48,6 @@ extern int maps_protect;
 
 extern void create_seq_entry(char *name, mode_t mode,
 				const struct file_operations *f);
-extern int proc_exe_link(struct inode *, struct path *);
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
diff -puN fs/proc/task_mmu.c~fix-procfs-task-exe-symlink fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fix-procfs-task-exe-symlink
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
diff -puN fs/proc/task_nommu.c~fix-procfs-task-exe-symlink fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~fix-procfs-task-exe-symlink
+++ a/fs/proc/task_nommu.c
@@ -104,40 +104,6 @@ int task_statm(struct mm_struct *mm, int
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
diff -puN include/linux/init_task.h~fix-procfs-task-exe-symlink include/linux/init_task.h
--- a/include/linux/init_task.h~fix-procfs-task-exe-symlink
+++ a/include/linux/init_task.h
@@ -46,6 +46,13 @@
 	.max_reqs	= ~0U,				\
 }
 
+#ifdef CONFIG_PROC_FS
+#define INIT_MM_EXE_FILE(name) \
+	.exe_file_lock	= __SPIN_LOCK_UNLOCKED(name.exe_file_lock),
+#else
+#define INIT_MM_EXE_FILE(name)
+#endif
+
 #define INIT_MM(name) \
 {			 					\
 	.mm_rb		= RB_ROOT,				\
@@ -56,6 +63,7 @@
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(name.page_table_lock),	\
 	.mmlist		= LIST_HEAD_INIT(name.mmlist),		\
 	.cpu_vm_mask	= CPU_MASK_ALL,				\
+	INIT_MM_EXE_FILE(name)					\
 }
 
 #define INIT_SIGNALS(sig) {						\
diff -puN include/linux/mm.h~fix-procfs-task-exe-symlink include/linux/mm.h
--- a/include/linux/mm.h~fix-procfs-task-exe-symlink
+++ a/include/linux/mm.h
@@ -1028,6 +1028,28 @@ extern void unlink_file_vma(struct vm_ar
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
 	unsigned long addr, unsigned long len, pgoff_t pgoff);
 extern void exit_mmap(struct mm_struct *);
+
+#ifdef CONFIG_PROC_FS
+static inline void init_mm_exe_file(struct mm_struct *mm)
+{
+	/* The exe_file field itself is already correctly set at this point */
+	spin_lock_init(&mm->exe_file_lock);
+}
+
+/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
+extern void added_exe_file_vma(struct mm_struct *mm);
+extern void removed_exe_file_vma(struct mm_struct *mm);
+#else
+static inline void init_mm_exe_file(struct mm_struct *mm)
+{}
+
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
diff -puN include/linux/mm_types.h~fix-procfs-task-exe-symlink include/linux/mm_types.h
--- a/include/linux/mm_types.h~fix-procfs-task-exe-symlink
+++ a/include/linux/mm_types.h
@@ -228,6 +228,13 @@ struct mm_struct {
 #ifdef CONFIG_CGROUP_MEM_CONT
 	struct mem_cgroup *mem_cgroup;
 #endif
+
+#ifdef CONFIG_PROC_FS
+	/* store ref to file /proc/<pid>/exe symlink points to */
+	spinlock_t exe_file_lock;
+	struct file *exe_file;
+	unsigned long num_exe_file_vmas;
+#endif
 };
 
 #endif /* _LINUX_MM_TYPES_H */
diff -puN include/linux/proc_fs.h~fix-procfs-task-exe-symlink include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~fix-procfs-task-exe-symlink
+++ a/include/linux/proc_fs.h
@@ -9,7 +9,6 @@
 
 struct net;
 struct completion;
-
 /*
  * The proc filesystem constants/structures
  */
@@ -209,6 +208,11 @@ extern void proc_net_remove(struct net *
 extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 	struct proc_dir_entry *parent);
 
+/* While the {get|set}_mm_exe_file functions are for mm_structs, they are
+ * only needed to implement /proc/<pid>|self/exe so we define them here. */
+extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
+extern struct file *get_mm_exe_file(struct mm_struct *mm);
+
 #else
 
 #define proc_root_driver NULL
@@ -258,6 +262,14 @@ static inline void pid_ns_release_proc(s
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
 #endif /* CONFIG_PROC_FS */
 
 #if !defined(CONFIG_PROC_KCORE)
diff -puN kernel/fork.c~fix-procfs-task-exe-symlink kernel/fork.c
--- a/kernel/fork.c~fix-procfs-task-exe-symlink
+++ a/kernel/fork.c
@@ -358,6 +358,7 @@ static struct mm_struct * mm_init(struct
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;
 	mm_init_cgroup(mm, p);
+	init_mm_exe_file(mm);
 
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
@@ -409,6 +410,7 @@ void mmput(struct mm_struct *mm)
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
 		exit_mmap(mm);
+		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -525,6 +527,7 @@ static struct mm_struct *dup_mm(struct t
 	if (err)
 		goto free_pt;
 
+	mm->exe_file = get_mm_exe_file(oldmm);
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
 
diff -puN mm/mmap.c~fix-procfs-task-exe-symlink mm/mmap.c
--- a/mm/mmap.c~fix-procfs-task-exe-symlink
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
@@ -1820,8 +1828,11 @@ int split_vma(struct mm_struct * mm, str
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
@@ -2138,8 +2149,11 @@ struct vm_area_struct *copy_vma(struct v
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
diff -puN mm/nommu.c~fix-procfs-task-exe-symlink mm/nommu.c
--- a/mm/nommu.c~fix-procfs-task-exe-symlink
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

fix-procfs-task-exe-symlink.patch
