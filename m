From: akpm@linux-foundation.org
Subject: + mm-extract-exe_file-handling-from-procfs.patch added to -mm tree
Date: Tue, 26 Apr 2011 14:07:03 -0700
Message-ID: <201104262107.p3QL73V1019178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758394Ab1DZVLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 17:11:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     mm: extract exe_file handling from procfs
has been added to the -mm tree.  Its filename is
     mm-extract-exe_file-handling-from-procfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: extract exe_file handling from procfs
From: Jiri Slaby <jslaby@suse.cz>

Setup and cleanup of mm_struct->exe_file is currently done in fs/proc/. 
This was because exe_file was needed only for /proc/<pid>/exe.  Since we
will need the exe_file functionality also for core dumps (so core name can
contain full binary path), built this functionality always into the
kernel.

To achieve that move that out of proc FS to the kernel/ where in fact it
should belong.  By doing that we can make dup_mm_exe_file static.  Also we
can drop linux/proc_fs.h inclusion in fs/exec.c and kernel/fork.c.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |    1 
 fs/proc/base.c           |   51 ------------------------------------
 include/linux/mm.h       |   10 +------
 include/linux/mm_types.h |    2 -
 include/linux/proc_fs.h  |   19 -------------
 kernel/fork.c            |   52 ++++++++++++++++++++++++++++++++++++-
 6 files changed, 53 insertions(+), 82 deletions(-)

diff -puN fs/exec.c~mm-extract-exe_file-handling-from-procfs fs/exec.c
--- a/fs/exec.c~mm-extract-exe_file-handling-from-procfs
+++ a/fs/exec.c
@@ -42,7 +42,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
 #include <linux/namei.h>
-#include <linux/proc_fs.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
diff -puN fs/proc/base.c~mm-extract-exe_file-handling-from-procfs fs/proc/base.c
--- a/fs/proc/base.c~mm-extract-exe_file-handling-from-procfs
+++ a/fs/proc/base.c
@@ -1576,57 +1576,6 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
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
 static int proc_exe_link(struct inode *inode, struct path *exe_path)
 {
 	struct task_struct *task;
diff -puN include/linux/mm.h~mm-extract-exe_file-handling-from-procfs include/linux/mm.h
--- a/include/linux/mm.h~mm-extract-exe_file-handling-from-procfs
+++ a/include/linux/mm.h
@@ -1427,17 +1427,11 @@ extern void exit_mmap(struct mm_struct *
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
-#ifdef CONFIG_PROC_FS
 /* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
 extern void added_exe_file_vma(struct mm_struct *mm);
 extern void removed_exe_file_vma(struct mm_struct *mm);
-#else
-static inline void added_exe_file_vma(struct mm_struct *mm)
-{}
-
-static inline void removed_exe_file_vma(struct mm_struct *mm)
-{}
-#endif /* CONFIG_PROC_FS */
+extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
+extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
diff -puN include/linux/mm_types.h~mm-extract-exe_file-handling-from-procfs include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-extract-exe_file-handling-from-procfs
+++ a/include/linux/mm_types.h
@@ -304,11 +304,9 @@ struct mm_struct {
 	struct task_struct __rcu *owner;
 #endif
 
-#ifdef CONFIG_PROC_FS
 	/* store ref to file /proc/<pid>/exe symlink points to */
 	struct file *exe_file;
 	unsigned long num_exe_file_vmas;
-#endif
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
diff -puN include/linux/proc_fs.h~mm-extract-exe_file-handling-from-procfs include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~mm-extract-exe_file-handling-from-procfs
+++ a/include/linux/proc_fs.h
@@ -173,12 +173,6 @@ extern void proc_net_remove(struct net *
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
@@ -226,19 +220,6 @@ static inline void pid_ns_release_proc(s
 {
 }
 
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
diff -puN kernel/fork.c~mm-extract-exe_file-handling-from-procfs kernel/fork.c
--- a/kernel/fork.c~mm-extract-exe_file-handling-from-procfs
+++ a/kernel/fork.c
@@ -59,7 +59,6 @@
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
 #include <linux/tty.h>
-#include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
@@ -597,6 +596,57 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
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
+static void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
+{
+	/* It's safe to write the exe_file pointer without exe_file_lock because
+	 * this is called during fork when the task is not yet in /proc */
+	newmm->exe_file = get_mm_exe_file(oldmm);
+}
+
 /**
  * get_task_mm - acquire a reference to the task's mm
  *
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mm-extract-exe_file-handling-from-procfs.patch
coredump-add-support-for-exe_file-in-core-name.patch

