From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:06 -0700
Message-ID: <543c175e.Gdx1JKbkBW6I0Fjp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaJMSSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: shift "priv->task = NULL" from m_start() to m_stop()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -146,17 +146,12 @@ static void *m_start(struct seq_file *m,
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
 
@@ -228,8 +223,10 @@ static void m_stop(struct seq_file *m, v
 
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
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

