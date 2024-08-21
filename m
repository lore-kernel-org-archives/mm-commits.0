Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487C961FF6
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206083; cv=none; b=J5BfZ+gjmC3E9vFqaKsLEQY9zC8YFa6dqchieJYmD4OueF5IwBoXVxKKqHA1bxutSieZ2mCr9kOJASyyXsK5qm7f7Po1dkl8QB0WCdIgsX02fWk1TpxyZwtEzZfpZfq3LAlEoimH45h4oRHcLbeFGiXQVcGxUv8k/39uafnS40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206083; c=relaxed/simple;
	bh=15lF3dKg36wmVD/ceKAVhdzTTwr9fJFaU8YKnVpQdHg=;
	h=Date:To:From:Subject:Message-Id; b=CqvMKmLJharEEHGQGZA9y8pdnY3fSMyFDQwwzGKLvabTR5bAwG/wwa4Pb/GIVk6TuSOmj5x+McvAiSFUQrwE6IyiKhIyjQxWK7tNk1nxEsMmh6f3jlbzF72g01y5p+UzKmcrOvy/Pjo1Py6dt0zi9yRhBG/BfceU0Afb9yKToNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DWGj2n/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DWGj2n/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1201BC4AF17;
	Wed, 21 Aug 2024 02:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206083;
	bh=15lF3dKg36wmVD/ceKAVhdzTTwr9fJFaU8YKnVpQdHg=;
	h=Date:To:From:Subject:From;
	b=DWGj2n/8Sm8aCrNDu7nYxNYY1Vh1Kq068hpB7XEeTgeO+uodWrM+F/ybzd7eSRQnj
	 IwRGkl5nYN8tg7B4q6Y4aSwnzuuz2sshwjuEWRqRDqYYDK0j/4hvdFJp5Aje6LEVE9
	 gIcnTbjeWj4UkNJnbSdc4mRY6DARJbIDwSZv0AAI=
Date: Tue, 20 Aug 2024 19:08:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-can_modify_mm.patch added to mm-unstable branch
Message-Id: <20240821020803.1201BC4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove can_modify_mm()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-can_modify_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-can_modify_mm.patch

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
Subject: mm: remove can_modify_mm()
Date: Sat, 17 Aug 2024 01:18:33 +0100

With no more users in the tree, we can finally remove can_modify_mm().

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-6-d8d2e037df30@gmail.com
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

 mm/internal.h |   14 --------------
 mm/mseal.c    |   21 ---------------------
 2 files changed, 35 deletions(-)

--- a/mm/internal.h~mm-remove-can_modify_mm
+++ a/mm/internal.h
@@ -1368,25 +1368,11 @@ static inline int can_do_mseal(unsigned
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

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

