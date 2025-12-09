Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173F30649A
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308390; cv=none; b=d2xcEDE/Yg8pyeD6tNwshBJrLYvs+SRdycAHT2YmMaT8o5HVSxeDWfU0ixWdfpmX0e4asQSg3pRHt7kHFZg7DJdjVcSHe91+tRmycPZjiClN92XxXkieO6umZvwasftjfMFcv56Cs43X3UlukCQxbt7HNoGIjjC8ZO78M6CDuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308390; c=relaxed/simple;
	bh=lrEayZ0zXWVGrYdF5Yntaar4g9hBsTRK484hEOMhh9E=;
	h=Date:To:From:Subject:Message-Id; b=j4t9BWHOoytgnxBgztoKEOSE29bh5zaoR9YsLccANUXo5FuNZQqpHkwKKFDmKCy2fzJR30cW/MZDbmCwoiJbKBFM9f9loId3dNN098OtxkboITkhrDrQICiY1Qkmg3fSv/oZsVFX3JglUo3xF4+WA9MOlB2soCRtiQazWCKbhJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/VCmox6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/VCmox6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DF0C4CEFB;
	Tue,  9 Dec 2025 19:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308389;
	bh=lrEayZ0zXWVGrYdF5Yntaar4g9hBsTRK484hEOMhh9E=;
	h=Date:To:From:Subject:From;
	b=J/VCmox6Bk6uZIu4t5CeS2MmINwNIXpUQQE70BUHrAo9SF2KDbP9QQ/VOCcbAzRmk
	 WXcKHw2eXwS4v+8lDxhPrdlAqzC8CNziD9J2tiPzzzVzozNvW2UeDXDk3ZFp439xl5
	 7qtWuvQiwZitGMRO+0uwlqRU9lC1XvfFy5wITbRI=
Date: Tue, 09 Dec 2025 11:26:28 -0800
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,osalvador@suse.de,nicolinc@nvidia.com,muchun.song@linux.dev,mochs@nvidia.com,joshua.hahnjy@gmail.com,jgg@nvidia.com,skolothumtho@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages.patch removed from -mm tree
Message-Id: <20251209192629.62DF0C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix incorrect error return from hugetlb_reserve_pages()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shameer Kolothum <skolothumtho@nvidia.com>
Subject: mm/hugetlb: fix incorrect error return from hugetlb_reserve_pages()
Date: Tue, 25 Nov 2025 17:13:50 +0000

The function hugetlb_reserve_pages() returns the number of pages added
to the reservation map on success and a negative error code on failure
(e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
directly.

For example, a failure at:

    if (hugetlb_acct_memory(h, gbl_reserve) < 0)
        goto out_put_pages;

results in returning -1 (since add = -1), which may be misinterpreted
in userspace as -EPERM.

Fix this by explicitly capturing and propagating the return values from
helper functions, and using -EINVAL for all other failure cases.

Link: https://lkml.kernel.org/r/20251125171350.86441-1-skolothumtho@nvidia.com
Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew R. Ochs <mochs@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages
+++ a/mm/hugetlb.c
@@ -6579,6 +6579,7 @@ long hugetlb_reserve_pages(struct inode
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	int err;
 
 	/* This should never happen */
 	if (from > to) {
@@ -6612,8 +6613,10 @@ long hugetlb_reserve_pages(struct inode
 	} else {
 		/* Private mapping. */
 		resv_map = resv_map_alloc();
-		if (!resv_map)
+		if (!resv_map) {
+			err = -ENOMEM;
 			goto out_err;
+		}
 
 		chg = to - from;
 
@@ -6621,11 +6624,15 @@ long hugetlb_reserve_pages(struct inode
 		set_vma_desc_resv_flags(desc, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
+	if (chg < 0) {
+		/* region_chg() above can return -ENOMEM */
+		err = (chg == -ENOMEM) ? -ENOMEM : -EINVAL;
 		goto out_err;
+	}
 
-	if (hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
-				chg * pages_per_huge_page(h), &h_cg) < 0)
+	err = hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
+				chg * pages_per_huge_page(h), &h_cg);
+	if (err < 0)
 		goto out_err;
 
 	if (desc && !(desc->vm_flags & VM_MAYSHARE) && h_cg) {
@@ -6641,14 +6648,17 @@ long hugetlb_reserve_pages(struct inode
 	 * reservations already in place (gbl_reserve).
 	 */
 	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_reserve < 0)
+	if (gbl_reserve < 0) {
+		err = gbl_reserve;
 		goto out_uncharge_cgroup;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	if (hugetlb_acct_memory(h, gbl_reserve) < 0)
+	err = hugetlb_acct_memory(h, gbl_reserve);
+	if (err < 0)
 		goto out_put_pages;
 
 	/*
@@ -6667,6 +6677,7 @@ long hugetlb_reserve_pages(struct inode
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
+			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
@@ -6726,7 +6737,7 @@ out_err:
 		kref_put(&resv_map->refs, resv_map_release);
 		set_vma_desc_resv_map(desc, NULL);
 	}
-	return chg < 0 ? chg : add < 0 ? add : -EINVAL;
+	return err;
 }
 
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
_

Patches currently in -mm which might be from skolothumtho@nvidia.com are


