Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81091243348
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837192; cv=none; b=EwmYm83yHXY5qvkONgSz/SuUZHSoJ7O0GHVqa70rjBoyq7rgccDr7L4/4QAWkS7HL+oRxzveldq3iuBGHvHn3To6+703+FfuUFliHFuxtdHzfcXLrA6f4etIVoQP+5APEn4RIJrOagcOhsJRiTq6aNvw+r/rXtFRYFGJv4RO2tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837192; c=relaxed/simple;
	bh=9reWYmqNGIfUwW2r0RYPu2zP/dRnMYm7oBG2f3wgepE=;
	h=Date:To:From:Subject:Message-Id; b=lumnASQCzecd5H/jzbZCmPHj0SlTdHiOoFZPffepflF0HkYBbLNvJ08DTbyFn4R2LAccqRuD6vXNXYdtergO93nORw9Gwuff/5wXrU6t8V8IivoP7Q2UDVE30yrBqPaqZAi3iq4pcviw/VEIfbiJ7inak87YW7jChq5ecu8tIT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HmPocKVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HmPocKVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5501BC4CEDD;
	Tue, 14 Jan 2025 06:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837192;
	bh=9reWYmqNGIfUwW2r0RYPu2zP/dRnMYm7oBG2f3wgepE=;
	h=Date:To:From:Subject:From;
	b=HmPocKVuGhuR3DMZPUOckgzPCDYehHfgPmJlC1b8f+U4s1GGM4g4MvVwAxdg5vD+t
	 S2F9TonFTaYffbPxlMeopo8SMZOdSlqyfZbsLc0n6x8bF2JbhXll6Rb4CR/DJdLNf/
	 WuZLRARpKW5NsfQMl/ufebFIRSZioUG8vv1mmG4Q=
Date: Mon, 13 Jan 2025 22:46:31 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch removed from -mm tree
Message-Id: <20250114064632.5501BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: rename avoid_reserve to cow_from_owner
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
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
@@ -3012,8 +3012,15 @@ int replace_free_hugepage_folios(unsigne
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
@@ -3042,7 +3049,7 @@ struct folio *alloc_hugetlb_folio(struct
 	 * Allocations for MAP_NORESERVE mappings also need to be
 	 * checked against any subpool limit.
 	 */
-	if (map_chg || avoid_reserve) {
+	if (map_chg || cow_from_owner) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
 		if (gbl_chg < 0)
 			goto out_end_reservation;
@@ -3050,7 +3057,7 @@ struct folio *alloc_hugetlb_folio(struct
 
 	/* If this allocation is not consuming a reservation, charge it now.
 	 */
-	deferred_reserve = map_chg || avoid_reserve;
+	deferred_reserve = map_chg || cow_from_owner;
 	if (deferred_reserve) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
@@ -3075,7 +3082,7 @@ struct folio *alloc_hugetlb_folio(struct
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
+		if (!cow_from_owner && vma_has_reserves(vma, gbl_chg)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			h->resv_huge_pages--;
 		}
@@ -3142,7 +3149,7 @@ out_uncharge_cgroup_reservation:
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg);
 out_subpool_put:
-	if (map_chg || avoid_reserve)
+	if (map_chg || cow_from_owner)
 		hugepage_subpool_put_pages(spool, 1);
 out_end_reservation:
 	vma_end_reservation(h, vma, addr);
@@ -5373,7 +5380,7 @@ again:
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, 0);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5839,7 +5846,7 @@ static vm_fault_t hugetlb_wp(struct foli
 	struct hstate *h = hstate_vma(vma);
 	struct folio *old_folio;
 	struct folio *new_folio;
-	int outside_reserve = 0;
+	bool cow_from_owner = 0;
 	vm_fault_t ret = 0;
 	struct mmu_notifier_range range;
 
@@ -5902,7 +5909,7 @@ retry_avoidcopy:
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
 			old_folio != pagecache_folio)
-		outside_reserve = 1;
+		cow_from_owner = true;
 
 	folio_get(old_folio);
 
@@ -5911,7 +5918,7 @@ retry_avoidcopy:
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, outside_reserve);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5921,7 +5928,7 @@ retry_avoidcopy:
 		 * reliability, unmap the page from child processes. The child
 		 * may get SIGKILLed if it later faults.
 		 */
-		if (outside_reserve) {
+		if (cow_from_owner) {
 			struct address_space *mapping = vma->vm_file->f_mapping;
 			pgoff_t idx;
 			u32 hash;
@@ -6172,7 +6179,7 @@ static vm_fault_t hugetlb_no_page(struct
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, 0);
+		folio = alloc_hugetlb_folio(vma, vmf->address, false);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -6638,7 +6645,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			ret = -ENOMEM;
 			goto out;
@@ -6680,7 +6687,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
_

Patches currently in -mm which might be from peterx@redhat.com are


