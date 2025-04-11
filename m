Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADC2290BC0;
	Fri, 11 Apr 2025 23:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744414088; cv=none; b=mmxHj1U6wWeOa64Em3j8NxR6g5fIYfqVHoXEs5R5L1RNti2GgxnGtg/L2xmKxfbne6LbF9MZUq2jxLtqR0r2uf1UG9dXAYO1D8Vi7sNdvyORM3V15pjWu3NsoKFC7N0tAkcIkDCm7MXRRz+O6c81QQml6PJYefIwfZ0URXDT1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744414088; c=relaxed/simple;
	bh=mOmQ75OpMhQoNbqGg9Et/yb4RCLF5cHRZ5C7oAIcwWY=;
	h=Date:To:From:Subject:Message-Id; b=BQWEh32ZMsK2Eukz9sTzHPn/nn2TI+FyYisdX/+bKcIZDQYgWCBHpM2ah0VGo5/4vWEFH3xePzbkEETl8JiFsqOJKiv5jynVlINFLCBn38+lF4Xqjlf4JbRVsPiM//nFmFuNT0t90BnlPla7VmZ2HbYpmR10V5w5/VRZhKf7Yz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXTVBarr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXTVBarr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75132C4CEE2;
	Fri, 11 Apr 2025 23:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744414087;
	bh=mOmQ75OpMhQoNbqGg9Et/yb4RCLF5cHRZ5C7oAIcwWY=;
	h=Date:To:From:Subject:From;
	b=iXTVBarrZsBSsF2+aWmWk+i1woBLaESRgmbDAL/iVkH/VCjMaTnWy/oSf3oD/chRJ
	 CVMQzP92ceEBIW58w8dh6Fc5eTZJT1cwBaE276LX2MONiDOiF/NJjvWd7QM/ouLg1V
	 uEaeeC5nZNNMo35PCJa3wka+2ZJQJcyrirVUqbzY=
Date: Fri, 11 Apr 2025 16:28:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,joshua.hahnjy@gmail.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-incorrect-fallback-for-subpool.patch added to mm-hotfixes-unstable branch
Message-Id: <20250411232807.75132C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: fix incorrect fallback for subpool
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-incorrect-fallback-for-subpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-incorrect-fallback-for-subpool.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Wupeng Ma <mawupeng1@huawei.com>
Subject: mm: hugetlb: fix incorrect fallback for subpool
Date: Thu, 10 Apr 2025 14:26:33 +0800

During our testing with hugetlb subpool enabled, we observe that
hstate->resv_huge_pages may underflow into negative values.  Root cause
analysis reveals a race condition in subpool reservation fallback handling
as follow:

hugetlb_reserve_pages()
    /* Attempt subpool reservation */
    gbl_reserve = hugepage_subpool_get_pages(spool, chg);

    /* Global reservation may fail after subpool allocation */
    if (hugetlb_acct_memory(h, gbl_reserve) < 0)
        goto out_put_pages;

out_put_pages:
    /* This incorrectly restores reservation to subpool */
    hugepage_subpool_put_pages(spool, chg);

When hugetlb_acct_memory() fails after subpool allocation, the current
implementation over-commits subpool reservations by returning the full
'chg' value instead of the actual allocated 'gbl_reserve' amount.  This
discrepancy propagates to global reservations during subsequent releases,
eventually causing resv_huge_pages underflow.

This problem can be trigger easily with the following steps:
1. reverse hugepage for hugeltb allocation
2. mount hugetlbfs with min_size to enable hugetlb subpool
3. alloc hugepages with two task(make sure the second will fail due to
   insufficient amount of hugepages)
4. with for a few seconds and repeat step 3 which will make
   hstate->resv_huge_pages to go below zero.

To fix this problem, return corrent amount of pages to subpool during the
fallback after hugepage_subpool_get_pages is called.

Link: https://lkml.kernel.org/r/20250410062633.3102457-1-mawupeng1@huawei.com
Fixes: 1c5ecae3a93f ("hugetlbfs: add minimum size accounting to subpools")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-incorrect-fallback-for-subpool
+++ a/mm/hugetlb.c
@@ -3010,7 +3010,7 @@ struct folio *alloc_hugetlb_folio(struct
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg;
+	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -3163,8 +3163,16 @@ out_uncharge_cgroup_reservation:
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg);
 out_subpool_put:
-	if (map_chg)
-		hugepage_subpool_put_pages(spool, 1);
+	/*
+	 * put page to subpool iff the quota of subpool's rsv_hpages is used
+	 * during hugepage_subpool_get_pages.
+	 */
+	if (map_chg && !gbl_chg) {
+		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+		hugetlb_acct_memory(h, -gbl_reserve);
+	}
+
+
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
@@ -7233,7 +7241,7 @@ bool hugetlb_reserve_pages(struct inode
 					struct vm_area_struct *vma,
 					vm_flags_t vm_flags)
 {
-	long chg = -1, add = -1;
+	long chg = -1, add = -1, spool_resv, gbl_resv;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
@@ -7368,8 +7376,16 @@ bool hugetlb_reserve_pages(struct inode
 	return true;
 
 out_put_pages:
-	/* put back original number of pages, chg */
-	(void)hugepage_subpool_put_pages(spool, chg);
+	spool_resv = chg - gbl_reserve;
+	if (spool_resv) {
+		/* put sub pool's reservation back, chg - gbl_reserve */
+		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
+		/*
+		 * subpool's reserved pages can not be put back due to race,
+		 * return to hstate.
+		 */
+		hugetlb_acct_memory(h, -gbl_resv);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-hugetlb-fix-incorrect-fallback-for-subpool.patch

