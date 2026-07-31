Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A132328635
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465785; cv=none; b=m3faU8bXyi4xVtW608tPMZjZ4NwAj0gYnmU0xqj4y/3EqDYcxdvZ9zIXChMACnOZq37TVkQ8WFGA/wH4hETG5jRadACx5BAQJPE+GOWu0i6HgGZe8+LEYXXyY3aYmZepwIUV/X7XX1PdlSkyoDoYzzCbrNqz3Uo+TYHf2nPjW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465785; c=relaxed/simple;
	bh=ZtpwJD7K+BsJ/0YgmzRXwAwUSHH9/P7RUNWQTjzzcPw=;
	h=Date:To:From:Subject:Message-Id; b=ayccqx8XYTatreIXmExnir1GnK0LCRdOT07OVs5xSd+Wu5TTr9nAZLqQO0haQFXE5bNtrib9ataUPw2tcfnjb16ES2VvfeP20n9CsjmbcvfaANC5yuFelrxmBhMrmVAMCoKO8xX2k2kQJ5jdsL8+ZPBtH5vOAKOk91v09iYBTms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zGsjXQPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zGsjXQPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1851F000E9;
	Fri, 31 Jul 2026 02:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465784;
	bh=tM2eCEvJv0GV3LpZhKx908B9DD3Dx+GqbwMzkXTCYIE=;
	h=Date:To:From:Subject;
	b=zGsjXQPEOXYwIbh933unVA8z/kLqfYJu2qHlEoRTMn0vBPGhljKNdgMVHBYtr+Wjw
	 +YpkPP/FPiHhOJ9by0HttdHFhRzaBnu7BuABxc8AuyFUC6qbtk1Dlb33s336JSj1ko
	 IcHIWzLb7W71HPrke/Pye9pHlgiofx96W/eFzSf0=
Date: Thu, 30 Jul 2026 19:43:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,yan.y.zhao@intel.com,vannapurve@google.com,shivankg@amd.com,shakeel.butt@linux.dev,seanjc@google.com,roman.gushchin@linux.dev,rientjes@google.com,rick.p.edgecombe@intel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pratyush@kernel.org,peterx@redhat.com,pbonzini@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,michael.roth@amd.com,mhocko@kernel.org,matthew.brost@intel.com,jthoughton@google.com,joshua.hahnjy@gmail.com,jiaqiyan@google.com,jgg@ziepe.ca,gourry@gourry.net,fvdl@google.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch removed from -mm tree
Message-Id: <20260731024304.1A1851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: move mpol interpretation out of dequeue_hugetlb_folio_vma()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm: hugetlb: move mpol interpretation out of dequeue_hugetlb_folio_vma()
Date: Thu, 02 Jul 2026 09:21:47 -0700

Move memory policy interpretation out of dequeue_hugetlb_folio_vma() and
into alloc_hugetlb_folio() to separate reading and interpretation of
memory policy from actual allocation.

Also rename dequeue_hugetlb_folio_vma() to
dequeue_hugetlb_folio_with_mpol() to remove association with vma and to
align with alloc_buddy_hugetlb_folio_with_mpol().

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely.  This opens doors for
other callers of the HugeTLB folio allocation function, such as
guest_memfd, where memory may not always be mapped and hence may not have
an associated vma.

No functional change intended.

Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-3-d53cefcccf34@google.com
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   66 +++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma
+++ a/mm/hugetlb.c
@@ -1322,32 +1322,26 @@ struct mempolicy_interpreted {
 	enum mempolicy_mode mode;
 };
 
-static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
-				struct vm_area_struct *vma,
-				unsigned long address)
+static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
+					   struct mempolicy_interpreted *mpoli)
 {
+	nodemask_t *nodemask = mpoli->nodemask;
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask;
-	nodemask_t *nodemask;
-	int nid;
-
-	gfp_mask = htlb_alloc_mask(h);
-	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
-	if (mpol_is_preferred_many(mpol)) {
+	if (mpoli->mode == MPOL_PREFERRED_MANY) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
-							nid, nodemask);
+						       mpoli->nid,
+						       nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!folio)
+	if (!folio) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
-							nid, nodemask);
-
-	mpol_cond_put(mpol);
+						       mpoli->nid,
+						       nodemask);
+	}
 	return folio;
 }
 
@@ -2854,7 +2848,11 @@ struct folio *alloc_hugetlb_folio(struct
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	struct hugetlb_cgroup *h_cg_rsvd = NULL;
+	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	int nid;
 
 	idx = hstate_index(h);
 
@@ -2913,6 +2911,18 @@ struct folio *alloc_hugetlb_folio(struct
 	if (ret)
 		goto out_uncharge_cgroup_reservation;
 
+	/* Takes reference on mpol. */
+	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+	mpoli = (struct mempolicy_interpreted){
+		.nid = nid,
+#ifdef CONFIG_NUMA
+		.mode = mpol ? mpol->mode : MPOL_DEFAULT,
+#else
+		.mode = MPOL_DEFAULT,
+#endif
+		.nodemask = nodemask,
+	};
+
 	spin_lock_irq(&hugetlb_lock);
 
 	/*
@@ -2923,35 +2933,23 @@ struct folio *alloc_hugetlb_folio(struct
 	 */
 	folio = NULL;
 	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+		folio = dequeue_hugetlb_folio(h, gfp, &mpoli);
 
 	if (!folio) {
-		struct mempolicy_interpreted mpoli;
-		struct mempolicy *mpol;
-		nodemask_t *nodemask;
-		int nid;
-
 		spin_unlock_irq(&hugetlb_lock);
-		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
-		mpoli = (struct mempolicy_interpreted){
-			.nid = nid,
-#ifdef CONFIG_NUMA
-			.mode = mpol ? mpol->mode : MPOL_DEFAULT,
-#else
-			.mode = MPOL_DEFAULT,
-#endif
-			.nodemask = nodemask,
-		};
 		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
-		mpol_cond_put(mpol);
-		if (!folio)
+		if (!folio) {
+			mpol_cond_put(mpol);
 			goto out_uncharge_cgroup;
+		}
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		/* Fall through */
 	}
 
+	mpol_cond_put(mpol);
+
 	/*
 	 * Either dequeued or buddy-allocated folio needs to add special
 	 * mark to the folio when it consumes a global reservation.
_

Patches currently in -mm which might be from ackerleytng@google.com are


