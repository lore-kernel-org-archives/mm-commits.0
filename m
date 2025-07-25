Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB1B262D0C
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486027; cv=none; b=hNF+nvkWZo39XYf+VaXPxVQ4l8z+F4e44jwePxsckFJbi60Ru/UQtmzO+7i7HrosywB599QA+jszP0o4sV/Ht65qzSZvsd+yXBYhmUTDkpImLWjw8MAyw8yunYqexgneKS0Xm/fDeTqOi1Y/BJMzN3AODsDhqCG3dagKSOkQR0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486027; c=relaxed/simple;
	bh=NujsFN2HGNZ+jFf+PjoG/3Ni5lMF7rmB6mEcp9KoekQ=;
	h=Date:To:From:Subject:Message-Id; b=SOYQQWaeo0F+ajK8Wv95D8RoPSIgWQuaBrOipjyAygDeNw8JZzTXYplhi85HaLXkD9p6dzyCwvoC6SJum8QSUibDZaVVoZFY2FClo4Dwnja8o1veVLfBAFNLeczM7nHt798+pNg7WxqUxWLUes3RosAMt5HqsDdExdNOf7Jvfx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B2QjyP2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B2QjyP2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551B0C4CEE7;
	Fri, 25 Jul 2025 23:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486026;
	bh=NujsFN2HGNZ+jFf+PjoG/3Ni5lMF7rmB6mEcp9KoekQ=;
	h=Date:To:From:Subject:From;
	b=B2QjyP2EjF5Jo9SCCIGjbPkLjnW+mcdypFuFJH7uBxu3tJJNLGf5KH7yQ0XEjWTZS
	 8MjHzAu8An5FfFENVJTc2IoSytYHLIOyFvfp7izeu4eGe7gPqdDCfhv7oPQPmFoy4f
	 XDn8tQPlUC1iISnlWYUS9WbPqrRy3WH6/kjc87mk=
Date: Fri, 25 Jul 2025 16:27:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-simplify-and-rename-vma-gap-check.patch added to mm-unstable branch
Message-Id: <20250725232706.551B0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: simplify and rename VMA gap check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mseal-simplify-and-rename-vma-gap-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-simplify-and-rename-vma-gap-check.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: simplify and rename VMA gap check
Date: Fri, 25 Jul 2025 09:29:44 +0100

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

Link: https://lkml.kernel.org/r/dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/mm/mseal.c~mm-mseal-simplify-and-rename-vma-gap-check
+++ a/mm/mseal.c
@@ -38,31 +38,28 @@ out:
 }
 
 /*
- * Check for do_mseal:
- * 1> start is part of a valid vma.
- * 2> end is part of a valid vma.
- * 3> No gap (unallocated address) between start and end.
- * 4> map is sealable.
+ * Does the [start, end) range contain any unmapped memory?
+ *
+ * We ensure that:
+ * - start is part of a valid VMA.
+ * - end is part of a valid VMA.
+ * - no gap (unallocated memory) exists between start and end.
  */
-static int check_mm_seal(unsigned long start, unsigned long end)
+static bool range_contains_unmapped(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma;
-	unsigned long nstart = start;
+	unsigned long prev_end = start;
 	VMA_ITERATOR(vmi, current->mm, start);
 
-	/* going through each vma to check. */
 	for_each_vma_range(vmi, vma, end) {
-		if (vma->vm_start > nstart)
-			/* unallocated memory found. */
-			return -ENOMEM;
-
-		if (vma->vm_end >= end)
-			return 0;
+		if (vma->vm_start > prev_end)
+			return true;
 
-		nstart = vma->vm_end;
+		prev_end = vma->vm_end;
 	}
 
-	return -ENOMEM;
+	return prev_end < end;
 }
 
 /*
@@ -184,14 +181,10 @@ int do_mseal(unsigned long start, size_t
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

maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

