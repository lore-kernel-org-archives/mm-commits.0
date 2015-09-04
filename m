From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch removed from -mm tree
Date: Fri, 04 Sep 2015 15:28:13 -0700
Message-ID: <55ea1afd.PHjAqaEZ3RhJol3D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159AbbIDW2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: cleanup superfluous _irq locking
has been removed from the -mm tree.  Its filename was
     userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch

This patch was dropped because it was folded into userfaultfd-add-new-syscall-to-provide-memory-externalization.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: cleanup superfluous _irq locking

This leftover shouldn't have caused any malfunction because the loop
either schedules or it re-enables irqs immediately and schedule()
doesn't seem to BUG_ON(irqs_disabled()). However lately we've been
using the non blocking model so the schedule isn't really exercised
here. Regardless of the side effects this must be fixed as it's not ok
to enter schedule with irq disabled and it's not beneficial to toggle
irqs in the first place.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix
+++ a/fs/userfaultfd.c
@@ -433,11 +433,11 @@ static ssize_t userfaultfd_ctx_read(stru
 		}
 		spin_unlock(&ctx->fd_wqh.lock);
 		schedule();
-		spin_lock_irq(&ctx->fd_wqh.lock);
+		spin_lock(&ctx->fd_wqh.lock);
 	}
 	__remove_wait_queue(&ctx->fd_wqh, &wait);
 	__set_current_state(TASK_RUNNING);
-	spin_unlock_irq(&ctx->fd_wqh.lock);
+	spin_unlock(&ctx->fd_wqh.lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-wake-pending-userfaults.patch
userfaultfd-optimize-read-and-poll-to-be-o1.patch
userfaultfd-optimize-read-and-poll-to-be-o1-fix.patch
userfaultfd-allocate-the-userfaultfd_ctx-cacheline-aligned.patch
userfaultfd-solve-the-race-between-uffdio_copyzeropage-and-read.patch
userfaultfd-buildsystem-activation.patch
userfaultfd-activate-syscall.patch
userfaultfd-uffdio_copyuffdio_zeropage-uapi.patch
userfaultfd-mcopy_atomicmfill_zeropage-uffdio_copyuffdio_zeropage-preparation.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
userfaultfd-require-uffdio_api-before-other-ioctls.patch
userfaultfd-allow-signals-to-interrupt-a-userfault.patch
userfaultfd-propagate-the-full-address-in-thp-faults.patch
userfaultfd-avoid-missing-wakeups-during-refile-in-userfaultfd_read.patch
userfaultfd-selftest.patch

