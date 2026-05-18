Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D2739A7E1
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141130; cv=none; b=U8rw7Aj4G16lHQJXi92wizozF5u93/LX7ZkfxnMF3cH5wsixjoEwnEXiX3WE7lmDDnTE/bYIjdvRao2jkJsEul8NSJdB9FVShnW7GbCUweqRvN1+2hxSRjd8zDDijAAPcB8UYhfQ6RaiK/7blsQ7LATACWYPOPo24rl5P0yKOcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141130; c=relaxed/simple;
	bh=c6kcGNalyJ+MhK7fWey94D0fB5ZEQ8yceJ84SDs+O8o=;
	h=Date:To:From:Subject:Message-Id; b=HcjZVa3nTjRGzYjQMpek7HtOJ0T/b7kuB7txRnBulzC86WudQd44E9/QSsDtbNWo8jKjQKoPDm6dbDEph7ioqVOlYmn8IixllfKNI8SrF641yXF1API/wdHAj4j/Tc6TyWucpKoTqnJ4x6Rg1R4zOeP3175kL44zn6gnmX1EOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mk3Kfv36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mk3Kfv36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC904C2BCB7;
	Mon, 18 May 2026 21:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141127;
	bh=c6kcGNalyJ+MhK7fWey94D0fB5ZEQ8yceJ84SDs+O8o=;
	h=Date:To:From:Subject:From;
	b=mk3Kfv36bJ8TkSqFAI65FDC/6Bm62JiCBcgjUnYljx0/H/V4JUWTVjLJ5LjmpEDlK
	 /0swIdONVptte8amypu+wb6oR0Qolb4nRNgqKZpNyQQPAP+derjNmArpIvndOqbbTQ
	 v69TA3P6Z1OKhYqonqw2HhbI/qa8xvyrETPcBVJE=
Date: Mon, 18 May 2026 14:52:07 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch added to mm-new branch
Message-Id: <20260518215207.CC904C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move THP gfp limit helper into header
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: move THP gfp limit helper into header
Date: Sun, 17 May 2026 23:39:42 +0800

Shmem has some special requirements for THP GFP and has to limit it in
certain zones or provide a more lenient fallback.

We'll use this helper for generic swap THP allocation, which needs to
support shmem.  For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper is
basically a no-op.  But it's necessary for certain shmem users, mostly
drivers.

No feature change.

Link: https://lore.kernel.org/20260517-swap-table-p4-v5-3-88ae43e064c7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   30 ++++++++++++++++++++++++++++++
 mm/shmem.c              |   30 +++---------------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-move-thp-gfp-limit-helper-into-header
+++ a/include/linux/huge_mm.h
@@ -243,6 +243,31 @@ static inline bool thp_vma_suitable_orde
 }
 
 /*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some shmem users want THP allocation to be done less aggressively
+ * and only in certain zone.
+ */
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
+/*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
  * All orders that pass the checks are returned as a bitfield.
@@ -565,6 +590,11 @@ static inline bool thp_vma_suitable_orde
 	return false;
 }
 
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	return huge_gfp;
+}
+
 static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long orders)
 {
--- a/mm/shmem.c~mm-huge_memory-move-thp-gfp-limit-helper-into-header
+++ a/mm/shmem.c
@@ -1791,30 +1791,6 @@ static struct folio *shmem_swapin_cluste
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2065,7 +2041,7 @@ static struct folio *shmem_swap_alloc_fo
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2141,7 +2117,7 @@ static int shmem_replace_folio(struct fo
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2548,7 +2524,7 @@ repeat:
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch
mm-swap-avoid-leaving-unused-extend-table-after-alloc-race.patch
mm-swap-simplify-swap-cache-allocation-helper.patch
mm-swap-move-common-swap-cache-operations-into-standalone-helpers.patch
mm-huge_memory-move-thp-gfp-limit-helper-into-header.patch
mm-swap-add-support-for-stable-large-allocation-in-swap-cache-directly.patch
mm-swap-unify-large-folio-allocation.patch
mm-memcg-swap-tidy-up-cgroup-v1-memsw-swap-helpers.patch
mm-swap-support-flexible-batch-freeing-of-slots-in-different-memcgs.patch
mm-swap-delay-and-unify-memcg-lookup-and-charging-for-swapin.patch
mm-swap-consolidate-cluster-allocation-helpers.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly.patch
mm-memcg-remove-no-longer-used-swap-cgroup-array.patch
mm-swap-merge-zeromap-into-swap-table.patch

