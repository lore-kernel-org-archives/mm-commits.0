From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-clear-the-vma-vm_userfaultfd_ctx-if-uffd_event_fork-fails.patch
 removed from -mm tree
Date: Fri, 12 Jan 2018 13:44:05 -0800
Message-ID: <20180112214405.bjyz2gsnG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965189AbeALVoK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 16:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dvyukov@google.com, ebiggers3@gmail.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, stable@vger.kernel.org, syzkaller@googlegroups.com


The patch titled
     Subject: userfaultfd: clear the vma->vm_userfaultfd_ctx if UFFD_EVENT_FORK fails
has been removed from the -mm tree.  Its filename was
     userfaultfd-clear-the-vma-vm_userfaultfd_ctx-if-uffd_event_fork-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: clear the vma->vm_userfaultfd_ctx if UFFD_EVENT_FORK fails

The previous fix 384632e67e0829 ("userfaultfd: non-cooperative: fix fork
use after free") corrected the refcounting in case of UFFD_EVENT_FORK
failure for the fork userfault paths.  That still didn't clear the
vma->vm_userfaultfd_ctx of the vmas that were set to point to the aborted
new uffd ctx earlier in dup_userfaultfd.

Link: http://lkml.kernel.org/r/20171223002505.593-2-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-clear-the-vma-vm_userfaultfd_ctx-if-uffd_event_fork-fails fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-clear-the-vma-vm_userfaultfd_ctx-if-uffd_event_fork-fails
+++ a/fs/userfaultfd.c
@@ -570,11 +570,14 @@ out:
 static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 					      struct userfaultfd_wait_queue *ewq)
 {
+	struct userfaultfd_ctx *release_new_ctx;
+
 	if (WARN_ON_ONCE(current->flags & PF_EXITING))
 		goto out;
 
 	ewq->ctx = ctx;
 	init_waitqueue_entry(&ewq->wq, current);
+	release_new_ctx = NULL;
 
 	spin_lock(&ctx->event_wqh.lock);
 	/*
@@ -601,8 +604,7 @@ static void userfaultfd_event_wait_compl
 				new = (struct userfaultfd_ctx *)
 					(unsigned long)
 					ewq->msg.arg.reserved.reserved1;
-
-				userfaultfd_ctx_put(new);
+				release_new_ctx = new;
 			}
 			break;
 		}
@@ -617,6 +619,20 @@ static void userfaultfd_event_wait_compl
 	__set_current_state(TASK_RUNNING);
 	spin_unlock(&ctx->event_wqh.lock);
 
+	if (release_new_ctx) {
+		struct vm_area_struct *vma;
+		struct mm_struct *mm = release_new_ctx->mm;
+
+		/* the various vma->vm_userfaultfd_ctx still points to it */
+		down_write(&mm->mmap_sem);
+		for (vma = mm->mmap; vma; vma = vma->vm_next)
+			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx)
+				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
+		up_write(&mm->mmap_sem);
+
+		userfaultfd_ctx_put(release_new_ctx);
+	}
+
 	/*
 	 * ctx may go away after this if the userfault pseudo fd is
 	 * already released.
_

Patches currently in -mm which might be from aarcange@redhat.com are


