From: akpm@linux-foundation.org
Subject: [merged] fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:12 -0700
Message-ID: <543c1764./i5OLGS/ZDM+ibEI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: introduce m_next_vma() helper
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-introduce-m_next_vma-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_mmu.c: introduce m_next_vma() helper

Extract the tail_vma/vm_next calculation from m_next() into the new
trivial helper, m_next_vma().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-introduce-m_next_vma-helper fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-introduce-m_next_vma-helper
+++ a/fs/proc/task_mmu.c
@@ -138,6 +138,14 @@ static void vma_stop(struct proc_maps_pr
 	mmput(mm);
 }
 
+static struct vm_area_struct *
+m_next_vma(struct proc_maps_private *priv, struct vm_area_struct *vma)
+{
+	if (vma == priv->tail_vma)
+		return NULL;
+	return vma->vm_next ?: priv->tail_vma;
+}
+
 static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
@@ -173,13 +181,10 @@ static void *m_start(struct seq_file *m,
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *tail_vma = priv->tail_vma;
-	struct vm_area_struct *vma = v, *next = NULL;
+	struct vm_area_struct *next;
 
 	(*pos)++;
-	if (vma != tail_vma)
-		next = vma->vm_next ?: tail_vma;
