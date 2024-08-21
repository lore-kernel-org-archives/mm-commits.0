Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E5A53370
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206080; cv=none; b=dft9+P1HnFzmrC28R0VX/sm8jVGzminIw8RXdfu+jbWV0mNUVd6YKFsr0X68Btb3Ca6l9Z6ldlVNreJyzkqsUnHtm0MPdwo98T9E+VmRoQhJ9A8mZUNjyeFfbW7ufYjRrkcxJgH7nFtYkLWcH1TvKsCost8WbSNCqTrSWIbK2hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206080; c=relaxed/simple;
	bh=L/YUVY254sXv0b7gDPSmhH8/b7LZ2OJXsdCHQjZBL2U=;
	h=Date:To:From:Subject:Message-Id; b=AvTF9mDuyawFSA/IOy3N50Bx6hpSlpzW+iKJfgSkXdG1+ZqwoUj0ybyuYTwH4UQWTGaOE7AqzDC8FDgrll+OTk6OGp46ZbHlYLUQRdcdVsPSbADN3493lhtMb+sNO6IefaiRuj6YqHUPLnkn59RDRQgj7pkoTEa4J3S8OgneWls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BMDQ8iaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BMDQ8iaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B50C4AF17;
	Wed, 21 Aug 2024 02:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206080;
	bh=L/YUVY254sXv0b7gDPSmhH8/b7LZ2OJXsdCHQjZBL2U=;
	h=Date:To:From:Subject:From;
	b=BMDQ8iaYq4SEa263kpDHi0nE3gGpKN1lrkiCWbmBK+DAvsyni+ZmND5Quh8srwj2o
	 Z3ekS8nJ7kmd+y2X9yji8dMuS0x8X0+B672jnArF2OE/JauqrGkJlVoAV7gnB+1xml
	 JLXwcDpyVonr9FEAT1G1oqBMvB3sgtIIhN2lsRKk=
Date: Tue, 20 Aug 2024 19:07:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch added to mm-unstable branch
Message-Id: <20240821020800.12B50C4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal: replace can_modify_mm_madv with a vma variant
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
@@ -1370,8 +1370,6 @@ static inline int can_do_mseal(unsigned
 
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

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

