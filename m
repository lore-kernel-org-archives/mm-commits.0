Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEF122619
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 20:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710793971; cv=none; b=XYqW4jLHD3aVaL3360ybBBFeXSqR2OHAlNVDYu9Mu7RkCdR4kQt82EW6vXFyE1oGR0locvkL2TLXKFwnDWuSHpHzT1Hyr1Meo6DjtYr2VL95qk1yiBe93SAU55/GiSzFamLTyNJn0dPWqZEwOXAixsCsTXHgP9oK/BQ1W+cJ4vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710793971; c=relaxed/simple;
	bh=3x9p2SWvImeMsRRab/eqeYqqdzY2rWsMxsr4zhIK6ew=;
	h=Date:To:From:Subject:Message-Id; b=qH6Dyjqh9Q6jpohVGqZt+Yq4IYrtfiYk5VybpVkqQdkI4ns184GNt0L7+nXOVIixcwJ8SURmtc/TnB5bwmUw9NA82EUqTLZuhtDzU3+jjrnAgWaZrG+V6bdX4lfHLZ3kHm/SbAXB0ikdsa1S3E0HPusDLG3B1AI5GmLH73JAQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m/FL/R/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m/FL/R/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D35FC43390;
	Mon, 18 Mar 2024 20:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710793971;
	bh=3x9p2SWvImeMsRRab/eqeYqqdzY2rWsMxsr4zhIK6ew=;
	h=Date:To:From:Subject:From;
	b=m/FL/R/TAPjpBAeYmU7KnKRJ3QvZB6OwLRE5GSTO8xI6RqyEAyP82hEEWUYOz0oBk
	 JL74pj/FogA4BUWOLCWIixSTDVB9iEqFw0fQypkjLWZisMEcEwQpkRBMbE3Q9dblNB
	 BG4EU5vt90yX7r5is4nzBx+owEBEB2Mdq74eaBZk=
Date: Mon, 18 Mar 2024 13:32:50 -0700
To: mm-commits@vger.kernel.org,jhubbard@nvidia.com,jgg@nvidia.com,hughd@google.com,djwong@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch added to mm-unstable branch
Message-Id: <20240318203251.1D35FC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: don't perform madvise VMA walk for MADV_POPULATE_(READ|WRITE)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/madvise: don't perform madvise VMA walk for MADV_POPULATE_(READ|WRITE)
Date: Thu, 14 Mar 2024 17:13:00 +0100

We changed faultin_page_range() to no longer consume a VMA, because
faultin_page_range() might internally release the mm lock to lookup
the VMA again -- required to cleanly handle VM_FAULT_RETRY. But
independent of that, __get_user_pages() will always lookup the VMA
itself.

Now that we let __get_user_pages() just handle VMA checks in a way that
is suitable for MADV_POPULATE_(READ|WRITE), the VMA walk in madvise()
is just overhead. So let's just call madvise_populate()
on the full range instead.

There is one change in behavior: madvise_walk_vmas() would skip any VMA
holes, and if everything succeeded, it would return -ENOMEM after
processing all VMAs.

However, for MADV_POPULATE_(READ|WRITE) it's unlikely for the caller to
notice any difference: -ENOMEM might either indicate that there were VMA
holes or that populating page tables failed because there was not enough
memory. So it's unlikely that user space will notice the difference, and
that special handling likely only makes sense for some other madvise()
actions.

Further, we'd already fail with -ENOMEM early in the past if looking up the
VMA after dropping the MM lock failed because of concurrent VMA
modifications. So let's just keep it simple and avoid the madvise VMA
walk, and consistently fail early if we find a VMA hole.

Link: https://lkml.kernel.org/r/20240314161300.382526-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/mm/madvise.c~mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite
+++ a/mm/madvise.c
@@ -901,26 +901,19 @@ static long madvise_dontneed_free(struct
 		return -EINVAL;
 }
 
-static long madvise_populate(struct vm_area_struct *vma,
-			     struct vm_area_struct **prev,
-			     unsigned long start, unsigned long end,
-			     int behavior)
+static long madvise_populate(struct mm_struct *mm, unsigned long start,
+		unsigned long end, int behavior)
 {
 	const bool write = behavior == MADV_POPULATE_WRITE;
-	struct mm_struct *mm = vma->vm_mm;
 	int locked = 1;
 	long pages;
 
-	*prev = vma;
-
 	while (start < end) {
 		/* Populate (prefault) page tables readable/writable. */
 		pages = faultin_page_range(mm, start, end, write, &locked);
 		if (!locked) {
 			mmap_read_lock(mm);
 			locked = 1;
-			*prev = NULL;
-			vma = NULL;
 		}
 		if (pages < 0) {
 			switch (pages) {
@@ -1021,9 +1014,6 @@ static int madvise_vma_behavior(struct v
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(vma, prev, start, end, behavior);
-	case MADV_POPULATE_READ:
-	case MADV_POPULATE_WRITE:
-		return madvise_populate(vma, prev, start, end, behavior);
 	case MADV_NORMAL:
 		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
 		break;
@@ -1425,8 +1415,16 @@ int do_madvise(struct mm_struct *mm, uns
 	end = start + len;
 
 	blk_start_plug(&plug);
-	error = madvise_walk_vmas(mm, start, end, behavior,
-			madvise_vma_behavior);
+	switch (behavior) {
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		error = madvise_populate(mm, start, end, behavior);
+		break;
+	default:
+		error = madvise_walk_vmas(mm, start, end, behavior,
+					  madvise_vma_behavior);
+		break;
+	}
 	blk_finish_plug(&plug);
 	if (write)
 		mmap_write_unlock(mm);
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch

