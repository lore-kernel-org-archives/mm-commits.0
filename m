From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
 added to -mm tree
Date: Thu, 14 Aug 2014 14:53:32 -0700
Message-ID: <53ed2fdc./1p91jIi0dTUlUsD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:37956 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaHNVxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:33 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so420728obb.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: cleanup the "tail_vma" horror in m_next()
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch

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
@@ -209,15 +209,13 @@ out:
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
 
-	next = (vma != tail_vma)? tail_vma: NULL;
 	if (!next)
 		vma_stop(priv);
 	return next;
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

