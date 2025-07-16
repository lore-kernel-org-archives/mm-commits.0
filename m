Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9293E1D86FF
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699684; cv=none; b=ekT7wbZT8hXfXYWwpCayIjLyv96C24dnooxXH4fR26KzShe1sdXMpsKInGzbYz0SzbSqQU+hiwQnCXvagbNbTd6vwtnVKMB4ZK241r8npz9n9pNLYyqinN7MWYGS0gIs3laOu9Ju1ga3C1hieppEzWg6WB3nK6ghABPUih313N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699684; c=relaxed/simple;
	bh=ZEefz7hKzvV4tD0VovAjfSdc+zAUY0bwn47enZ5E/pc=;
	h=Date:To:From:Subject:Message-Id; b=D68qn13REzLr9vy2100QX+rkzijThxJYLiR3P0zQWtIf6cba6uzXJaHeghL98YcftgTc/+/LcrGU85NkxNfOafxMad659y74xzd9mQFzOAJ4w8PBpEYb/icW25TUezbILqUmCOtK9j5xwn7vb3r9Ob/oBpHznEYlkP2ULnk/F8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xUTXBmVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xUTXBmVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB6BC4CEF1;
	Wed, 16 Jul 2025 21:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752699684;
	bh=ZEefz7hKzvV4tD0VovAjfSdc+zAUY0bwn47enZ5E/pc=;
	h=Date:To:From:Subject:From;
	b=xUTXBmVQ/DeLUiYvbloWOQ94lfOtFEgHgk6/NS0Hlc1sMGBr4Rse/MRHwJVeqIHK4
	 fNQywC2Axesw9oERrOkxmQeXmmcIZiHfz8oAXfBDLahVYnpcq6e/vzuls1383L/YZm
	 WXyVBcsLw2w8nyxY3fkBXFjjx2HCgEyDw2OLKYew=
Date: Wed, 16 Jul 2025 14:01:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-small-cleanups.patch added to mm-new branch
Message-Id: <20250716210123.EEB6BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: small cleanups
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-small-cleanups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-small-cleanups.patch

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
Subject: mm/mseal: small cleanups
Date: Wed, 16 Jul 2025 18:38:04 +0100

Drop the wholly unnecessary set_vma_sealed() helper(), which is used only
once, and place VMA_ITERATOR() declarations in the correct place.

Retain vma_is_sealed(), and use it instead of the confusingly named
can_modify_vma(), so it's abundantly clear what's being tested, rather
then a nebulous sense of 'can the VMA be modified'.

No functional change intended.

Link: https://lkml.kernel.org/r/ac51c2a3c68a2475149b54180ff012fffab72c02.1752687069.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c  |    2 +-
 mm/mprotect.c |    2 +-
 mm/mremap.c   |    2 +-
 mm/mseal.c    |    9 +--------
 mm/vma.c      |    4 ++--
 mm/vma.h      |   20 ++------------------
 6 files changed, 8 insertions(+), 31 deletions(-)

--- a/mm/madvise.c~mm-mseal-small-cleanups
+++ a/mm/madvise.c
@@ -1286,7 +1286,7 @@ static bool can_madvise_modify(struct ma
 	struct vm_area_struct *vma = madv_behavior->vma;
 
 	/* If the VMA isn't sealed we're good. */
-	if (can_modify_vma(vma))
+	if (!vma_is_sealed(vma))
 		return true;
 
 	/* For a sealed VMA, we only care about discard operations. */
--- a/mm/mprotect.c~mm-mseal-small-cleanups
+++ a/mm/mprotect.c
@@ -605,7 +605,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	unsigned long charged = 0;
 	int error;
 
-	if (!can_modify_vma(vma))
+	if (vma_is_sealed(vma))
 		return -EPERM;
 
 	if (newflags == oldflags) {
--- a/mm/mremap.c~mm-mseal-small-cleanups
+++ a/mm/mremap.c
@@ -1651,7 +1651,7 @@ static int check_prep_vma(struct vma_rem
 		return -EFAULT;
 
 	/* If mseal()'d, mremap() is prohibited. */
-	if (!can_modify_vma(vma))
+	if (vma_is_sealed(vma))
 		return -EPERM;
 
 	/* Align to hugetlb page size, if required. */
--- a/mm/mseal.c~mm-mseal-small-cleanups
+++ a/mm/mseal.c
@@ -15,11 +15,6 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static inline void set_vma_sealed(struct vm_area_struct *vma)
-{
-	vm_flags_set(vma, VM_SEALED);
-}
-
 static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		struct vm_area_struct **prev, unsigned long start,
 		unsigned long end, vm_flags_t newflags)
@@ -36,7 +31,7 @@ static int mseal_fixup(struct vma_iterat
 		goto out;
 	}
 
-	set_vma_sealed(vma);
+	vm_flags_set(vma, VM_SEALED);
 out:
 	*prev = vma;
 	return ret;
@@ -53,7 +48,6 @@ static int check_mm_seal(unsigned long s
 {
 	struct vm_area_struct *vma;
 	unsigned long nstart = start;
-
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	/* going through each vma to check. */
@@ -78,7 +72,6 @@ static int apply_mm_seal(unsigned long s
 {
 	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
-
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	vma = vma_iter_load(&vmi);
--- a/mm/vma.c~mm-mseal-small-cleanups
+++ a/mm/vma.c
@@ -1351,7 +1351,7 @@ static int vms_gather_munmap_vmas(struct
 		}
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
-		if (!can_modify_vma(vms->vma)) {
+		if (vma_is_sealed(vms->vma)) {
 			error = -EPERM;
 			goto start_split_failed;
 		}
@@ -1371,7 +1371,7 @@ static int vms_gather_munmap_vmas(struct
 	for_each_vma_range(*(vms->vmi), next, vms->end) {
 		long nrpages;
 
-		if (!can_modify_vma(next)) {
+		if (vma_is_sealed(next)) {
 			error = -EPERM;
 			goto modify_vma_failed;
 		}
--- a/mm/vma.h~mm-mseal-small-cleanups
+++ a/mm/vma.h
@@ -559,31 +559,15 @@ struct vm_area_struct *vma_iter_next_rew
 }
 
 #ifdef CONFIG_64BIT
-
 static inline bool vma_is_sealed(struct vm_area_struct *vma)
 {
 	return (vma->vm_flags & VM_SEALED);
 }
-
-/*
- * check if a vma is sealed for modification.
- * return true, if modification is allowed.
- */
-static inline bool can_modify_vma(struct vm_area_struct *vma)
-{
-	if (unlikely(vma_is_sealed(vma)))
-		return false;
-
-	return true;
-}
-
 #else
-
-static inline bool can_modify_vma(struct vm_area_struct *vma)
+static inline bool vma_is_sealed(struct vm_area_struct *vma)
 {
-	return true;
+	return false;
 }
-
 #endif
 
 #if defined(CONFIG_STACK_GROWSUP)
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

