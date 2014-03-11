From: akpm@linux-foundation.org
Subject: + mm-per-thread-vma-caching-fix-4.patch added to -mm tree
Date: Tue, 11 Mar 2014 11:58:11 -0700
Message-ID: <531f5cc3.rCQpNSEY8eoiAiH+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaCKS6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, oleg@redhat.com, davidlohr@hp.com

Subject: + mm-per-thread-vma-caching-fix-4.patch added to -mm tree
To: davidlohr@hp.com,oleg@redhat.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:58:11 -0700


The patch titled
     From: Davidlohr Bueso <davidlohr@hp.com>
has been added to the -mm tree.  Its filename is
     mm-per-thread-vma-caching-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-per-thread-vma-caching-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-per-thread-vma-caching-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,vmacache: also flush cache for VM_CLONE

Oleg found that there is a potential race if we don't flush the task for
threads (VM_CLONE):

"Suppose we have a task T1 which has the valid vmacache,
T1->vmacache_seqnum == T1->mm->vmacache_seqnum == 0.  Suppose it sleeps a
lot.

Suppose that its subthread T2 does a lot munmap's, finally
mm->vmacache_seqnum becomes zero again and T2 calls vmacache_flush_all().

T1 wakes up and does clone(CLONE_VM).  The new thread T3 gets the copy of
T2's ->vmacache_seqnum and ->vmacache[].

T2 continues, vmacache_flush_all() finds T1 and does vmacache_flush(T1).

But the new thread T3 is not on the list yet, vmacache_flush_all() can't
find it.

So T3 will run with vmacache_valid() == T (till the next invalidate(mm)
of course) but its ->vmacache[] points to nowhere."

Address this by moving the flush call into copy_mm(), instead of only
having it in dup_mm().

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~mm-per-thread-vma-caching-fix-4 kernel/fork.c
--- a/kernel/fork.c~mm-per-thread-vma-caching-fix-4
+++ a/kernel/fork.c
@@ -840,9 +840,6 @@ static struct mm_struct *dup_mm(struct t
 	if (mm->binfmt && !try_module_get(mm->binfmt->module))
 		goto free_pt;
 
-	/* initialize the new vmacache entries */
-	vmacache_flush(tsk);
-
 	return mm;
 
 free_pt:
@@ -886,6 +883,9 @@ static int copy_mm(unsigned long clone_f
 	if (!oldmm)
 		return 0;
 
+	/* initialize the new vmacache entries */
+	vmacache_flush(tsk);
+
 	if (clone_flags & CLONE_VM) {
 		atomic_inc(&oldmm->mm_users);
 		mm = oldmm;
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-memoryc-update-comment-in-unmap_single_vma.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-4.patch
ipccompat-remove-sc_semopm-macro.patch
ipc-use-device_initcall.patch
linux-next.patch

