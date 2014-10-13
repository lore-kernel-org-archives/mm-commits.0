From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:18:04 -0700
Message-ID: <543c175c.zFcppikcrs5wAzse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: cleanup the "tail_vma" horror in m_next()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fs/proc/task_mmu.c: cleanup the "tail_vma" horror in m_next()

1. Kill the first "vma != NULL" check. Firstly this is not possible,
   m_next() won't be called if ->start() or the previous ->next()
   returns NULL.

   And if it was possible the 2nd "vma != tail_vma" check is buggy,
   we should not wrongly return ->tail_vma.

2. Make this function readable. The logic is very simple, we should
   return check "vma != tail" once and return "vm_next || tail_vma".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next
+++ a/fs/proc/task_mmu.c
@@ -210,15 +210,13 @@ out:
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *vma = v;
 	struct vm_area_struct *tail_vma = priv->tail_vma;
-	struct vm_area_struct *next;
+	struct vm_area_struct *vma = v, *next = NULL;
 
 	(*pos)++;
-	if (vma && (vma != tail_vma) && vma->vm_next)
-		return vma->vm_next;
+	if (vma != tail_vma)
+		next = vma->vm_next ?: tail_vma;
 
-	next = (vma != tail_vma) ? tail_vma : NULL;
 	if (!next)
 		vma_stop(priv);
 	return next;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

