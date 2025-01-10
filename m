Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909DA207DFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550286; cv=none; b=An63x8e4VpnzsnbiZkpJclr+HaUu10v2dxmz/kLK6Tp2UPU4o7jus/xAQzFj8G6MI+vDph9snEASaLkdhkfkaJOC1TGul8juXFgOYsHgRnDDQf6VZSTAwnIPvP5aT9sau+m4L+ivh1Reipnfy2sFU0tWiYmn2KOAI7ZyQc1npWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550286; c=relaxed/simple;
	bh=5w+PE3+ggjbbXnn5sQsN0NK+nSFkW3MaNWOMqZ47ylo=;
	h=Date:To:From:Subject:Message-Id; b=OXdwvysopFzQnDx4zDlzMZ/uc6acmcCNhdiPweE0Q70mCW7QSjpi56keQzLYe0B94oESJ//KxqFD7Yw+PC9bgUP6b/v6ihPL+Fm+Gu3vXB9CQUKOTktVEcZzVIGdQCfnUmUX24ybQkKSKtfNIp/ncTB1KuSXns8xxEYptR/hd0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ElVO87C0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ElVO87C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0418EC4CED6;
	Fri, 10 Jan 2025 23:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736550286;
	bh=5w+PE3+ggjbbXnn5sQsN0NK+nSFkW3MaNWOMqZ47ylo=;
	h=Date:To:From:Subject:From;
	b=ElVO87C0FNPxuYmmQet00H5mXTasDCGFTBSFqt8SEhOJWUhN88Lb9cEKMrGrSGlqy
	 lpXoQWKp1HoD9ihfdLwpNq6561bFoaIjm/YSnP6Wf506ZX6GD8ZOz6nU/bVrnqiDzU
	 KPUuRn9mrLJd4lESGBV2NXENSt9e/eQL8y15Ru1A=
Date: Fri, 10 Jan 2025 15:04:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch added to mm-unstable branch
Message-Id: <20250110230446.0418EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline() to work on folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb-cgroup: convert hugetlb_cgroup_css_offline() to work on folios
Date: Fri, 10 Jan 2025 19:21:48 +0100

Let's convert hugetlb_cgroup_css_offline() and
hugetlb_cgroup_move_parent() to work on folios.  hugepage_activelist
contains folios, not pages.

While at it, rename page_hcg simply to hcg, removing most of the "page"
terminology.

Also removes an unnecessary call to compound_head().

Link: https://lkml.kernel.org/r/20250110182149.746551-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
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

docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch
mm-hugetlb-dont-map-folios-writable-without-vm_write-when-copying-during-fork.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch
mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

