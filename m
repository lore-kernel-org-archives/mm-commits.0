Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FB07F9
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733273860; cv=none; b=BCdnFReBB8ogM0BOWOX77Ts2LAqeYPpcvdxMV/aKB0X23a8ToIxyeZr3mqqI05hURrWbzxy2xTD+Vf6IrBTFzgGOppgS/J/az7tlfznUuBg2TtrktSONwGNCNsK+TpGhNM+diCV4cXLHedYpnRm3Ic/o+m7oaS3UpubEsnDtjgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733273860; c=relaxed/simple;
	bh=B9/zdpW415yONDxlZP+7bu/MQMl33pF5lUHyy+2MToM=;
	h=Date:To:From:Subject:Message-Id; b=T7dcv8rwHw8tDoXSWFB5ukLD2sh0qFn+GWWQd/rLNVgSTYQm1CAzUESyz0awrZAK+K7OieEUze9ycYWlTXI+fUPYgJleJEmgOZrr/P/Qtm38lekmz4OY3qNm35LkdNUJeFIMCHm4760qzcW7vsd2sn7W7NrQhfHpql5zMLmxybc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPAJxj5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPAJxj5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AA4C4CEDC;
	Wed,  4 Dec 2024 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733273859;
	bh=B9/zdpW415yONDxlZP+7bu/MQMl33pF5lUHyy+2MToM=;
	h=Date:To:From:Subject:From;
	b=sPAJxj5z9nKsLSKbhjy/anhMBb9/26IU/FpMcs/b/AR1Eka6hGqC8r6S6d/OMvmrt
	 LZ5k+rBdAd1n95HGq9c6UgjxAqfzFhM9UXm5avoBzy2InbSuJ0dlG3vRa5/CBFlhT0
	 8QjNFHRVrPDXDZE6HjeicalhF0MTNrsdt/LYD8Ok=
Date: Tue, 03 Dec 2024 16:57:39 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch added to mm-unstable branch
Message-Id: <20241204005739.C3AA4C4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: move debug_pagealloc_map_pages() into online_pages_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch

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
Subject: mm/memory_hotplug: move debug_pagealloc_map_pages() into online_pages_range()
Date: Tue, 3 Dec 2024 11:20:50 +0100

In the near future, we want to have a single way to handover PageOffline
pages to the buddy, whereby they could have:

(a) Never been exposed to the buddy before: kept PageOffline when onlining
    the memory block.
(b) Been allocated from the buddy, for example using
    alloc_contig_range() to then be set PageOffline,

Let's start by making generic_online_page() less special compared to
ordinary page freeing (e.g., free_contig_range()), and perform the
debug_pagealloc_map_pages() call unconditionally, even when the online
callback might decide to keep the pages offline.

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
@@ -1293,12 +1293,6 @@ void __meminit __free_pages_core(struct
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

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch

