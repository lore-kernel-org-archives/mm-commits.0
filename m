Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8842E217F31
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 22:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729895573; cv=none; b=dyqSlodliLBWivtfM+5PUY50LG9QzNnf/u1TjmbnDXr8jjvY59RGsw/Qk50D1P0FHdkKeYWCroZ3VNSNfN9wFZuC5hWWqwEudhBlEjhieg1B3GLxIjTnRlF6ieJ1GS82mW03jOs0VX00KbpOggMDLVmcVFx3ZDIatUazhOMYDYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729895573; c=relaxed/simple;
	bh=YV2YFkqcqynpExtaVe+QWchnGk+Pb4vta1ppbRA5Ojg=;
	h=Date:To:From:Subject:Message-Id; b=bIXMOwSX/k90brEp21jCNo99JeR6rGhyIZ5oU/vu4Z7u+JxXwZAm/q8L+OH5fLmab5Wm4X8G5RuIfbizh2CNVe8ZdAlYJ/F27hjh1oLc18FKShL6TNF710q0iPvAC/N5tG21RNmi3oQIyK5pqRT0YO2ORN7zITQyYCPE4EyI1Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wT/i6wcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wT/i6wcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467A0C4CEC3;
	Fri, 25 Oct 2024 22:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729895573;
	bh=YV2YFkqcqynpExtaVe+QWchnGk+Pb4vta1ppbRA5Ojg=;
	h=Date:To:From:Subject:From;
	b=wT/i6wcdMA79xkU++JC845MM3hKUXJQ1VGOenOCC8ml4/Jtp+sZnvJGDIgxZ1FYz5
	 KurgWnk9oZN/4wCKEGSYU34nBq/tSRhnpl1BI3Z3rrF0ZudWdoF/uWH6Xv+BmmK2tl
	 4VaHopbnGvFXRaNnZaZbZ573SAyg8We5AFRga1tQ=
Date: Fri, 25 Oct 2024 15:32:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,peterx@redhat.com,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch added to mm-unstable branch
Message-Id: <20241025223253.467A0C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unnecessary reset state logic on merge new VMA
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch

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
Subject: mm: remove unnecessary reset state logic on merge new VMA
Date: Fri, 25 Oct 2024 13:26:26 +0100

The only place where this was used was in mmap_region(), which we have now
adjusted to not require this to be performed (we reset ourselves in
effect).

It also created a dangerous assumption that VMG state could be safely
reused after a merge, at which point it may have been mutated in
unexpected ways, leading to subtle bugs.

Note that it was discovered by Wei Yang that there was also an error in
this code - we are comparing vmg->vma with prev after setting it to NULL.

This however had no impact, as we previously reset VMA iterator state
before attempting merge again, but it was useless effort.

In any case, this patch removes all of the logic so also eliminates this
wasted effort.

Link: https://lkml.kernel.org/r/5d9a59eee6498ae017cc87d89aa723de7179f75d.1729858176.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/vma.c~mm-remove-unnecessary-reset-state-logic-on-merge-new-vma
+++ a/mm/vma.c
@@ -963,7 +963,6 @@ struct vm_area_struct *vma_merge_new_ran
 	struct vm_area_struct *next = vmg->next;
 	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
-	pgoff_t pgoff = vmg->pgoff;
 	pgoff_t pglen = PHYS_PFN(end - start);
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
@@ -1020,16 +1019,6 @@ struct vm_area_struct *vma_merge_new_ran
 		return vmg->vma;
 	}
 
-	/* If expansion failed, reset state. Allows us to retry merge later. */
-	if (!just_expand) {
-		vmg->vma = NULL;
-		vmg->start = start;
-		vmg->end = end;
-		vmg->pgoff = pgoff;
-		if (vmg->vma == prev)
-			vma_iter_set(vmg->vmi, start);
-	}
-
 	return NULL;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-avoid-unsafe-vma-hook-invocation-when-error-arises-on-mmap-hook.patch
mm-unconditionally-close-vmas-on-error.patch
mm-refactor-map_deny_write_exec.patch
mm-resolve-faulty-mmap_region-error-path-behaviour.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems-fix.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
mm-madvise-implement-lightweight-guard-page-mechanism-fix.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch

