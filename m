From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:18:10 -0700
Message-ID: <543c1762.6j3lFL3OsxFhtPAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: simplify m_start() to make it readable
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -138,12 +138,12 @@ static void vma_stop(struct proc_maps_pr
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
@@ -152,33 +152,19 @@ static void *m_start(struct seq_file *m,
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
