Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F04EC7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbjDFDDx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbjDFDDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3C683E4
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94B8264125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED54BC433D2;
        Thu,  6 Apr 2023 03:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750215;
        bh=BwSt8vJpR2EWI8EGqWLQsok8fk2tAk8klz7sryj4Mj0=;
        h=Date:To:From:Subject:From;
        b=fPu+HEh8h4Ko0HpFMOrPqGjtjw59MOI+cBLkdvnd+oLX6CDmkQxB6cEo4q/u7JUaM
         D7ZdTAU/R73crZVYMI2rXibxnBs8U00d11Kj8MCfsH0MffzW3AqzaRPpDMSaEoHo7y
         KAXWjRSisSsNhbjzbaHM8f/oT+0Bh0VSORPk72JQ=
Date:   Wed, 05 Apr 2023 20:03:34 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-per-vma-lock-and-helper-functions-to-control-it.patch removed from -mm tree
Message-Id: <20230406030334.ED54BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add per-VMA lock and helper functions to control it
has been removed from the -mm tree.  Its filename was
     mm-add-per-vma-lock-and-helper-functions-to-control-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: add per-VMA lock and helper functions to control it
Date: Mon, 27 Feb 2023 09:36:11 -0800

Introduce per-VMA locking.  The lock implementation relies on a per-vma
and per-mm sequence counters to note exclusive locking:

  - read lock - (implemented by vma_start_read) requires the vma
    (vm_lock_seq) and mm (mm_lock_seq) sequence counters to differ.
    If they match then there must be a vma exclusive lock held somewhere.
  - read unlock - (implemented by vma_end_read) is a trivial vma->lock
    unlock.
  - write lock - (vma_start_write) requires the mmap_lock to be held
    exclusively and the current mm counter is assigned to the vma counter.
    This will allow multiple vmas to be locked under a single mmap_lock
    write lock (e.g. during vma merging). The vma counter is modified
    under exclusive vma lock.
  - write unlock - (vma_end_write_all) is a batch release of all vma
    locks held. It doesn't pair with a specific vma_start_write! It is
    done before exclusive mmap_lock is released by incrementing mm
    sequence counter (mm_lock_seq).
  - write downgrade - if the mmap_lock is downgraded to the read lock, all
    vma write locks are released as well (effectivelly same as write
    unlock).

Link: https://lkml.kernel.org/r/20230227173632.3292573-13-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h        |   82 ++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h  |    8 +++
 include/linux/mmap_lock.h |   13 +++++
 kernel/fork.c             |    4 +
 mm/init-mm.c              |    3 +
 5 files changed, 110 insertions(+)

--- a/include/linux/mmap_lock.h~mm-add-per-vma-lock-and-helper-functions-to-control-it
+++ a/include/linux/mmap_lock.h
@@ -72,6 +72,17 @@ static inline void mmap_assert_write_loc
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
 }
 
+#ifdef CONFIG_PER_VMA_LOCK
+static inline void vma_end_write_all(struct mm_struct *mm)
+{
+	mmap_assert_write_locked(mm);
+	/* No races during update due to exclusive mmap_lock being held */
+	WRITE_ONCE(mm->mm_lock_seq, mm->mm_lock_seq + 1);
+}
+#else
+static inline void vma_end_write_all(struct mm_struct *mm) {}
+#endif
+
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
 	init_rwsem(&mm->mmap_lock);
@@ -114,12 +125,14 @@ static inline bool mmap_write_trylock(st
 static inline void mmap_write_unlock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_released(mm, true);
+	vma_end_write_all(mm);
 	up_write(&mm->mmap_lock);
 }
 
 static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
 	__mmap_lock_trace_acquire_returned(mm, false, true);
+	vma_end_write_all(mm);
 	downgrade_write(&mm->mmap_lock);
 }
 
--- a/include/linux/mm.h~mm-add-per-vma-lock-and-helper-functions-to-control-it
+++ a/include/linux/mm.h
@@ -624,6 +624,87 @@ struct vm_operations_struct {
 					  unsigned long addr);
 };
 
+#ifdef CONFIG_PER_VMA_LOCK
+static inline void vma_init_lock(struct vm_area_struct *vma)
+{
+	init_rwsem(&vma->lock);
+	vma->vm_lock_seq = -1;
+}
+
+/*
+ * Try to read-lock a vma. The function is allowed to occasionally yield false
+ * locked result to avoid performance overhead, in which case we fall back to
+ * using mmap_lock. The function should never yield false unlocked result.
+ */
+static inline bool vma_start_read(struct vm_area_struct *vma)
+{
+	/* Check before locking. A race might cause false locked result. */
+	if (vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq))
+		return false;
+
+	if (unlikely(down_read_trylock(&vma->lock) == 0))
+		return false;
+
+	/*
+	 * Overflow might produce false locked result.
+	 * False unlocked result is impossible because we modify and check
+	 * vma->vm_lock_seq under vma->lock protection and mm->mm_lock_seq
+	 * modification invalidates all existing locks.
+	 */
+	if (unlikely(vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq))) {
+		up_read(&vma->lock);
+		return false;
+	}
+	return true;
+}
+
+static inline void vma_end_read(struct vm_area_struct *vma)
+{
+	rcu_read_lock(); /* keeps vma alive till the end of up_read */
+	up_read(&vma->lock);
+	rcu_read_unlock();
+}
+
+static inline void vma_start_write(struct vm_area_struct *vma)
+{
+	int mm_lock_seq;
+
+	mmap_assert_write_locked(vma->vm_mm);
+
+	/*
+	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
+	 * mm->mm_lock_seq can't be concurrently modified.
+	 */
+	mm_lock_seq = READ_ONCE(vma->vm_mm->mm_lock_seq);
+	if (vma->vm_lock_seq == mm_lock_seq)
+		return;
+
+	down_write(&vma->lock);
+	vma->vm_lock_seq = mm_lock_seq;
+	up_write(&vma->lock);
+}
+
+static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	/*
+	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
+	 * mm->mm_lock_seq can't be concurrently modified.
+	 */
+	VM_BUG_ON_VMA(vma->vm_lock_seq != READ_ONCE(vma->vm_mm->mm_lock_seq), vma);
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static inline void vma_init_lock(struct vm_area_struct *vma) {}
+static inline bool vma_start_read(struct vm_area_struct *vma)
+		{ return false; }
+static inline void vma_end_read(struct vm_area_struct *vma) {}
+static inline void vma_start_write(struct vm_area_struct *vma) {}
+static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	static const struct vm_operations_struct dummy_vm_ops = {};
@@ -632,6 +713,7 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+	vma_init_lock(vma);
 }
 
 /* Use when VMA is not part of the VMA tree and needs no locking */
--- a/include/linux/mm_types.h~mm-add-per-vma-lock-and-helper-functions-to-control-it
+++ a/include/linux/mm_types.h
@@ -503,6 +503,11 @@ struct vm_area_struct {
 		vm_flags_t __private __vm_flags;
 	};
 
+#ifdef CONFIG_PER_VMA_LOCK
+	int vm_lock_seq;
+	struct rw_semaphore lock;
+#endif
+
 	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
@@ -639,6 +644,9 @@ struct mm_struct {
 					  * init_mm.mmlist, and are protected
 					  * by mmlist_lock
 					  */
+#ifdef CONFIG_PER_VMA_LOCK
+		int mm_lock_seq;
+#endif
 
 
 		unsigned long hiwater_rss; /* High-watermark of RSS usage */
--- a/kernel/fork.c~mm-add-per-vma-lock-and-helper-functions-to-control-it
+++ a/kernel/fork.c
@@ -474,6 +474,7 @@ struct vm_area_struct *vm_area_dup(struc
 		 */
 		data_race(memcpy(new, orig, sizeof(*new)));
 		INIT_LIST_HEAD(&new->anon_vma_chain);
+		vma_init_lock(new);
 		dup_anon_vma_name(orig, new);
 	}
 	return new;
@@ -1208,6 +1209,9 @@ static struct mm_struct *mm_init(struct
 	seqcount_init(&mm->write_protect_seq);
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
+#ifdef CONFIG_PER_VMA_LOCK
+	mm->mm_lock_seq = 0;
+#endif
 	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
--- a/mm/init-mm.c~mm-add-per-vma-lock-and-helper-functions-to-control-it
+++ a/mm/init-mm.c
@@ -37,6 +37,9 @@ struct mm_struct init_mm = {
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
 	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
+#ifdef CONFIG_PER_VMA_LOCK
+	.mm_lock_seq	= 0,
+#endif
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
 #ifdef CONFIG_IOMMU_SVA
_

Patches currently in -mm which might be from surenb@google.com are


