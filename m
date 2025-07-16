Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3DC28E611
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699687; cv=none; b=t9Aqycp5+HOs2O3e61OuCLvfJxCZxLst9sguoEn2b13Y/OZj24w4DviVMMHBGwWBRvDW7WSPACkOAybqihU9CtQqH/1qqqY2mfXO2qeJ4JMqu6rxCcyC1++6LXBUzR/ljzDzXGTu1fGZ1nQvL/LLfwyvcqW7PwrSSWkLDSI8glw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699687; c=relaxed/simple;
	bh=5dGsG7b5HvrezLMs3tfSKA5SfK1ApezYp20DevyRBeE=;
	h=Date:To:From:Subject:Message-Id; b=Ca9qZBta2lNq5gcx8HD1gnqFNhXp4zRpDULO106b9/89D3fMvwIwx25nBiibEKlgs3vyqiNsrJbcJdcaSbHs1kc4M2qQaJ7EfD0Xfaeq7nH6fIS9cBLKH1BQcgouuaWOOOhAwS8Z1o4q3P4BpC+RMDSSnbLzTPGAbxUOPrVfNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=orlt5dJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="orlt5dJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C214C4CEE7;
	Wed, 16 Jul 2025 21:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752699687;
	bh=5dGsG7b5HvrezLMs3tfSKA5SfK1ApezYp20DevyRBeE=;
	h=Date:To:From:Subject:From;
	b=orlt5dJ2+3OiGOKskVVRUXRmhrFFWF3NizL2CxcQpZnr6t0hPZiVoijAWJ1VIlhxG
	 xl0Dv7HgxXRcXkadFb0COYpftkeAcbFrAvWL8VOHPOk56gIx+ytZjopTjgK8tNhiqF
	 xnOyBOq7J1NZ5KPWCd+EeT8UOty2rNB4AStbZz0o=
Date: Wed, 16 Jul 2025 14:01:26 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-rework-mseal-apply-logic.patch added to mm-new branch
Message-Id: <20250716210127.4C214C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: rework mseal apply logic
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-rework-mseal-apply-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-rework-mseal-apply-logic.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: rework mseal apply logic
Date: Wed, 16 Jul 2025 18:38:06 +0100

The logic can be simplified - firstly by renaming the inconsistently named
apply_mm_seal() to mseal_apply().

We then wrap mseal_fixup() into the main loop as the logic is simple
enough to not require it, equally it isn't a hugely pleasant pattern in
mprotect() etc.  so it's not something we want to perpetuate.

We eliminate the need for invoking vma_iter_end() on each loop by directly
determining if the VMA was merged - the only thing we need concern
ourselves with is whether the start/end of the (gapless) range are offset
into VMAs.

This refactoring also avoids the rather horrid 'pass pointer to prev
around' pattern used in mprotect() et al.

No functional change intended.

Link: https://lkml.kernel.org/r/9ae70e1c509d790cf174f16e491975efd9be50b6.1752687069.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   67 +++++++++++++++------------------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

--- a/mm/mseal.c~mm-mseal-rework-mseal-apply-logic
+++ a/mm/mseal.c
@@ -15,28 +15,6 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		struct vm_area_struct **prev, unsigned long start,
-		unsigned long end, vm_flags_t newflags)
-{
-	int ret = 0;
-	vm_flags_t oldflags = vma->vm_flags;
-
-	if (newflags == oldflags)
-		goto out;
-
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, newflags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto out;
-	}
-
-	vm_flags_set(vma, VM_SEALED);
-out:
-	*prev = vma;
-	return ret;
-}
-
 /* Does the [start, end) range contain any unmapped memory? */
 static bool range_contains_unmapped(struct mm_struct *mm,
 		unsigned long start, unsigned long end)
@@ -55,38 +33,33 @@ static bool range_contains_unmapped(stru
 	return prev_end < end;
 }
 
-/*
- * Apply sealing.
- */
-static int apply_mm_seal(unsigned long start, unsigned long end)
+static int mseal_apply(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
-	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long curr_start = start;
+	VMA_ITERATOR(vmi, mm, start);
 
+	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
-	/*
-	 * Note: check_mm_seal should already checked ENOMEM case.
-	 * so vma should not be null, same for the other ENOMEM cases.
-	 */
 	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
 
-	nstart = start;
 	for_each_vma_range(vmi, vma, end) {
-		int error;
-		unsigned long tmp;
-		vm_flags_t newflags;
-
-		newflags = vma->vm_flags | VM_SEALED;
-		tmp = vma->vm_end;
-		if (tmp > end)
-			tmp = end;
-		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
-		if (error)
-			return error;
-		nstart = vma_iter_end(&vmi);
+		unsigned long curr_end = MIN(vma->vm_end, end);
+
+		if (!(vma->vm_flags & VM_SEALED)) {
+			vma = vma_modify_flags(&vmi, prev, vma,
+					curr_start, curr_end,
+					vma->vm_flags | VM_SEALED);
+			if (IS_ERR(vma))
+				return PTR_ERR(vma);
+			vm_flags_set(vma, VM_SEALED);
+		}
+
+		prev = vma;
+		curr_start = curr_end;
 	}
 
 	return 0;
@@ -185,10 +158,10 @@ int do_mseal(unsigned long start, size_t
 	 * reaching the max supported VMAs, however, those cases shall
 	 * be rare.
 	 */
-	ret = apply_mm_seal(start, end);
+	ret = mseal_apply(mm, start, end);
 
 out:
-	mmap_write_unlock(current->mm);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

