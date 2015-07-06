From: akpm@linux-foundation.org
Subject: [merged]
 fs-filec-dont-acquire-files-file_lock-in-fd_install.patch removed from -mm
 tree
Date: Mon, 06 Jul 2015 12:48:27 -0700
Message-ID: <559adb8b.FZb3UlyaKl+LGTfN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbbGFTs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edumazet@google.com, khlebnikov@yandex-team.ru, mguzik@redhat.com, paulmck@linux.vnet.ibm.com, viro@ZenIV.linux.org.uk, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/file.c: don't acquire files->file_lock in fd_install()
has been removed from the -mm tree.  Its filename was
     fs-filec-dont-acquire-files-file_lock-in-fd_install.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: fs/file.c: don't acquire files->file_lock in fd_install()

Mateusz Guzik reported :

 Currently obtaining a new file descriptor results in locking fdtable
 twice - once in order to reserve a slot and second time to fill it.

Holding the spinlock in __fd_install() is needed in case a resize is
done, or to prevent a resize.

Mateusz provided an RFC patch and a micro benchmark :
  http://people.redhat.com/~mguzik/pipebench.c

A resize is an unlikely operation in a process lifetime,
as table size is at least doubled at every resize.

We can use RCU instead of the spinlock :

__fd_install() must wait if a resize is in progress.

The resize must block new __fd_install() callers from starting,
and wait that ongoing install are finished (synchronize_sched())

resize should be attempted by a single thread to not waste resources.

rcu_sched variant is used, as __fd_install() and expand_fdtable() run
from process context.

It gives us a ~30% speedup using pipebench with 16 threads, and a ~10%
speedup with another program using TCP sockets.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Mateusz Guzik <mguzik@redhat.com>
Acked-by: Mateusz Guzik <mguzik@redhat.com>
Tested-by: Mateusz Guzik <mguzik@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file.c               |   66 +++++++++++++++++++++++++++-----------
 include/linux/fdtable.h |    3 +
 2 files changed, 50 insertions(+), 19 deletions(-)

diff -puN fs/file.c~fs-filec-dont-acquire-files-file_lock-in-fd_install fs/file.c
--- a/fs/file.c~fs-filec-dont-acquire-files-file_lock-in-fd_install
+++ a/fs/file.c
@@ -147,6 +147,13 @@ static int expand_fdtable(struct files_s
 
 	spin_unlock(&files->file_lock);
 	new_fdt = alloc_fdtable(nr);
+
+	/* make sure all __fd_install() have seen resize_in_progress
+	 * or have finished their rcu_read_lock_sched() section.
+	 */
+	if (atomic_read(&files->count) > 1)
+		synchronize_sched();
+
 	spin_lock(&files->file_lock);
 	if (!new_fdt)
 		return -ENOMEM;
@@ -158,21 +165,14 @@ static int expand_fdtable(struct files_s
 		__free_fdtable(new_fdt);
 		return -EMFILE;
 	}
-	/*
-	 * Check again since another task may have expanded the fd table while
-	 * we dropped the lock
-	 */
 	cur_fdt = files_fdtable(files);
-	if (nr >= cur_fdt->max_fds) {
-		/* Continue as planned */
-		copy_fdtable(new_fdt, cur_fdt);
-		rcu_assign_pointer(files->fdt, new_fdt);
-		if (cur_fdt != &files->fdtab)
-			call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
-	} else {
-		/* Somebody else expanded, so undo our attempt */
-		__free_fdtable(new_fdt);
-	}
+	BUG_ON(nr < cur_fdt->max_fds);
+	copy_fdtable(new_fdt, cur_fdt);
+	rcu_assign_pointer(files->fdt, new_fdt);
+	if (cur_fdt != &files->fdtab)
+		call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
+	/* coupled with smp_rmb() in __fd_install() */
+	smp_wmb();
 	return 1;
 }
 
@@ -185,21 +185,38 @@ static int expand_fdtable(struct files_s
  * The files->file_lock should be held on entry, and will be held on exit.
  */
 static int expand_files(struct files_struct *files, int nr)
+	__releases(files->file_lock)
+	__acquires(files->file_lock)
 {
 	struct fdtable *fdt;
+	int expanded = 0;
 
+repeat:
 	fdt = files_fdtable(files);
 
 	/* Do we need to expand? */
 	if (nr < fdt->max_fds)
-		return 0;
+		return expanded;
 
 	/* Can we expand? */
 	if (nr >= sysctl_nr_open)
 		return -EMFILE;
 
+	if (unlikely(files->resize_in_progress)) {
+		spin_unlock(&files->file_lock);
+		expanded = 1;
+		wait_event(files->resize_wait, !files->resize_in_progress);
+		spin_lock(&files->file_lock);
+		goto repeat;
+	}
+
 	/* All good, so we try */
-	return expand_fdtable(files, nr);
+	files->resize_in_progress = true;
+	expanded = expand_fdtable(files, nr);
+	files->resize_in_progress = false;
+
+	wake_up_all(&files->resize_wait);
+	return expanded;
 }
 
 static inline void __set_close_on_exec(int fd, struct fdtable *fdt)
@@ -256,6 +273,8 @@ struct files_struct *dup_fd(struct files
 	atomic_set(&newf->count, 1);
 
 	spin_lock_init(&newf->file_lock);
+	newf->resize_in_progress = false;
+	init_waitqueue_head(&newf->resize_wait);
 	newf->next_fd = 0;
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
@@ -553,11 +572,20 @@ void __fd_install(struct files_struct *f
 		struct file *file)
 {
 	struct fdtable *fdt;
-	spin_lock(&files->file_lock);
-	fdt = files_fdtable(files);
+
+	rcu_read_lock_sched();
+
+	while (unlikely(files->resize_in_progress)) {
+		rcu_read_unlock_sched();
+		wait_event(files->resize_wait, !files->resize_in_progress);
+		rcu_read_lock_sched();
+	}
+	/* coupled with smp_wmb() in expand_fdtable() */
+	smp_rmb();
+	fdt = rcu_dereference_sched(files->fdt);
 	BUG_ON(fdt->fd[fd] != NULL);
 	rcu_assign_pointer(fdt->fd[fd], file);
-	spin_unlock(&files->file_lock);
+	rcu_read_unlock_sched();
 }
 
 void fd_install(unsigned int fd, struct file *file)
diff -puN include/linux/fdtable.h~fs-filec-dont-acquire-files-file_lock-in-fd_install include/linux/fdtable.h
--- a/include/linux/fdtable.h~fs-filec-dont-acquire-files-file_lock-in-fd_install
+++ a/include/linux/fdtable.h
@@ -47,6 +47,9 @@ struct files_struct {
    * read mostly part
    */
 	atomic_t count;
+	bool resize_in_progress;
+	wait_queue_head_t resize_wait;
+
 	struct fdtable __rcu *fdt;
 	struct fdtable fdtab;
   /*
_

Patches currently in -mm which might be from edumazet@google.com are


