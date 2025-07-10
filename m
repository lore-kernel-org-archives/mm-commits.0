Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A94E29117A
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752183991; cv=none; b=UMWuFpglcwk4t+yxZe0Jpz/ENqtvnV3zdVoAKjHUqZRfcVtbytwfs+bU6NIFOREC1cJFOTYQRgmvPJEVKobx0XzUDzyUdELQy/KZPUyqHf9ALL2zxlF+ibA5iJG9ljUeWgOCdJeUREULbIGERalY0liF8dRBK1zPXDqSm0lPS/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752183991; c=relaxed/simple;
	bh=amNGIIX5U4OLURfgcAmPzuV1fK2p6HbZ1wAuUaea2gU=;
	h=Date:To:From:Subject:Message-Id; b=ozqCKwo55W4lqBP3sJuVrkgMKCf0zE5V7pir4Bp3kzjbONMjLIEcnnBIF2FycRUij93vLfkjLpI0COSr49BKVVrDp3dv1ZB1/z39hSGxJrs454F/4z2FNS72n/YyJkOHimE+AE+4lolwmoNLAqzG4bUhftfUd8guYcIkTGWpGv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1quBwAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1quBwAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45188C4CEE3;
	Thu, 10 Jul 2025 21:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752183991;
	bh=amNGIIX5U4OLURfgcAmPzuV1fK2p6HbZ1wAuUaea2gU=;
	h=Date:To:From:Subject:From;
	b=W1quBwAoedAFV1alCjQQIdYT3Vw7uh2fFHZHOh1HRDLTMeGTY+KQuIhXMpoCHYy2J
	 p/tr2DdDsULi9EtqYHBvKiRzuNNupa1VEJsWrCUTLaY2TVxyfUMs5/+eySOIjyn9ly
	 Hbvbp/mj+OYQvEmIZaLzAzkWpvU3A2A0A7jg+xks=
Date: Thu, 10 Jul 2025 14:46:30 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-clean-up-mlock-populate-behaviour.patch added to mm-new branch
Message-Id: <20250710214631.45188C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: clean up mlock populate behaviour
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-clean-up-mlock-populate-behaviour.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-clean-up-mlock-populate-behaviour.patch

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
Subject: mm/mremap: clean up mlock populate behaviour
Date: Thu, 10 Jul 2025 16:50:32 +0100

When an mlock()'d VMA is expanded, we need to populate the expanded region
to maintain the contract that all mlock()'d memory is present (albeit -
with some period after mmap unlock where the expanded part of the mapping
remains unfaulted).

The current implementation is very unclear, so make it absolutely explicit
under what circumstances we do this.

Link: https://lkml.kernel.org/r/26d2af0a6dbbdfe839b3b09d3a8ddd7b10d4be7f.1752162066.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-clean-up-mlock-populate-behaviour
+++ a/mm/mremap.c
@@ -65,7 +65,7 @@ struct vma_remap_struct {
 
 	/* Internal state, determined in do_mremap(). */
 	unsigned long delta;		/* Absolute delta of old_len,new_len. */
-	bool mlocked;			/* Was the VMA mlock()'d? */
+	bool populate_expand;		/* mlock()'d expanded, must populate. */
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
@@ -1012,10 +1012,8 @@ static void vrm_stat_account(struct vma_
 	struct vm_area_struct *vma = vrm->vma;
 
 	vm_stat_account(mm, vma->vm_flags, pages);
-	if (vma->vm_flags & VM_LOCKED) {
+	if (vma->vm_flags & VM_LOCKED)
 		mm->locked_vm += pages;
-		vrm->mlocked = true;
-	}
 }
 
 /*
@@ -1655,6 +1653,10 @@ static int check_prep_vma(struct vma_rem
 	if (new_len <= old_len)
 		return 0;
 
+	/* We are expanding and the VMA is mlock()'d so we need to populate. */
+	if (vma->vm_flags & VM_LOCKED)
+		vrm->populate_expand = true;
+
 	/* Need to be careful about a growing mapping */
 	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
 	pgoff += vma->vm_pgoff;
@@ -1775,7 +1777,8 @@ out:
 	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
 
-	if (!failed && vrm->mlocked && vrm->new_len > vrm->old_len)
+	/* VMA mlock'd + was expanded, so populated expanded region. */
+	if (!failed && vrm->populate_expand)
 		mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 
 	notify_uffd(vrm, failed);
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

