From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_nommuc-dont-use-priv-task-mm.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:18:22 -0700
Message-ID: <543c176e.YdL/8EK74sBYqM74%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gerg@uclinux.org, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_nommu.c: don't use priv->task->mm
has been removed from the -mm tree.  Its filename was
     fs-proc-task_nommuc-dont-use-priv-task-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_nommu.c: don't use priv->task->mm

I do not know if CONFIG_PREEMPT/SMP is possible without CONFIG_MMU
but the usage of task->mm in m_stop(). The task can exit/exec before
we take mmap_sem, in this case m_stop() can hit NULL or unlock the
wrong rw_semaphore.

Also, this code uses priv->task != NULL to decide whether we need
up_read/mmput. This is correct, but we will probably kill priv->task.
Change m_start/m_stop to rely on IS_ERR_OR_NULL() like task_mmu.c does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_nommu.c~fs-proc-task_nommuc-dont-use-priv-task-mm fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~fs-proc-task_nommuc-dont-use-priv-task-mm
+++ a/fs/proc/task_nommu.c
@@ -217,17 +217,17 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = priv->mm;
-	if (!mm || !atomic_inc_not_zero(&mm->mm_users)) {
-		put_task_struct(priv->task);
-		priv->task = NULL;
+	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
 		return NULL;
-	}
-	down_read(&mm->mmap_sem);
 
+	down_read(&mm->mmap_sem);
 	/* start from the Nth VMA */
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
 		if (n-- == 0)
 			return p;
+
+	up_read(&mm->mmap_sem);
+	mmput(mm);
 	return NULL;
 }
 
@@ -235,11 +235,13 @@ static void m_stop(struct seq_file *m, v
 {
 	struct proc_maps_private *priv = m->private;
 
+	if (!IS_ERR_OR_NULL(_vml)) {
+		up_read(&priv->mm->mmap_sem);
+		mmput(priv->mm);
+	}
 	if (priv->task) {
-		struct mm_struct *mm = priv->task->mm;
-		up_read(&mm->mmap_sem);
-		mmput(mm);
 		put_task_struct(priv->task);
+		priv->task = NULL;
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

