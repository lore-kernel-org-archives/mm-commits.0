Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFAB33859B
	for <mm-commits@vger.kernel.org>; Mon,  1 Dec 2025 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764611446; cv=none; b=N1y4+iF17Md4wB+yX+vGoD+GEiJsG19mrUp8oFHjt5+LT3Bc5Nijeb8RWOxg4qKORCn7QbqM3UGOsSuUOcbnqYr7xrQw+W6lGOixIWzrG7A485XGp0N6zcJF9Yi2yerRbAm0eVJGs9daTTzOqrF+EDz0OeifoTbU7hryY7WXfXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764611446; c=relaxed/simple;
	bh=qyc1/ZZ+1fKsIr230/X1g2BKFeBOXugHC0JAMR7t1mE=;
	h=Date:To:From:Subject:Message-Id; b=pI7r3JVUV5bCmLIAMkAlw20zVWJSq/cv1OTz/p2qtAm3tICkDWArQ7go9Rm7l25OuwN7bYoVh3Oz1ZxfwcwjpWvkOq/HnY0HdKIqxkFHKVtcfZjUjZwSGfibj5y+SKdpnIxsVr/41dKMOj2LpbPGKGNJ/vYBoDbwpAgUpHDCPcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7FqTGXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7FqTGXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BE5C4CEF1;
	Mon,  1 Dec 2025 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764611446;
	bh=qyc1/ZZ+1fKsIr230/X1g2BKFeBOXugHC0JAMR7t1mE=;
	h=Date:To:From:Subject:From;
	b=h7FqTGXXOYpecI5Lzw4dIv0vSsrYDLDgAFsIeTUEGGCRNSs9lRcbxuMhiG62YJIFf
	 WbVXSTH6E0e6dl9D2B3wtN31JIRimNO0XgFi3NJXayKH2ezNP2fv80xkgtQuG/4d8l
	 5/0A6hE44Me5TlHEIG0ZTgYEwm1JwgkcgBFFMzH4=
Date: Mon, 01 Dec 2025 09:50:45 -0800
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,osalvador@suse.de,nicolinc@nvidia.com,muchun.song@linux.dev,mochs@nvidia.com,joshua.hahnjy@gmail.com,jgg@nvidia.com,skolothumtho@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages.patch added to mm-unstable branch
Message-Id: <20251201175045.E3BE5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix incorrect error return from hugetlb_reserve_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages.patch

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

mm-hugetlb-fix-incorrect-error-return-from-hugetlb_reserve_pages.patch

