Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB04123A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836980; cv=none; b=WgPQBr0AkC0viwqDihTis+6zDZhGMEPt4eUikRU/eMDKgCCzx25YLb8dJQrNZoxaPKJAqG+jaKWnjX8vJqZw44LTYf6hAm1Qy8ES0BCihiKftCs4sMW1N8Vyq+BULBce4EflXAGqUd97zuL7oIgQXzvL8hjF4VZgTXp9Fk5RS7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836980; c=relaxed/simple;
	bh=oL70HFoURKcG/RYDPQFfopN1SrxyMvBIfMDr7AEdM4I=;
	h=Date:To:From:Subject:Message-Id; b=aM9bIejZQD/TB/RO1rZsIEg/ifH+dybbZZTNClZDGnsbgwmfT5ogOTPm6UXZApeNrU/sJfHiUF1idFhrWLsF37Nc0uDi1RDeSOizKyRvkhGsgydCai2kpw2bqXq7ff0CTWMK4XkHcepqlDKhLlVT5qSWXpp+D8a0SE+3AeNgib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=toV0HHHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="toV0HHHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF25DC4CEDD;
	Tue, 14 Jan 2025 06:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836980;
	bh=oL70HFoURKcG/RYDPQFfopN1SrxyMvBIfMDr7AEdM4I=;
	h=Date:To:From:Subject:From;
	b=toV0HHHnaMvzCWMCmYDgfNXSqjbZ+u0JMUJXCyiTLtnm1RSDaLQHH7zRbhErw5RPU
	 BCi0MnAKhuCtTKlfWXXCh31xWlPp6wSy3rcI2T/1Zv4BZ21NhU9Ru5j2X4BILUDUh1
	 CUW5atCaWwhCKebUGH1PWn5QBgFvJ50ukl7VeIU8=
Date: Mon, 13 Jan 2025 22:43:00 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch removed from -mm tree
Message-Id: <20250114064300.AF25DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: move debug_pagealloc_map_pages() into online_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: move debug_pagealloc_map_pages() into online_pages_range()
Date: Tue, 3 Dec 2024 11:20:50 +0100

In the near future, we want to have a single way to handover PageOffline
pages to the buddy, whereby they could have:

(a) Never been exposed to the buddy before: kept PageOffline when onlining
    the memory block.
(b) Been allocated from the buddy, for example using
    alloc_contig_range() to then be set PageOffline,

Let's start by making generic_online_page()->__free_pages_core() less
special compared to ordinary page freeing (e.g., free_contig_range()),
and perform the debug_pagealloc_map_pages() call unconditionally, even
when the online callback might decide to keep the pages offline.

All pages are already initialized with PageOffline, so nobody touches them
either way.

Link: https://lkml.kernel.org/r/20241203102050.223318-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++++++++-
 mm/page_alloc.c     |    6 ------
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range
+++ a/mm/memory_hotplug.c
@@ -650,6 +650,7 @@ static void online_pages_range(unsigned
 	 * this and the first chunk to online will be pageblock_nr_pages.
 	 */
 	for (pfn = start_pfn; pfn < end_pfn;) {
+		struct page *page = pfn_to_page(pfn);
 		int order;
 
 		/*
@@ -664,7 +665,14 @@ static void online_pages_range(unsigned
 		else
 			order = MAX_PAGE_ORDER;
 
-		(*online_page_callback)(pfn_to_page(pfn), order);
+		/*
+		 * Exposing the page to the buddy by freeing can cause
+		 * issues with debug_pagealloc enabled: some archs don't
+		 * like double-unmappings. So treat them like any pages that
+		 * were allocated from the buddy.
+		 */
+		debug_pagealloc_map_pages(page, 1 << order);
+		(*online_page_callback)(page, order);
 		pfn += (1UL << order);
 	}
 
--- a/mm/page_alloc.c~mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range
+++ a/mm/page_alloc.c
@@ -1295,12 +1295,6 @@ void __meminit __free_pages_core(struct
 			set_page_count(p, 0);
 		}
 
-		/*
-		 * Freeing the page with debug_pagealloc enabled will try to
-		 * unmap it; some archs don't like double-unmappings, so
-		 * map it first.
-		 */
-		debug_pagealloc_map_pages(page, nr_pages);
 		adjust_managed_page_count(page, nr_pages);
 	} else {
 		for (loop = 0; loop < nr_pages; loop++, p++) {
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

