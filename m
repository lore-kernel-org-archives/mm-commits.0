Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD98C04E69
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjG0UIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjG0UHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238AC2D67;
        Thu, 27 Jul 2023 13:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E92B761F2C;
        Thu, 27 Jul 2023 20:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E3CC433C8;
        Thu, 27 Jul 2023 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488466;
        bh=9BZIzuHWzkDj93gqPp9KbSuEWukw8rcv7zB2vtAU1aA=;
        h=Date:To:From:Subject:From;
        b=xfd1JmbO8tTHx/CeN+vpgUCAtjaFIwrTZgiRdTwiTbUqqJ37I9Ec7hlueRr2c7RMY
         4z6G3WS5npRGCJCqzul08Ecin+nHemL1oINfd+P7gD3dNb0OYLvm+SmLYLT5yk8Mik
         2ZEFXvrXervzO0j3D82i4h9knXRFiieZwGwCiHzw=
Date:   Thu, 27 Jul 2023 13:07:45 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-memory-ordering-for-mm_lock_seq-and-vm_lock_seq.patch removed from -mm tree
Message-Id: <20230727200746.41E3CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix memory ordering for mm_lock_seq and vm_lock_seq
has been removed from the -mm tree.  Its filename was
     mm-fix-memory-ordering-for-mm_lock_seq-and-vm_lock_seq.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm: fix memory ordering for mm_lock_seq and vm_lock_seq
Date: Sat, 22 Jul 2023 00:51:07 +0200

mm->mm_lock_seq effectively functions as a read/write lock; therefore it
must be used with acquire/release semantics.

A specific example is the interaction between userfaultfd_register() and
lock_vma_under_rcu().

userfaultfd_register() does the following from the point where it changes
a VMA's flags to the point where concurrent readers are permitted again
(in a simple scenario where only a single private VMA is accessed and no
merging/splitting is involved):

userfaultfd_register
  userfaultfd_set_vm_flags
    vm_flags_reset
      vma_start_write
        down_write(&vma->vm_lock->lock)
        vma->vm_lock_seq = mm_lock_seq [marks VMA as busy]
        up_write(&vma->vm_lock->lock)
      vm_flags_init
        [sets VM_UFFD_* in __vm_flags]
  vma->vm_userfaultfd_ctx.ctx = ctx
  mmap_write_unlock
    vma_end_write_all
      WRITE_ONCE(mm->mm_lock_seq, mm->mm_lock_seq + 1) [unlocks VMA]

There are no memory barriers in between the __vm_flags update and the
mm->mm_lock_seq update that unlocks the VMA, so the unlock can be
reordered to above the `vm_flags_init()` call, which means from the
perspective of a concurrent reader, a VMA can be marked as a userfaultfd
VMA while it is not VMA-locked.  That's bad, we definitely need a
store-release for the unlock operation.

The non-atomic write to vma->vm_lock_seq in vma_start_write() is mostly
fine because all accesses to vma->vm_lock_seq that matter are always
protected by the VMA lock.  There is a racy read in vma_start_read()
though that can tolerate false-positives, so we should be using
WRITE_ONCE() to keep things tidy and data-race-free (including for KCSAN).

On the other side, lock_vma_under_rcu() works as follows in the relevant
region for locking and userfaultfd check:

lock_vma_under_rcu
  vma_start_read
    vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq) [early bailout]
    down_read_trylock(&vma->vm_lock->lock)
    vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq) [main check]
  userfaultfd_armed
    checks vma->vm_flags & __VM_UFFD_FLAGS

Here, the interesting aspect is how far down the mm->mm_lock_seq read can
be reordered - if this read is reordered down below the vma->vm_flags
access, this could cause lock_vma_under_rcu() to partly operate on
information that was read while the VMA was supposed to be locked.  To
prevent this kind of downwards bleeding of the mm->mm_lock_seq read, we
need to read it with a load-acquire.

Some of the comment wording is based on suggestions by Suren.

BACKPORT WARNING: One of the functions changed by this patch (which I've
written against Linus' tree) is vma_try_start_write(), but this function
no longer exists in mm/mm-everything.  I don't know whether the merged
version of this patch will be ordered before or after the patch that
removes vma_try_start_write().  If you're backporting this patch to a tree
with vma_try_start_write(), make sure this patch changes that function.

Link: https://lkml.kernel.org/r/20230721225107.942336-1-jannh@google.com
Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h        |   29 +++++++++++++++++++++++------
 include/linux/mm_types.h  |   28 ++++++++++++++++++++++++++++
 include/linux/mmap_lock.h |   10 ++++++++--
 3 files changed, 59 insertions(+), 8 deletions(-)

--- a/include/linux/mmap_lock.h~mm-fix-memory-ordering-for-mm_lock_seq-and-vm_lock_seq
+++ a/include/linux/mmap_lock.h
@@ -76,8 +76,14 @@ static inline void mmap_assert_write_loc
 static inline void vma_end_write_all(struct mm_struct *mm)
 {
 	mmap_assert_write_locked(mm);
-	/* No races during update due to exclusive mmap_lock being held */
-	WRITE_ONCE(mm->mm_lock_seq, mm->mm_lock_seq + 1);
+	/*
+	 * Nobody can concurrently modify mm->mm_lock_seq due to exclusive
+	 * mmap_lock being held.
+	 * We need RELEASE semantics here to ensure that preceding stores into
+	 * the VMA take effect before we unlock it with this store.
+	 * Pairs with ACQUIRE semantics in vma_start_read().
+	 */
+	smp_store_release(&mm->mm_lock_seq, mm->mm_lock_seq + 1);
 }
 #else
 static inline void vma_end_write_all(struct mm_struct *mm) {}
--- a/include/linux/mm.h~mm-fix-memory-ordering-for-mm_lock_seq-and-vm_lock_seq
+++ a/include/linux/mm.h
@@ -641,8 +641,14 @@ static inline void vma_numab_state_free(
  */
 static inline bool vma_start_read(struct vm_area_struct *vma)
 {
-	/* Check before locking. A race might cause false locked result. */
-	if (vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq))
+	/*
+	 * Check before locking. A race might cause false locked result.
+	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
+	 * ACQUIRE semantics, because this is just a lockless check whose result
+	 * we don't rely on for anything - the mm_lock_seq read against which we
+	 * need ordering is below.
+	 */
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq))
 		return false;
 
 	if (unlikely(down_read_trylock(&vma->vm_lock->lock) == 0))
@@ -653,8 +659,13 @@ static inline bool vma_start_read(struct
 	 * False unlocked result is impossible because we modify and check
 	 * vma->vm_lock_seq under vma->vm_lock protection and mm->mm_lock_seq
 	 * modification invalidates all existing locks.
+	 *
+	 * We must use ACQUIRE semantics for the mm_lock_seq so that if we are
+	 * racing with vma_end_write_all(), we only start reading from the VMA
+	 * after it has been unlocked.
+	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq))) {
+	if (unlikely(vma->vm_lock_seq == smp_load_acquire(&vma->vm_mm->mm_lock_seq))) {
 		up_read(&vma->vm_lock->lock);
 		return false;
 	}
@@ -676,7 +687,7 @@ static bool __is_vma_write_locked(struct
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	*mm_lock_seq = READ_ONCE(vma->vm_mm->mm_lock_seq);
+	*mm_lock_seq = vma->vm_mm->mm_lock_seq;
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
@@ -688,7 +699,13 @@ static inline void vma_start_write(struc
 		return;
 
 	down_write(&vma->vm_lock->lock);
-	vma->vm_lock_seq = mm_lock_seq;
+	/*
+	 * We should use WRITE_ONCE() here because we can have concurrent reads
+	 * from the early lockless pessimistic check in vma_start_read().
+	 * We don't really care about the correctness of that early check, but
+	 * we should use WRITE_ONCE() for cleanliness and to keep KCSAN happy.
+	 */
+	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 	up_write(&vma->vm_lock->lock);
 }
 
@@ -702,7 +719,7 @@ static inline bool vma_try_start_write(s
 	if (!down_write_trylock(&vma->vm_lock->lock))
 		return false;
 
-	vma->vm_lock_seq = mm_lock_seq;
+	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 	up_write(&vma->vm_lock->lock);
 	return true;
 }
--- a/include/linux/mm_types.h~mm-fix-memory-ordering-for-mm_lock_seq-and-vm_lock_seq
+++ a/include/linux/mm_types.h
@@ -514,6 +514,20 @@ struct vm_area_struct {
 	};
 
 #ifdef CONFIG_PER_VMA_LOCK
+	/*
+	 * Can only be written (using WRITE_ONCE()) while holding both:
+	 *  - mmap_lock (in write mode)
+	 *  - vm_lock->lock (in write mode)
+	 * Can be read reliably while holding one of:
+	 *  - mmap_lock (in read or write mode)
+	 *  - vm_lock->lock (in read or write mode)
+	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
+	 * while holding nothing (except RCU to keep the VMA struct allocated).
+	 *
+	 * This sequence counter is explicitly allowed to overflow; sequence
+	 * counter reuse can only lead to occasional unnecessary use of the
+	 * slowpath.
+	 */
 	int vm_lock_seq;
 	struct vma_lock *vm_lock;
 
@@ -679,6 +693,20 @@ struct mm_struct {
 					  * by mmlist_lock
 					  */
 #ifdef CONFIG_PER_VMA_LOCK
+		/*
+		 * This field has lock-like semantics, meaning it is sometimes
+		 * accessed with ACQUIRE/RELEASE semantics.
+		 * Roughly speaking, incrementing the sequence number is
+		 * equivalent to releasing locks on VMAs; reading the sequence
+		 * number can be part of taking a read lock on a VMA.
+		 *
+		 * Can be modified under write mmap_lock using RELEASE
+		 * semantics.
+		 * Can be read with no other protection when holding write
+		 * mmap_lock.
+		 * Can be read with ACQUIRE semantics if not holding write
+		 * mmap_lock.
+		 */
 		int mm_lock_seq;
 #endif
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-dont-drop-vma-locks-in-mm_drop_all_locks.patch

