Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0434A0C
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752183982; cv=none; b=GyN17yljdsUnmZgb2d6v+nGcL0qPO2fK8StyekQgknYDHEG6fc1meN4bfLSXUnSBSfEJRcHXz87czrjuMhRUwQiOaHQ4tihtgLcslQmyZHsXfxmtbASAFCYXPgCduQ+PyuRS2VBViA08o94Ub8F4R/X4mKXBjHbdOVBY2VV7xZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752183982; c=relaxed/simple;
	bh=Pwh/CY4ntiYKQuP9oS3emT3AVNxC8C3mic/AbtjnJpY=;
	h=Date:To:From:Subject:Message-Id; b=SV57FijqPpxLJ7PZNgAxe5labASz1YfHbLDquRqvmjluiA8Dva7DJ+HCb3m9BKubgreDUm8A4QVW/yYj1Hm1NLcDGMfzCQ7nOxXYQbFe9fDmAiXAgg2zdZ88iTXorXda/NdjcdO/URBNYV5oOc3t36wD3rE0wmgznQya09/O4+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XVYLSB+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XVYLSB+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA080C4CEE3;
	Thu, 10 Jul 2025 21:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752183981;
	bh=Pwh/CY4ntiYKQuP9oS3emT3AVNxC8C3mic/AbtjnJpY=;
	h=Date:To:From:Subject:From;
	b=XVYLSB+kttxs9n35hm9wsmqIbBT6PXO6bdjt57llH5sbryYo5UY3tTjrJdcxdllK8
	 YPCNqzzNXZalL9Q7cxe2Fh9eV380RCoVgIee01Cnb/hORJHZBcadhuOtH/jGN/bh1c
	 ztxl4jsXEtYDpKd+32Rpslkp55oApR91kkvpb2fM=
Date: Thu, 10 Jul 2025 14:46:21 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-cleanup-post-processing-stage-of-mremap.patch added to mm-new branch
Message-Id: <20250710214621.AA080C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: cleanup post-processing stage of mremap
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-cleanup-post-processing-stage-of-mremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-cleanup-post-processing-stage-of-mremap.patch

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
Subject: mm/mremap: cleanup post-processing stage of mremap
Date: Thu, 10 Jul 2025 16:50:28 +0100

Separate out the uffd bits so it clear's what's happening.

Don't bother setting vrm->mmap_locked after unlocking, because after this
we are done anyway.

The only time we drop the mmap lock is on VMA shrink, at which point
vrm->new_len will be < vrm->old_len and the operation will not be performed
anyway, so move this code out of the if (vrm->mmap_locked) block.

All addresses returned by mremap() are page-aligned, so the
offset_in_page() check on ret seems only to be incorrectly trying to detect
whether an error occurred - explicitly check for this.

No functional change intended.

Link: https://lkml.kernel.org/r/4eb6dd13ff135a01a1cc82583214d8d790be9592.1752162066.git.lorenzo.stoakes@oracle.com
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

 mm/mremap.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-cleanup-post-processing-stage-of-mremap
+++ a/mm/mremap.c
@@ -1731,6 +1731,15 @@ static int check_prep_vma(struct vma_rem
 	return 0;
 }
 
+static void notify_uffd(struct vma_remap_struct *vrm, unsigned long to)
+{
+	struct mm_struct *mm = current->mm;
+
+	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
+	mremap_userfaultfd_complete(vrm->uf, vrm->addr, to, vrm->old_len);
+	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
@@ -1756,18 +1765,13 @@ static unsigned long do_mremap(struct vm
 	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
 
 out:
-	if (vrm->mmap_locked) {
+	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
-		vrm->mmap_locked = false;
-
-		if (!offset_in_page(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
-			mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
-	}
 
-	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
-	mremap_userfaultfd_complete(vrm->uf, vrm->addr, res, vrm->old_len);
-	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
+	if (!IS_ERR_VALUE(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
+		mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 
+	notify_uffd(vrm, res);
 	return res;
 }
 
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

