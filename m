From: akpm@linux-foundation.org
Subject: [patch 033/126] userfaultfd: non-cooperative: closing the
 uffd without triggering SIGBUS
Date: Fri, 08 Sep 2017 16:12:42 -0700
Message-ID: <20170908231242.XQ_1w_oi1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932716AbdIHXMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, xemul@virtuozzo.com

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
@@ -381,8 +381,26 @@ int handle_userfault(struct vm_fault *vm
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
