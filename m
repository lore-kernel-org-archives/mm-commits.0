From: akpm@linux-foundation.org
Subject: +
 fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch added
 to -mm tree
Date: Thu, 14 Aug 2014 14:53:38 -0700
Message-ID: <53ed2fe2.SzvnuaTuV6xLjFxV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:50573 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaHNVxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:53:39 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so31563igi.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:53:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: update m->version in the main loop in m_start()
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch

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
Subject: fs/proc/task_mmu.c: update m->version in the main loop in m_start()

Change the main loop in m_start() to update m->version. Mostly for
consistency, but this can help to avoid the same loop if the very
1st ->show() fails due to seq_overflow().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start
+++ a/fs/proc/task_mmu.c
@@ -183,11 +183,14 @@ static void *m_start(struct seq_file *m,
 
 	m->version = 0;
 	if (pos < mm->map_count) {
-		for (vma = mm->mmap; pos; pos--)
+		for (vma = mm->mmap; pos; pos--) {
+			m->version = vma->vm_start;
 			vma = vma->vm_next;
+		}
 		return vma;
 	}
 
+	/* we do not bother to update m->version in this case */
 	if (pos == mm->map_count && priv->tail_vma)
 		return priv->tail_vma;
 
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

