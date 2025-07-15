Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB7B1C6FE9
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 23:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752621086; cv=none; b=nki5r3uBRIWf688RbtXSPqXpjF9ou6wOYClapmHuRNhc4mg01UzGMd6qZOUN1/O+1Ijysq5xMNcN2aMvSFEXa0AkwpNdYMhfamFOaA/MhIh0ndw9anr/TkQhOUB3PzJXKt+Sqq3ziSQzYrtWfMiuq3ESlmmPbz1G+kjr6wpwUlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752621086; c=relaxed/simple;
	bh=KhII/MdGyUfNxV0qfAny+2pa1K1XSGXe22JUsWoGSaw=;
	h=Date:To:From:Subject:Message-Id; b=fuGv9QV+Y3jpTxmoOqoeRED5XVJTnYa/ab25VEBPd+IYYhC4VrkhK8UXvz/BDFJPFqcQWBOaTHWfrrRKqfexB9wgSPVqCnl3+EK8sjcHuuuC21wSbDAQcriXCQO5JNBtSXOgODIITbN50oViJnZ64BRpWU9QDzTcQ+gn/HzJ3os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1t4z4PGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1t4z4PGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037B6C4CEE3;
	Tue, 15 Jul 2025 23:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752621086;
	bh=KhII/MdGyUfNxV0qfAny+2pa1K1XSGXe22JUsWoGSaw=;
	h=Date:To:From:Subject:From;
	b=1t4z4PGqfnofMyR/4lDHZvbW9Xjap5xIDgW5Em9fBkZ69EYXSiX5w+sDuoHwbv8xv
	 M2EYLY0qTilTjQ75PWHtesVgaNHqA34Mo+FpQU1KqNNwlHLny6v6QcuaG/dbebQez2
	 Hh5TL/5k3pg6FPMt57I84XeyIT9fmzMVtw177POs=
Date: Tue, 15 Jul 2025 16:11:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-rework-mseal-apply-logic.patch added to mm-new branch
Message-Id: <20250715231126.037B6C4CEE3@smtp.kernel.org>
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
Date: Tue, 15 Jul 2025 14:37:42 +0100

The logic can be simplified - firstly by renaming the inconsistently named
apply_mm_seal() to mseal_apply().

We then wrap mseal_fixup() into the main loop as the logic is simple
enough to not require it, equally it isn't a hugely pleasant pattern in
mprotect() etc.  so it's not something we want to perpetuate.

We remove some redundant comments, and then avoid the entirely unnecessary
and slightly bizarre invocation of vma_iter_end() on each loop - really
what we want, given we have asserted there are no gaps in the range - is
to handle start, end being offset into a VMAs.  This is easily handled
with MIN()/MAX().

There's no need to have an 'out' label block since on vma_modify_flags()
error we abort anyway.

And by refactoring like this we avoid the rather horrid 'pass pointer to
prev around' pattern used in mprotect() et al.

No functional change intended.

Link: https://lkml.kernel.org/r/1d6abf27d8eac0001f8ad47b13f0084ceaa6657b.1752586090.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   69 ++++++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 47 deletions(-)

--- a/mm/mseal.c~mm-mseal-rework-mseal-apply-logic
+++ a/mm/mseal.c
@@ -15,60 +15,35 @@
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
+		unsigned long curr_start, curr_end;
+
+		if (vma->vm_flags & VM_SEALED) {
+			prev = vma;
+			continue;
+		}
+		curr_start = MAX(start, vma->vm_start);
+		curr_end = MIN(vma->vm_end, end);
+
+		vma = vma_modify_flags(&vmi, prev, vma, curr_start, curr_end,
+				vma->vm_flags | VM_SEALED);
+		if (IS_ERR(vma))
+			return PTR_ERR(vma);
+		vm_flags_set(vma, VM_SEALED);
+
+		prev = vma;
 	}
 
 	return 0;
@@ -185,10 +160,10 @@ int do_mseal(unsigned long start, size_t
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
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

