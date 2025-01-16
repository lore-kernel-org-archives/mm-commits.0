Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B700418C03D
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006315; cv=none; b=EjZB/lOjMxgFGSaGQdcJBURagclrIUBJK1rvsEGmPPi8DYgyn6NI6laVmhiSGIRvtJIZ3ZxDFIEt9tKW71b0c4wk5LtYazWWC3I6Tk+ImjTTbML3ghWBgWWJvWaAnKHLWJWJhwOUg7YTbW2yknExaJkBsvehE5QmVpYdNXvCkuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006315; c=relaxed/simple;
	bh=yJNivx1wUPZlO4XCLAJE+3XCMKAk4hY8kse1skLzsug=;
	h=Date:To:From:Subject:Message-Id; b=uAyeUcLvSfqULI6vtbd1lx0337Svpll5kIfSB+Dbovi4r9ESm/WHkokUC0QXpFiMBhxdk/Mjivl8+v2bldmrHR65gHfBzBf8J0Am9WhhNL+ENcKgB/YPgLsO6lZSe61GK5fmwu8wBlttjwLqJ8978j2u+aBKhIWBErOIfWWNa8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ugunvmUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ugunvmUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4151CC4CED6;
	Thu, 16 Jan 2025 05:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006315;
	bh=yJNivx1wUPZlO4XCLAJE+3XCMKAk4hY8kse1skLzsug=;
	h=Date:To:From:Subject:From;
	b=ugunvmUaNooXSbPagSNvdY0tUqbP5xW5JREfhA4808+v+8F3zdjst6i2j9C8+/nZa
	 JpydcRWRAFLZr+FnMdWBZbaTRq9XlEJ42F8fXDmb3mvBgJskgm3lM/5BIWxrlzKk3r
	 EKfmpj46pHdoQLpXTPbc4RgeR9FeqTAS5oSVmix4=
Date: Wed, 15 Jan 2025 21:45:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch removed from -mm tree
Message-Id: <20250116054515.4151CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline() to work on folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline() to work on folios
Date: Mon, 13 Jan 2025 14:16:10 +0100

Let's convert hugetlb_cgroup_css_offline() and
hugetlb_cgroup_move_parent() to work on folios.  hugepage_activelist
contains folios, not pages.

While at it, rename page_hcg simply to hcg, removing most of the "page"
terminology.

This removes an unnecessary call to compound_head().

Link: https://lkml.kernel.org/r/20250113131611.2554758-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios
+++ a/mm/hugetlb_cgroup.c
@@ -195,24 +195,23 @@ static void hugetlb_cgroup_css_free(stru
  * cannot fail.
  */
 static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
-				       struct page *page)
+				       struct folio *folio)
 {
 	unsigned int nr_pages;
 	struct page_counter *counter;
-	struct hugetlb_cgroup *page_hcg;
+	struct hugetlb_cgroup *hcg;
 	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(h_cg);
-	struct folio *folio = page_folio(page);
 
-	page_hcg = hugetlb_cgroup_from_folio(folio);
+	hcg = hugetlb_cgroup_from_folio(folio);
 	/*
 	 * We can have pages in active list without any cgroup
 	 * ie, hugepage with less than 3 pages. We can safely
 	 * ignore those pages.
 	 */
-	if (!page_hcg || page_hcg != h_cg)
+	if (!hcg || hcg != h_cg)
 		goto out;
 
-	nr_pages = compound_nr(page);
+	nr_pages = folio_nr_pages(folio);
 	if (!parent) {
 		parent = root_h_cgroup;
 		/* root has no limit */
@@ -235,13 +234,13 @@ static void hugetlb_cgroup_css_offline(s
 {
 	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
 	struct hstate *h;
-	struct page *page;
+	struct folio *folio;
 
 	do {
 		for_each_hstate(h) {
 			spin_lock_irq(&hugetlb_lock);
-			list_for_each_entry(page, &h->hugepage_activelist, lru)
-				hugetlb_cgroup_move_parent(hstate_index(h), h_cg, page);
+			list_for_each_entry(folio, &h->hugepage_activelist, lru)
+				hugetlb_cgroup_move_parent(hstate_index(h), h_cg, folio);
 
 			spin_unlock_irq(&hugetlb_lock);
 		}
_

Patches currently in -mm which might be from david@redhat.com are


