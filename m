From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:53:35 -0700
Message-ID: <53ed2fdf.LZi+OujYO5bJMDLP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:46166 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaHNVxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:37 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so211189qcz.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: simplify m_start() to make it readable
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch

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
Subject: fs/proc/task_mmu.c: simplify m_start() to make it readable

Now that m->version is gone we can cleanup m_start(). In particular,

  - Remove the "unsigned long" typecast, m->index can't be negative
    or exceed ->map_count. But lets use "unsigned int pos" to make
    it clear that "pos < map_count" is safe.

  - Remove the unnecessary "vma != NULL" check in the main loop. It
    can't be NULL unless we have a vm bug.

  - This also means that "pos < map_count" case can simply return the
    valid vma and avoid "goto" and subsequent checks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-m_start-to-make-it-readable fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-simplify-m_start-to-make-it-readable
+++ a/fs/proc/task_mmu.c
@@ -137,12 +137,12 @@ static void vma_stop(struct proc_maps_pr
 	mmput(mm);
 }
 
-static void *m_start(struct seq_file *m, loff_t *pos)
+static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mm_struct *mm;
-	struct vm_area_struct *vma, *tail_vma = NULL;
-	loff_t l = *pos;
+	struct vm_area_struct *vma;
+	unsigned int pos = *ppos;
 
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
@@ -151,33 +151,19 @@ static void *m_start(struct seq_file *m,
 	mm = priv->mm;
 	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
 		return NULL;
-	down_read(&mm->mmap_sem);
 
-	tail_vma = get_gate_vma(mm);
-	priv->tail_vma = tail_vma;
+	down_read(&mm->mmap_sem);
 	hold_task_mempolicy(priv);
+	priv->tail_vma = get_gate_vma(mm);
 
-	/*
-	 * Check the vma index is within the range and do
-	 * sequential scan until m_index.
-	 */
-	vma = NULL;
-	if ((unsigned long)l < mm->map_count) {
-		vma = mm->mmap;
-		while (l-- && vma)
+	if (pos < mm->map_count) {
+		for (vma = mm->mmap; pos; pos--)
 			vma = vma->vm_next;
-		goto out;
-	}
-
-	if (l != mm->map_count)
-		tail_vma = NULL; /* After gate vma */
-
-out:
-	if (vma)
 		return vma;
+	}
 
-	if (tail_vma)
-		return tail_vma;
+	if (pos == mm->map_count && priv->tail_vma)
+		return priv->tail_vma;
 
 	vma_stop(priv);
 	return NULL;
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

