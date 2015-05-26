From: akpm@linux-foundation.org
Subject: +
 userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch added to -mm tree
Date: Tue, 26 May 2015 14:57:38 -0700
Message-ID: <5564ec52.wk1hQnp6EX4NGlp+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbEZV5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 May 2015 17:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: cleanup superfluous _irq locking
has been added to the -mm tree.  Its filename is
     userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

thp-cleanup-how-khugepaged-enters-freezer.patch
mm-drop-bogus-vm_bug_on_page-assert-in-put_page-codepath.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt.patch
userfaultfd-linux-documentation-vm-userfaultfdtxt-fix.patch
userfaultfd-waitqueue-add-nr-wake-parameter-to-__wake_up_locked_key.patch
userfaultfd-uapi.patch
userfaultfd-linux-userfaultfd_kh.patch
userfaultfd-add-vm_userfaultfd_ctx-to-the-vm_area_struct.patch
userfaultfd-add-vm_uffd_missing-and-vm_uffd_wp.patch
userfaultfd-call-handle_userfault-for-userfaultfd_missing-faults.patch
userfaultfd-teach-vma_merge-to-merge-across-vma-vm_userfaultfd_ctx.patch
userfaultfd-prevent-khugepaged-to-merge-if-userfaultfd-is-armed.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix.patch
userfaultfd-add-new-syscall-to-provide-memory-externalization-fix-fix-fix.patch
userfaultfd-rename-uffd_apibits-into-features.patch
userfaultfd-rename-uffd_apibits-into-features-fixup.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix.patch
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
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
fs-userfaultfdc-work-around-i386-build-error.patch
mm-oom_kill-remove-unnecessary-locking-in-oom_enable.patch
mm-oom_kill-clean-up-victim-marking-and-exiting-interfaces.patch
mm-oom_kill-switch-test-and-clear-of-known-tif_memdie-to-clear.patch
mm-oom_kill-generalize-oom-progress-waitqueue.patch
mm-oom_kill-remove-unnecessary-locking-in-exit_oom_victim.patch
mm-oom_kill-simplify-oom-killer-locking.patch
mm-page_alloc-inline-should_alloc_retry.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions.patch
powerpc-mm-use-generic-version-of-pmdp_clear_flush.patch
mm-clarify-that-the-function-operates-on-hugepage-pte.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

