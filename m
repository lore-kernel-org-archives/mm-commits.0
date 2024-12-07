Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C474A24
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 06:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733551487; cv=none; b=SRneQRp8AkovCMwokVenpdBu+NsykyaXNDQGxArucP7Of2NwkZm50YSN8sSK+ubYsWwN7A6GIarUUTAgDU5H2GK4ZZJ1OWjwMCKsZL7A+NX9qPeIcpNpSHLeZAIuEB1gspvZrEhGODPx+xv86LBLTI+Jd7MeCdo13p6I2zl7ZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733551487; c=relaxed/simple;
	bh=Dm6KcEXVDxcu8R4RTiuOrTgmgH3mWw6AWvwsaFsaoMs=;
	h=Date:To:From:Subject:Message-Id; b=B/3PaV6YIDySYv+d4k4E2G82SKGluVEA9qXaFSR3Jq/PsDZ3oX1P9jSUwqcTMqSa/14K+qurPCP9yZd92XauyKdXp3fp8fZ4TlCNqg+9DC9bOzsdyb3g96z/55h9rfiO1LYB/eGPGabIfFpi1UAjuJZE45xxBnmAN16oOj0dfKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y7czug9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y7czug9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D54C4CECD;
	Sat,  7 Dec 2024 06:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733551486;
	bh=Dm6KcEXVDxcu8R4RTiuOrTgmgH3mWw6AWvwsaFsaoMs=;
	h=Date:To:From:Subject:From;
	b=y7czug9R3d1EFgA16bSJ1YPIwxfwXemJEw2DvAScjX1WlExJoJXxLZEJTgigBnnhg
	 ruBkiHDOGr7hyw9icKmP9WjzTq+YofMmh/W870ppH/a5Bqhbqqg6wk32ngqLPzj3lz
	 Ob1lNwrxUIr+GbAmdKP5Q+A7EWGnGe08Kp1FeZ0c=
Date: Fri, 06 Dec 2024 22:04:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,vbabka@suse.cz,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch added to mm-unstable branch
Message-Id: <20241207060446.A3D54C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: conditionally split > pageblock_order pages in free_one_page() and move_freepages_block_isolate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch

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
Subject: mm/page_alloc: conditionally split > pageblock_order pages in free_one_page() and move_freepages_block_isolate()
Date: Fri, 6 Dec 2024 10:59:50 +0100

Patch series "mm/page_alloc: rework conditional splitting >=
pageblock_order pages when freeing".

Looking into recent alloc_contig_range(__GFP_COMP) support, I realized
that we now unconditionally split up high-order pages on the page freeing
path to free in pageblock granularity, just to immediately let the buddy
merge them again in the common case.

Let's optimize for the common case (all pageblock migratetypes match), and
enable it only in configs where this is strictly required.  Further, add
some comments that explain why this special casing is required at all.

Alongside, a fix for a stale comment in page isolation code.


This patch (of 2):

Let's special-case for the common scenarios that:

(a) We are freeing pages <= pageblock_order
(b) We are freeing a page <= MAX_PAGE_ORDER and all pageblocks match
    (especially, no mixture of isolated and non-isolated pageblocks)

When we encounter a > MAX_PAGE_ORDER page, it can only come from
alloc_contig_range(), and we can process MAX_PAGE_ORDER chunks.

When we encounter a >pageblock_order <= MAX_PAGE_ORDER page, check whether
all pageblocks match, and if so (common case), don't split them up just
for the buddy to merge them back.

This makes sure that when we free MAX_PAGE_ORDER chunks to the buddy, for
example during system startups, memory onlining, or when isolating
consecutive pageblocks via alloc_contig_range()/memory offlining, that we
don't unnecessarily split up what we'll immediately merge again, because
the migratetypes match.

Rename split_large_buddy() to __free_one_page_maybe_split(), to make it
clearer what's happening, and handle in it only natural buddy orders, not
the alloc_contig_range(__GFP_COMP) special case: handle that in
free_one_page() only.

Link: https://lkml.kernel.org/r/20241206095951.98007-1-david@redhat.com
Link: https://lkml.kernel.org/r/20241206095951.98007-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   71 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 57 insertions(+), 14 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate
+++ a/mm/page_alloc.c
@@ -1225,24 +1225,50 @@ static void free_pcppages_bulk(struct zo
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
-/* Split a multi-block free page into its individual pageblocks. */
-static void split_large_buddy(struct zone *zone, struct page *page,
-			      unsigned long pfn, int order, fpi_t fpi)
+static bool pfnblock_migratetype_equal(unsigned long pfn,
+		unsigned long end_pfn, int mt)
 {
-	unsigned long end = pfn + (1 << order);
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | end_pfn, pageblock_nr_pages));
 
+	while (pfn != end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (unlikely(mt != get_pfnblock_migratetype(page, pfn)))
+			return false;
+		pfn += pageblock_nr_pages;
+	}
+	return true;
+}
+
+static void __free_one_page_maybe_split(struct zone *zone, struct page *page,
+		unsigned long pfn, int order, fpi_t fpi_flags)
+{
+	const unsigned long end_pfn = pfn + (1 << order);
+	int mt = get_pfnblock_migratetype(page, pfn);
+
+	VM_WARN_ON_ONCE(order > MAX_PAGE_ORDER);
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
 	VM_WARN_ON_ONCE(PageBuddy(page));
 
-	if (order > pageblock_order)
-		order = pageblock_order;
-
-	while (pfn != end) {
-		int mt = get_pfnblock_migratetype(page, pfn);
+	/*
+	 * With CONFIG_MEMORY_ISOLATION, we might be freeing MAX_ORDER_NR_PAGES
+	 * pages that cover pageblocks with different migratetypes; for example
+	 * only some migratetypes might be MIGRATE_ISOLATE. In that (unlikely)
+	 * case, fallback to freeing individual pageblocks so they get put
+	 * onto the right lists.
+	 */
+	if (!IS_ENABLED(CONFIG_MEMORY_ISOLATION) ||
+	    likely(order <= pageblock_order) ||
+	    pfnblock_migratetype_equal(pfn + pageblock_nr_pages, end_pfn, mt)) {
+		__free_one_page(page, pfn, zone, order, mt, fpi_flags);
+		return;
+	}
 
-		__free_one_page(page, pfn, zone, order, mt, fpi);
-		pfn += 1 << order;
+	while (pfn != end_pfn) {
+		mt = get_pfnblock_migratetype(page, pfn);
+		__free_one_page(page, pfn, zone, pageblock_order, mt, fpi_flags);
+		pfn += pageblock_nr_pages;
 		page = pfn_to_page(pfn);
 	}
 }
@@ -1254,7 +1280,24 @@ static void free_one_page(struct zone *z
 	unsigned long flags;
 
 	spin_lock_irqsave(&zone->lock, flags);
-	split_large_buddy(zone, page, pfn, order, fpi_flags);
+	if (likely(order <= MAX_PAGE_ORDER)) {
+		__free_one_page_maybe_split(zone, page, pfn, order, fpi_flags);
+	} else if (IS_ENABLED(CONFIG_CONTIG_ALLOC)) {
+		const unsigned long end_pfn = pfn + (1 << order);
+
+		/*
+		 * The only way we can end up with order > MAX_PAGE_ORDER is
+		 * through alloc_contig_range(__GFP_COMP).
+		 */
+		while (pfn != end_pfn) {
+			__free_one_page_maybe_split(zone, page, pfn,
+						    MAX_PAGE_ORDER, fpi_flags);
+			pfn += MAX_ORDER_NR_PAGES;
+			page = pfn_to_page(pfn);
+		}
+	} else {
+		WARN_ON_ONCE(1);
+	}
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	__count_vm_events(PGFREE, 1 << order);
@@ -1790,7 +1833,7 @@ bool move_freepages_block_isolate(struct
 		del_page_from_free_list(buddy, zone, order,
 					get_pfnblock_migratetype(buddy, pfn));
 		set_pageblock_migratetype(page, migratetype);
-		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
+		__free_one_page_maybe_split(zone, buddy, pfn, order, FPI_NONE);
 		return true;
 	}
 
@@ -1801,7 +1844,7 @@ bool move_freepages_block_isolate(struct
 		del_page_from_free_list(page, zone, order,
 					get_pfnblock_migratetype(page, pfn));
 		set_pageblock_migratetype(page, migratetype);
-		split_large_buddy(zone, page, pfn, order, FPI_NONE);
+		__free_one_page_maybe_split(zone, page, pfn, order, FPI_NONE);
 		return true;
 	}
 move:
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
fs-proc-vmcore-convert-vmcore_cb_lock-into-vmcore_mutex.patch
fs-proc-vmcore-replace-vmcoredd_mutex-by-vmcore_mutex.patch
fs-proc-vmcore-disallow-vmcore-modifications-while-the-vmcore-is-open.patch
fs-proc-vmcore-prefix-all-pr_-with-vmcore.patch
fs-proc-vmcore-move-vmcore-definitions-out-of-kcoreh.patch
fs-proc-vmcore-factor-out-allocating-a-vmcore-range-and-adding-it-to-a-list.patch
fs-proc-vmcore-factor-out-freeing-a-list-of-vmcore-ranges.patch
fs-proc-vmcore-introduce-proc_vmcore_device_ram-to-detect-device-ram-ranges-in-2nd-kernel.patch
virtio-mem-mark-device-ready-before-registering-callbacks-in-kdump-mode.patch
virtio-mem-remember-usable-region-size.patch
virtio-mem-support-config_proc_vmcore_device_ram.patch
s390-kdump-virtio-mem-kdump-support-config_proc_vmcore_device_ram.patch
mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch
mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch

