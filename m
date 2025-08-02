Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD9F253F1A
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160879; cv=none; b=SdeJmGsxs5Hc0bnhh0IsbE2g+Cy6YZAh+hfYeRuAC5VjtkBHBXz9pa48gWgrB+5nuZu/ZKQhT4OD8vQJd5mriB6GWP+4ayatUouDLCjoriUPHPt2G7v8UKm/HwW4vAZbr5q+plvdn7m9z1uS05Lx34912h/hkvy5gRLCZG3xKX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160879; c=relaxed/simple;
	bh=erua8vHUjO7kDcXirrMtRvjDC9jJBMS8JMhf6PNpMo8=;
	h=Date:To:From:Subject:Message-Id; b=Fjrouec8179hSDAllIBu+cjOAhNqlaplpVGhwRHLJlSdrZUrvDd+chpbhdWUg8YkHi1M2kZ56tp6B8QXeaRJiRVfyBKeHm6fgQAx9mH/dT0rSAyfZgFnDSTAdivlxsvq8GlduFEU0xPObAD9l1mdQDlUcYjkrwwK0ehs3M3lKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N/d/Z9k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N/d/Z9k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3871AC4CEEF;
	Sat,  2 Aug 2025 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160879;
	bh=erua8vHUjO7kDcXirrMtRvjDC9jJBMS8JMhf6PNpMo8=;
	h=Date:To:From:Subject:From;
	b=N/d/Z9k4HxTDuNsLpnOvN9Nt2dPW4Oyd/QlwKnvQDx4YQg/KlC9veVskobEM2n6WP
	 6PZDZ3z58qifhpmSC3tKdU/cDl1FEsqg3C43jHu7FPsldkkIzMU+fiXJrGAVTqaJKw
	 zXx+rRC7Su7mOYtohG8vg1JqrpfR1kYO9bIaSyfU=
Date: Sat, 02 Aug 2025 11:54:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-swap-tidy-up-thp-swapin-checks.patch removed from -mm tree
Message-Id: <20250802185439.3871AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: tidy up THP swapin checks
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-tidy-up-thp-swapin-checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: tidy up THP swapin checks
Date: Mon, 28 Jul 2025 15:53:01 +0800

Move all THP swapin related checks under CONFIG_TRANSPARENT_HUGEPAGE, so
they will be trimmed off by the compiler if not needed.

And add a WARN if shmem sees a order > 0 entry when
CONFIG_TRANSPARENT_HUGEPAGE is disabled, that should never happen unless
things went very wrong.

There should be no observable feature change except the new added WARN.

Link: https://lkml.kernel.org/r/20250728075306.12704-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/shmem.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-tidy-up-thp-swapin-checks
+++ a/mm/shmem.c
@@ -2017,26 +2017,38 @@ static struct folio *shmem_swap_alloc_fo
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
+		     non_swapcache_batch(entry, nr_pages) != nr_pages)
+			return ERR_PTR(-EINVAL);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 
 	new = shmem_alloc_folio(gfp, order, info, index);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 
-	nr_pages = folio_nr_pages(new);
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
 					   gfp, entry)) {
 		folio_put(new);
@@ -2320,9 +2332,6 @@ static int shmem_swapin_folio(struct ino
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
-		int nr_pages = 1 << order;
-		bool fallback_order0 = false;
-
 		/* Or update major stats only when swapin succeeds?? */
 		if (fault_type) {
 			*fault_type |= VM_FAULT_MAJOR;
@@ -2330,20 +2339,8 @@ static int shmem_swapin_folio(struct ino
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


