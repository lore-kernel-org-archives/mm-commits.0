From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:02 -0700
Message-ID: <543c175a.G3BBqfy7UeQPu+pV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaJMSSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: simplify the vma_stop() logic
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-the-vma_stop-logic
+++ a/fs/proc/task_mmu.c
@@ -129,14 +129,13 @@ static void release_task_mempolicy(struc
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
+
+	release_task_mempolicy(priv);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
 }
 
 static void *m_start(struct seq_file *m, loff_t *pos)
@@ -199,12 +198,13 @@ out:
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
@@ -212,21 +212,24 @@ static void *m_next(struct seq_file *m,
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
+	next = (vma != tail_vma) ? tail_vma : NULL;
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
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

