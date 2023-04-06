Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC09C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbjDFDFD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbjDFDEO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A8B9EC5
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7026064174
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B8AC433D2;
        Thu,  6 Apr 2023 03:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750240;
        bh=q5oVYClJ8CD/fS0NeYWG69KQ3sgRn6+KWjL17b6BPd4=;
        h=Date:To:From:Subject:From;
        b=ads5Qlp4zA0EUwTWNvsZ0lQD2NDYDwGeuNM8dk1VN7Ym2BP6Bpd073cZr3aqcMq42
         BgomzbI1NWoTdWtrRoCv71Y0Vhe7lUVdkFNouQ9b8MNJxFoUaYq7oWDF8uM5T2jLd2
         +suEgf4j/jPLO7iv889G7nzRJpKrZMeiTNStaMBs=
Date:   Wed, 05 Apr 2023 20:04:00 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-separate-vma-lock-from-vm_area_struct.patch removed from -mm tree
Message-Id: <20230406030400.C7B8AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: separate vma->lock from vm_area_struct
has been removed from the -mm tree.  Its filename was
     mm-separate-vma-lock-from-vm_area_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: separate vma->lock from vm_area_struct
Date: Mon, 27 Feb 2023 09:36:32 -0800

vma->lock being part of the vm_area_struct causes performance regression
during page faults because during contention its count and owner fields
are constantly updated and having other parts of vm_area_struct used
during page fault handling next to them causes constant cache line
bouncing.  Fix that by moving the lock outside of the vm_area_struct.

All attempts to keep vma->lock inside vm_area_struct in a separate cache
line still produce performance regression especially on NUMA machines. 
Smallest regression was achieved when lock is placed in the fourth cache
line but that bloats vm_area_struct to 256 bytes.

Considering performance and memory impact, separate lock looks like the
best option.  It increases memory footprint of each VMA but that can be
optimized later if the new size causes issues.  Note that after this
change vma_init() does not allocate or initialize vma->lock anymore.  A
number of drivers allocate a pseudo VMA on the stack but they never use
the VMA's lock, therefore it does not need to be allocated.  The future
drivers which might need the VMA lock should use
vm_area_alloc()/vm_area_free() to allocate the VMA.

Link: https://lkml.kernel.org/r/20230227173632.3292573-34-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   23 +++++------
 include/linux/mm_types.h |    6 ++-
 kernel/fork.c            |   73 +++++++++++++++++++++++++++++--------
 3 files changed, 74 insertions(+), 28 deletions(-)

--- a/include/linux/mm.h~mm-separate-vma-lock-from-vm_area_struct
+++ a/include/linux/mm.h
@@ -628,12 +628,6 @@ struct vm_operations_struct {
 };
 
 #ifdef CONFIG_PER_VMA_LOCK
-static inline void vma_init_lock(struct vm_area_struct *vma)
-{
-	init_rwsem(&vma->lock);
-	vma->vm_lock_seq = -1;
-}
-
 /*
  * Try to read-lock a vma. The function is allowed to occasionally yield false
  * locked result to avoid performance overhead, in which case we fall back to
@@ -645,17 +639,17 @@ static inline bool vma_start_read(struct
 	if (vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq))
 		return false;
 
-	if (unlikely(down_read_trylock(&vma->lock) == 0))
+	if (unlikely(down_read_trylock(&vma->vm_lock->lock) == 0))
 		return false;
 
 	/*
 	 * Overflow might produce false locked result.
 	 * False unlocked result is impossible because we modify and check
-	 * vma->vm_lock_seq under vma->lock protection and mm->mm_lock_seq
+	 * vma->vm_lock_seq under vma->vm_lock protection and mm->mm_lock_seq
 	 * modification invalidates all existing locks.
 	 */
 	if (unlikely(vma->vm_lock_seq == READ_ONCE(vma->vm_mm->mm_lock_seq))) {
-		up_read(&vma->lock);
+		up_read(&vma->vm_lock->lock);
 		return false;
 	}
 	return true;
@@ -664,7 +658,7 @@ static inline bool vma_start_read(struct
 static inline void vma_end_read(struct vm_area_struct *vma)
 {
 	rcu_read_lock(); /* keeps vma alive till the end of up_read */
-	up_read(&vma->lock);
+	up_read(&vma->vm_lock->lock);
 	rcu_read_unlock();
 }
 
@@ -687,9 +681,9 @@ static inline void vma_start_write(struc
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
 
-	down_write(&vma->lock);
+	down_write(&vma->vm_lock->lock);
 	vma->vm_lock_seq = mm_lock_seq;
-	up_write(&vma->lock);
+	up_write(&vma->vm_lock->lock);
 }
 
 static inline bool vma_try_start_write(struct vm_area_struct *vma)
@@ -740,6 +734,10 @@ static inline void vma_mark_detached(str
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+/*
+ * WARNING: vma_init does not initialize vma->vm_lock.
+ * Use vm_area_alloc()/vm_area_free() if vma needs locking.
+ */
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	static const struct vm_operations_struct dummy_vm_ops = {};
@@ -749,7 +747,6 @@ static inline void vma_init(struct vm_ar
 	vma->vm_ops = &dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma_mark_detached(vma, false);
-	vma_init_lock(vma);
 }
 
 /* Use when VMA is not part of the VMA tree and needs no locking */
--- a/include/linux/mm_types.h~mm-separate-vma-lock-from-vm_area_struct
+++ a/include/linux/mm_types.h
@@ -471,6 +471,10 @@ struct anon_vma_name {
 	char name[];
 };
 
+struct vma_lock {
+	struct rw_semaphore lock;
+};
+
 /*
  * This struct describes a virtual memory area. There is one of these
  * per VM-area/task. A VM area is any part of the process virtual memory
@@ -505,7 +509,7 @@ struct vm_area_struct {
 
 #ifdef CONFIG_PER_VMA_LOCK
 	int vm_lock_seq;
-	struct rw_semaphore lock;
+	struct vma_lock *vm_lock;
 
 	/* Flag to indicate areas detached from the mm->mm_mt tree */
 	bool detached;
--- a/kernel/fork.c~mm-separate-vma-lock-from-vm_area_struct
+++ a/kernel/fork.c
@@ -451,13 +451,49 @@ static struct kmem_cache *vm_area_cachep
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache *mm_cachep;
 
+#ifdef CONFIG_PER_VMA_LOCK
+
+/* SLAB cache for vm_area_struct.lock */
+static struct kmem_cache *vma_lock_cachep;
+
+static bool vma_lock_alloc(struct vm_area_struct *vma)
+{
+	vma->vm_lock = kmem_cache_alloc(vma_lock_cachep, GFP_KERNEL);
+	if (!vma->vm_lock)
+		return false;
+
+	init_rwsem(&vma->vm_lock->lock);
+	vma->vm_lock_seq = -1;
+
+	return true;
+}
+
+static inline void vma_lock_free(struct vm_area_struct *vma)
+{
+	kmem_cache_free(vma_lock_cachep, vma->vm_lock);
+}
+
+#else /* CONFIG_PER_VMA_LOCK */
+
+static inline bool vma_lock_alloc(struct vm_area_struct *vma) { return true; }
+static inline void vma_lock_free(struct vm_area_struct *vma) {}
+
+#endif /* CONFIG_PER_VMA_LOCK */
+
 struct vm_area_struct *vm_area_alloc(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 
 	vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
-	if (vma)
-		vma_init(vma, mm);
+	if (!vma)
+		return NULL;
+
+	vma_init(vma, mm);
+	if (!vma_lock_alloc(vma)) {
+		kmem_cache_free(vm_area_cachep, vma);
+		return NULL;
+	}
+
 	return vma;
 }
 
@@ -465,24 +501,30 @@ struct vm_area_struct *vm_area_dup(struc
 {
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 
-	if (new) {
-		ASSERT_EXCLUSIVE_WRITER(orig->vm_flags);
-		ASSERT_EXCLUSIVE_WRITER(orig->vm_file);
-		/*
-		 * orig->shared.rb may be modified concurrently, but the clone
-		 * will be reinitialized.
-		 */
-		data_race(memcpy(new, orig, sizeof(*new)));
-		INIT_LIST_HEAD(&new->anon_vma_chain);
-		vma_init_lock(new);
-		dup_anon_vma_name(orig, new);
+	if (!new)
+		return NULL;
+
+	ASSERT_EXCLUSIVE_WRITER(orig->vm_flags);
+	ASSERT_EXCLUSIVE_WRITER(orig->vm_file);
+	/*
+	 * orig->shared.rb may be modified concurrently, but the clone
+	 * will be reinitialized.
+	 */
+	data_race(memcpy(new, orig, sizeof(*new)));
+	if (!vma_lock_alloc(new)) {
+		kmem_cache_free(vm_area_cachep, new);
+		return NULL;
 	}
+	INIT_LIST_HEAD(&new->anon_vma_chain);
+	dup_anon_vma_name(orig, new);
+
 	return new;
 }
 
 void __vm_area_free(struct vm_area_struct *vma)
 {
 	free_anon_vma_name(vma);
+	vma_lock_free(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
@@ -493,7 +535,7 @@ static void vm_area_free_rcu_cb(struct r
 						  vm_rcu);
 
 	/* The vma should not be locked while being destroyed. */
-	VM_BUG_ON_VMA(rwsem_is_locked(&vma->lock), vma);
+	VM_BUG_ON_VMA(rwsem_is_locked(&vma->vm_lock->lock), vma);
 	__vm_area_free(vma);
 }
 #endif
@@ -3152,6 +3194,9 @@ void __init proc_caches_init(void)
 			NULL);
 
 	vm_area_cachep = KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
+#ifdef CONFIG_PER_VMA_LOCK
+	vma_lock_cachep = KMEM_CACHE(vma_lock, SLAB_PANIC|SLAB_ACCOUNT);
+#endif
 	mmap_init();
 	nsproxy_cache_init();
 }
_

Patches currently in -mm which might be from surenb@google.com are


