Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE46921A44C
	for <mm-commits@vger.kernel.org>; Fri, 27 Jun 2025 20:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751055406; cv=none; b=DF/XdVCqmkSdGW30FF7hKu05lE31uvDMnugAxMBxflkFO55oMfDtRRKnbIf8hKxkAOcvjg+rQhaTXF+mTznE5JjroKfHarcRjEFrAg8qwP7iqjrad2c2vPxaLc+g9tW2r7Pi5iSVi5U8cVO9oY1yL8duVW8hZ8Pb6Db6Ev6HjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751055406; c=relaxed/simple;
	bh=RXoicbsQAXbzM53H15AwtLwmEG4hAC1y39TtzX0C1aQ=;
	h=Date:To:From:Subject:Message-Id; b=D+ctV/9PaOqHXx3lb6+t9i1nBUNyuNwYySOUDgZWbEyZ8rRDx0/yPBMhQ0lgN3GCWTuimPQk8ZTTgr5VIGC7aPEcY52pHJ01cB7MGHcXwBoCDCSMsY4VdBwpDSJe1QIHnFwBITtXH7B9zsZdxwvfYawDnPLuJN04nu/1XhmKzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rxNX9kfy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rxNX9kfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D3AC4CEE3;
	Fri, 27 Jun 2025 20:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751055405;
	bh=RXoicbsQAXbzM53H15AwtLwmEG4hAC1y39TtzX0C1aQ=;
	h=Date:To:From:Subject:From;
	b=rxNX9kfyz/oFJIzVcc7T6RJ4jbH6zuw36u5z5Xnu+tMFhZjMLYqy+EdvT5AL6P0eK
	 jg3NMJ0iXi577xigvE9sWJUIobHPnFSBQ0okiBHpCn0SCwdDxrQ3gpbR8b9o1KjERl
	 rBqN+yLeMK0kDeXUF8vdAxgUNE67fTOrqCZ7zJbY=
Date: Fri, 27 Jun 2025 13:16:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-tidy-up-thp-swapin-checks.patch added to mm-new branch
Message-Id: <20250627201645.49D3AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: tidy up THP swapin checks
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-tidy-up-thp-swapin-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-tidy-up-thp-swapin-checks.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: tidy up THP swapin checks
Date: Fri, 27 Jun 2025 14:20:16 +0800

Move all THP swapin related checks under CONFIG_TRANSPARENT_HUGEPAGE, so
they will be trimmed off by the compiler if not needed.

And add a WARN if shmem sees a order > 0 entry when
CONFIG_TRANSPARENT_HUGEPAGE is disabled, that should never happen unless
things went very wrong.

There should be no observable feature change except the new added WARN.

Link: https://lkml.kernel.org/r/20250627062020.534-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-tidy-up-thp-swapin-checks
+++ a/mm/shmem.c
@@ -1980,26 +1980,39 @@ static struct folio *shmem_swap_alloc_fo
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	int nr_pages = 1 << order;
 	struct folio *new;
 	void *shadow;
-	int nr_pages;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && order > 0) {
-		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
-
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (WARN_ON_ONCE(order))
+			return ERR_PTR(-EINVAL);
+	} else if (order) {
+		/*
+		 * If uffd is active for the vma, we need per-page fault
+		 * fidelity to maintain the uffd semantics, then fallback
+		 * to swapin order-0 folio, as well as for zswap case.
+		 * Any existing sub folio in the swap cache also blocks
+		 * mTHP swapin.
+		 */
+		if ((vma && unlikely(userfaultfd_armed(vma))) ||
+		     !zswap_never_enabled() ||
+		     non_swapcache_batch(entry, nr_pages) != nr_pages) {
+			return ERR_PTR(-EINVAL);
+		} else {
+			gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		}
 	}
 
 	new = shmem_alloc_folio(gfp, order, info, index);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
-	nr_pages = folio_nr_pages(new);
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
 					   gfp, entry)) {
 		folio_put(new);
@@ -2283,9 +2296,6 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		int nr_pages = 1 << order;
-		bool fallback_order0 = false;
-
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
@@ -2293,20 +2303,8 @@ static int shmem_swapin_folio(struct ino
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 
-		/*
-		 * If uffd is active for the vma, we need per-page fault
-		 * fidelity to maintain the uffd semantics, then fallback
-		 * to swapin order-0 folio, as well as for zswap case.
-		 * Any existing sub folio in the swap cache also blocks
-		 * mTHP swapin.
-		 */
-		if (order > 0 && ((vma && unlikely(userfaultfd_armed(vma))) ||
-				  !zswap_never_enabled() ||
-				  non_swapcache_batch(swap, nr_pages) != nr_pages))
-			fallback_order0 = true;
-
 		/* Skip swapcache for synchronous device. */
-		if (!fallback_order0 && data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
 			if (!IS_ERR(folio)) {
 				skip_swapcache = true;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-clean-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-fix-major-fault-counting.patch
mm-shmem-swap-avoid-false-positive-swap-cache-lookup.patch

