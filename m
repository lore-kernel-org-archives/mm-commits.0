From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch added to
 -mm tree
Date: Thu, 14 Aug 2014 14:53:31 -0700
Message-ID: <53ed2fdb.joJXyMo20OV/RzTN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:36063 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaHNVxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:32 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so491076pde.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: simplify the vma_stop() logic
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch

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
Subject: fs/proc/task_mmu.c: simplify the vma_stop() logic

m_start() drops ->mmap_sem and does mmput() if it retuns vsyscall
vma. This is because in this case m_stop()->vma_stop() obviously
can't use gate_vma->vm_mm.

Now that we have proc_maps_private->mm we can simplify this logic:

  - Change m_start() to return with ->mmap_sem held unless it returns
    IS_ERR_OR_NULL().

  - Change vma_stop() to use priv->mm and avoid the ugly vma checks,
    this makes "vm_area_struct *vma" unnecessary.

  - This also allows m_start() to use vm_stop().

  - Cleanup m_next() to follow the new locking rule.

    Note: m_stop() looks very ugly, and this temporary uglifies it
    even more. Fixed by the next change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic
+++ a/fs/proc/task_mmu.c
@@ -129,14 +129,12 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
+static void vma_stop(struct proc_maps_private *priv)
 {
-	if (vma && vma != priv->tail_vma) {
-		struct mm_struct *mm = vma->vm_mm;
-		release_task_mempolicy(priv);
-		up_read(&mm->mmap_sem);
-		mmput(mm);
-	}
+	struct mm_struct *mm = priv->mm;
+	release_task_mempolicy(priv);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
@@ -199,12 +197,13 @@ out:
 	if (vma)
 		return vma;
 
-	release_task_mempolicy(priv);
 	/* End of vmas has been reached */
 	m->version = (tail_vma != NULL)? 0: -1UL;
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-	return tail_vma;
+	if (tail_vma)
+		return tail_vma;
+
+	vma_stop(priv);
+	return NULL;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
@@ -212,21 +211,24 @@ static void *m_next(struct seq_file *m,
 	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct vm_area_struct *tail_vma = priv->tail_vma;
+	struct vm_area_struct *next;
 
 	(*pos)++;
 	if (vma && (vma != tail_vma) && vma->vm_next)
 		return vma->vm_next;
-	vma_stop(priv, vma);
-	return (vma != tail_vma)? tail_vma: NULL;
+
+	next = (vma != tail_vma)? tail_vma: NULL;
+	if (!next)
+		vma_stop(priv);
+	return next;
 }
 
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
 
-	if (!IS_ERR(vma))
-		vma_stop(priv, vma);
+	if (!IS_ERR_OR_NULL(v))
+		vma_stop(priv);
 	if (priv->task)
 		put_task_struct(priv->task);
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

