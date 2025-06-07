Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAE3EEDE
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749338079; cv=none; b=G+JLHc/svU3hqOWRbhGFp6tvWpzxSwPdwHUKOVyB26HC5BNgDbjY7euqanZNaRlOfJol2eLJ+nNl/LJE0f9kwv2efC2F7qRyYdRf19ACjSdGOAlCzOK68PR/fjfcefClvAI6fgCT/nDhRf3DypxIMtQIpItMQojxHZHzX/gfiQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749338079; c=relaxed/simple;
	bh=GpxDgfJf1Q0Gd8dMqEZiwi1HMr+qR9NOgUv24P+26FM=;
	h=Date:To:From:Subject:Message-Id; b=lVLop4P1U1GwhNEprJdQbBjsnR/ytxRN1JHjvCWEVJTrxDv9BZ5Jk0Yp8PQSgnMHSHUf9yKfe1j362xGPPTyqmwU97siaZLjK3/2jNRdXiYyihQRJ0eH+RfIRhvX/TruKrO6d5L9hltPs6yVSWtV8yyfHb3porXSYUTWKvCx8vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=usSZaq36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="usSZaq36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9171FC4CEE4;
	Sat,  7 Jun 2025 23:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749338078;
	bh=GpxDgfJf1Q0Gd8dMqEZiwi1HMr+qR9NOgUv24P+26FM=;
	h=Date:To:From:Subject:From;
	b=usSZaq36zJoKcOpVIzjxB70ltSzzTYR+fCsOKj6eDxp17kWESxTbBAt2wLwzuxGeX
	 6gFAMYtNPXJzcbBiqWmhogp/JgIqA871mrUSRofsAA+8Dz/gWEtRUlk8G5ktCyX37w
	 gFdsuB0XJKyqwVxmDzG4Bht+voHKEtdcX64jRQQE=
Date: Sat, 07 Jun 2025 16:14:37 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,surenb@google.com,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,david@redhat.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-per_vma-lock-for-madv_dontneed.patch added to mm-new branch
Message-Id: <20250607231438.9171FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use per_vma lock for MADV_DONTNEED
has been added to the -mm mm-new branch.  Its filename is
     mm-use-per_vma-lock-for-madv_dontneed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-per_vma-lock-for-madv_dontneed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: use per_vma lock for MADV_DONTNEED
Date: Sun, 8 Jun 2025 10:01:50 +1200

Certain madvise operations, especially MADV_DONTNEED, occur far more
frequently than other madvise options, particularly in native and Java
heaps for dynamic memory management.

Currently, the mmap_lock is always held during these operations, even when
unnecessary.  This causes lock contention and can lead to severe priority
inversion, where low-priority threads—such as Android's
HeapTaskDaemon— hold the lock and block higher-priority threads.

This patch enables the use of per-VMA locks when the advised range lies
entirely within a single VMA, avoiding the need for full VMA traversal. 
In practice, userspace heaps rarely issue MADV_DONTNEED across multiple
VMAs.

Tangquan's testing shows that over 99.5% of memory reclaimed by Android
benefits from this per-VMA lock optimization.  After extended runtime,
217,735 madvise calls from HeapTaskDaemon used the per-VMA path, while
only 1,231 fell back to mmap_lock.

To simplify handling, the implementation falls back to the standard
mmap_lock if userfaultfd is enabled on the VMA, avoiding the complexity of
userfaultfd_remove().

Many thanks to Lorenzo's work[1] on "mm/madvise: support VMA read locks
for MADV_DONTNEED[_LOCKED]"

Then use this mechanism to permit VMA locking to be done later in the
madvise() logic and also to allow altering of the locking mode to permit
falling back to an mmap read lock if required."

One important point, as pointed out by Jann[2], is that
untagged_addr_remote() requires holding mmap_lock.  This is because
address tagging on x86 and RISC-V is quite complex.

Until untagged_addr_remote() becomes atomic—which seems unlikely in the
near future—we cannot support per-VMA locks for remote processes.  So
for now, only local processes are supported.

Link: https://lore.kernel.org/all/0b96ce61-a52c-4036-b5b6-5c50783db51f@lucifer.local/ [1]
Link: https://lore.kernel.org/all/CAG48ez11zi-1jicHUZtLhyoNPGGVB+ROeAJCUw48bsjk4bbEkA@mail.gmail.com/ [2]
Link: https://lkml.kernel.org/r/20250607220150.2980-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |  195 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 147 insertions(+), 48 deletions(-)

--- a/mm/madvise.c~mm-use-per_vma-lock-for-madv_dontneed
+++ a/mm/madvise.c
@@ -48,38 +48,19 @@ struct madvise_walk_private {
 	bool pageout;
 };
 
+enum madvise_lock_mode {
+	MADVISE_NO_LOCK,
+	MADVISE_MMAP_READ_LOCK,
+	MADVISE_MMAP_WRITE_LOCK,
+	MADVISE_VMA_READ_LOCK,
+};
+
 struct madvise_behavior {
 	int behavior;
 	struct mmu_gather *tlb;
+	enum madvise_lock_mode lock_mode;
 };
 
-/*
- * Any behaviour which results in changes to the vma->vm_flags needs to
- * take mmap_lock for writing. Others, which simply traverse vmas, need
- * to only take it for reading.
- */
-static int madvise_need_mmap_write(int behavior)
-{
-	switch (behavior) {
-	case MADV_REMOVE:
-	case MADV_WILLNEED:
-	case MADV_DONTNEED:
-	case MADV_DONTNEED_LOCKED:
-	case MADV_COLD:
-	case MADV_PAGEOUT:
-	case MADV_FREE:
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
-	case MADV_COLLAPSE:
-	case MADV_GUARD_INSTALL:
-	case MADV_GUARD_REMOVE:
-		return 0;
-	default:
-		/* be safe, default to 1. list exceptions explicitly */
-		return 1;
-	}
-}
-
 #ifdef CONFIG_ANON_VMA_NAME
 struct anon_vma_name *anon_vma_name_alloc(const char *name)
 {
@@ -1489,6 +1470,44 @@ static bool process_madvise_remote_valid
 }
 
 /*
+ * Try to acquire a VMA read lock if possible.
+ *
+ * We only support this lock over a single VMA, which the input range must
+ * span either partially or fully.
+ *
+ * This function always returns with an appropriate lock held. If a VMA read
+ * lock could be acquired, we return the locked VMA.
+ *
+ * If a VMA read lock could not be acquired, we return NULL and expect caller to
+ * fallback to mmap lock behaviour.
+ */
+static struct vm_area_struct *try_vma_read_lock(struct mm_struct *mm,
+		struct madvise_behavior *madv_behavior,
+		unsigned long start, unsigned long end)
+{
+	struct vm_area_struct *vma;
+
+	vma = lock_vma_under_rcu(mm, start);
+	if (!vma)
+		goto take_mmap_read_lock;
+	/*
+	 * Must span only a single VMA; uffd and remote processes are
+	 * unsupported.
+	 */
+	if (end > vma->vm_end || current->mm != mm ||
+	    userfaultfd_armed(vma)) {
+		vma_end_read(vma);
+		goto take_mmap_read_lock;
+	}
+	return vma;
+
+take_mmap_read_lock:
+	mmap_read_lock(mm);
+	madv_behavior->lock_mode = MADVISE_MMAP_READ_LOCK;
+	return NULL;
+}
+
+/*
  * Walk the vmas in range [start,end), and call the visit function on each one.
  * The visit function will get start and end parameters that cover the overlap
  * between the current vma and the original range.  Any unmapped regions in the
@@ -1498,7 +1517,8 @@ static bool process_madvise_remote_valid
  */
 static
 int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
-		      unsigned long end, void *arg,
+		      unsigned long end, struct madvise_behavior *madv_behavior,
+		      void *arg,
 		      int (*visit)(struct vm_area_struct *vma,
 				   struct vm_area_struct **prev, unsigned long start,
 				   unsigned long end, void *arg))
@@ -1507,6 +1527,20 @@ int madvise_walk_vmas(struct mm_struct *
 	struct vm_area_struct *prev;
 	unsigned long tmp;
 	int unmapped_error = 0;
+	int error;
+
+	/*
+	 * If VMA read lock is supported, apply madvise to a single VMA
+	 * tentatively, avoiding walking VMAs.
+	 */
+	if (madv_behavior && madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
+		vma = try_vma_read_lock(mm, madv_behavior, start, end);
+		if (vma) {
+			error = visit(vma, &prev, start, end, arg);
+			vma_end_read(vma);
+			return error;
+		}
+	}
 
 	/*
 	 * If the interval [start,end) covers some unmapped address
@@ -1518,8 +1552,6 @@ int madvise_walk_vmas(struct mm_struct *
 		prev = vma;
 
 	for (;;) {
-		int error;
-
 		/* Still start < end. */
 		if (!vma)
 			return -ENOMEM;
@@ -1600,34 +1632,86 @@ int madvise_set_anon_name(struct mm_stru
 	if (end == start)
 		return 0;
 
-	return madvise_walk_vmas(mm, start, end, anon_name,
+	return madvise_walk_vmas(mm, start, end, NULL, anon_name,
 				 madvise_vma_anon_name);
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 
-static int madvise_lock(struct mm_struct *mm, int behavior)
+
+/*
+ * Any behaviour which results in changes to the vma->vm_flags needs to
+ * take mmap_lock for writing. Others, which simply traverse vmas, need
+ * to only take it for reading.
+ */
+static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
 {
+	int behavior = madv_behavior->behavior;
+
 	if (is_memory_failure(behavior))
-		return 0;
+		return MADVISE_NO_LOCK;
 
-	if (madvise_need_mmap_write(behavior)) {
+	switch (behavior) {
+	case MADV_REMOVE:
+	case MADV_WILLNEED:
+	case MADV_COLD:
+	case MADV_PAGEOUT:
+	case MADV_FREE:
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+	case MADV_COLLAPSE:
+	case MADV_GUARD_INSTALL:
+	case MADV_GUARD_REMOVE:
+		return MADVISE_MMAP_READ_LOCK;
+	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
+		return MADVISE_VMA_READ_LOCK;
+	default:
+		return MADVISE_MMAP_WRITE_LOCK;
+	}
+}
+
+static int madvise_lock(struct mm_struct *mm,
+		struct madvise_behavior *madv_behavior)
+{
+	enum madvise_lock_mode lock_mode = get_lock_mode(madv_behavior);
+
+	switch (lock_mode) {
+	case MADVISE_NO_LOCK:
+		break;
+	case MADVISE_MMAP_WRITE_LOCK:
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
-	} else {
+		break;
+	case MADVISE_MMAP_READ_LOCK:
 		mmap_read_lock(mm);
+		break;
+	case MADVISE_VMA_READ_LOCK:
+		/* We will acquire the lock per-VMA in madvise_walk_vmas(). */
+		break;
 	}
+
+	madv_behavior->lock_mode = lock_mode;
 	return 0;
 }
 
-static void madvise_unlock(struct mm_struct *mm, int behavior)
+static void madvise_unlock(struct mm_struct *mm,
+		struct madvise_behavior *madv_behavior)
 {
-	if (is_memory_failure(behavior))
+	switch (madv_behavior->lock_mode) {
+	case  MADVISE_NO_LOCK:
 		return;
-
-	if (madvise_need_mmap_write(behavior))
+	case MADVISE_MMAP_WRITE_LOCK:
 		mmap_write_unlock(mm);
-	else
+		break;
+	case MADVISE_MMAP_READ_LOCK:
 		mmap_read_unlock(mm);
+		break;
+	case MADVISE_VMA_READ_LOCK:
+		/* We will drop the lock per-VMA in madvise_walk_vmas(). */
+		break;
+	}
+
+	madv_behavior->lock_mode = MADVISE_NO_LOCK;
 }
 
 static bool madvise_batch_tlb_flush(int behavior)
@@ -1712,6 +1796,21 @@ static bool is_madvise_populate(int beha
 	}
 }
 
+/*
+ * untagged_addr_remote() assumes mmap_lock is already held. On
+ * architectures like x86 and RISC-V, tagging is tricky because each
+ * mm may have a different tagging mask. However, we might only hold
+ * the per-VMA lock (currently only local processes are supported),
+ * so untagged_addr is used to avoid the mmap_lock assertion for
+ * local processes.
+ */
+static inline unsigned long get_untagged_addr(struct mm_struct *mm,
+		unsigned long start)
+{
+	return current->mm == mm ? untagged_addr(start) :
+				   untagged_addr_remote(mm, start);
+}
+
 static int madvise_do_behavior(struct mm_struct *mm,
 		unsigned long start, size_t len_in,
 		struct madvise_behavior *madv_behavior)
@@ -1723,7 +1822,7 @@ static int madvise_do_behavior(struct mm
 
 	if (is_memory_failure(behavior))
 		return madvise_inject_error(behavior, start, start + len_in);
-	start = untagged_addr_remote(mm, start);
+	start = get_untagged_addr(mm, start);
 	end = start + PAGE_ALIGN(len_in);
 
 	blk_start_plug(&plug);
@@ -1731,7 +1830,7 @@ static int madvise_do_behavior(struct mm
 		error = madvise_populate(mm, start, end, behavior);
 	else
 		error = madvise_walk_vmas(mm, start, end, madv_behavior,
-					  madvise_vma_behavior);
+				madv_behavior, madvise_vma_behavior);
 	blk_finish_plug(&plug);
 	return error;
 }
@@ -1819,13 +1918,13 @@ int do_madvise(struct mm_struct *mm, uns
 
 	if (madvise_should_skip(start, len_in, behavior, &error))
 		return error;
-	error = madvise_lock(mm, behavior);
+	error = madvise_lock(mm, &madv_behavior);
 	if (error)
 		return error;
 	madvise_init_tlb(&madv_behavior, mm);
 	error = madvise_do_behavior(mm, start, len_in, &madv_behavior);
 	madvise_finish_tlb(&madv_behavior);
-	madvise_unlock(mm, behavior);
+	madvise_unlock(mm, &madv_behavior);
 
 	return error;
 }
@@ -1849,7 +1948,7 @@ static ssize_t vector_madvise(struct mm_
 
 	total_len = iov_iter_count(iter);
 
-	ret = madvise_lock(mm, behavior);
+	ret = madvise_lock(mm, &madv_behavior);
 	if (ret)
 		return ret;
 	madvise_init_tlb(&madv_behavior, mm);
@@ -1882,8 +1981,8 @@ static ssize_t vector_madvise(struct mm_
 
 			/* Drop and reacquire lock to unwind race. */
 			madvise_finish_tlb(&madv_behavior);
-			madvise_unlock(mm, behavior);
-			ret = madvise_lock(mm, behavior);
+			madvise_unlock(mm, &madv_behavior);
+			ret = madvise_lock(mm, &madv_behavior);
 			if (ret)
 				goto out;
 			madvise_init_tlb(&madv_behavior, mm);
@@ -1894,7 +1993,7 @@ static ssize_t vector_madvise(struct mm_
 		iov_iter_advance(iter, iter_iov_len(iter));
 	}
 	madvise_finish_tlb(&madv_behavior);
-	madvise_unlock(mm, behavior);
+	madvise_unlock(mm, &madv_behavior);
 
 out:
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch
mm-use-per_vma-lock-for-madv_dontneed.patch

