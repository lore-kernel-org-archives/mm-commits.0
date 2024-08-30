Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7B91C0DED
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725055914; cv=none; b=gMPA3ggE1o4p8TSXvkLJ3cxwLUMqfK0VIAYnMPsdpIvREX7A0vY+Gt1Lz9oxSLRGTLcG3eMLJ7Vo1wE1dYexq45ip0LkwxQI5dkNFcBHyqoWgcKDKFtzArgCEvb3o8yu2ZevutU569uH8tBpGyIN/1pm6/BJkEQlTiAaOKYk6F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725055914; c=relaxed/simple;
	bh=qZMGCQdc2tMoZ4f0T83eXNfsm/9H/3AcdjnNZtYPrgI=;
	h=Date:To:From:Subject:Message-Id; b=iX5CJE+RkdXRGj/HT8auRdxUMQAEYqqGZT/2ec8x5hVrz5SgajsOXv3LOOzPpxIbP40+ixOouMOizZIria3Xmcw+i9UESbsoLrzlCqHJT7ZjQaghfLcfpVrkww5T51N78we0XhCfSGtwzNJc6hS//SBdIqu774gP6o8RGqgE11E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UDtKNw35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UDtKNw35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11806C4CEC2;
	Fri, 30 Aug 2024 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725055914;
	bh=qZMGCQdc2tMoZ4f0T83eXNfsm/9H/3AcdjnNZtYPrgI=;
	h=Date:To:From:Subject:From;
	b=UDtKNw35/4darwm6gTWGdSpqcO9aYHn8AeztNvKn1BrPjwfSx9PYq/3nk5fZHHCOL
	 5pCG9ly/+YKf7J8FBHKyQUUG2faX6IGz2Xz/mZTNx5sQCT0yb1qChvqnVS/lb5k7nA
	 wKnFViSKR23bc9gA/VsZ+fV6PS2mtezqdKNI4ESg=
Date: Fri, 30 Aug 2024 15:11:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-duplicated-open-coded-vma-policy-check.patch added to mm-unstable branch
Message-Id: <20240830221154.11806C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove duplicated open-coded VMA policy check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-duplicated-open-coded-vma-policy-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-duplicated-open-coded-vma-policy-check.patch

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
Subject: mm: remove duplicated open-coded VMA policy check
Date: Fri, 30 Aug 2024 19:10:16 +0100

Both can_vma_merge_before() and can_vma_merge_after() are invoked after
checking for compatible VMA NUMA policy, we can simply move this to
is_mergeable_vma() and abstract this altogether.

In mmap_region() we set vmg->policy to NULL, so the policy comparisons
checked in can_vma_merge_before() and can_vma_merge_after() are exactly
equivalent to !vma_policy(vmg.next) and !vma_policy(vmg.prev).

Equally, in do_brk_flags(), vmg->policy is NULL, so the
can_vma_merge_after() is checking !vma_policy(vma), as we set vmg.prev to
vma.

In vma_merge(), we compare prev and next policies with vmg->policy before
checking can_vma_merge_after() and can_vma_merge_before() respectively,
which this patch causes to be checked in precisely the same way.

This therefore maintains precisely the same logic as before, only now
abstracted into is_mergeable_vma().

Link: https://lkml.kernel.org/r/0dbff286d9c4988333bc6f4ff3734cb95dd5410a.1725040657.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++-----
 mm/vma.c  |    9 ++++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/mm/mmap.c~mm-remove-duplicated-open-coded-vma-policy-check
+++ a/mm/mmap.c
@@ -1423,8 +1423,7 @@ unsigned long mmap_region(struct file *f
 
 	/* Attempt to expand an old mapping */
 	/* Check next */
-	if (next && next->vm_start == end && !vma_policy(next) &&
-	    can_vma_merge_before(&vmg)) {
+	if (next && next->vm_start == end && can_vma_merge_before(&vmg)) {
 		merge_end = next->vm_end;
 		vma = next;
 		vmg.pgoff = next->vm_pgoff - pglen;
@@ -1438,8 +1437,7 @@ unsigned long mmap_region(struct file *f
 	}
 
 	/* Check prev */
-	if (prev && prev->vm_end == addr && !vma_policy(prev) &&
-	    can_vma_merge_after(&vmg)) {
+	if (prev && prev->vm_end == addr && can_vma_merge_after(&vmg)) {
 		merge_start = prev->vm_start;
 		vma = prev;
 		vmg.pgoff = prev->vm_pgoff;
@@ -1779,7 +1777,7 @@ static int do_brk_flags(struct vma_itera
 	 * Expand the existing vma if possible; Note that singular lists do not
 	 * occur after forking, so the expand will only happen on new VMAs.
 	 */
-	if (vma && vma->vm_end == addr && !vma_policy(vma)) {
+	if (vma && vma->vm_end == addr) {
 		VMG_STATE(vmg, mm, vmi, addr, addr + len, flags, PHYS_PFN(addr));
 
 		vmg.prev = vma;
--- a/mm/vma.c~mm-remove-duplicated-open-coded-vma-policy-check
+++ a/mm/vma.c
@@ -19,6 +19,8 @@ static inline bool is_mergeable_vma(stru
 	 */
 	bool may_remove_vma = merge_next;
 
+	if (!mpol_equal(vmg->policy, vma_policy(vma)))
+		return false;
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
 	 * match the flags but dirty bit -- the caller should mark
@@ -1053,17 +1055,14 @@ static struct vm_area_struct *vma_merge(
 		vma_pgoff = prev->vm_pgoff;
 
 		/* Can we merge the predecessor? */
-		if (addr == prev->vm_end && mpol_equal(vma_policy(prev), vmg->policy)
-		    && can_vma_merge_after(vmg)) {
-
+		if (addr == prev->vm_end && can_vma_merge_after(vmg)) {
 			merge_prev = true;
 			vma_prev(vmg->vmi);
 		}
 	}
 
 	/* Can we merge the successor? */
-	if (next && mpol_equal(vmg->policy, vma_policy(next)) &&
-	    can_vma_merge_before(vmg)) {
+	if (next && can_vma_merge_before(vmg)) {
 		merge_next = true;
 	}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

