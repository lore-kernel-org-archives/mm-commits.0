Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D251DC745
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394965; cv=none; b=RYGEEm81Q2+iPXAR/RPcj+jUpHBwO4hOn18YERajIKoDqB2VGNn/ua1kopuvGEgwOrJ4/g0Qssc8EXlhoZnqHiP8QeBoA1FS+UYqlHC0Yy1PPYm3XuZHu8z4WVsyYTHhvysa/Pt86y438uJ/8IJHk1BJ3708SHwr/1hveG/Rgsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394965; c=relaxed/simple;
	bh=iq69VS7VzNXYZkB6HrwL9lEUn6tMZk1LYV9lVJcryzQ=;
	h=Date:To:From:Subject:Message-Id; b=lS5JMEwMN3VKbzdUjAa5bGg0llnqZyXUgyM9ToIJBnM353hq4POBTk7h22sd5xkFDKjKXPP/fsh1KUMoSHiJ5DGMonilCEaMlpeo1CFgqAvV0eVk5ZNo5IDtjL9EyrRc7jpTAJzenFKB4tLD0B7dstXfspwCPF4IS160h5u+pG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v170kTOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v170kTOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715CEC4CEC4;
	Tue,  3 Sep 2024 20:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725394964;
	bh=iq69VS7VzNXYZkB6HrwL9lEUn6tMZk1LYV9lVJcryzQ=;
	h=Date:To:From:Subject:From;
	b=v170kTOtxTdjmPNkzg9tZyCfImRhv1RaX4iX0n2s8QT22ZbfdMp/YCH5DovVC5cVX
	 WNCXGTDM0qmR4GG5Vw0TwTQF+CoT3ezSowuS9uOnmPb8Wxt8SiFZbPwmQ/qcqp6j+m
	 FKQqRgguxWz1TZK/L+asjnJaXVn+UYKNRr7lD6U0=
Date: Tue, 03 Sep 2024 13:22:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch added to mm-hotfixes-unstable branch
Message-Id: <20240903202244.715CEC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   10 ++++++++++
 mm/hugetlb.c            |   17 +++++++++++++++++
 mm/memfd.c              |    9 ++++-----
 3 files changed, 31 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak
+++ a/include/linux/hugetlb.h
@@ -695,6 +695,9 @@ struct folio *alloc_hugetlb_folio(struct
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
+struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
+					  nodemask_t *nmask, gfp_t gfp_mask);
+
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
@@ -1060,6 +1063,13 @@ static inline struct folio *alloc_hugetl
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
@@ -2564,6 +2564,23 @@ struct folio *alloc_buddy_hugetlb_folio_
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

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

