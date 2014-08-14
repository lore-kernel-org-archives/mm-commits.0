From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch added to -mm tree
Date: Thu, 14 Aug 2014 14:53:33 -0700
Message-ID: <53ed2fdd.5N49y1JlrYypoKib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:41444 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaHNVxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:34 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so420259obb.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: shift "priv->task = NULL" from m_start() to m_stop()
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch

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
Subject: fs/proc/task_mmu.c: shift "priv->task = NULL" from m_start() to m_stop()

1. There is no reason to reset ->tail_vma in m_start(), if we return
   IS_ERR_OR_NULL() it won't be used.

2. m_start() also clears priv->task to ensure that m_stop() won't use
   the stale pointer if we fail before get_task_struct(). But this is
   ugly and confusing, move this initialization in m_stop().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop
+++ a/fs/proc/task_mmu.c
@@ -145,17 +145,12 @@ static void *m_start(struct seq_file *m,
 	struct vm_area_struct *vma, *tail_vma = NULL;
 	loff_t l = *pos;
 
-	/* Clear the per syscall fields in priv */
-	priv->task = NULL;
-	priv->tail_vma = NULL;
-
 	/*
 	 * We remember last_addr rather than next_addr to hit with
 	 * vmacache most of the time. We have zero last_addr at
 	 * the beginning and also after lseek. We will have -1 last_addr
 	 * after the end of the vmas.
 	 */
-
 	if (last_addr == -1UL)
 		return NULL;
 
@@ -227,8 +222,10 @@ static void m_stop(struct seq_file *m, v
 
 	if (!IS_ERR_OR_NULL(v))
 		vma_stop(priv);
-	if (priv->task)
+	if (priv->task) {
 		put_task_struct(priv->task);
+		priv->task = NULL;
+	}
 }
 
 static int proc_maps_open(struct inode *inode, struct file *file,
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

