From: akpm@linux-foundation.org
Subject: - lockdep-annotate-mm_take_all_locks.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:30 -0700
Message-ID: <200808122033.m7CKXURf011793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbYHLUnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, andrea@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     lockdep: annotate mm_take_all_locks()
has been removed from the -mm tree.  Its filename was
     lockdep-annotate-mm_take_all_locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep: annotate mm_take_all_locks()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The nesting is correct due to holding mmap_sem, use the new annotation
to annotate this.

This doesn't solve the MAX_LOCK_DEPTH issue, but 48 seems enough for
the current kvm usage, which does this early on in the life of an mm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mmap.c~lockdep-annotate-mm_take_all_locks mm/mmap.c
--- a/mm/mmap.c~lockdep-annotate-mm_take_all_locks
+++ a/mm/mmap.c
@@ -2273,14 +2273,14 @@ int install_special_mapping(struct mm_st
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
-static void vm_lock_anon_vma(struct anon_vma *anon_vma)
+static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
 	if (!test_bit(0, (unsigned long *) &anon_vma->head.next)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock(&anon_vma->lock);
+		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->lock. If some other vma in this mm shares
@@ -2296,7 +2296,7 @@ static void vm_lock_anon_vma(struct anon
 	}
 }
 
-static void vm_lock_mapping(struct address_space *mapping)
+static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 {
 	if (!test_bit(AS_MM_ALL_LOCKS, &mapping->flags)) {
 		/*
@@ -2310,7 +2310,7 @@ static void vm_lock_mapping(struct addre
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		spin_lock(&mapping->i_mmap_lock);
+		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
 	}
 }
 
@@ -2359,9 +2359,9 @@ int mm_take_all_locks(struct mm_struct *
 		if (signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
-			vm_lock_anon_vma(vma->anon_vma);
+			vm_lock_anon_vma(mm, vma->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
-			vm_lock_mapping(vma->vm_file->f_mapping);
+			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 	ret = 0;
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
irq-warn-about-irqf_disabledirqf_shared.patch

