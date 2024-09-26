Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A851850B6;
	Thu, 26 Sep 2024 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384651; cv=none; b=TVqk567PSF87LoKmJw7URp86GuLpRcxOX0ZHrakOFileV/QTgeyBcxEtM7vleLvRgkh0ot0tq5KfpeAH4242yhSSevZcFrRrnjd9GyywIKaJg171ZOCasAtdsjvqY7xZPum89AqKoteyYjvfH3Tz/3NqJVh/udY+zvr42BrYdHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384651; c=relaxed/simple;
	bh=rya/orJnpKVzw2wFK1CYnFqAua8G8yu0RVTdHk7W1BQ=;
	h=Date:To:From:Subject:Message-Id; b=Yildu1p+fiHvEb1WKgExhSGeb4bd3j2k2I+wZNJNO6jk5GS50LFTPQzuD70kGMn8EySkaeOybz/Qp81+ugxJVKXSmL96J/4JwgN4oqPECpNUdfFIswt7OTC3Ac9NY2ERZsOvxWPtlCkwYWngVCD73oBkFNR+S3Mxy8AANxUtx6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vr7XjrA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vr7XjrA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C3EC4CEC5;
	Thu, 26 Sep 2024 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384651;
	bh=rya/orJnpKVzw2wFK1CYnFqAua8G8yu0RVTdHk7W1BQ=;
	h=Date:To:From:Subject:From;
	b=Vr7XjrA8unE9alacYu/8Bakq1yqDaIkN0Ws+oJhHJVbTanq8HlhLMlqqcCNd9PLX3
	 mretMmTiLnqJYEPTNDK0aE080mNnRCo6AFt4yrYRvy673jd784E8eBsW0xmqbl8khr
	 pSWUPi1qY+/TftUNpkgGm4Dspw7MJBDbDETy6JF8=
Date: Thu, 26 Sep 2024 14:04:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch removed from -mm tree
Message-Id: <20240926210411.10C3EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak
Date: Tue, 3 Sep 2024 07:25:19 -0700

memfd_pin_folios followed by unpin_folios leaves resv_huge_pages elevated
if the pages were not already faulted in.  During a normal page fault,
resv_huge_pages is consumed here:

hugetlb_fault()
  alloc_hugetlb_folio()
    dequeue_hugetlb_folio_vma()
      dequeue_hugetlb_folio_nodemask()
        dequeue_hugetlb_folio_node_exact()
          free_huge_pages--
      resv_huge_pages--

During memfd_pin_folios, the page is created by calling
alloc_hugetlb_folio_nodemask instead of alloc_hugetlb_folio, and
resv_huge_pages is not modified:

memfd_alloc_folio()
  alloc_hugetlb_folio_nodemask()
    dequeue_hugetlb_folio_nodemask()
      dequeue_hugetlb_folio_node_exact()
        free_huge_pages--

alloc_hugetlb_folio_nodemask has other callers that must not modify
resv_huge_pages.  Therefore, to fix, define an alternate version of
alloc_hugetlb_folio_nodemask for this call site that adjusts
resv_huge_pages.

Link: https://lkml.kernel.org/r/1725373521-451395-4-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++++++++
 mm/hugetlb.c            |   17 +++++++++++++++++
 mm/memfd.c              |    9 ++++-----
 3 files changed, 31 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak
+++ a/include/linux/hugetlb.h
@@ -692,6 +692,9 @@ struct folio *alloc_hugetlb_folio(struct
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
+struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+					  nodemask_t *nmask, gfp_t gfp_mask);
+
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
@@ -1058,6 +1061,13 @@ static inline struct folio *alloc_hugetl
 {
 	return NULL;
 }
+
+static inline struct folio *
+alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+			    nodemask_t *nmask, gfp_t gfp_mask)
+{
+	return NULL;
+}
 
 static inline struct folio *
 alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
--- a/mm/hugetlb.c~mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak
+++ a/mm/hugetlb.c
@@ -2390,6 +2390,23 @@ struct folio *alloc_buddy_hugetlb_folio_
 	return folio;
 }
 
+struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+		nodemask_t *nmask, gfp_t gfp_mask)
+{
+	struct folio *folio;
+
+	spin_lock_irq(&hugetlb_lock);
+	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
+					       nmask);
+	if (folio) {
+		VM_BUG_ON(!h->resv_huge_pages);
+		h->resv_huge_pages--;
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+	return folio;
+}
+
 /* folio migration callback function */
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
--- a/mm/memfd.c~mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak
+++ a/mm/memfd.c
@@ -82,11 +82,10 @@ struct folio *memfd_alloc_folio(struct f
 		gfp_mask = htlb_alloc_mask(hstate_file(memfd));
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-		folio = alloc_hugetlb_folio_nodemask(hstate_file(memfd),
-						     numa_node_id(),
-						     NULL,
-						     gfp_mask,
-						     false);
+		folio = alloc_hugetlb_folio_reserve(hstate_file(memfd),
+						    numa_node_id(),
+						    NULL,
+						    gfp_mask);
 		if (folio && folio_try_get(folio)) {
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
_

Patches currently in -mm which might be from steven.sistare@oracle.com are


