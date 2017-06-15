From: akpm@linux-foundation.org
Subject: + userfaultfd-shmem-handle-coredumping-in-handle_userfault.patch
 added to -mm tree
Date: Thu, 15 Jun 2017 14:55:03 -0700
Message-ID: <59430237.vL9JjrKEzXMHXvlE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752017AbdFOVzE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 17:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: shmem: handle coredumping in handle_userfault()
has been added to the -mm tree.  Its filename is
     userfaultfd-shmem-handle-coredumping-in-handle_userfault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-shmem-handle-coredumping-in-handle_userfault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-shmem-handle-coredumping-in-handle_userfault.patch

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
Subject: userfaultfd: shmem: handle coredumping in handle_userfault()

Anon and hugetlbfs handle FOLL_DUMP set by get_dump_page() internally to
__get_user_pages().

shmem as opposed has no special FOLL_DUMP handling there so
handle_mm_fault() is invoked without mmap_sem and ends up calling
handle_userfault() that isn't expecting to be invoked without mmap_sem
held.

This makes handle_userfault() fail immediately if invoked through
shmem_vm_ops->fault during coredumping and solves the problem.

It's zero cost as we already had a check for current->flags to prevent
futex to trigger userfaults during exit (PF_EXITING).

Link: http://lkml.kernel.org/r/20170615214838.27429-1-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-shmem-handle-coredumping-in-handle_userfault fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-shmem-handle-coredumping-in-handle_userfault
+++ a/fs/userfaultfd.c
@@ -342,9 +342,28 @@ int handle_userfault(struct vm_fault *vm
 	bool must_wait, return_to_userland;
 	long blocking_state;
 
-	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
-
 	ret = VM_FAULT_SIGBUS;
+
+	/*
+	 * We don't do userfault handling for the final child pid update.
+	 *
+	 * We also don't do userfault handling during
+	 * coredumping. hugetlbfs has the special
+	 * follow_hugetlb_page() to skip missing pages in the
+	 * FOLL_DUMP case, anon memory also checks for FOLL_DUMP with
+	 * the no_page_table() helper in follow_page_mask(), but the
+	 * shmem_vm_ops->fault method is invoked even during
+	 * coredumping without mmap_sem and it ends up here.
+	 */
+	if (current->flags & (PF_EXITING|PF_DUMPCORE))
+		goto out;
+
+	/*
+	 * Coredumping runs without mmap_sem so we can only check that
+	 * the mmap_sem is held, if PF_DUMPCORE was not set.
+	 */
+	WARN_ON_ONCE(!rwsem_is_locked(&mm->mmap_sem));
+
 	ctx = vmf->vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx)
 		goto out;
@@ -363,12 +382,6 @@ int handle_userfault(struct vm_fault *vm
 		goto out;
 
 	/*
-	 * We don't do userfault handling for the final child pid update.
-	 */
-	if (current->flags & PF_EXITING)
-		goto out;
