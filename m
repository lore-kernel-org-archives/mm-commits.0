From: akpm@linux-foundation.org
Subject: [merged] mm-rcu-protected-get_mm_exe_file.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:19:50 -0700
Message-ID: <55355156.oSlsi9S53kQJ1KYN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbDTTN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, dbueso@suse.de, oleg@redhat.com, paulmck@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rcu-protected get_mm_exe_file()
has been removed from the -mm tree.  Its filename was
     mm-rcu-protected-get_mm_exe_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm: rcu-protected get_mm_exe_file()

This patch removes mm->mmap_sem from mm->exe_file read side.
Also it kills dup_mm_exe_file() and moves exe_file duplication into
dup_mmap() where both mmap_sems are locked.

[akpm@linux-foundation.org: fix comment typo]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c                |    3 -
 include/linux/fs.h       |    1 
 include/linux/mm_types.h |    2 -
 kernel/fork.c            |   56 ++++++++++++++++++++++++-------------
 4 files changed, 40 insertions(+), 22 deletions(-)

diff -puN fs/file.c~mm-rcu-protected-get_mm_exe_file fs/file.c
--- a/fs/file.c~mm-rcu-protected-get_mm_exe_file
+++ a/fs/file.c
@@ -638,8 +638,7 @@ static struct file *__fget(unsigned int
 	file = fcheck_files(files, fd);
 	if (file) {
 		/* File object ref couldn't be taken */
-		if ((file->f_mode & mask) ||
-		    !atomic_long_inc_not_zero(&file->f_count))
+		if ((file->f_mode & mask) || !get_file_rcu(file))
 			file = NULL;
 	}
 	rcu_read_unlock();
diff -puN include/linux/fs.h~mm-rcu-protected-get_mm_exe_file include/linux/fs.h
--- a/include/linux/fs.h~mm-rcu-protected-get_mm_exe_file
+++ a/include/linux/fs.h
@@ -870,6 +870,7 @@ static inline struct file *get_file(stru
 	atomic_long_inc(&f->f_count);
 	return f;
 }
+#define get_file_rcu(x) atomic_long_inc_not_zero(&(x)->f_count)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
diff -puN include/linux/mm_types.h~mm-rcu-protected-get_mm_exe_file include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rcu-protected-get_mm_exe_file
+++ a/include/linux/mm_types.h
@@ -429,7 +429,7 @@ struct mm_struct {
 #endif
 
 	/* store ref to file /proc/<pid>/exe symlink points to */
-	struct file *exe_file;
+	struct file __rcu *exe_file;
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
diff -puN kernel/fork.c~mm-rcu-protected-get_mm_exe_file kernel/fork.c
--- a/kernel/fork.c~mm-rcu-protected-get_mm_exe_file
+++ a/kernel/fork.c
@@ -403,6 +403,9 @@ static int dup_mmap(struct mm_struct *mm
 	 */
 	down_write_nested(&mm->mmap_sem, SINGLE_DEPTH_NESTING);
 
+	/* No ordering required: file already has been exposed. */
+	RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
+
 	mm->total_vm = oldmm->total_vm;
 	mm->shared_vm = oldmm->shared_vm;
 	mm->exec_vm = oldmm->exec_vm;
@@ -528,7 +531,13 @@ static inline void mm_free_pgd(struct mm
 	pgd_free(mm, mm->pgd);
 }
 #else
-#define dup_mmap(mm, oldmm)	(0)
+static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
+{
+	down_write(&oldmm->mmap_sem);
+	RCU_INIT_POINTER(mm->exe_file, get_mm_exe_file(oldmm));
+	up_write(&oldmm->mmap_sem);
+	return 0;
+}
 #define mm_alloc_pgd(mm)	(0)
 #define mm_free_pgd(mm)
 #endif /* CONFIG_MMU */
@@ -697,35 +706,46 @@ void mmput(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmput);
 
+/**
+ * set_mm_exe_file - change a reference to the mm's executable file
+ *
+ * This changes mm's executable file (shown as symlink /proc/[pid]/exe).
+ *
+ * Main users are mmput(), sys_execve() and sys_prctl(PR_SET_MM_MAP/EXE_FILE).
+ * Callers prevent concurrent invocations: in mmput() nobody alive left,
+ * in execve task is single-threaded, prctl holds mmap_sem exclusively.
+ */
 void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
 {
+	struct file *old_exe_file = rcu_dereference_protected(mm->exe_file,
+			!atomic_read(&mm->mm_users) || current->in_execve ||
+			lockdep_is_held(&mm->mmap_sem));
+
 	if (new_exe_file)
 		get_file(new_exe_file);
-	if (mm->exe_file)
-		fput(mm->exe_file);
-	mm->exe_file = new_exe_file;
+	rcu_assign_pointer(mm->exe_file, new_exe_file);
+	if (old_exe_file)
+		fput(old_exe_file);
 }
 
+/**
+ * get_mm_exe_file - acquire a reference to the mm's executable file
+ *
+ * Returns %NULL if mm has no associated executable file.
+ * User must release file via fput().
+ */
 struct file *get_mm_exe_file(struct mm_struct *mm)
 {
 	struct file *exe_file;
 
-	/* We need mmap_sem to protect against races with removal of exe_file */
-	down_read(&mm->mmap_sem);
-	exe_file = mm->exe_file;
-	if (exe_file)
-		get_file(exe_file);
-	up_read(&mm->mmap_sem);
+	rcu_read_lock();
+	exe_file = rcu_dereference(mm->exe_file);
+	if (exe_file && !get_file_rcu(exe_file))
+		exe_file = NULL;
+	rcu_read_unlock();
 	return exe_file;
 }
 
-static void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
-{
-	/* It's safe to write the exe_file pointer without exe_file_lock because
-	 * this is called during fork when the task is not yet in /proc */
-	newmm->exe_file = get_mm_exe_file(oldmm);
-}
-
 /**
  * get_task_mm - acquire a reference to the task's mm
  *
@@ -887,8 +907,6 @@ static struct mm_struct *dup_mm(struct t
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
-	dup_mm_exe_file(oldmm, mm);
