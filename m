Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13850285
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733035475; cv=none; b=RqxIWXOVsA8Gl6PtszjP88NOxiJP5pQrqaC26TEUzloPhaSHxfK2r221M2qMutkNrjsDN3na+Mm4I+LdZBUjJLhbBHM9rNu4SQhEruERUfYJhiAAi6VoWkSnvr6MWwXNQabrSl9mBGwLfKsFFKMO5xFTPJryVn+Zld1AyQyTagY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733035475; c=relaxed/simple;
	bh=RfaM3eIV3He6Ruan02wjKHVMV+z1+RtbtraLsa4pAAM=;
	h=Date:To:From:Subject:Message-Id; b=doyBQ2WK0eOYZfhphsEHQnVefQqys0RJtc0Hqu/HM1SLipJTNCLkW+gCSrsU74hBEbbOkbzf86zd0Ep/QPUb2g0qx+ZPA7l6ByEDc1WirgPqnXzpneaoiwuihZH0qqUm3+zsN5HytLwnnSKp52qc/jjo1FIJWQ1J2345MSIDpQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yx5SoEw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yx5SoEw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC4FC4CECF;
	Sun,  1 Dec 2024 06:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733035474;
	bh=RfaM3eIV3He6Ruan02wjKHVMV+z1+RtbtraLsa4pAAM=;
	h=Date:To:From:Subject:From;
	b=Yx5SoEw+f+wN5aIIKJ0HYPlNmiiN/Mn2kKIcQDvxVHEVZ/neUQndD/SiTXiYw+eJl
	 RXDEt4yAP2gw9lnv0OyrUnWedJTlP+wZA+SxlSg8XSc2cVUdG0b1W3KSTS0L1FZjlE
	 AuRmXFtaWjtYNcWrnaHwuQW+tCVmAw2i29nUbR5Y=
Date: Sat, 30 Nov 2024 22:44:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,oleg@redhat.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,Liam.Howlett@Oracle.com,jannh@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,david@redhat.com,brauner@kernel.org,arnd@arndb.de,andrii@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-convert-mm_lock_seq-to-a-proper-seqcount.patch removed from -mm tree
Message-Id: <20241201064434.8AC4FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert mm_lock_seq to a proper seqcount
has been removed from the -mm tree.  Its filename was
     mm-convert-mm_lock_seq-to-a-proper-seqcount.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: convert mm_lock_seq to a proper seqcount
Date: Thu, 24 Oct 2024 13:52:30 -0700

Convert mm_lock_seq to be seqcount_t and change all mmap_write_lock
variants to increment it, in-line with the usual seqcount usage pattern.
This lets us check whether the mmap_lock is write-locked by checking
mm_lock_seq.sequence counter (odd=locked, even=unlocked). This will be
used when implementing mmap_lock speculation functions.
As a result vm_lock_seq is also change to be unsigned to match the type
of mm_lock_seq.sequence.

Link: https://lkml.kernel.org/r/20241024205231.1944747-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: <hca@linux.ibm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h               |   12 +++---
 include/linux/mm_types.h         |    7 ++-
 include/linux/mmap_lock.h        |   58 +++++++++++++++++++----------
 kernel/fork.c                    |    5 --
 mm/init-mm.c                     |    2 -
 tools/testing/vma/vma.c          |    4 +-
 tools/testing/vma/vma_internal.h |    4 +-
 7 files changed, 56 insertions(+), 36 deletions(-)

--- a/include/linux/mmap_lock.h~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/include/linux/mmap_lock.h
@@ -71,39 +71,38 @@ static inline void mmap_assert_write_loc
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
-/*
- * Drop all currently-held per-VMA locks.
- * This is called from the mmap_lock implementation directly before releasing
- * a write-locked mmap_lock (or downgrading it to read-locked).
- * This should normally NOT be called manually from other places.
- * If you want to call this manually anyway, keep in mind that this will release
- * *all* VMA write locks, including ones from further up the stack.
- */
-static inline void vma_end_write_all(struct mm_struct *mm)
+static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
-	mmap_assert_write_locked(mm);
-	/*
-	 * Nobody can concurrently modify mm->mm_lock_seq due to exclusive
-	 * mmap_lock being held.
-	 * We need RELEASE semantics here to ensure that preceding stores into
-	 * the VMA take effect before we unlock it with this store.
-	 * Pairs with ACQUIRE semantics in vma_start_read().
-	 */
-	smp_store_release(&mm->mm_lock_seq, mm->mm_lock_seq + 1);
+	seqcount_init(&mm->mm_lock_seq);
+}
+
+static inline void mm_lock_seqcount_begin(struct mm_struct *mm)
+{
+	do_raw_write_seqcount_begin(&mm->mm_lock_seq);
+}
+
+static inline void mm_lock_seqcount_end(struct mm_struct *mm)
+{
+	do_raw_write_seqcount_end(&mm->mm_lock_seq);
 }
+
 #else
-static inline void vma_end_write_all(struct mm_struct *mm) {}
+static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
+static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
+static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
 #endif
 
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
 	init_rwsem(&mm->mmap_lock);
+	mm_lock_seqcount_init(mm);
 }
 
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write(&mm->mmap_lock);
+	mm_lock_seqcount_begin(mm);
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
@@ -111,6 +110,7 @@ static inline void mmap_write_lock_neste
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write_nested(&mm->mmap_lock, subclass);
+	mm_lock_seqcount_begin(mm);
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
@@ -120,10 +120,30 @@ static inline int mmap_write_lock_killab
 
 	__mmap_lock_trace_start_locking(mm, true);
 	ret = down_write_killable(&mm->mmap_lock);
+	if (!ret)
+		mm_lock_seqcount_begin(mm);
 	__mmap_lock_trace_acquire_returned(mm, true, ret == 0);
 	return ret;
 }
 
+/*
+ * Drop all currently-held per-VMA locks.
+ * This is called from the mmap_lock implementation directly before releasing
+ * a write-locked mmap_lock (or downgrading it to read-locked).
+ * This should normally NOT be called manually from other places.
+ * If you want to call this manually anyway, keep in mind that this will release
+ * *all* VMA write locks, including ones from further up the stack.
+ */
+static inline void vma_end_write_all(struct mm_struct *mm)
+{
+	mmap_assert_write_locked(mm);
+	/*
+	 * Nobody can concurrently modify mm->mm_lock_seq due to exclusive
+	 * mmap_lock being held.
+	 */
+	mm_lock_seqcount_end(mm);
+}
+
 static inline void mmap_write_unlock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_released(mm, true);
--- a/include/linux/mm.h~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/include/linux/mm.h
@@ -710,7 +710,7 @@ static inline bool vma_start_read(struct
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq))
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq.sequence))
 		return false;
 
 	if (unlikely(down_read_trylock(&vma->vm_lock->lock) == 0))
@@ -727,7 +727,7 @@ static inline bool vma_start_read(struct
 	 * after it has been unlocked.
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == smp_load_acquire(&vma->vm_mm->mm_lock_seq))) {
+	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&vma->vm_mm->mm_lock_seq))) {
 		up_read(&vma->vm_lock->lock);
 		return false;
 	}
@@ -742,7 +742,7 @@ static inline void vma_end_read(struct v
 }
 
 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
+static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -750,7 +750,7 @@ static bool __is_vma_write_locked(struct
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	*mm_lock_seq = vma->vm_mm->mm_lock_seq;
+	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
@@ -761,7 +761,7 @@ static bool __is_vma_write_locked(struct
  */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
+	unsigned int mm_lock_seq;
 
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
@@ -779,7 +779,7 @@ static inline void vma_start_write(struc
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
+	unsigned int mm_lock_seq;
 
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
--- a/include/linux/mm_types.h~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/include/linux/mm_types.h
@@ -697,7 +697,7 @@ struct vm_area_struct {
 	 * counter reuse can only lead to occasional unnecessary use of the
 	 * slowpath.
 	 */
-	int vm_lock_seq;
+	unsigned int vm_lock_seq;
 	/* Unstable RCU readers are allowed to read this. */
 	struct vma_lock *vm_lock;
 #endif
@@ -891,6 +891,9 @@ struct mm_struct {
 		 * Roughly speaking, incrementing the sequence number is
 		 * equivalent to releasing locks on VMAs; reading the sequence
 		 * number can be part of taking a read lock on a VMA.
+		 * Incremented every time mmap_lock is write-locked/unlocked.
+		 * Initialized to 0, therefore odd values indicate mmap_lock
+		 * is write-locked and even values that it's released.
 		 *
 		 * Can be modified under write mmap_lock using RELEASE
 		 * semantics.
@@ -899,7 +902,7 @@ struct mm_struct {
 		 * Can be read with ACQUIRE semantics if not holding write
 		 * mmap_lock.
 		 */
-		int mm_lock_seq;
+		seqcount_t mm_lock_seq;
 #endif
 
 
--- a/kernel/fork.c~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/kernel/fork.c
@@ -448,7 +448,7 @@ static bool vma_lock_alloc(struct vm_are
 		return false;
 
 	init_rwsem(&vma->vm_lock->lock);
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	return true;
 }
@@ -1267,9 +1267,6 @@ static struct mm_struct *mm_init(struct
 	seqcount_init(&mm->write_protect_seq);
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
-#ifdef CONFIG_PER_VMA_LOCK
-	mm->mm_lock_seq = 0;
-#endif
 	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
--- a/mm/init-mm.c~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/mm/init-mm.c
@@ -40,7 +40,7 @@ struct mm_struct init_mm = {
 	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
 #ifdef CONFIG_PER_VMA_LOCK
-	.mm_lock_seq	= 0,
+	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
--- a/tools/testing/vma/vma.c~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/tools/testing/vma/vma.c
@@ -89,7 +89,7 @@ static struct vm_area_struct *alloc_and_
 	 * begun. Linking to the tree will have caused this to be incremented,
 	 * which means we will get a false positive otherwise.
 	 */
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	return vma;
 }
@@ -214,7 +214,7 @@ static bool vma_write_started(struct vm_
 	int seq = vma->vm_lock_seq;
 
 	/* We reset after each check. */
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	/* The vma_start_write() stub simply increments this value. */
 	return seq > -1;
--- a/tools/testing/vma/vma_internal.h~mm-convert-mm_lock_seq-to-a-proper-seqcount
+++ a/tools/testing/vma/vma_internal.h
@@ -241,7 +241,7 @@ struct vm_area_struct {
 	 * counter reuse can only lead to occasional unnecessary use of the
 	 * slowpath.
 	 */
-	int vm_lock_seq;
+	unsigned int vm_lock_seq;
 	struct vma_lock *vm_lock;
 #endif
 
@@ -416,7 +416,7 @@ static inline bool vma_lock_alloc(struct
 		return false;
 
 	init_rwsem(&vma->vm_lock->lock);
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	return true;
 }
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-fix-module-allocation-tags-populated-area-calculation.patch
alloc_tag-fix-set_codetag_empty-when-config_mem_alloc_profiling_debug.patch
mm-introduce-mmap_lock_speculation_beginend.patch

