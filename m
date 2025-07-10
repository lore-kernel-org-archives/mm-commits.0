Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB12A2918DE
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752183994; cv=none; b=OFJhAw5V/hkh6e5oQwXf4nOC0MER5Vk29LS/EJLwoMO2T/Uftm8T/gOPtiXoHmHkRKXFon95iOJLjkNMb7rsp8bR6lVvxCsemHUFg7dA5e2xA2q63T3StthGJDMRecVkO+QjSUv6TtSfw4G2IfrhV4c4GXSHEQKLuHfuTsZqP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752183994; c=relaxed/simple;
	bh=iUnWijGcNCWQqBcFvSp9A4M939Ho0EzHF8cHhh8uHKg=;
	h=Date:To:From:Subject:Message-Id; b=PGDi00OCYuoQ4Icjr82cvu6iQxnxdskmUy5NiF+3DcAU84/txgcncMKkrp90s80bQ5QhWt+KWGwxb4sO7Dk3lrqOEEIkESHOHnMnBQmEKc+F62uia0bN/MvPCsiZZHJuqIl6yR1xVphlxRDcJjrV0mti7i0f2KJlGPlBl7Vcoxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VSxfb2dP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VSxfb2dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A35C4CEE3;
	Thu, 10 Jul 2025 21:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752183993;
	bh=iUnWijGcNCWQqBcFvSp9A4M939Ho0EzHF8cHhh8uHKg=;
	h=Date:To:From:Subject:From;
	b=VSxfb2dPJrBuHqwz7oBoIUKjV3FZqUkeWCuK5JxG9Pa97Go/R25+IKkjtlIDgn+fT
	 D8GGV3exAkQbRbFxc+/awKO4K0eCQyGpLEy81JzTxSCOVqMk/X+edaGKNOa5Wrw/CZ
	 Z+vaZcEdGNdS9btIte8mKG0ATDQJ5uBY3nAesi3o=
Date: Thu, 10 Jul 2025 14:46:32 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-permit-mremap-move-of-multiple-vmas.patch added to mm-new branch
Message-Id: <20250710214633.58A35C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: permit mremap() move of multiple VMAs
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-permit-mremap-move-of-multiple-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-permit-mremap-move-of-multiple-vmas.patch

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
Subject: mm/mremap: permit mremap() move of multiple VMAs
Date: Thu, 10 Jul 2025 16:50:33 +0100

Historically we've made it a uAPI requirement that mremap() may only
operate on a single VMA at a time.

For instances where VMAs need to be resized, this makes sense, as it
becomes very difficult to determine what a user actually wants should they
indicate a desire to expand or shrink the size of multiple VMAs (truncate?
Adjust sizes individually? Some other strategy?).

However, in instances where a user is moving VMAs, it is restrictive to
disallow this.

This is especially the case when anonymous mapping remap may or may not be
mergeable depending on whether VMAs have or have not been faulted due to
anon_vma assignment and folio index alignment with vma->vm_pgoff.

Often this can result in surprising impact where a moved region is faulted,
then moved back and a user fails to observe a merge from otherwise
compatible, adjacent VMAs.

This change allows such cases to work without the user having to be
cognizant of whether a prior mremap() move or other VMA operations has
resulted in VMA fragmentation.

Having refactored mremap code to aggregate per-VMA and parameter checks, we
are now in a position to permit this kind of move.

We do so by detecting if this is a move-only operation up-front, and then
utilising a separate code path via remap_move() rather than the ordinary
single-VMA path.

There are two tasks that occur outside of the mmap write lock - userfaultfd
notification and population of unmapped regions of expanded VMAs should the
VMA be mlock()'d.

The latter doesn't apply, as this is logic for a move only and thus no
expansion can take place. In the former case, we explicitly disallow
multi-VMA operations on uffd-armed VMAs.

The mmap lock is never dropped in the move-only case, this only occurs on a
VMA shrink.

We take care to handle cases where a VMA merge has occurred, by resetting
the VMA iterator in such instances.

We needn't worry about self-merges, as in those cases we would, by
definition, not be spanning multiple VMAs. The overlapping range test is
performed on the whole range so specifically disallows this.

Link: https://lkml.kernel.org/r/6fe9dd2a366c7f55201320a81412f789ccfd675c.1752162066.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |  132 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 125 insertions(+), 7 deletions(-)

--- a/mm/mremap.c~mm-mremap-permit-mremap-move-of-multiple-vmas
+++ a/mm/mremap.c
@@ -69,6 +69,8 @@ struct vma_remap_struct {
 	enum mremap_type remap_type;	/* expand, shrink, etc. */
 	bool mmap_locked;		/* Is mm currently write-locked? */
 	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
+	bool multi_vma;			/* Is >1 VMA being moved? */
+	bool vmi_needs_reset;		/* Was the VMA iterator invalidated? */
 };
 
 static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
@@ -1188,6 +1190,9 @@ static int copy_vma_and_data(struct vma_
 		*new_vma_ptr = NULL;
 		return -ENOMEM;
 	}
+	if (vma != vrm->vma)
+		vrm->vmi_needs_reset = true;
+
 	vrm->vma = vma;
 	pmc.old = vma;
 	pmc.new = new_vma;
@@ -1583,6 +1588,18 @@ static bool vrm_will_map_new(struct vma_
 	return false;
 }
 
+/* Does this remap ONLY move mappings? */
+static bool vrm_move_only(struct vma_remap_struct *vrm)
+{
+	if (!vrm_implies_new_addr(vrm))
+		return false;
+
+	if (vrm->old_len != vrm->new_len)
+		return false;
+
+	return true;
+}
+
 static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
 {
 	struct mm_struct *mm = current->mm;
@@ -1646,10 +1663,29 @@ static int check_prep_vma(struct vma_rem
 			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
 		return -EINVAL;
 
-	/* We can't remap across vm area boundaries */
+	/*
+	 * We can't remap across the end of VMAs, as another VMA may be
+	 * adjacent:
+	 *
+	 *       addr   vma->vm_end
+	 *  |-----.----------|
+	 *  |     .          |
+	 *  |-----.----------|
+	 *        .<--------->xxx>
+	 *            old_len
+	 *
+	 * We also require that vma->vm_start <= addr < vma->vm_end.
+	 */
 	if (old_len > vma->vm_end - addr)
 		return -EFAULT;
 
+	/*
+	 * We can't support moving multiple uffd VMAs as notify requires mmap
+	 * lock to be dropped.
+	 */
+	if (vrm->multi_vma && userfaultfd_armed(vma))
+		return -EINVAL;
+
 	if (new_len <= old_len)
 		return 0;
 
@@ -1746,6 +1782,84 @@ static unsigned long check_mremap_params
 	return 0;
 }
 
+static unsigned long remap_move(struct vma_remap_struct *vrm)
+{
+	struct vm_area_struct *vma;
+	unsigned long start = vrm->addr;
+	unsigned long end = vrm->addr + vrm->old_len;
+	unsigned long new_addr = vrm->new_addr;
+	unsigned long prev_addr = start;
+	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long res = -EFAULT;
+	unsigned long last_end;
+
+	/*
+	 * When moving VMAs we allow for batched moves across multiple VMAs,
+	 * with all VMAs in the input range [addr, addr + old_len) being moved
+	 * (and split as necessary).
+	 */
+	for_each_vma_range(vmi, vma, end) {
+		/* Account for start, end not aligned with VMA start, end. */
+		unsigned long addr = max(vma->vm_start, start);
+		unsigned long len = min(end, vma->vm_end) - addr;
+		unsigned long offset, res_vma;
+
+		/* Merged with self, move on. */
+		if (vrm->multi_vma && prev_addr == addr)
+			continue;
+
+		/*
+		 * To sensibly move multiple VMAs, accounting for the fact that
+		 * get_unmapped_area() may align even MAP_FIXED moves, we simply
+		 * attempt to move such that the gaps between source VMAs remain
+		 * consistent in destination VMAs, e.g.:
+		 *
+		 *           X        Y                       X        Y
+		 *         <--->     <->                    <--->     <->
+		 * |-------|   |-----| |-----|      |-------|   |-----| |-----|
+		 * |   A   |   |  B  | |  C  | ---> |   A'  |   |  B' | |  C' |
+		 * |-------|   |-----| |-----|      |-------|   |-----| |-----|
+		 *                               new_addr
+		 *
+		 * Now, new_addr may be altered even with MREMAP_FIXED set, due
+		 * to e.g. alignment changes from get_unmapped_area().
+		 *
+		 * So we map B' at A'->vm_end + X, and C' at B'->vm_end + Y.
+		 */
+		offset = vrm->multi_vma ? vma->vm_start - last_end : 0;
+		last_end = vma->vm_end;
+
+		vrm->vma = vma;
+		vrm->addr = addr;
+		vrm->new_addr = new_addr + offset;
+		vrm->old_len = vrm->new_len = len;
+
+		res_vma = check_prep_vma(vrm);
+		if (!res_vma)
+			res_vma = mremap_to(vrm);
+		if (IS_ERR_VALUE(res_vma))
+			return res_vma;
+
+		/* mmap lock is only dropped on shrink. */
+		VM_WARN_ON_ONCE(!vrm->mmap_locked);
+		/* This is a move, no expand should occur. */
+		VM_WARN_ON_ONCE(vrm->populate_expand);
+
+		if (!vrm->multi_vma)
+			res = res_vma;
+
+		if (vrm->vmi_needs_reset) {
+			vma_iter_reset(&vmi);
+			vrm->vmi_needs_reset = false;
+		}
+		vrm->multi_vma = true;
+		prev_addr = addr;
+		new_addr = res_vma + vrm->new_len;
+	}
+
+	return res;
+}
+
 static unsigned long do_mremap(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
@@ -1763,13 +1877,17 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	vrm->vma = vma_lookup(current->mm, vrm->addr);
-	res = check_prep_vma(vrm);
-	if (res)
-		goto out;
+	if (vrm_move_only(vrm)) {
+		res = remap_move(vrm);
+	} else {
+		vrm->vma = vma_lookup(current->mm, vrm->addr);
+		res = check_prep_vma(vrm);
+		if (res)
+			goto out;
 
-	/* Actually execute mremap. */
-	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
+		/* Actually execute mremap. */
+		res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
+	}
 
 out:
 	failed = IS_ERR_VALUE(res);
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

