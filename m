Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5C36AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423514; cv=none; b=LOl5kK7467/bfm9ptC7CcOnPCCzFPIPkZb8uODTPmro22tA/E2hHd4VI5kDGWV1elW3zBrgbDbCvJgkmL+p2g0+W7jxHYvMiRc5XgT0zhNybxv5AE3BKKSEppiOiDvx3CF4nA66QGN9EIoeI0IXeteedJ3ghzFaBa6K4BgnKdLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423514; c=relaxed/simple;
	bh=K5QQSThlXtyzxdlUdPTSpALW9i2RZm0GPatlvG5LuDc=;
	h=Date:To:From:Subject:Message-Id; b=r32p+9nUegubJ4opDQ/2wTFLVRFE7W+w/1PfBqOTgCqyU82aSF6nBUrXO2J/l8iDk9kuwAxnPGt4TjAJljCDP61Fc5h+dpjjiwb2zrb0MZ7Mb7gIjHN/IR1Vkn84X6urqeMZlwKO5fj5wIqKlZazOnQBW0XozYPpodMtSXm5kh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KFVD1eyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KFVD1eyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A0AC4CEC2;
	Wed,  4 Sep 2024 04:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423514;
	bh=K5QQSThlXtyzxdlUdPTSpALW9i2RZm0GPatlvG5LuDc=;
	h=Date:To:From:Subject:From;
	b=KFVD1eyBwUhq0xZVYcN6EVyZ6ARq1UONfEBbZxdyBFJ3thy/Cc8QEpRsW9OqD+IFV
	 qpMwmOMo0t426j89Guvo1IPI7YA/ZMUhj5kNRhokG/coYJIQ/tbVb21R7HP99ih5sZ
	 udK1w+rPDaO5ZVIwCmV9tJ76ugRozEAODHIFeQew=
Date: Tue, 03 Sep 2024 21:18:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch removed from -mm tree
Message-Id: <20240904041834.04A0AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal: replace can_modify_mm_madv with a vma variant
has been removed from the -mm tree.  Its filename was
     mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mseal: replace can_modify_mm_madv with a vma variant
Date: Sat, 17 Aug 2024 01:18:32 +0100

Replace can_modify_mm_madv() with a single vma variant, and associated
checks in madvise.

While we're at it, also invert the order of checks in:
 if (unlikely(is_ro_anon(vma) && !can_modify_vma(vma))

Checking if we can modify the vma itself (through vm_flags) is certainly
cheaper than is_ro_anon() due to arch_vma_access_permitted() looking at
e.g pkeys registers (with extra branches) in some architectures.

This patch allows for partial madvise success when finding a sealed VMA,
which historically has been allowed in Linux.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-5-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 --
 mm/madvise.c  |   13 +++----------
 mm/mseal.c    |   17 ++++-------------
 mm/vma.h      |    7 +++++++
 4 files changed, 14 insertions(+), 25 deletions(-)

--- a/mm/internal.h~mseal-replace-can_modify_mm_madv-with-a-vma-variant
+++ a/mm/internal.h
@@ -1361,8 +1361,6 @@ static inline int can_do_mseal(unsigned
 
 bool can_modify_mm(struct mm_struct *mm, unsigned long start,
 		unsigned long end);
-bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start,
-		unsigned long end, int behavior);
 #else
 static inline int can_do_mseal(unsigned long flags)
 {
--- a/mm/madvise.c~mseal-replace-can_modify_mm_madv-with-a-vma-variant
+++ a/mm/madvise.c
@@ -1031,6 +1031,9 @@ static int madvise_vma_behavior(struct v
 	struct anon_vma_name *anon_name;
 	unsigned long new_flags = vma->vm_flags;
 
+	if (unlikely(!can_modify_vma_madv(vma, behavior)))
+		return -EPERM;
+
 	switch (behavior) {
 	case MADV_REMOVE:
 		return madvise_remove(vma, prev, start, end);
@@ -1448,15 +1451,6 @@ int do_madvise(struct mm_struct *mm, uns
 	start = untagged_addr_remote(mm, start);
 	end = start + len;
 
-	/*
-	 * Check if the address range is sealed for do_madvise().
-	 * can_modify_mm_madv assumes we have acquired the lock on MM.
-	 */
-	if (unlikely(!can_modify_mm_madv(mm, start, end, behavior))) {
-		error = -EPERM;
-		goto out;
-	}
-
 	blk_start_plug(&plug);
 	switch (behavior) {
 	case MADV_POPULATE_READ:
@@ -1470,7 +1464,6 @@ int do_madvise(struct mm_struct *mm, uns
 	}
 	blk_finish_plug(&plug);
 
-out:
 	if (write)
 		mmap_write_unlock(mm);
 	else
--- a/mm/mseal.c~mseal-replace-can_modify_mm_madv-with-a-vma-variant
+++ a/mm/mseal.c
@@ -75,24 +75,15 @@ bool can_modify_mm(struct mm_struct *mm,
 }
 
 /*
- * Check if the vmas of a memory range are allowed to be modified by madvise.
- * the memory ranger can have a gap (unallocated memory).
- * return true, if it is allowed.
+ * Check if a vma is allowed to be modified by madvise.
  */
-bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start, unsigned long end,
-		int behavior)
+bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
 {
-	struct vm_area_struct *vma;
-
-	VMA_ITERATOR(vmi, mm, start);
-
 	if (!is_madv_discard(behavior))
 		return true;
 
-	/* going through each vma to check. */
-	for_each_vma_range(vmi, vma, end)
-		if (unlikely(is_ro_anon(vma) && !can_modify_vma(vma)))
-			return false;
+	if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
+		return false;
 
 	/* Allow by default. */
 	return true;
--- a/mm/vma.h~mseal-replace-can_modify_mm_madv-with-a-vma-variant
+++ a/mm/vma.h
@@ -380,12 +380,19 @@ static inline bool can_modify_vma(struct
 	return true;
 }
 
+bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior);
+
 #else
 
 static inline bool can_modify_vma(struct vm_area_struct *vma)
 {
 	return true;
 }
+
+static inline bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
+{
+	return true;
+}
 
 #endif
 
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are


