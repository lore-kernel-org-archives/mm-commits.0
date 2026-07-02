Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749773B5851
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 22:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783030359; cv=none; b=CvgnVs/jHDxsKq1fyQUgg+AET9YrmlMySzyDVcx8U2CNfTI/1mbRcctnfnuvXtdZK5ftA5Wy8SvCM1SAaPxlAL5LbJSHzW0Mxi+kCG57IWSP9yuIn/gyFDSfL+23PynMyN1ZJoCEY4ErsD23TDvB+kfUOiiuXdsx7jZGy0Asakk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783030359; c=relaxed/simple;
	bh=B35dkfKOumemiqeoXhIzBMxmMappPnxGiSp2kzrJ47U=;
	h=Date:To:From:Subject:Message-Id; b=P+4erWrUiYvRLGNLcGGDcsTYGsfVjSgwkhoMpse1K/rYa9Uss+DKHAMpnl1FhNjn53f1chO/XS04ilTzQv1I6EyAZ9fEA0t+xDM2OtpxZB3819Tjf4UqaUzcOajrPqeMY2SflJ9tHv8E9rhr0jAi+3Ofgx+wgkzAnYdKKzLO37M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QknP006S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QknP006S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0853D1F000E9;
	Thu,  2 Jul 2026 22:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783030358;
	bh=bAMQBHbUlrhX2s07zJW9s+xHvVTdY88RIkWO7jk+wdY=;
	h=Date:To:From:Subject;
	b=QknP006SwZ0DKt2uIGsUCSPkLxhHh4liocm6eoN7RVtzqf8OregSRqc5gj5rbsCkm
	 8i0k6LInkKvXw1+ZKwOa/vhW20IsyqAhJ8VMjOhCfavYmWHak/iNJqKHmEZv9pSzEP
	 SUbe/4kab8xbwVRV1Osh9sBfs8VreKiSr5hcYrj4=
Date: Thu, 02 Jul 2026 15:12:37 -0700
To: mm-commits@vger.kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch added to mm-new branch
Message-Id: <20260702221238.0853D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: move mpol interpretation out of dequeue_hugetlb_folio_vma()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch

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

mm-hugetlb-consolidate-interpretation-of-gbl_chg-within-alloc_hugetlb_folio.patch
mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol.patch
mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch
mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch
mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch
mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch

