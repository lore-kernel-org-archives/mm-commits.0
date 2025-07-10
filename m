Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B4E22154B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126330; cv=none; b=O//CSjXb/fP8szEzkEbVDJSxjNlE5cKeMAAdZl0UqHFeQ9KmBzoC2AhnFxrk4gRghu9PcezTxDmFp69K5Qmgq0FwFX2wTYjwVfiJyP7ZJ+D/94t0ze2epBvnUttk/A4/3wOdo+B0x0c8lo09SC7ycCCstSz1yrIKCwS/GKQfjj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126330; c=relaxed/simple;
	bh=ktNONJQzwOW7UMl42PZNitcc1IhULyHzmJXkQSJ5fiE=;
	h=Date:To:From:Subject:Message-Id; b=DR4s5xD5uvJlNNrYyF0LO2Va52LBwp56SvkcdPc/i45/n8OF7SrlfOW/064F+yhbjAXBtox/ccpfQCqYbuod1nKU1BiSc5aOHBWGBMO80XnVTkrbKHdm1He9/y8AbcD7p1IWUkAwC+M68Nda/aY+VblRXadQKg2lOUdyrMgSvd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0JTHWfjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0JTHWfjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA73DC4CEE3;
	Thu, 10 Jul 2025 05:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126330;
	bh=ktNONJQzwOW7UMl42PZNitcc1IhULyHzmJXkQSJ5fiE=;
	h=Date:To:From:Subject:From;
	b=0JTHWfjZJgTaN0nCQOrqTXnPerIYTvBbdPdrnm1JB2jpXFC866TEmByzi3zIJRbCG
	 jQOBujwZvErUISaXguRj8P3cWjERF/gfsDdnEAB7AUoQw9VOge2JGnkTLjBOEL2QTy
	 tTvHp/0xUtbCk0wzm2ddnUoQ3Q4hIQ+KX3oBRiXo=
Date: Wed, 09 Jul 2025 22:45:29 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,kraxel@redhat.com,david@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-reserve-hugetlb-folios-before-allocation.patch removed from -mm tree
Message-Id: <20250710054529.EA73DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: reserve hugetlb folios before allocation
has been removed from the -mm tree.  Its filename was
     mm-memfd-reserve-hugetlb-folios-before-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: mm/memfd: reserve hugetlb folios before allocation
Date: Tue, 17 Jun 2025 22:30:54 -0700

When we try to allocate a folio via alloc_hugetlb_folio_reserve(), we need
to ensure that there is an active reservation associated with the
allocation.  Otherwise, our allocation request would fail if there are no
active reservations made at that moment against any other allocations. 
This is because alloc_hugetlb_folio_reserve() checks h->resv_huge_pages
before proceeding with the allocation.

Therefore, to address this issue, we just need to make a reservation (by
calling hugetlb_reserve_pages()) before we try to allocate the folio. 
This will also ensure that proper region/subpool accounting is done
associated with our allocation.

Link: https://lkml.kernel.org/r/20250618053415.1036185-3-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Steve Sistare <steven.sistare@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 +++++
 mm/hugetlb.c            |    5 -----
 mm/memfd.c              |   17 ++++++++++++++---
 3 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb.h~mm-memfd-reserve-hugetlb-folios-before-allocation
+++ a/include/linux/hugetlb.h
@@ -740,6 +740,11 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
+static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
+{
+	return HUGETLBFS_SB(inode->i_sb)->spool;
+}
+
 static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
 {
 	return folio->_hugetlb_subpool;
--- a/mm/hugetlb.c~mm-memfd-reserve-hugetlb-folios-before-allocation
+++ a/mm/hugetlb.c
@@ -284,11 +284,6 @@ static long hugepage_subpool_put_pages(s
 	return ret;
 }
 
-static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
-{
-	return HUGETLBFS_SB(inode->i_sb)->spool;
-}
-
 static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
 {
 	return subpool_inode(file_inode(vma->vm_file));
--- a/mm/memfd.c~mm-memfd-reserve-hugetlb-folios-before-allocation
+++ a/mm/memfd.c
@@ -70,7 +70,6 @@ struct folio *memfd_alloc_folio(struct f
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
-	int err;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -79,12 +78,19 @@ struct folio *memfd_alloc_folio(struct f
 		 * alloc from. Also, the folio will be pinned for an indefinite
 		 * amount of time, so it is not expected to be migrated away.
 		 */
+		struct inode *inode = file_inode(memfd);
 		struct hstate *h = hstate_file(memfd);
+		int err = -ENOMEM;
+		long nr_resv;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
+		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, 0);
+		if (nr_resv < 0)
+			return ERR_PTR(nr_resv);
+
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
@@ -95,12 +101,17 @@ struct folio *memfd_alloc_folio(struct f
 							idx);
 			if (err) {
 				folio_put(folio);
-				return ERR_PTR(err);
+				goto err_unresv;
 			}
+
+			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
 			folio_unlock(folio);
 			return folio;
 		}
-		return ERR_PTR(-ENOMEM);
+err_unresv:
+		if (nr_resv > 0)
+			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
+		return ERR_PTR(err);
 	}
 #endif
 	return shmem_read_folio(memfd->f_mapping, idx);
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are


