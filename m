From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:16 -0700
Message-ID: <543c1768.oahBny36n/b7bVfv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: update m->version in the main loop in m_start()
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -184,11 +184,14 @@ static void *m_start(struct seq_file *m,
 
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
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_sizefix.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

