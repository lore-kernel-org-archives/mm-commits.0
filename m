Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D471DF27F
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 03:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754971059; cv=none; b=X7uTSFsUERn/w3tJQm2b6L3jMA50cCXwr4HKWnzzaTp99Cv+JbCbRXRtJTd+gmeI6Oyr1xTY8rcjpEl5yZMp5WW1Dq/hjntcKsAFJPixJjSlv5wLmbg/s8S/InOwNLgK/y7p7Fci4Oy2MhuWfyVq7VcSO5F03SnjqRk31Fqbu7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754971059; c=relaxed/simple;
	bh=Ht0pJBdTJdP9Npf4z3hU4FlRtCWVnH6TVQGroYzBE/Q=;
	h=Date:To:From:Subject:Message-Id; b=MOlq4SNOiYSMSe9T8R2J9/Xq1UW3CyUeO4xXKdu9Vuyip/ctiTSWK8bDpD855iBFWl+V1bqSwuYNDlI1gex/sKFZpf5H7iT3Mj5ayUAzPIKSyB2KJQfkE7Ner2KfRnwtTxu26t03YxVkqvN40Wk2+KbtieH7t18oD7VBYsg2eUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ywt65UKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ywt65UKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12387C4CEF0;
	Tue, 12 Aug 2025 03:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754971058;
	bh=Ht0pJBdTJdP9Npf4z3hU4FlRtCWVnH6TVQGroYzBE/Q=;
	h=Date:To:From:Subject:From;
	b=Ywt65UKwX2Qg0lY7tutrEKrEtNmi3dFq34WLNyLfmiPllbgAtAJPNdIC7Zbki6NKn
	 WT0OYvmZGBKQrpumIZoOrgCTpdk83Shl/5l+LjfytFOqq+YlMwkZaYZ503Ns92hsOe
	 rLO6r+uoEnFwuZw2ZgDBpXtgivLYIrhAtY+guzS4=
Date: Mon, 11 Aug 2025 20:57:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812035738.12387C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: allow multi-VMA move when filesystem uses thp_get_unmapped_area
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/mremap: allow multi-VMA move when filesystem uses thp_get_unmapped_area
Date: Sun, 3 Aug 2025 12:11:21 +0100

The multi-VMA move functionality introduced in commit d23cb648e365
("mm/mremap: permit mremap() move of multiple VMA") doesn't allow moves of
file-backed mappings which specify a custom f_op->get_unmapped_area
handler excepting hugetlb and shmem.

We expand this to include thp_get_unmapped_area to support file-backed
mappings for filesystems which use large folios.

Additionally, when the first VMA in a range is not compatible with a
multi-VMA move, instead of moving the first VMA and returning an error,
this series results in us not moving anything and returning an error
immediately.

Examining this second change in detail:

The semantics of multi-VMA moves in mremap() very clearly indicate that a
failure can result in a partial move of VMAs.

This is in line with other aggregate operations within the kernel, which
share these semantics.

There are two classes of failures we're concerned with - eligiblity for
mutli-VMA move, and transient failures that would occur even if the user
individually moved each VMA.

The latter is due to out-of-memory conditions (which, given the
allocations involved are small, would likely be fatal in any case), or
hitting the mapping limit.

Regardless of the cause, transient issues would be fatal anyway, so it
isn't really material which VMAs succeeded at being moved or not.

However with when it comes to multi-VMA move eligiblity, we face another
issue - we must allow a single VMA to succeed regardless of this
eligiblity (as, of course, it is not a multi-VMA move) - but we must then
fail multi-VMA operations.

The two means by which VMAs may fail the eligbility test are - the VMAs
being UFFD-armed, or the VMA being file-backed and providing its own
f_op->get_unmapped_area() helper (because this may result in MREMAP_FIXED
being disregarded), excepting those known to correctly handle
MREMAP_FIXED.

It is therefore conceivable that a user could erroneously try to use this
functionality in these instances, and would prefer to not perform any move
at all should that occur.

This series therefore avoids any move of subsequent VMAs should the first
be multi-VMA move ineligble and the input span exceeds that of the first
VMA.

We also add detailed test logic to assert that multi VMA move with
ineligible VMAs functions as expected.


This patch (of 3):

We currently restrict multi-VMA move to avoid filesystems or drivers which
provide a custom f_op->get_unmapped_area handler unless it is known to
correctly handle MREMAP_FIXED.

We do this so we do not get unexpected result when moving from one area to
another (for instance, if the handler would align things resulting in the
moved VMAs having different gaps than the original mapping).

More and more filesystems are moving to using large folios, and typically
do so (in part) by setting f_op->get_unmapped_area to
thp_get_unmapped_area.

When mremap() invokes the file system's get_unmapped MREMAP_FIXED, it does
so via get_unmapped_area(), called in vrm_set_new_addr().  In order to do
so, it converts the MREMAP_FIXED flag to a MAP_FIXED flag and passes this
to the unmapped area handler.

The __get_unmapped_area() function (called by get_unmapped_area()) in turn
invokes the filesystem or driver's f_op->get_unmapped_area() handler.

Therefore this is a point at which thp_get_unmapped_area() may be called
(also, this is the case for anonymous mappings where the size is huge page
aligned).

thp_get_unmapped_area() calls thp_get_unmapped_area_vmflags() and
__thp_get_unmapped_area() in turn (falling back to
mm_get_unmapped_area_vm_flags() which is known to handle MAP_FIXED
correctly).

The __thp_get_unmapped_area() function in turn does nothing to change the
address hint, nor the MAP_FIXED flag, only adjusting alignment parameters.
It hten calls mm_get_unmapped_area_vmflags(), and in turn arch-specific
unmapped area functions, all of which honour MAP_FIXED correctly.

Therefore, we can safely add thp_get_unmapped_area to the known-good
handlers.

Link: https://lkml.kernel.org/r/cover.1754218667.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/4f2542340c29c84d3d470b0c605e916b192f6c81.1754218667.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area
+++ a/mm/mremap.c
@@ -1620,7 +1620,7 @@ static void notify_uffd(struct vma_remap
 
 static bool vma_multi_allowed(struct vm_area_struct *vma)
 {
-	struct file *file;
+	struct file *file = vma->vm_file;
 
 	/*
 	 * We can't support moving multiple uffd VMAs as notify requires
@@ -1633,15 +1633,17 @@ static bool vma_multi_allowed(struct vm_
 	 * Custom get unmapped area might result in MREMAP_FIXED not
 	 * being obeyed.
 	 */
-	file = vma->vm_file;
-	if (file && !vma_is_shmem(vma) && !is_vm_hugetlb_page(vma)) {
-		const struct file_operations *fop = file->f_op;
+	if (!file || !file->f_op->get_unmapped_area)
+		return true;
+	/* Known good. */
+	if (vma_is_shmem(vma))
+		return true;
+	if (is_vm_hugetlb_page(vma))
+		return true;
+	if (file->f_op->get_unmapped_area == thp_get_unmapped_area)
+		return true;
 
-		if (fop->get_unmapped_area)
-			return false;
-	}
-
-	return true;
+	return false;
 }
 
 static int check_prep_vma(struct vma_remap_struct *vrm)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-avoid-expensive-folio-lookup-on-mremap-folio-pte-batch.patch
tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch

