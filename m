From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-3.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 16:09:54 -0700
Message-ID: <59b08042.yZxZP9EPtIfWVrtI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47706 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbdIFXJz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: oom: let oom_reap_task and exit_mmap run concurrently, add unlikely
has been removed from the -mm tree.  Its filename was
     mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-3.patch

This patch was dropped because it was folded into mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently.patch

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: oom: let oom_reap_task and exit_mmap run concurrently, add unlikely

Microoptimization to fold before merging.

Link: http://lkml.kernel.org/r/20170817171240.GB5066@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-3 mm/mmap.c
--- a/mm/mmap.c~mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently-fix-3
+++ a/mm/mmap.c
@@ -3003,7 +3003,7 @@ void exit_mmap(struct mm_struct *mm)
 	unmap_vmas(&tlb, vma, 0, -1);
 
 	set_bit(MMF_OOM_SKIP, &mm->flags);
-	if (tsk_is_oom_victim(current)) {
+	if (unlikely(tsk_is_oom_victim(current))) {
 		/*
 		 * Wait for oom_reap_task() to stop working on this
 		 * mm. Because MMF_OOM_SKIP is already set before
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch
mm-oom-let-oom_reap_task-and-exit_mmap-to-run-concurrently.patch

