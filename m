From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch removed
 from -mm tree
Date: Wed, 22 Feb 2017 15:19:32 -0800
Message-ID: <58ae1c84.nEIIXw3MLKBxE4H3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933984AbdBVXTe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: Add fork() event, build warning fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch

This patch was dropped because it was folded into userfaultfd-non-cooperative-add-fork-event.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: Add fork() event, build warning fix

It was harmless, but 32bit kernel builds would emit warnings if not
passing through an (unsigned long) cast of the pointer, before storing it
in a __u64.

Warning found by the kbuild test robot.

Link: http://lkml.kernel.org/r/20161216144821.5183-10-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-add-fork-event-build-warning-fix fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-add-fork-event-build-warning-fix
+++ a/fs/userfaultfd.c
@@ -578,7 +578,7 @@ static int dup_fctx(struct userfaultfd_f
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_FORK;
-	ewq.msg.arg.reserved.reserved1 = (__u64)fctx->new;
+	ewq.msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
 
 	return userfaultfd_event_wait_completion(ctx, &ewq);
 }
@@ -832,7 +832,9 @@ static ssize_t userfaultfd_ctx_read(stru
 			*msg = uwq->msg;
 
 			if (uwq->msg.event == UFFD_EVENT_FORK) {
-				fork_nctx = (struct userfaultfd_ctx *)uwq->msg.arg.reserved.reserved1;
+				fork_nctx = (struct userfaultfd_ctx *)
+					(unsigned long)
+					uwq->msg.arg.reserved.reserved1;
 				list_move(&uwq->wq.task_list, &fork_event);
 				spin_unlock(&ctx->event_wqh.lock);
 				ret = 0;
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-a-lockup-resulting-from-corrupted-page-flags.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

