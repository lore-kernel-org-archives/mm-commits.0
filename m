Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDE128DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489814; cv=none; b=KptEAjJ+mNC+TSL2TfZo6QLxHi/u5zCQDw6MFzCp1uQK3IKjvJvh88SXy68y+T+Jiw5kaV108KynluFOp4TXiMIiJaMI/o/R6GmziTIlpBWw10Nt5qzbtpc/KuXgpKXM/fP2y2Af8b4UvKS043y0rHGoe7p48430qNPeOcpGWlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489814; c=relaxed/simple;
	bh=QILaME8nfMiRjrjX7nPL2YXExGlbLMVavJECcTMuLWo=;
	h=Date:To:From:Subject:Message-Id; b=PQUGHchgGCIZPOVArOmICz4KIfbPvHBx1G4GA206GTiGKWOfa43LaYXTz5Kou4Hajhaj++3PuTBes99zNIc7TDQRVI9NekHXqLT8TX4iCxK+9J+JMKeQ5AP1BQznKSE4PX7a7cREjRA5ySEZeLeQbDhHVoAZkKgR8jcdDmRONbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Loe/Cvra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Loe/Cvra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C99AC4CEE7;
	Sun, 21 Sep 2025 21:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489814;
	bh=QILaME8nfMiRjrjX7nPL2YXExGlbLMVavJECcTMuLWo=;
	h=Date:To:From:Subject:From;
	b=Loe/CvrasioM3NHbzXg0KzrZ+ZTt8hseNRyc3mkzD2SHVFFAqnEMp7q3Rq44x3Rcs
	 WaclvsYSbl5LeARLABHHND4/oXJ7wMwFIRu8llrOJU3kTx8UJxjE+T67u7bKaLIK3Q
	 iPOIKQH5L0x666x5siZOsKXo609j6clFlCFPA5Ps=
Date: Sun, 21 Sep 2025 14:23:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof.patch removed from -mm tree
Message-Id: <20250921212334.1C99AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Mon, 1 Sep 2025 17:03:27 +0200

Let's reject them early, which in turn makes folio_alloc_gigantic() reject
them properly.

To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
and calculate MAX_FOLIO_NR_PAGES based on that.

While at it, let's just make the order a "const unsigned order".

Link: https://lkml.kernel.org/r/20250901150359.867252-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++--
 mm/page_alloc.c    |   10 +++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof
+++ a/include/linux/mm.h
@@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #else
-#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
 #endif
 
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
--- a/mm/page_alloc.c~mm-page_alloc-reject-unreasonable-folio-compound-page-sizes-in-alloc_contig_range_noprof
+++ a/mm/page_alloc.c
@@ -6838,6 +6838,7 @@ static int __alloc_contig_verify_gfp_mas
 int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
+	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
 	int ret = 0;
 
@@ -6855,6 +6856,14 @@ int alloc_contig_range_noprof(unsigned l
 					    PB_ISOLATE_MODE_CMA_ALLOC :
 					    PB_ISOLATE_MODE_OTHER;
 
+	/*
+	 * In contrast to the buddy, we allow for orders here that exceed
+	 * MAX_PAGE_ORDER, so we must manually make sure that we are not
+	 * exceeding the maximum folio order.
+	 */
+	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
+		return -EINVAL;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
@@ -6952,7 +6961,6 @@ int alloc_contig_range_noprof(unsigned l
 			free_contig_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
-		int order = ilog2(end - start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
_

Patches currently in -mm which might be from david@redhat.com are


