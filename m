From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch added to
 -mm tree
Date: Thu, 14 Aug 2014 14:53:27 -0700
Message-ID: <53ed2fd7.Y8Lrr2Znp3veh18q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61981 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbaHNVx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:29 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so210456vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: don't use task->mm in m_start() and show_*map()
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch

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

