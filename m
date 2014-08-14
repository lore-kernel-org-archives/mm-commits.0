From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:53:34 -0700
Message-ID: <53ed2fde.NoHaYx9XMeLgzk0K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:44498 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaHNVxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:35 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so210823yha.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: kill the suboptimal and confusing m->version logic
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch

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
Subject: fs/proc/task_mmu.c: kill the suboptimal and confusing m->version logic

m_start() carefully documents, checks, and sets "m->version = -1" if
we are going to return NULL. The only problem is that we will be never
called again if m_start() returns NULL, so this is simply pointless
and misleading.

Otoh, ->show() methods m->version = 0 if vma == tail_vma and this is
just wrong, we want -1 in this case. And in fact we also want -1 if
->vm_next == NULL and ->tail_vma == NULL.

And it is not used consistently, the "scan vmas" loop in m_start()
should update last_addr too.

Finally, imo the whole "last_addr" logic in m_start() looks horrible.
find_vma(last_addr) is called unconditionally even if we are not going
to use the result. But the main problem is that this code participates
in tail_vma-or-NULL mess, and this looks simply unfixable.

Remove this optimization. We will add it back after some cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic
+++ a/fs/proc/task_mmu.c
@@ -140,20 +140,10 @@ static void vma_stop(struct proc_maps_pr
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma, *tail_vma = NULL;
 	loff_t l = *pos;
 
-	/*
-	 * We remember last_addr rather than next_addr to hit with
-	 * vmacache most of the time. We have zero last_addr at
-	 * the beginning and also after lseek. We will have -1 last_addr
-	 * after the end of the vmas.
-	 */
-	if (last_addr == -1UL)
-		return NULL;
-
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
@@ -166,12 +156,6 @@ static void *m_start(struct seq_file *m,
 	tail_vma = get_gate_vma(mm);
 	priv->tail_vma = tail_vma;
 	hold_task_mempolicy(priv);
-	/* Start with last addr hint */
-	vma = find_vma(mm, last_addr);
-	if (last_addr && vma) {
-		vma = vma->vm_next;
-		goto out;
-	}
 
 	/*
 	 * Check the vma index is within the range and do
@@ -192,8 +176,6 @@ out:
 	if (vma)
 		return vma;
 
-	/* End of vmas has been reached */
-	m->version = (tail_vma != NULL)? 0: -1UL;
 	if (tail_vma)
 		return tail_vma;
 
@@ -365,14 +347,7 @@ done:
 
 static int show_map(struct seq_file *m, void *v, int is_pid)
 {
-	struct vm_area_struct *vma = v;
-	struct proc_maps_private *priv = m->private;
-
-	show_map_vma(m, vma, is_pid);
-
-	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != priv->tail_vma)
-			? vma->vm_start : 0;
+	show_map_vma(m, v, is_pid);
 	return 0;
 }
 
@@ -598,7 +573,6 @@ static void show_smap_vma_flags(struct s
 
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
-	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
@@ -651,10 +625,6 @@ static int show_smap(struct seq_file *m,
 				mss.nonlinear >> 10);
 
 	show_smap_vma_flags(m, vma);
-
-	if (m->count < m->size)  /* vma is copied successfully */
-		m->version = (vma != priv->tail_vma)
-			? vma->vm_start : 0;
 	return 0;
 }
 
@@ -1500,9 +1470,6 @@ static int show_numa_map(struct seq_file
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
-
-	if (m->count < m->size)
-		m->version = (vma != proc_priv->tail_vma) ? vma->vm_start : 0;
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

