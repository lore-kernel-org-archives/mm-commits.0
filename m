Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528817406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423515; cv=none; b=EkEkwtdZqqOfJJ7AXncsGRqTgSfzBlv5XkNcE8PVMKNaD/FEod/GRiP31542j9qwhHodMS2vQWBLRddrzUz5cho8RJxtEq/FTqmbCliVWtWo/y06yHLZVmNc+Py4XX1v+7g1MZBrFCCszeU/4XTp7akLkwZhNzEf62uFZkFFgSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423515; c=relaxed/simple;
	bh=8KhNk1QLgNNAyBNxwt9s2N0aWNS7dixrDZFzPqnPeK8=;
	h=Date:To:From:Subject:Message-Id; b=oiZJyDfi7A8/0+G9RmYGIAQku6eGNiGUHl5NzESuDcVKLWOmI8v7eCCwB0P01ZaPNBtGDmWasQKHfzlJkISRbtZn/8y52jdqC/N/puSXekbQQzuOm7HMP97fxU6cHLuur/lGr4Y5uffWlrj42sf3SfQuo1QR3rTG9/Ga6HOhGa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JjfIJKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JjfIJKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26048C4CEC2;
	Wed,  4 Sep 2024 04:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423515;
	bh=8KhNk1QLgNNAyBNxwt9s2N0aWNS7dixrDZFzPqnPeK8=;
	h=Date:To:From:Subject:From;
	b=2JjfIJKEDwmZMHEWeKMcqWNyai+Odk6PnhwePPy1NDClf0OQgKshcMfHn4GSMrJ1S
	 g/PaVmJg0isKdp+Ffqq49qEcRjFrhCjlDdTXJzynGQ0leYCtHrw72GmY4c4llEu3cN
	 lt90sEFmRMrs1L2rnIqSNX43Fxk7nYFfRUXWEC8U=
Date: Tue, 03 Sep 2024 21:18:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-can_modify_mm.patch removed from -mm tree
Message-Id: <20240904041835.26048C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove can_modify_mm()
has been removed from the -mm tree.  Its filename was
     mm-remove-can_modify_mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm: remove can_modify_mm()
Date: Sat, 17 Aug 2024 01:18:33 +0100

With no more users in the tree, we can finally remove can_modify_mm().

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-6-d8d2e037df30@gmail.com
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

 mm/internal.h |   14 --------------
 mm/mseal.c    |   21 ---------------------
 2 files changed, 35 deletions(-)

--- a/mm/internal.h~mm-remove-can_modify_mm
+++ a/mm/internal.h
@@ -1359,25 +1359,11 @@ static inline int can_do_mseal(unsigned
 	return 0;
 }
 
-bool can_modify_mm(struct mm_struct *mm, unsigned long start,
-		unsigned long end);
 #else
 static inline int can_do_mseal(unsigned long flags)
 {
 	return -EPERM;
 }
-
-static inline bool can_modify_mm(struct mm_struct *mm, unsigned long start,
-		unsigned long end)
-{
-	return true;
-}
-
-static inline bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start,
-		unsigned long end, int behavior)
-{
-	return true;
-}
 #endif
 
 #ifdef CONFIG_SHRINKER_DEBUG
--- a/mm/mseal.c~mm-remove-can_modify_mm
+++ a/mm/mseal.c
@@ -54,27 +54,6 @@ static bool is_ro_anon(struct vm_area_st
 }
 
 /*
- * Check if the vmas of a memory range are allowed to be modified.
- * the memory ranger can have a gap (unallocated memory).
- * return true, if it is allowed.
- */
-bool can_modify_mm(struct mm_struct *mm, unsigned long start, unsigned long end)
-{
-	struct vm_area_struct *vma;
-
-	VMA_ITERATOR(vmi, mm, start);
-
-	/* going through each vma to check. */
-	for_each_vma_range(vmi, vma, end) {
-		if (unlikely(!can_modify_vma(vma)))
-			return false;
-	}
-
-	/* Allow by default. */
-	return true;
-}
-
-/*
  * Check if a vma is allowed to be modified by madvise.
  */
 bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are


