From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_mmuc-reintroduce-m-version-logic.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:14 -0700
Message-ID: <543c1766.2huS9lR79fUTtCzJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: reintroduce m->version logic
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-reintroduce-m-version-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -146,13 +146,24 @@ m_next_vma(struct proc_maps_private *pri
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
@@ -165,6 +176,13 @@ static void *m_start(struct seq_file *m,
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
@@ -340,6 +358,7 @@ done:
 static int show_map(struct seq_file *m, void *v, int is_pid)
 {
 	show_map_vma(m, v, is_pid);
+	m_cache_vma(m, v);
 	return 0;
 }
 
@@ -617,6 +636,7 @@ static int show_smap(struct seq_file *m,
 				mss.nonlinear >> 10);
 
 	show_smap_vma_flags(m, vma);
+	m_cache_vma(m, vma);
 	return 0;
 }
 
@@ -1471,6 +1491,7 @@ static int show_numa_map(struct seq_file
 			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
 out:
 	seq_putc(m, '\n');
+	m_cache_vma(m, vma);
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

