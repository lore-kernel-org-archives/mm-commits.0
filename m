Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645FC17D2
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 23:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750290780; cv=none; b=XgxhdyKH00AK7p6jmV6WDZhq55AiShTbj9GNpovk2f8tfdkonCkzHc2eqaggsGViDAXycOBVBzcp1MEczJqEMUorBlAIAK3UvWvt/j5SKYKEK4mDcVRi1JQcJe8SUkubGCdfFJSnqHpVEIt1IQlTxor+gBMhUrbEoP25RjJ1PtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750290780; c=relaxed/simple;
	bh=SQ1oZQiVxvFJObVmr4GPdRAti9bEu31+fH+sX5TVmrM=;
	h=Date:To:From:Subject:Message-Id; b=mSZUexsQ4q7jK1PjGmjpx+uDJ5vDh98z+I+PqNQ1TVRftNHO6X/m5Az/Z0NlRJzW2fjRPr+lbqBplHB/up2KXqQG7gyiD+yafwNIXPDfr+A0aFugePTb+A0L5DtUWBV8CUreMsw1ZR4DNbt3WF0oOzVHuy5NTm3u5eGunqI+uls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UNwzyLxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UNwzyLxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD036C4CEE7;
	Wed, 18 Jun 2025 23:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750290779;
	bh=SQ1oZQiVxvFJObVmr4GPdRAti9bEu31+fH+sX5TVmrM=;
	h=Date:To:From:Subject:From;
	b=UNwzyLxtdsY1ukwKvF9s2vkkLeykmeNQZSty1LNwA/0qpl4XDvY6dkaDT96zncIXl
	 wcXG6ssehcNq5nZ6hMaGyCj/gaHqMNaSPIoF6sjsq4LTJ6bJVqy8YUDoMfGPFP54xm
	 2gzff/4B9VdZ2DMKabsp39NegYuPY/N5UcJoVNWs=
Date: Wed, 18 Jun 2025 16:52:59 -0700
To: mm-commits@vger.kernel.org,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,kraxel@redhat.com,david@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-reserve-hugetlb-folios-before-allocation.patch added to mm-new branch
Message-Id: <20250618235259.CD036C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: reserve hugetlb folios before allocation
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd-reserve-hugetlb-folios-before-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-reserve-hugetlb-folios-before-allocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-hugetlb-make-hugetlb_reserve_pages-return-nr-of-entries-updated.patch
mm-memfd-reserve-hugetlb-folios-before-allocation.patch
selftests-udmabuf-add-a-test-to-pin-first-before-writing-to-memfd.patch

