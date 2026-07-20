Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2403A9610
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 23:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784588753; cv=none; b=ZNzO8k7fdChBzeLPaLgu52ZNDBikFaLmrOfCe7UBqU+TLZEjwMTFMllqtz7rdPUZIe73VcJT3kWb4cgcwqY7zXyt0FpkJ2Edy4MXbPUPxvepsWBCC9HpTR98HvaMkGAnunzKc8RBUJ2TFJCV1KMCMQ7s4chy5fs4A8JBF08REvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784588753; c=relaxed/simple;
	bh=iGFfHn0UuIUFfBMKrnbbnncgNbwg6B2TOBs38NgqDPI=;
	h=Date:To:From:Subject:Message-Id; b=c4a8EuecppLpIs+bZMUrssqNVGXARhkXcg7mSI9LX1447CV/HS/mOA1qsFlVWFxuAHyeGaQZTgTmpEB/k+n8wS4VcxKIPEIH6V52g6/oxF7LoZ2DObphxVtGU0hXNIGbXfZX+SRhjxUhydmrDsD+EsPiJJOC9W4VQw8j7jZo/io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNPsMiPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNPsMiPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9093E1F000E9;
	Mon, 20 Jul 2026 23:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784588751;
	bh=CnGG4/fwMG1aJiO4vt7ylrMGGgDtGUQ1OIB4b5TjzBs=;
	h=Date:To:From:Subject;
	b=uNPsMiPPbFtP4cY5VPVPU2gXhLie09sjrgZRqRS53+VtRX2QJpI8Q/PlAKKPtX9X3
	 K2Y9aEHpt4nz5hwAnWnjLFOFCtzlNY9YBT1AR9H6OHpB+3ZnevSaw7gfO7GPPuz68u
	 5znE1Qj0qrzqsUunFWMjfPRgo2Hj4m8qGMHuLT/s=
Date: Mon, 20 Jul 2026 16:05:51 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch added to mm-new branch
Message-Id: <20260720230551.9093E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: convert folio_referenced() to use vma_flags_t
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: convert folio_referenced() to use vma_flags_t
Date: Mon, 20 Jul 2026 19:12:00 +0800

Patch series "promote mapped executable folios after first usage for
MGLRU", v4.

Now MGLRU's protection of mapped executable file folios is less reliable. 
Follow the classical LRU's logic, promoting mapped executable file folios
after their first usage to give executable code a better chance to stay in
memory and improve workload performance (See patch 2 for more details).


This patch (of 3):

Replace use of the legacy vm_flags_t flags with vma_flags_t values for
folio_referenced() and related logic.  This is also a preparation for the
following changes.

No functional changes.

Link: https://lore.kernel.org/cover.1784509721.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/2bd39e16ec19e3e3c4716aa9a1a25775c26cac57.1784509721.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    7 +++----
 mm/rmap.c            |   19 +++++++++++--------
 mm/vmscan.c          |   14 +++++++-------
 3 files changed, 21 insertions(+), 19 deletions(-)

--- a/include/linux/rmap.h~mm-vmscan-convert-folio_referenced-to-use-vma_flags_t
+++ a/include/linux/rmap.h
@@ -843,7 +843,7 @@ static inline int folio_try_share_anon_r
  * Called from mm/vmscan.c to handle paging out
  */
 int folio_referenced(struct folio *, int is_locked,
-			struct mem_cgroup *memcg, vm_flags_t *vm_flags);
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags);
 
 void try_to_migrate(struct folio *folio, enum ttu_flags flags);
 void try_to_unmap(struct folio *, enum ttu_flags flags);
@@ -977,10 +977,9 @@ struct anon_vma *folio_lock_anon_vma_rea
 #define anon_vma_prepare(vma)	(0)
 
 static inline int folio_referenced(struct folio *folio, int is_locked,
-				  struct mem_cgroup *memcg,
-				  vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	return 0;
 }
 
--- a/mm/rmap.c~mm-vmscan-convert-folio_referenced-to-use-vma_flags_t
+++ a/mm/rmap.c
@@ -908,7 +908,7 @@ out:
 struct folio_referenced_arg {
 	int mapcount;
 	int referenced;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	struct mem_cgroup *memcg;
 };
 
@@ -927,7 +927,7 @@ static bool folio_referenced_one(struct
 		address = pvmw.address;
 		nr = 1;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma_test(vma, VMA_LOCKED_BIT)) {
 			ptes++;
 			pra->mapcount--;
 
@@ -948,7 +948,7 @@ static bool folio_referenced_one(struct
 			/* Restore the mlock which got missed */
 			mlock_vma_folio(folio, vma);
 			page_vma_mapped_walk_done(&pvmw);
-			pra->vm_flags |= VM_LOCKED;
+			vma_flags_set(&pra->vma_flags, VMA_LOCKED_BIT);
 			return false; /* To break the loop */
 		}
 
@@ -1016,8 +1016,11 @@ static bool folio_referenced_one(struct
 		referenced++;
 
 	if (referenced) {
+		vma_flags_t vma_flags = vma->flags;
+
 		pra->referenced++;
-		pra->vm_flags |= vma->vm_flags & ~VM_LOCKED;
+		vma_flags_clear(&vma_flags, VMA_LOCKED_BIT);
+		vma_flags_set_mask(&pra->vma_flags, vma_flags);
 	}
 
 	if (!pra->mapcount)
@@ -1055,7 +1058,7 @@ static bool invalid_folio_referenced_vma
  * @folio: The folio to test.
  * @is_locked: Caller holds lock on the folio.
  * @memcg: target memory cgroup
- * @vm_flags: A combination of all the vma->vm_flags which referenced the folio.
+ * @vma_flags: A combination of all the vma->flags which referenced the folio.
  *
  * Quick test_and_clear_referenced for all mappings of a folio,
  *
@@ -1063,7 +1066,7 @@ static bool invalid_folio_referenced_vma
  * the function bailed out due to rmap lock contention.
  */
 int folio_referenced(struct folio *folio, int is_locked,
-		     struct mem_cgroup *memcg, vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
 	bool we_locked = false;
 	struct folio_referenced_arg pra = {
@@ -1079,7 +1082,7 @@ int folio_referenced(struct folio *folio
 	};
 
 	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	if (!pra.mapcount)
 		return 0;
 
@@ -1093,7 +1096,7 @@ int folio_referenced(struct folio *folio
 	}
 
 	rmap_walk(folio, &rwc);
-	*vm_flags = pra.vm_flags;
+	vma_flags_set_mask(vma_flags, pra.vma_flags);
 
 	if (we_locked)
 		folio_unlock(folio);
--- a/mm/vmscan.c~mm-vmscan-convert-folio_referenced-to-use-vma_flags_t
+++ a/mm/vmscan.c
@@ -861,16 +861,16 @@ static enum folio_references folio_check
 						  struct scan_control *sc)
 {
 	int referenced_ptes, referenced_folio;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 
 	referenced_ptes = folio_referenced(folio, 1, sc->target_mem_cgroup,
-					   &vm_flags);
+					   &vma_flags);
 
 	/*
 	 * The supposedly reclaimable folio was found to be in a VM_LOCKED vma.
 	 * Let the folio, now marked Mlocked, be moved to the unevictable list.
 	 */
-	if (vm_flags & VM_LOCKED)
+	if (vma_flags_test(&vma_flags, VMA_LOCKED_BIT))
 		return FOLIOREF_ACTIVATE;
 
 	/*
@@ -914,7 +914,7 @@ static enum folio_references folio_check
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio))
+		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2063,7 +2063,7 @@ static void shrink_active_list(unsigned
 {
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
@@ -2107,7 +2107,7 @@ static void shrink_active_list(unsigned
 
 		/* Referenced or rmap lock contention: rotate */
 		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
-				     &vm_flags) != 0) {
+				     &vma_flags) != 0) {
 			/*
 			 * Identify referenced, file-backed active folios and
 			 * give them one more trip around the active list. So
@@ -2117,7 +2117,7 @@ static void shrink_active_list(unsigned
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio)) {
+			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch
mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

