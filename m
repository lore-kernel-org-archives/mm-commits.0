Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CDB33936C
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465784; cv=none; b=SCdnloRSDUXMhnvYlC7ClITy9jgJVAw7O50Wd0buH9eIKKZSAcPpqB9ny/aLzIvFta7f+2oQGBgdmnQUmyRGe14jGdVy1NTIXODpXphqoM64RctxkU3neh0b2DGgDzQPka4MU2C7ePo0TrtPdbxwF/LSJ6phiFYlWANAGT/9gPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465784; c=relaxed/simple;
	bh=HkagI8oMxe+BoaQBrCRBmYSO7AdlZBQfelg9iFBX9IU=;
	h=Date:To:From:Subject:Message-Id; b=n+lCcZuDZ5GAwXPhIn+8lZtgVsEeQoKImrtWhDD53OiNJKMn0Ic8DUa6bcQgqnoCOUI69B0xksnQqkZXL/8GYStVqWdqSiqcMmoiiSvzVoFVDwLtRycieWXtVSRpyJFW3H4bAhPfAtaAHmiLQtFmE7un6EX81HMfvkcWK8qcCJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V45Q7Pyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V45Q7Pyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AC31F00A3A;
	Fri, 31 Jul 2026 02:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465782;
	bh=MODWoOMETKzAjy6tJD8SQJCyIx6V4jvTYTbc6e0xcgI=;
	h=Date:To:From:Subject;
	b=V45Q7Pyv9D93vdNlAjKxvdCWsjXEeO4M4b3MGiLfpCC/JAtnvn1RgE+TsGpULeWmC
	 kX8am1NFfzUst6PRGmhhmaefRHmpu9HotlC89rpyk0IlBWTYBIt0s2EhPnj2gVoNSV
	 QP88xUzKNP4cs0yn6zQO+PmwDSf+uxpwWsjeklYU=
Date: Thu, 30 Jul 2026 19:43:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,yan.y.zhao@intel.com,vannapurve@google.com,shivankg@amd.com,shakeel.butt@linux.dev,seanjc@google.com,roman.gushchin@linux.dev,rientjes@google.com,rick.p.edgecombe@intel.com,rakie.kim@sk.com,qi.zheng@linux.dev,pratyush@kernel.org,peterx@redhat.com,pbonzini@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,muchun.song@linux.dev,michael.roth@amd.com,mhocko@kernel.org,matthew.brost@intel.com,jthoughton@google.com,joshua.hahnjy@gmail.com,jiaqiyan@google.com,jgg@ziepe.ca,gourry@gourry.net,fvdl@google.com,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol.patch removed from -mm tree
Message-Id: <20260731024302.A0AC31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm: hugetlb: move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
Date: Thu, 02 Jul 2026 09:21:46 -0700

Move memory policy interpretation out of
alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
separate reading and interpretation of memory policy from actual
allocation.

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely.  This opens doors for
other callers of the HugeTLB folio allocation function, such as
guest_memfd, where memory may not always be mapped and hence may not have
an associated vma.

Introduce struct mempolicy_interpreted to hold all the components of an
interpreted memory policy.

Rename alloc_buddy_hugetlb_folio_with_mpol() to
alloc_buddy_hugetlb_folio() since the function no longer interprets memory
policy.

No functional change intended.

Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-2-d53cefcccf34@google.com
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
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

 include/uapi/linux/mempolicy.h |    2 -
 mm/hugetlb.c                   |   54 ++++++++++++++++++++-----------
 2 files changed, 37 insertions(+), 19 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol
+++ a/include/uapi/linux/mempolicy.h
@@ -16,7 +16,7 @@
  */
 
 /* Policies */
-enum {
+enum mempolicy_mode {
 	MPOL_DEFAULT,
 	MPOL_PREFERRED,
 	MPOL_BIND,
--- a/mm/hugetlb.c~mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol
+++ a/mm/hugetlb.c
@@ -1316,6 +1316,12 @@ static unsigned long available_huge_page
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
+struct mempolicy_interpreted {
+	int nid;
+	nodemask_t *nodemask;
+	enum mempolicy_mode mode;
+};
+
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address)
@@ -2137,32 +2143,28 @@ static struct folio *alloc_migrate_huget
 	return folio;
 }
 
-/*
- * Use the VMA's mpolicy to allocate a huge page from the buddy.
- */
 static
-struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
+		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-	int nid;
-	nodemask_t *nodemask;
+	nodemask_t *nodemask = mpoli->nodemask;
 
-	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	if (mpol_is_preferred_many(mpol)) {
+	if (mpoli->mode == MPOL_PREFERRED_MANY) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
-		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
+						    nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!folio)
-		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
-	mpol_cond_put(mpol);
+	if (!folio) {
+		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
+						    nodemask);
+	}
+
 	return folio;
 }
 
@@ -2852,7 +2854,7 @@ struct folio *alloc_hugetlb_folio(struct
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	struct hugetlb_cgroup *h_cg_rsvd = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp = htlb_alloc_mask(h);
 
 	idx = hstate_index(h);
 
@@ -2924,8 +2926,24 @@ struct folio *alloc_hugetlb_folio(struct
 		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
 
 	if (!folio) {
+		struct mempolicy_interpreted mpoli;
+		struct mempolicy *mpol;
+		nodemask_t *nodemask;
+		int nid;
+
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+		mpoli = (struct mempolicy_interpreted){
+			.nid = nid,
+#ifdef CONFIG_NUMA
+			.mode = mpol ? mpol->mode : MPOL_DEFAULT,
+#else
+			.mode = MPOL_DEFAULT,
+#endif
+			.nodemask = nodemask,
+		};
+		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
+		mpol_cond_put(mpol);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
@@ -2981,7 +2999,7 @@ struct folio *alloc_hugetlb_folio(struct
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
_

Patches currently in -mm which might be from ackerleytng@google.com are


