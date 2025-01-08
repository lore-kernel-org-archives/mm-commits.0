Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2D42E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308362; cv=none; b=e9R/nqd00MpOhQHsoz5ko8zrNngSbO9A3xd6quhgGxwL4B9fLcUsl/rwaNtZ02sounVSgFK2Y6fj8zyNnfQFZdIsLmveNOglPCBZAt5Waono0P6DXHvjZ62jrtZp2TSiQtrhJNTv/29u8n51/5U3F8+mGFJmo2AK0SHpGbcPbFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308362; c=relaxed/simple;
	bh=HVTAM8t/ozN1vyi8WgOfZGlH1vXiWownmlGA3bJa56w=;
	h=Date:To:From:Subject:Message-Id; b=ny7mZXG9UKaBVSmWjnFcwRcVHIaiDCTs38ajMuyZlnu+fjXGApJKy7JQFCBiqxVStNEq81nr7vCKLw5330Cf8Uhg/qhIfaDT1hptpC+REz/ExGLII3kFADGFM4X/FMVUsjMt1LXjzxuVGAcupUc4nM+QbV8E5JepkCcb8uTndqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jb4TwXqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jb4TwXqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4736AC4CEE4;
	Wed,  8 Jan 2025 03:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308360;
	bh=HVTAM8t/ozN1vyi8WgOfZGlH1vXiWownmlGA3bJa56w=;
	h=Date:To:From:Subject:From;
	b=Jb4TwXqLSbyRCwnFGnGGtQi5MQ9UIgTw+iE40Vi4sWbMa1CXJ3TICJ13TdSJdc4lV
	 lgopOdYMyEcze9pzGY7/ZrcixC8x+0VZ/JR7Sr/Uh+cV+MJTX1e9tJ8U7VW3l8aTfN
	 tjaExb3SPXG3aSUZSAYt18m6QJMf7cXdE1OEIono=
Date: Tue, 07 Jan 2025 19:52:39 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch added to mm-unstable branch
Message-Id: <20250108035240.4736AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: rename avoid_reserve to cow_from_owner
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: rename avoid_reserve to cow_from_owner
Date: Tue, 7 Jan 2025 15:39:58 -0500

The old name "avoid_reserve" can be too generic and can be used wrongly in
the new call sites that want to allocate a hugetlb folio.

It's confusing on two things: (1) whether one can opt-in to avoid global
reservation, and (2) whether it should take more than one count.

In reality, this flag is only used in an extremely hacky path, in an
extremely hacky way in hugetlb CoW path only, and always use with 1 saying
"skip global reservation".  Rename the flag to avoid future abuse of this
flag, making it a boolean so as to reflect its true representation that
it's not a counter.  To make it even harder to abuse, add a comment above
the function to explain it.

Link: https://lkml.kernel.org/r/20250107204002.2683356-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    2 +-
 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   33 ++++++++++++++++++++-------------
 3 files changed, 23 insertions(+), 16 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-rename-avoid_reserve-to-cow_from_owner
+++ a/fs/hugetlbfs/inode.c
@@ -814,7 +814,7 @@ static long hugetlbfs_fallocate(struct f
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		folio = alloc_hugetlb_folio(&pseudo_vma, addr, 0);
+		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
 		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
--- a/include/linux/hugetlb.h~mm-hugetlb-rename-avoid_reserve-to-cow_from_owner
+++ a/include/linux/hugetlb.h
@@ -683,7 +683,7 @@ struct huge_bootmem_page {
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				unsigned long addr, int avoid_reserve);
+				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
@@ -1068,7 +1068,7 @@ static inline int replace_free_hugepage_
 
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   int avoid_reserve)
+					   bool cow_from_owner)
 {
 	return NULL;
 }
--- a/mm/hugetlb.c~mm-hugetlb-rename-avoid_reserve-to-cow_from_owner
+++ a/mm/hugetlb.c
@@ -3008,8 +3008,15 @@ int replace_free_hugepage_folios(unsigne
 	return ret;
 }
 
+/*
+ * NOTE! "cow_from_owner" represents a very hacky usage only used in CoW
+ * faults of hugetlb private mappings on top of a non-page-cache folio (in
+ * which case even if there's a private vma resv map it won't cover such
+ * allocation).  New call sites should (probably) never set it to true!!
+ * When it's set, the allocation will bypass all vma level reservations.
+ */
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, int avoid_reserve)
+				    unsigned long addr, bool cow_from_owner)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
@@ -3038,7 +3045,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 * Allocations for MAP_NORESERVE mappings also need to be
 	 * checked against any subpool limit.
 	 */
-	if (map_chg || avoid_reserve) {
+	if (map_chg || cow_from_owner) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
 		if (gbl_chg < 0)
 			goto out_end_reservation;
@@ -3046,7 +3053,7 @@ struct folio *alloc_hugetlb_folio(struct
 
 	/* If this allocation is not consuming a reservation, charge it now.
 	 */
-	deferred_reserve = map_chg || avoid_reserve;
+	deferred_reserve = map_chg || cow_from_owner;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
@@ -3071,7 +3078,7 @@ struct folio *alloc_hugetlb_folio(struct
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
+		if (!cow_from_owner && vma_has_reserves(vma, gbl_chg)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			h->resv_huge_pages--;
 		}
@@ -3138,7 +3145,7 @@ out_uncharge_cgroup_reservation:
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg);
 out_subpool_put:
-	if (map_chg || avoid_reserve)
+	if (map_chg || cow_from_owner)
 		hugepage_subpool_put_pages(spool, 1);
 out_end_reservation:
 	vma_end_reservation(h, vma, addr);
@@ -5369,7 +5376,7 @@ again:
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, 0);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5823,7 +5830,7 @@ static vm_fault_t hugetlb_wp(struct foli
 	struct hstate *h = hstate_vma(vma);
 	struct folio *old_folio;
 	struct folio *new_folio;
-	int outside_reserve = 0;
+	bool cow_from_owner = 0;
 	vm_fault_t ret = 0;
 	struct mmu_notifier_range range;
 
@@ -5886,7 +5893,7 @@ retry_avoidcopy:
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
 			old_folio != pagecache_folio)
-		outside_reserve = 1;
+		cow_from_owner = true;
 
 	folio_get(old_folio);
 
@@ -5895,7 +5902,7 @@ retry_avoidcopy:
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, outside_reserve);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5905,7 +5912,7 @@ retry_avoidcopy:
 		 * reliability, unmap the page from child processes. The child
 		 * may get SIGKILLed if it later faults.
 		 */
-		if (outside_reserve) {
+		if (cow_from_owner) {
 			struct address_space *mapping = vma->vm_file->f_mapping;
 			pgoff_t idx;
 			u32 hash;
@@ -6156,7 +6163,7 @@ static vm_fault_t hugetlb_no_page(struct
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, 0);
+		folio = alloc_hugetlb_folio(vma, vmf->address, false);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -6622,7 +6629,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			ret = -ENOMEM;
 			goto out;
@@ -6664,7 +6671,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-avoid_reserve-to-allow-taking-folio-from-subpool.patch
mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch
mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch
mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch
mm-hugetlb-simplify-vma_has_reserves.patch
mm-hugetlb-drop-vma_has_reserves.patch
mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

