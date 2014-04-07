From: akpm@linux-foundation.org
Subject: [folded-merged] mm-per-thread-vma-caching-fix-4.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:04:40 -0700
Message-ID: <534320f8.8bllG9IFhTbG9M8U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbaDGWEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:04:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, torvalds@linux-foundation.org, riel@redhat.com, oleg@redhat.com, davidlohr@hp.com

Subject: [folded-merged] mm-per-thread-vma-caching-fix-4.patch removed from -mm tree
To: davidlohr@hp.com,oleg@redhat.com,riel@redhat.com,torvalds@linux-foundation.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:04:40 -0700


The patch titled
     Subject: mm,vmacache: also flush cache for VM_CLONE
has been removed from the -mm tree.  Its filename was
     mm-per-thread-vma-caching-fix-4.patch

This patch was dropped because it was folded into mm-per-thread-vma-caching.patch

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
mm-memoryc-update-comment-in-unmap_single_vma.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6.patch
mm-per-thread-vma-caching-fix-6-fix.patch
ipccompat-remove-sc_semopm-macro.patch
ipc-use-device_initcall.patch

