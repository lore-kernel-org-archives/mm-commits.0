Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326D27144B
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068096; cv=none; b=qnaeqjX04w63MpRuNbuK3HoWdd8PhhPEy6jcR/xRRBrbDJxdS+Evhx4vTUjw+/O6KSLCtvFDuUOoyYUd0pFNRq9Bnrq29HKQb/N+gRST0OwecIC/sYBh8WfqwaYgw/PAgWBafLhu7Um8qi/b4DrnACbeX0iCoS2dA7dzYqlnnC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068096; c=relaxed/simple;
	bh=TIi0QCEMSz+xaYhhdt6nVrULYYGiw7AHvOGG0HBHpM8=;
	h=Date:To:From:Subject:Message-Id; b=Yy7MWYd0rDrPpM6kiHHovnFcLYLXWPHanWFxqYMz8FBW/Eyiaz0r1Fsjx3/ftTDtzFRia9zaMDjEzbJ7KWkWza+BiJGO7LuTjQIZSp099XVx3v/pJA5IyZ3cexo0/voWX7wiVVSd08NQk/graoCRK/EfnIHcXhuYE7hy3rQTPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kzMsFPXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kzMsFPXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD811F00ACA;
	Fri,  7 Aug 2026 02:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068093;
	bh=26ZDhKqfqnYJlOK9icgnGJLjdTxKTm/W1LW8MuGo+Xg=;
	h=Date:To:From:Subject;
	b=kzMsFPXxKZFvuZKSjOghV49etS0t6nYQFFiPibyOAeF6zdDyW7vF9Gaah9oLswy16
	 p53eOGkbLpG4swlJAB/qK0++5BLNXFLAQUnZON2eyAvfmUoTKRIRYIrm26DXlEam6v
	 CM2nKmjsXfq9xIxd7QFC48nTe+9vuiGkPNhaIRjg=
Date: Thu, 06 Aug 2026 19:01:32 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,kees@kernel.org,jannh@google.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch removed from -mm tree
Message-Id: <20260807020133.1DD811F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: remove superfluous comments, fix confusion around mm
has been removed from the -mm tree.  Its filename was
     mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mseal: remove superfluous comments, fix confusion around mm
Date: Fri, 17 Jul 2026 18:27:09 +0100

Patch series "mm/mseal: further cleanups", v2.

The mseal implementation is still rather confusing, so tighten things up a
little.

The only user of do_mseal() outside of the system call is the
MMAP_PAGE_ZERO process personality - retain better control over how mseal
is utilised by providing mseal_mmap_page_zero() for this instead.

The comments are overly long and confusion, so cut them down so they're a
lot clearer.

Remove confusing mm_struct params (mseal can not be used on remote mm's)
and wrap the actual system call logic into the system call declaration.


This patch (of 3):

Remove comment blocks that don't add value and eliminate any confusion
about whether or not we permit mseal()'ing of remote mm's by not passing
through an mm parameter but rather referencing current->mm in each
function.

Also while we're here, avoid an ugly goto by using an else branch, and
move local parameters declarations into reverse xmas tree order.

No functional change intended.

Link: https://lore.kernel.org/20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org
Link: https://lore.kernel.org/20260717-mseal-fixups-v2-1-0daa0014b813@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   53 ++++++++++-----------------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

--- a/mm/mseal.c~mm-mseal-remove-superfluous-comments-fix-confusion-around-mm
+++ a/mm/mseal.c
@@ -16,32 +16,11 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-/*
- * mseal() disallows an input range which contain unmapped ranges (VMA holes).
- *
- * It disallows unmapped regions from start to end whether they exist at the
- * start, in the middle, or at the end of the range, or any combination thereof.
- *
- * This is because after sealing a range, there's nothing to stop memory mapping
- * of ranges in the remaining gaps later, meaning that the user might then
- * wrongly consider the entirety of the mseal()'d range to be sealed when it
- * in fact isn't.
- */
-
-/*
- * Does the [start, end) range contain any unmapped memory?
- *
- * We ensure that:
- * - start is part of a valid VMA.
- * - end is part of a valid VMA.
- * - no gap (unallocated memory) exists between start and end.
- */
-static bool range_contains_unmapped(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *vma;
-	unsigned long prev_end = start;
 	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long prev_end = start;
+	struct vm_area_struct *vma;
 
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_start > prev_end)
@@ -53,11 +32,10 @@ static bool range_contains_unmapped(stru
 	return prev_end < end;
 }
 
-static int mseal_apply(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static int mseal_apply(unsigned long start, unsigned long end)
 {
+	VMA_ITERATOR(vmi, current->mm, start);
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, mm, start);
 
 	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
@@ -142,10 +120,10 @@ static int mseal_apply(struct mm_struct
  */
 int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
-	size_t len;
-	int ret = 0;
-	unsigned long end;
 	struct mm_struct *mm = current->mm;
+	unsigned long end;
+	int ret = 0;
+	size_t len;
 
 	/* Verify flags not set. */
 	if (flags)
@@ -170,20 +148,11 @@ int do_mseal(unsigned long start, size_t
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	if (range_contains_unmapped(mm, start, end)) {
+	if (range_contains_unmapped(start, end))
 		ret = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Second pass, this should success, unless there are errors
-	 * from vma_modify_flags, e.g. merge/split error, or process
-	 * reaching the max supported VMAs, however, those cases shall
-	 * be rare.
-	 */
-	ret = mseal_apply(mm, start, end);
+	else
+		ret = mseal_apply(start, end);
 
-out:
 	mmap_write_unlock(mm);
 	return ret;
 }
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

