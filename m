From: akpm@linux-foundation.org
Subject: + fs-proc-task_nommuc-dont-use-priv-task-mm.patch added to -mm
 tree
Date: Thu, 14 Aug 2014 14:53:41 -0700
Message-ID: <53ed2fe5.W4UyxCDsf2tUqNhE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:58493 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaHNVxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:42 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so31729igi.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_nommu.c: don't use priv->task->mm
has been added to the -mm tree.  Its filename is
     fs-proc-task_nommuc-dont-use-priv-task-mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_nommuc-dont-use-priv-task-mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_nommuc-dont-use-priv-task-mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
linux-next.patch

