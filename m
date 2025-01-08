Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38992E40E
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 03:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308363; cv=none; b=EHTYf8/VH/AebOxMA+kCWq2KLMRNORiWbLN0qfhThsc53dvirSX7X5Q4TS1PryGIDggGgOyThys7Gs/CVVWETdNytsp8242rV4Pcs2Xx+6fx6ET8NGeA0/5kUu8VVmQFY71i9tgU3QG1tnKIy7JDnob7sI0WvuTfSihMq4XqPdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308363; c=relaxed/simple;
	bh=Q+howBrPiwZZxTUy2PWnyZng2Xj0RQm8bU4zcGzKMkA=;
	h=Date:To:From:Subject:Message-Id; b=r55Rd+zxUIF+DQZDhyz1xCKjcTyUEDxO3nGOE058D9BL5bZhta/nWUS5c3oWs1itptc5kIgSs6QqT6+3BeJoN9AkYxb6v+bNzmwVCWg4UZSc5FCD7jdUZkvNbEXRrZr/9d9xGqS1qOX/+nEzuyxF2GVSgPt8PRhfxdTCcwsP3jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X1PwvxWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X1PwvxWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE05C4CEDD;
	Wed,  8 Jan 2025 03:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736308363;
	bh=Q+howBrPiwZZxTUy2PWnyZng2Xj0RQm8bU4zcGzKMkA=;
	h=Date:To:From:Subject:From;
	b=X1PwvxWMZP2IOlEVJLEtyiPfQJ7ibIjo92kwviO+i3mxUNnhL+v4iTDWM3FRON9xZ
	 9/jV1OC1alodDXdMpqnYzjDUSlZr7R++6Z5rHHe2b5mF77UzAPyoIlc4eC++yP7j6W
	 XaKstxeO7ezCKJ9aEf4c1BLdTf8mTbnawpPRcCEI=
Date: Tue, 07 Jan 2025 19:52:42 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch added to mm-unstable branch
Message-Id: <20250108035243.2AE05C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: clean up map/global resv accounting when allocate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch

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
Subject: mm/hugetlb: clean up map/global resv accounting when allocate
Date: Tue, 7 Jan 2025 15:39:59 -0500

alloc_hugetlb_folio() isn't a function easy to read, especially on
reservation accountings for either VMA or globally (majorly, spool only).

The 1st complexity lies in the special private CoW path, aka,
cow_from_owner=true case.

The 2nd complexity may be the confusing updates of gbl_chg after it's set
once, which looks like they can change anytime on the fly.

Logically, cow_from_user is only about vma reservation.  We could already
decouple the flag and consolidate it into map charge flag very early. 
Then we don't need to keep checking the CoW special flag every time.

This patch does it by making map_chg a tri-state flag.  Tri-state needed
is unfortunate, and it's because currently vma_needs_reservation() has a
side effect internally, that it must be followed by either a end() or
commit().

We keep the same semantic as before on one thing: "if (map_chg)" means we
need a separate per-vma resv count.  It keeps most of the old code like
before untouched with the new enum.

After this patch, we take these steps to decide these variables, hopefully
slightly easier to follow:

  - First, decide map_chg.  This will take cow_from_owner into account,
    once and for all.  It's about whether we could take a resv count from
    the vma, no matter it's shared, private, etc.

  - Then, decide gbl_chg.  The only diff here is spool, comparing to
    map_chg.

Now only update each flag once and for all, instead of keep any of them
flipping which can be very hard to follow.

With cow_from_owner merged into map_chg, we could remove quite a few such
checks all over.  Side benefit of such is that we can get rid of one more
confusing flag, which is deferred_reserve.

Cleanup the comments a bit too.  E.g., MAP_NORESERVE may not need to check
against spool limit, AFAIU, if it's on a shared mapping, and if the page
cache folio has its inode's resv map available (in which case map_chg
would have been set zero, hence the code should be correct, not the
comment).

There's one trivial detail that needs attention that this patch touched,
which is this check right after vma_commit_reservation():

  if (map_chg > map_commit)

It changes to:

  if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0))

It should behave the same like before, because previously the only way to
make "map_chg > map_commit" happen is map_chg=1 && map_commit=0.  That's
exactly the rewritten line.  Meanwhile, either commit() or end() will need
to be skipped if ENFORCE, to keep the old behavior.

Even though it looks a lot changed, but no functional change expected.

Link: https://lkml.kernel.org/r/20250107204002.2683356-5-peterx@redhat.com
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

 mm/hugetlb.c |  110 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 77 insertions(+), 33 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate
+++ a/mm/hugetlb.c
@@ -2970,6 +2970,25 @@ int isolate_or_dissolve_huge_page(struct
 	return ret;
 }
 
+typedef enum {
+	/*
+	 * For either 0/1: we checked the per-vma resv map, and one resv
+	 * count either can be reused (0), or an extra needed (1).
+	 */
+	MAP_CHG_REUSE = 0,
+	MAP_CHG_NEEDED = 1,
+	/*
+	 * Cannot use per-vma resv count can be used, hence a new resv
+	 * count is enforced.
+	 *
+	 * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
+	 * that currently vma_needs_reservation() has an unwanted side
+	 * effect to either use end() or commit() to complete the
+	 * transaction.	 Hence it needs to differenciate from NEEDED.
+	 */
+	MAP_CHG_ENFORCED = 2,
+} map_chg_state;
+
 /*
  *  replace_free_hugepage_folios - Replace free hugepage folios in a given pfn
  *  range with new folios.
@@ -3021,40 +3040,59 @@ struct folio *alloc_hugetlb_folio(struct
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long map_chg, map_commit;
-	long gbl_chg;
+	long retval, gbl_chg;
+	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	bool deferred_reserve;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
-	/*
-	 * Examine the region/reserve map to determine if the process
-	 * has a reservation for the page to be allocated.  A return
-	 * code of zero indicates a reservation exists (no change).
-	 */
-	map_chg = gbl_chg = vma_needs_reservation(h, vma, addr);
-	if (map_chg < 0)
-		return ERR_PTR(-ENOMEM);
+
+	/* Whether we need a separate per-vma reservation? */
+	if (cow_from_owner) {
+		/*
+		 * Special case!  Since it's a CoW on top of a reserved
+		 * page, the private resv map doesn't count.  So it cannot
+		 * consume the per-vma resv map even if it's reserved.
+		 */
+		map_chg = MAP_CHG_ENFORCED;
+	} else {
+		/*
+		 * Examine the region/reserve map to determine if the process
+		 * has a reservation for the page to be allocated.  A return
+		 * code of zero indicates a reservation exists (no change).
+		 */
+		retval = vma_needs_reservation(h, vma, addr);
+		if (retval < 0)
+			return ERR_PTR(-ENOMEM);
+		map_chg = retval ? MAP_CHG_NEEDED : MAP_CHG_REUSE;
+	}
 
 	/*
+	 * Whether we need a separate global reservation?
+	 *
 	 * Processes that did not create the mapping will have no
 	 * reserves as indicated by the region/reserve map. Check
 	 * that the allocation will not exceed the subpool limit.
-	 * Allocations for MAP_NORESERVE mappings also need to be
-	 * checked against any subpool limit.
+	 * Or if it can get one from the pool reservation directly.
 	 */
-	if (map_chg || cow_from_owner) {
+	if (map_chg) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
 		if (gbl_chg < 0)
 			goto out_end_reservation;
+	} else {
+		/*
+		 * If we have the vma reservation ready, no need for extra
+		 * global reservation.
+		 */
+		gbl_chg = 0;
 	}
 
-	/* If this allocation is not consuming a reservation, charge it now.
+	/*
+	 * If this allocation is not consuming a per-vma reservation,
+	 * charge the hugetlb cgroup now.
 	 */
-	deferred_reserve = map_chg || cow_from_owner;
-	if (deferred_reserve) {
+	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
 		if (ret)
@@ -3078,7 +3116,7 @@ struct folio *alloc_hugetlb_folio(struct
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
-		if (!cow_from_owner && vma_has_reserves(vma, gbl_chg)) {
+		if (vma_has_reserves(vma, gbl_chg)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			h->resv_huge_pages--;
 		}
@@ -3091,7 +3129,7 @@ struct folio *alloc_hugetlb_folio(struct
 	/* If allocation is not consuming a reservation, also store the
 	 * hugetlb_cgroup pointer on the page.
 	 */
-	if (deferred_reserve) {
+	if (map_chg) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
 						  h_cg, folio);
 	}
@@ -3100,26 +3138,31 @@ struct folio *alloc_hugetlb_folio(struct
 
 	hugetlb_set_folio_subpool(folio, spool);
 
-	map_commit = vma_commit_reservation(h, vma, addr);
-	if (unlikely(map_chg > map_commit)) {
+	if (map_chg != MAP_CHG_ENFORCED) {
+		/* commit() is only needed if the map_chg is not enforced */
+		retval = vma_commit_reservation(h, vma, addr);
 		/*
+		 * Check for possible race conditions. When it happens..
 		 * The page was added to the reservation map between
 		 * vma_needs_reservation and vma_commit_reservation.
 		 * This indicates a race with hugetlb_reserve_pages.
 		 * Adjust for the subpool count incremented above AND
-		 * in hugetlb_reserve_pages for the same page.  Also,
+		 * in hugetlb_reserve_pages for the same page.	Also,
 		 * the reservation count added in hugetlb_reserve_pages
 		 * no longer applies.
 		 */
-		long rsv_adjust;
+		if (unlikely(map_chg == MAP_CHG_NEEDED && retval == 0)) {
+			long rsv_adjust;
 
-		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -rsv_adjust);
-		if (deferred_reserve) {
-			spin_lock_irq(&hugetlb_lock);
-			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
-					pages_per_huge_page(h), folio);
-			spin_unlock_irq(&hugetlb_lock);
+			rsv_adjust = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -rsv_adjust);
+			if (map_chg) {
+				spin_lock_irq(&hugetlb_lock);
+				hugetlb_cgroup_uncharge_folio_rsvd(
+				    hstate_index(h), pages_per_huge_page(h),
+				    folio);
+				spin_unlock_irq(&hugetlb_lock);
+			}
 		}
 	}
 
@@ -3141,14 +3184,15 @@ struct folio *alloc_hugetlb_folio(struct
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
 out_uncharge_cgroup_reservation:
-	if (deferred_reserve)
+	if (map_chg)
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg);
 out_subpool_put:
-	if (map_chg || cow_from_owner)
+	if (map_chg)
 		hugepage_subpool_put_pages(spool, 1);
 out_end_reservation:
-	vma_end_reservation(h, vma, addr);
+	if (map_chg != MAP_CHG_ENFORCED)
+		vma_end_reservation(h, vma, addr);
 	return ERR_PTR(-ENOSPC);
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-avoid_reserve-to-allow-taking-folio-from-subpool.patch
mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch
mm-hugetlb-rename-avoid_reserve-to-cow_from_owner.patch
mm-hugetlb-clean-up-map-global-resv-accounting-when-allocate.patch
mm-hugetlb-simplify-vma_has_reserves.patch
mm-hugetlb-drop-vma_has_reserves.patch
mm-hugetlb-unify-restore-reserve-accounting-for-new-allocations.patch

