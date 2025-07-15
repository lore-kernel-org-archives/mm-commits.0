Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CCD1C6FE9
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752621084; cv=none; b=Dr1B4aO/fe9uXxlkrTr3Uga+4EarwxgYwXsd1kJNofQcsQS99nF7/PMuNtPtKI3HL1uSJKntgmHlcY6qv++KxVrMR5zOzEKBam/Aydl9Gz5MDWjCv66X8MF/mC1anrdejyFxyBpElh9RvVvZB4wpst0e9SJQZTGaTgsZby6uhoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752621084; c=relaxed/simple;
	bh=1VWtFv96kiqutWzDVBIENLA2nrePXJEg28kOLuUjAGE=;
	h=Date:To:From:Subject:Message-Id; b=lEiQuYY4d1q6+oLSzSwfzaS7id2hwa1QZrW64ZUAtn6EnrTlFmQsrnQQd+E0GVb5O83xElHJug2ghepEyWIHkRs+XuDoVgYZXJ0pJhYm1pRNErobk5AGAfdQJkyWBsHQzBLJQy0l5oJk8wjFu6NALEkSPFezC1e2yBVQzr4HyNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QI486Ci3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QI486Ci3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013B4C4CEE3;
	Tue, 15 Jul 2025 23:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752621084;
	bh=1VWtFv96kiqutWzDVBIENLA2nrePXJEg28kOLuUjAGE=;
	h=Date:To:From:Subject:From;
	b=QI486Ci3teA3/5cs1zLLgPRFdPJyLJGnHYoIAp5C+XKf408jT1Mj+ZuNVmVoyWhVC
	 mEUidByyiK6tzXm4x/FVMfz0OX+SRCczeKYLlZW+FgBUHg6Vdn9TdA6lzvGsOSaslV
	 fphsUT79tXhsDfjlgpJX0ZOYl+D+6eCs4ueCFAI4=
Date: Tue, 15 Jul 2025 16:11:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-simplify-and-rename-vma-gap-check.patch added to mm-new branch
Message-Id: <20250715231124.013B4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: Simplify and rename VMA gap check
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-simplify-and-rename-vma-gap-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-simplify-and-rename-vma-gap-check.patch

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
Subject: mm/mseal: Simplify and rename VMA gap check
Date: Tue, 15 Jul 2025 14:37:41 +0100

The check_mm_seal() function is doing something general - checking whether
a range contains only VMAs (or rather that it does NOT contain any
unmapped regions).

So rename this function to range_contains_unmapped().

Additionally simplify the logic, we are simply checking whether the last
vma->vm_end has either a VMA starting after it or ends before the end
parameter.

This check is rather dubious, so it is sensible to keep it local to
mm/mseal.c as at a later stage it may be removed, and we don't want any
other mm code to perform such a check.

No functional change intended.

Link: https://lkml.kernel.org/r/8efef79c46553a9b8924878c1f4363998c1f49ed.1752586090.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   56 +++++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

--- a/mm/mseal.c~mm-mseal-simplify-and-rename-vma-gap-check
+++ a/mm/mseal.c
@@ -38,34 +38,6 @@ out:
 }
 
 /*
- * Check for do_mseal:
- * 1> start is part of a valid vma.
- * 2> end is part of a valid vma.
- * 3> No gap (unallocated address) between start and end.
- * 4> map is sealable.
- */
-static int check_mm_seal(unsigned long start, unsigned long end)
-{
-	struct vm_area_struct *vma;
-	unsigned long nstart = start;
-	VMA_ITERATOR(vmi, current->mm, start);
-
-	/* going through each vma to check. */
-	for_each_vma_range(vmi, vma, end) {
-		if (vma->vm_start > nstart)
-			/* unallocated memory found. */
-			return -ENOMEM;
-
-		if (vma->vm_end >= end)
-			return 0;
-
-		nstart = vma->vm_end;
-	}
-
-	return -ENOMEM;
-}
-
-/*
  * Apply sealing.
  */
 static int apply_mm_seal(unsigned long start, unsigned long end)
@@ -102,6 +74,24 @@ static int apply_mm_seal(unsigned long s
 	return 0;
 }
 
+/* Does the [start, end) range contain any unmapped memory? */
+static bool range_contains_unmapped(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
+{
+	struct vm_area_struct *vma;
+	unsigned long prev_end = start;
+	VMA_ITERATOR(vmi, current->mm, start);
+
+	for_each_vma_range(vmi, vma, end) {
+		if (vma->vm_start > prev_end)
+			return true;
+
+		prev_end = vma->vm_end;
+	}
+
+	return prev_end < end;
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -184,14 +174,10 @@ int do_mseal(unsigned long start, size_t
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	/*
-	 * First pass, this helps to avoid
-	 * partial sealing in case of error in input address range,
-	 * e.g. ENOMEM error.
-	 */
-	ret = check_mm_seal(start, end);
-	if (ret)
+	if (range_contains_unmapped(mm, start, end)) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/*
 	 * Second pass, this should success, unless there are errors
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

