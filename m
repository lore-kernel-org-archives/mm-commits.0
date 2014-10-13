From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:17:54 -0700
Message-ID: <543c1752.WCJkGYt7F/4mqq8l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: don't use task->mm in m_start() and show_*map()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_mmu.c: don't use task->mm in m_start() and show_*map()

get_gate_vma(priv->task->mm) looks ugly and wrong, task->mm can be NULL or
it can changed by exec right after mm_access().

And in theory this race is not harmless, the task can exec and then later
exit and free the new mm_struct.  In this case get_task_mm(oldmm) can't
help, get_gate_vma(task->mm) can read the freed/unmapped memory.

I think that priv->task should simply die and hold_task_mempolicy() logic
can be simplified.  tail_vma logic asks for cleanups too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map
+++ a/fs/proc/task_mmu.c
@@ -170,7 +170,7 @@ static void *m_start(struct seq_file *m,
 		return mm;
 	down_read(&mm->mmap_sem);
 
-	tail_vma = get_gate_vma(priv->task->mm);
+	tail_vma = get_gate_vma(mm);
 	priv->tail_vma = tail_vma;
 	hold_task_mempolicy(priv);
 	/* Start with last addr hint */
@@ -351,12 +351,11 @@ static int show_map(struct seq_file *m,
 {
 	struct vm_area_struct *vma = v;
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 
 	show_map_vma(m, vma, is_pid);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task->mm))
+		m->version = (vma != priv->tail_vma)
 			? vma->vm_start : 0;
 	return 0;
 }
@@ -584,7 +583,6 @@ static void show_smap_vma_flags(struct s
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
@@ -639,7 +637,7 @@ static int show_smap(struct seq_file *m,
 	show_smap_vma_flags(m, vma);
 
 	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != get_gate_vma(task->mm))
+		m->version = (vma != priv->tail_vma)
 			? vma->vm_start : 0;
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

