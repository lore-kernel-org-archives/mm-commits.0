Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416C722FDFA
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752183978; cv=none; b=BeDQQPb4RX4l52fa2GUyMWiB5Au9lISURJhUzUTx3tkQ0o/MyqfeUaiqmvBDQc9rVoGDIghYHFY+TFPky/iAuRwa3yyrbp/7VDY1ZZMBi2it+20Up1arpj5ySolNDWTQu8y5SmaO6ODIMRXg1vgepseomx7ojD/4VEaBay+GfEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752183978; c=relaxed/simple;
	bh=6GIxnKoXklB5ST+WUWSXrjrarBO7jkUIGdWC0ijFP84=;
	h=Date:To:From:Subject:Message-Id; b=mkCFNznZkG056s03fUheN0w7kd5LFCsFFPnN8fSGn1GVOT3UXeXWwLu2/PjyUhESjWCeuTT6Re+2PvmYR47nVMKs2XxDdfL3Iy7lCaxbAJRmCBi6cIbnxnuL4lhMACZkTDHjNER3aSQGXqJkwFkVgAjBkq9d1HGhdjLgjKuvWWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JIFqqR6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JIFqqR6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B87C4CEE3;
	Thu, 10 Jul 2025 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752183977;
	bh=6GIxnKoXklB5ST+WUWSXrjrarBO7jkUIGdWC0ijFP84=;
	h=Date:To:From:Subject:From;
	b=JIFqqR6ci+mY3RjNa8eR5Wt8OkcPbUy9U82wETPggkguZKa7GjQFf1vgNI8Xl6ews
	 jWQEF/fCmnFpBDKuuZwyH4H1viM14oIN9r7LH+SuTZZsrwSdk7vyjBsw/durPkEZg8
	 Yi5l37INv6xx1S3d3G1Qp3b9sF0B1IFJg5RzEcm0=
Date: Thu, 10 Jul 2025 14:46:17 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-refactor-initial-parameter-sanity-checks.patch added to mm-new branch
Message-Id: <20250710214617.A7B87C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: refactor initial parameter sanity checks
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-refactor-initial-parameter-sanity-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-refactor-initial-parameter-sanity-checks.patch

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
Subject: mm/mremap: refactor initial parameter sanity checks
Date: Thu, 10 Jul 2025 16:50:26 +0100

We are currently checking some things later, and some things
immediately. Aggregate the checks and avoid ones that need not be made.

Simplify things by aligning lengths immediately. Defer setting the delta
parameter until later, which removes some duplicate code in the hugetlb
case.

We can safely perform the checks moved from mremap_to() to
check_mremap_params() because:

* If we set a new address via vrm_set_new_addr(), then this is guaranteed
  to not overlap nor to position the new VMA past TASK_SIZE, so there's no
  need to check these later.

* We can simply page align lengths immediately. We do not need to check for
  overlap nor TASK_SIZE sanity after hugetlb alignment as this asserts
  addresses are huge-aligned, then huge-aligns lengths, rounding down. This
  means any existing overlap would have already been caught.

Moving things around like this lays the groundwork for subsequent changes
to permit operations on batches of VMAs.

No functional change intended.

Link: https://lkml.kernel.org/r/d6614e35931246cbc68e9d6250552966a407ab45.1752162066.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/mm/mremap.c~mm-mremap-refactor-initial-parameter-sanity-checks
+++ a/mm/mremap.c
@@ -1415,14 +1415,6 @@ static unsigned long mremap_to(struct vm
 	struct mm_struct *mm = current->mm;
 	unsigned long err;
 
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
-		return -EINVAL;
-
-	if (vrm_overlaps(vrm))
-		return -EINVAL;
-
 	if (vrm->flags & MREMAP_FIXED) {
 		/*
 		 * In mremap_to().
@@ -1527,7 +1519,12 @@ static unsigned long check_mremap_params
 	 * for DOS-emu "duplicate shm area" thing. But
 	 * a zero new-len is nonsensical.
 	 */
-	if (!PAGE_ALIGN(vrm->new_len))
+	if (!vrm->new_len)
+		return -EINVAL;
+
+	/* Is the new length or address silly? */
+	if (vrm->new_len > TASK_SIZE ||
+	    vrm->new_addr > TASK_SIZE - vrm->new_len)
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
@@ -1546,6 +1543,10 @@ static unsigned long check_mremap_params
 	if (flags & MREMAP_DONTUNMAP && vrm->old_len != vrm->new_len)
 		return -EINVAL;
 
+	/* Target VMA must not overlap source VMA. */
+	if (vrm_overlaps(vrm))
+		return -EINVAL;
+
 	/*
 	 * move_vma() need us to stay 4 maps below the threshold, otherwise
 	 * it will bail out at the very beginning.
@@ -1622,8 +1623,6 @@ static bool align_hugetlb(struct vma_rem
 	if (vrm->new_len > vrm->old_len)
 		return false;
 
-	vrm_set_delta(vrm);
-
 	return true;
 }
 
@@ -1723,14 +1722,13 @@ static unsigned long do_mremap(struct vm
 	struct vm_area_struct *vma;
 	unsigned long res;
 
+	vrm->old_len = PAGE_ALIGN(vrm->old_len);
+	vrm->new_len = PAGE_ALIGN(vrm->new_len);
+
 	res = check_mremap_params(vrm);
 	if (res)
 		return res;
 
-	vrm->old_len = PAGE_ALIGN(vrm->old_len);
-	vrm->new_len = PAGE_ALIGN(vrm->new_len);
-	vrm_set_delta(vrm);
-
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 	vrm->mmap_locked = true;
@@ -1753,6 +1751,7 @@ static unsigned long do_mremap(struct vm
 		goto out;
 	}
 
+	vrm_set_delta(vrm);
 	vrm->remap_type = vrm_remap_type(vrm);
 
 	/* Actually execute mremap. */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

