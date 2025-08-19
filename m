Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A61270EAB
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646597; cv=none; b=Zdouo1G3Y2yuffDMlWism6PjZwZByd85ChUphgj1i63bWYUd73WBBa16dclJ1VE3wIcOOBvUcS9njHhlQeiiXA7L8/3ouZ+T3PiOqRR+bXikGjQxCQzZ6YejTvsPBVWAZ3n2nG0t+V5KVNMAYHqvDU5eEYZHVeUOWndjn88JjZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646597; c=relaxed/simple;
	bh=R8RJTU9q5qNa10x267+SL1Aug8ShTYArs7zIeKilC5Q=;
	h=Date:To:From:Subject:Message-Id; b=UogE41Hz6Tob3dqDlYNpLUBQzfPQWiA1kELgYzooxvEoIBJTP2GWGCfHzM29VNjVyZF4wLf/xODwhMJ1o1hOBYFnLw9ZUOCqxpa8QLb/uZq7aOZr/eLNBebeQK/gdAbsGHYEyQRsmy445spmrJG7c57yAO2ajUJtU1j5IOF1NnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o1I1oFzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o1I1oFzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95453C4CEF1;
	Tue, 19 Aug 2025 23:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646596;
	bh=R8RJTU9q5qNa10x267+SL1Aug8ShTYArs7zIeKilC5Q=;
	h=Date:To:From:Subject:From;
	b=o1I1oFzKMBd4/AjPuGt4GLIcbwny8pfLjFaDuhAEO1aolAvm7YYgAIPpipV//OysE
	 KIHeQOgzOxk10Ehahy9Fmpv4et2kOy6zbUvZR+W6K8gl4b/amYnej0c6Urp4Wv7wze
	 oi+tgUb1jefxBDAO8jO1jzuQtGnP8/w2TkkQqw1E=
Date: Tue, 19 Aug 2025 16:36:36 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch removed from -mm tree
Message-Id: <20250819233636.95453C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: allow multi-VMA move when filesystem uses thp_get_unmapped_area
has been removed from the -mm tree.  Its filename was
     mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

