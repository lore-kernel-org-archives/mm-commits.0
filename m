Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418DA3ACA75
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 06:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528790; cv=none; b=iyKWJv9q+fKCRZncT4eOD+4/yKSfRdLZThiqjV2wvKG5JG0YFyfg03jgWhIcQfpXSeEaJsRWWG/5+nMeucMxty7iZfJ7+SGIGipv9GioaSXuOMIaa+UBfYdESn1UxtoCi4m27lLOiL48qevy8V60JsJ2SUAexXYrWH1qisOLrkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528790; c=relaxed/simple;
	bh=HoimIH/AtX9n6t1+n+Xfsj1q8+8Ea98+CbDbgCNYnkw=;
	h=Date:To:From:Subject:Message-Id; b=dz7tB0q1AdX7+yoCNZcTbI1H2xyb0dLh16Plc6w22ZFMTSfDY/TQNUeqK5IXb8eTTrSnksZrcCiex5c+cP63MCJt2eRigqS2ZMsXkXfy9QkuIVExVjvwBuZdD7dGjp3YX5IoMpRa5TB2dJ7aJIgHwYKy4kjPsJaS+BZtvw3Yir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pXWpte0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pXWpte0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A51F000E9;
	Mon, 20 Jul 2026 06:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784528786;
	bh=3EgiF38J3Vd9SIyd+qjn3V8XQMq4CUoDzIm7e/5DdJw=;
	h=Date:To:From:Subject;
	b=pXWpte0bGpyVDtkil64JI5mGjGbw7zI+cm9N8our3o3g6gDAseeEwyeLobzZVixmZ
	 j4uXsNjQImzS6IJRolduuac13Mth6tABwDhsQNZRgyNnSK2qSRoD8xNFcbQtNKmTJP
	 /5z+uA5SyEi4Leht3qt8P45q8KNC/i9vXf6yC0co=
Date: Sun, 19 Jul 2026 23:26:26 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,riel@surriel.com,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,jannh@google.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20260720062626.9E2A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: convert folio_referenced() to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: convert folio_referenced() to use vma_flags_t
Date: Fri, 17 Jul 2026 18:05:33 +0800

Patch series "promote mapped executable folios after first usage for
MGLRU", v3.

Now MGLRU's protection of mapped executable file folios is less reliable. 
Follow the classical LRU's logic, promoting mapped executable file folios
after their first usage to give executable code a better chance to stay in
memory and improve workload performance (See patch 2 for more details).


This patch (of 2):

Replace use of the legacy vm_flags_t flags with vma_flags_t values for
folio_referenced() and related logic.  This is also a preparation for the
following changes.

No functional changes.

Link: https://lore.kernel.org/cover.1784268206.git.baolin.wang@linux.alibaba.com
Link: https://lore.kernel.org/b9ef058305d1b5d6b811114830d17dd05980cef2.1784268206.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
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
@@ -975,10 +975,9 @@ struct anon_vma *folio_lock_anon_vma_rea
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
@@ -907,7 +907,7 @@ out:
 struct folio_referenced_arg {
 	int mapcount;
 	int referenced;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	struct mem_cgroup *memcg;
 };
 
@@ -926,7 +926,7 @@ static bool folio_referenced_one(struct
 		address = pvmw.address;
 		nr = 1;
 
-		if (vma->vm_flags & VM_LOCKED) {
+		if (vma_test(vma, VMA_LOCKED_BIT)) {
 			ptes++;
 			pra->mapcount--;
 
@@ -947,7 +947,7 @@ static bool folio_referenced_one(struct
 			/* Restore the mlock which got missed */
 			mlock_vma_folio(folio, vma);
 			page_vma_mapped_walk_done(&pvmw);
-			pra->vm_flags |= VM_LOCKED;
+			vma_flags_set(&pra->vma_flags, VMA_LOCKED_BIT);
 			return false; /* To break the loop */
 		}
 
@@ -1015,8 +1015,11 @@ static bool folio_referenced_one(struct
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
@@ -1054,7 +1057,7 @@ static bool invalid_folio_referenced_vma
  * @folio: The folio to test.
  * @is_locked: Caller holds lock on the folio.
  * @memcg: target memory cgroup
- * @vm_flags: A combination of all the vma->vm_flags which referenced the folio.
+ * @vma_flags: A combination of all the vma->flags which referenced the folio.
  *
  * Quick test_and_clear_referenced for all mappings of a folio,
  *
@@ -1062,7 +1065,7 @@ static bool invalid_folio_referenced_vma
  * the function bailed out due to rmap lock contention.
  */
 int folio_referenced(struct folio *folio, int is_locked,
-		     struct mem_cgroup *memcg, vm_flags_t *vm_flags)
+		struct mem_cgroup *memcg, vma_flags_t *vma_flags)
 {
 	bool we_locked = false;
 	struct folio_referenced_arg pra = {
@@ -1078,7 +1081,7 @@ int folio_referenced(struct folio *folio
 	};
 
 	VM_WARN_ON_ONCE_FOLIO(folio_is_zone_device(folio), folio);
-	*vm_flags = 0;
+	vma_flags_clear_all(vma_flags);
 	if (!pra.mapcount)
 		return 0;
 
@@ -1092,7 +1095,7 @@ int folio_referenced(struct folio *folio
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
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

