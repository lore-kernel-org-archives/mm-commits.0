From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus.patch added to -mm tree
Date: Wed, 23 Aug 2017 14:56:34 -0700
Message-ID: <599dfa12.zWxrYP2rhtwJHvDv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdHWV4f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 17:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: closing the uffd without triggering SIGBUS
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus.patch

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
Subject: userfaultfd: non-cooperative: closing the uffd without triggering SIGBUS

This is an enhancement to avoid a non cooperative userfaultfd manager
having to unregister all regions before it can close the uffd after all
userfaultfd activity completed.

The UFFDIO_UNREGISTER would serialize against the handle_userfault by
taking the mmap_sem for writing, but we can simply repeat the page fault
if we detect the uffd was closed and so the regular page fault paths
should takeover.

Link: http://lkml.kernel.org/r/20170823181227.19926-1-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus
+++ a/fs/userfaultfd.c
@@ -384,8 +384,26 @@ int handle_userfault(struct vm_fault *vm
 	 * in __get_user_pages if userfaultfd_release waits on the
 	 * caller of handle_userfault to release the mmap_sem.
 	 */
-	if (unlikely(ACCESS_ONCE(ctx->released)))
+	if (unlikely(ACCESS_ONCE(ctx->released))) {
+		/*
+		 * Don't return VM_FAULT_SIGBUS in this case, so a non
+		 * cooperative manager can close the uffd after the
+		 * last UFFDIO_COPY, without risking to trigger an
+		 * involuntary SIGBUS if the process was starting the
+		 * userfaultfd while the userfaultfd was still armed
+		 * (but after the last UFFDIO_COPY). If the uffd
+		 * wasn't already closed when the userfault reached
+		 * this point, that would normally be solved by
+		 * userfaultfd_must_wait returning 'false'.
+		 *
+		 * If we were to return VM_FAULT_SIGBUS here, the non
+		 * cooperative manager would be instead forced to
+		 * always call UFFDIO_UNREGISTER before it can safely
+		 * close the uffd.
+		 */
+		ret = VM_FAULT_NOPAGE;
 		goto out;
+	}
 
 	/*
 	 * Check that we can return VM_FAULT_RETRY.
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch
mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently.patch
mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix.patch
mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-3.patch
userfaultfd-non-cooperative-closing-the-uffd-without-triggering-sigbus.patch

