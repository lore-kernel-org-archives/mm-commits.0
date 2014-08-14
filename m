From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-introduce-m_next_vma-helper.patch added to
 -mm tree
Date: Thu, 14 Aug 2014 14:53:36 -0700
Message-ID: <53ed2fe0.HOR9gVxP8nnbHpDn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:37610 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaHNVxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:37 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so420339oac.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: introduce m_next_vma() helper
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-introduce-m_next_vma-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-introduce-m_next_vma-helper.patch

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
@@ -137,6 +137,14 @@ static void vma_stop(struct proc_maps_pr
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
@@ -172,13 +180,10 @@ static void *m_start(struct seq_file *m,
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_maps_private *priv = m->private;
-	struct vm_area_struct *tail_vma = priv->tail_vma;
-	struct vm_area_struct *vma = v, *next = NULL;
+	struct vm_area_struct *next;
 
 	(*pos)++;
-	if (vma != tail_vma)
-		next = vma->vm_next ?: tail_vma;
-
+	next = m_next_vma(priv, v);
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

