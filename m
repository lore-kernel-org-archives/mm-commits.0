From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-reintroduce-m-version-logic.patch added to
 -mm tree
Date: Thu, 14 Aug 2014 14:53:37 -0700
Message-ID: <53ed2fe1.GbeGrrSo8c+LJYzV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:57744 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaHNVxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:38 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so380833oig.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: reintroduce m->version logic
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-reintroduce-m-version-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-reintroduce-m-version-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-reintroduce-m-version-logic.patch

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
Subject: fs/proc/task_mmu.c: reintroduce m->version logic

Add the "last_addr" optimization back. Like before, every ->show()
method checks !seq_overflow() and sets m->version = vma->vm_start.

However, it also checks that m_next_vma(vma) != NULL, otherwise it
sets m->version = -1 for the lockless "EOF" fast-path in m_start().

m_start() can simply do find_vma() + m_next_vma() if last_addr is
not zero, the code looks clear and simple and this case is clearly
separated from "scan vmas" path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-reintroduce-m-version-logic fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-reintroduce-m-version-logic
+++ a/fs/proc/task_mmu.c
@@ -145,13 +145,24 @@ m_next_vma(struct proc_maps_private *pri
 	return vma->vm_next ?: priv->tail_vma;
 }
 
+static void m_cache_vma(struct seq_file *m, struct vm_area_struct *vma)
+{
+	if (m->count < m->size)	/* vma is copied successfully */
+		m->version = m_next_vma(m->private, vma) ? vma->vm_start : -1UL;
+}
+
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
+	unsigned long last_addr = m->version;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int pos = *ppos;
 
+	/* See m_cache_vma(). Zero at the start or after lseek. */
+	if (last_addr == -1UL)
+		return NULL;
+
 	priv->task = get_pid_task(priv->pid, PIDTYPE_PID);
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
@@ -164,6 +175,13 @@ static void *m_start(struct seq_file *m,
 	hold_task_mempolicy(priv);
 	priv->tail_vma = get_gate_vma(mm);
 
+	if (last_addr) {
+		vma = find_vma(mm, last_addr);
+		if (vma && (vma = m_next_vma(priv, vma)))
+			return vma;
+	}
+
+	m->version = 0;
 	if (pos < mm->map_count) {
 		for (vma = mm->mmap; pos; pos--)
 			vma = vma->vm_next;
@@ -339,6 +357,7 @@ done:
 static int show_map(struct seq_file *m, void *v, int is_pid)
 {
 	show_map_vma(m, v, is_pid);
+	m_cache_vma(m, v);
 	return 0;
 }
 
@@ -616,6 +635,7 @@ static int show_smap(struct seq_file *m,
 				mss.nonlinear >> 10);
 
 	show_smap_vma_flags(m, vma);
+	m_cache_vma(m, vma);
 	return 0;
 }
 
@@ -1461,6 +1481,7 @@ static int show_numa_map(struct seq_file
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
+	m_cache_vma(m, vma);
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

