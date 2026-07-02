Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4433AB466
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783030367; cv=none; b=Xet77ut5PlqC3hb5l6uMaI/CyXlNfU/fPuw9W3g5OY3m82htZMVGassGYnGdSxs0sg1cRDGha6QXwhgEvOz6M5aU5BxpkFL5sgb9ip0HZSgUeKD7R5q4AFitPXhLwBuZFdojuGc4kmBudvHJrSeCXsmB2DBHJwS5xvpzm7h/ffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783030367; c=relaxed/simple;
	bh=o8/T8vVFlpcLzxErX1Bzsj9NvYdAJfAdXPlRhxZhKWw=;
	h=Date:To:From:Subject:Message-Id; b=o0qmYaOLJDeAQxVN7VECbYZM3SdfqR1XGnU31v0hRcElj++5QYWxiuGcbixmgLSrwHaIxmnWiHC5DNmc4rPvtlLBs3i0a71jXinloS8dla9Ekvgyu3R2JT+IvSEoBA8MR+FLOAGtdo9+LcSOsbxBHDgL5Tp3EwGCFpqqYNynhh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1eA61gc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1eA61gc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9341F000E9;
	Thu,  2 Jul 2026 22:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783030365;
	bh=6NmeWF/ZecSWjwO3/hqFYf/YeNtoa1LJbJCkuOZBiYM=;
	h=Date:To:From:Subject;
	b=1eA61gc2FWEvi+NTg8bMTOT4mB8w+ZLFfGqoEqaoWdw5l0EGxbCmt3vhfH5bWkf0b
	 PnCPFibUc6TssirmYUuI+bMNB55d2W+Nxl0+NcHPCvoUhcE/VHEBxWHX8Ab4OpWm/5
	 319WO8r8pD5h9taNgut3TpJEW4TKnLj12PLC7HqE=
Date: Thu, 02 Jul 2026 15:12:44 -0700
To: mm-commits@vger.kernel.org,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch added to mm-new branch
Message-Id: <20260702221245.0C9341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: refactor out hugetlb_alloc_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch

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
Subject: mm: hugetlb: refactor out hugetlb_alloc_folio()
Date: Thu, 02 Jul 2026 09:21:50 -0700

Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
handles allocation of a folio and memory and HugeTLB charging to cgroups.

This refactoring decouples the HugeTLB page allocation from VMAs,
specifically:

1. Reservations (as in resv_map) are stored in the vma
2. mpol is stored at vma->vm_policy
3. A vma must be used for allocation even if the pages are not meant to be
   used by host process.

Without this coupling, VMAs are no longer a requirement for allocation. 
This opens up the allocation routine for usage without VMAs, which will
allow guest_memfd to use HugeTLB as a more generic allocator of huge
pages, since guest_memfd memory may not have any associated VMAs by
design.  In addition, direct allocations from HugeTLB could possibly be
refactored to avoid the use of a pseudo-VMA.

Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
subpool is stored at the fs mount.  This is also a requirement for
guest_memfd, where the plan is to have a subpool created per-fd and stored
on the inode.

Provide and use alloc_flags to allow more allocation knobs in future
without expanding the number of parameters in hugetlb_alloc_folio().

No functional change intended.

Link: https://lore.kernel.org/20260702-hugetlb-open-up-v4-6-d53cefcccf34@google.com
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: James Houghton <jthoughton@google.com>
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
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   18 +++
 mm/hugetlb.c            |  206 ++++++++++++++++++++------------------
 2 files changed, 131 insertions(+), 93 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-out-hugetlb_alloc_folio
+++ a/include/linux/hugetlb.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_HUGETLB_H
 #define _LINUX_HUGETLB_H
 
+#include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/mmdebug.h>
@@ -682,6 +683,23 @@ struct hstate {
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
+
+struct mempolicy_interpreted {
+	int nid;
+	nodemask_t *nodemask;
+	enum mempolicy_mode mode;
+};
+
+enum hugetlb_alloc_flag {
+	HUGETLB_ALLOC_CHARGE_CGROUP_RSVD_BIT = 0,
+	HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT,
+};
+
+#define HUGETLB_ALLOC_CHARG_CGROUP_RSVD BIT(HUGETLB_ALLOC_CHARGE_CGROUP_RSVD_BIT)
+#define HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS BIT(HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT)
+
+struct folio *hugetlb_alloc_folio(struct hstate *h,
+		struct mempolicy_interpreted *mpoli, u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
--- a/mm/hugetlb.c~mm-hugetlb-refactor-out-hugetlb_alloc_folio
+++ a/mm/hugetlb.c
@@ -1316,12 +1316,6 @@ static unsigned long available_huge_page
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
-struct mempolicy_interpreted {
-	int nid;
-	nodemask_t *nodemask;
-	enum mempolicy_mode mode;
-};
-
 static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 					   struct mempolicy_interpreted *mpoli)
 {
@@ -2811,6 +2805,104 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+/**
+ * hugetlb_alloc_folio - Allocate a hugetlb folio.
+ * @h: Hugetlb state control block.
+ * @mpoli: Interpreted memory policy to use for allocation.
+ * @alloc_flags: Flags controlling the allocation behavior.
+ *
+ * Allocates a hugetlb folio and handles cgroup charging and global hstate
+ * reservations.
+ *
+ * Return: A pointer to the allocated folio, or an ERR_PTR on failure.
+ *         -ENOSPC if cgroup charging fails or no folio is available.
+ *         -ENOMEM if mem cgroup charging fails.
+ */
+struct folio *hugetlb_alloc_folio(struct hstate *h,
+		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
+{
+	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
+					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
+	bool use_global_reservation = alloc_flags &
+				      HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
+	size_t nr_pages = pages_per_huge_page(h);
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
+	struct hugetlb_cgroup *h_cg = NULL;
+	gfp_t gfp = htlb_alloc_mask(h);
+	int idx = hstate_index(h);
+	struct folio *folio;
+	int ret;
+
+	if (charge_hugetlb_cgroup_rsvd &&
+	    hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg_rsvd))
+		return ERR_PTR(-ENOSPC);
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg)) {
+		ret = -ENOSPC;
+		goto err_uncharge_hugetlb_cgroup_rsvd;
+	}
+
+	spin_lock_irq(&hugetlb_lock);
+
+	folio = NULL;
+	if (use_global_reservation || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio(h, gfp, mpoli);
+
+	if (!folio) {
+		spin_unlock_irq(&hugetlb_lock);
+		folio = alloc_buddy_hugetlb_folio(h, gfp, mpoli);
+		if (!folio) {
+			ret = -ENOSPC;
+			goto err_uncharge_hugetlb_cgroup;
+		}
+		spin_lock_irq(&hugetlb_lock);
+		list_add(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
+	}
+
+	if (use_global_reservation) {
+		folio_set_hugetlb_restore_reserve(folio);
+		h->resv_huge_pages--;
+	}
+
+	hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
+
+	if (charge_hugetlb_cgroup_rsvd) {
+		hugetlb_cgroup_commit_charge_rsvd(idx, nr_pages, h_cg_rsvd,
+						  folio);
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here because if
+	 * mem_cgroup_charge_hugetlb failed, freeing the page will
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		/*
+		 * Skip uncharging hugetlb_cgroup since the charges
+		 * were committed to the folio and freeing the folio
+		 * would have cleared those up.
+		 */
+		return ERR_PTR(ret);
+	}
+
+	return folio;
+
+ err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+ err_uncharge_hugetlb_cgroup_rsvd:
+	if (charge_hugetlb_cgroup_rsvd)
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, nr_pages, h_cg_rsvd);
+
+	return ERR_PTR(ret);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
@@ -2845,16 +2937,13 @@ struct folio *alloc_hugetlb_folio(struct
 	struct folio *folio;
 	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
-	int ret, idx;
-	struct hugetlb_cgroup *h_cg = NULL;
-	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
+	u8 alloc_flags = 0;
 	int nid;
-
-	idx = hstate_index(h);
+	int ret;
 
 	/* Whether we need a separate per-vma reservation? */
 	if (cow_from_owner) {
@@ -2899,23 +2988,18 @@ struct folio *alloc_hugetlb_folio(struct
 	}
 
 	/*
-	 * If this allocation is not consuming a per-vma reservation,
-	 * charge the hugetlb cgroup now.
+	 * If allocation doesn't reuse a reservation in the resv_map,
+	 * charge for the reservation.
 	 */
-	if (map_chg) {
-		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg_rsvd);
-		if (ret) {
-			ret = -ENOSPC;
-			goto out_subpool_put;
-		}
-	}
+	if (map_chg != MAP_CHG_REUSE)
+		alloc_flags |= HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
 
-	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		ret = -ENOSPC;
-		goto out_uncharge_cgroup_reservation;
-	}
+	/*
+	 * gbl_chg == 0 indicates a reservation exists for this
+	 * allocation, so try to use it.
+	 */
+	if (gbl_chg == 0)
+		alloc_flags |= HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
 
 	/* Takes reference on mpol. */
 	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
@@ -2929,69 +3013,12 @@ struct folio *alloc_hugetlb_folio(struct
 		.nodemask = nodemask,
 	};
 
-	spin_lock_irq(&hugetlb_lock);
-
-	/*
-	 * gbl_chg == 0 indicates a reservation exists for the
-	 * allocation, so try dequeuing a page. In case there was no
-	 * reservation, try dequeuing a page if there are available
-	 * pages in the global pool.
-	 */
-	folio = NULL;
-	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio(h, gfp, &mpoli);
-
-	if (!folio) {
-		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
-		if (!folio) {
-			mpol_cond_put(mpol);
-			ret = -ENOSPC;
-			goto out_uncharge_cgroup;
-		}
-		spin_lock_irq(&hugetlb_lock);
-		list_add(&folio->lru, &h->hugepage_activelist);
-		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
-	}
+	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
 
 	mpol_cond_put(mpol);
 
-	/*
-	 * Either dequeued or buddy-allocated folio needs to add special
-	 * mark to the folio when it consumes a global reservation.
-	 */
-	if (!gbl_chg) {
-		folio_set_hugetlb_restore_reserve(folio);
-		h->resv_huge_pages--;
-	}
-
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
-	/* If allocation is not consuming a reservation, also store the
-	 * hugetlb_cgroup pointer on the page.
-	 */
-	if (map_chg) {
-		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg_rsvd, folio);
-	}
-
-	spin_unlock_irq(&hugetlb_lock);
-
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		/*
-		 * Skip uncharging hugetlb_cgroup since the charges
-		 * were committed to the folio and freeing the folio
-		 * would have cleared those up.
-		 */
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
 		goto out_subpool_put;
 	}
 
@@ -3024,12 +3051,6 @@ struct folio *alloc_hugetlb_folio(struct
 
 	return folio;
 
-out_uncharge_cgroup:
-	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
-out_uncharge_cgroup_reservation:
-	if (map_chg)
-		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg_rsvd);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
@@ -3040,7 +3061,6 @@ out_subpool_put:
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
-
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
_

Patches currently in -mm which might be from ackerleytng@google.com are

mm-hugetlb-consolidate-interpretation-of-gbl_chg-within-alloc_hugetlb_folio.patch
mm-hugetlb-move-mpol-interpretation-out-of-alloc_buddy_hugetlb_folio_with_mpol.patch
mm-hugetlb-move-mpol-interpretation-out-of-dequeue_hugetlb_folio_vma.patch
mm-hugetlb-use-error-variable-in-alloc_hugetlb_folio.patch
mm-hugetlb-move-mem_cgroup_charge_hugetlb-earlier-in-allocation.patch
mm-hugetlb-refactor-out-hugetlb_alloc_folio.patch

