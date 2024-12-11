Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243322451D8
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 01:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733879016; cv=none; b=sLYypJjVk4xujn9cnUnSH335H7ikz3pa5ZrCCMEVma4P56mDlFDEw28tW6r5RiYCoQVkWW3IvJrg4WygI1JRC+/Hrp/cKWhuV/xVm3D6nk6TOB7UsEIaQneKr4EIOioAPFrLkeASV1zO9nLz9j3kG7ysjNfoqjucvrp19nfYqkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733879016; c=relaxed/simple;
	bh=TrHCoADE8JT11M3lnU6mcXonHA9slEv/qwu+yORIlqE=;
	h=Date:To:From:Subject:Message-Id; b=PsrXA/W/gpW2hrD5Ceu/VHyctxzcM1wgFJ1OvNzr0ps/OKMqqWvysVruYFLdkxMEhmiH3a6Ci8vdGUbpWlro+4yiuletwrOZLDcgCZiOdKtx2OJqcOzEgZraZis/en+0EGvd2+2OPm0ykmEgfI6pZge4vNHdEneTygMLH0+8dSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jijhPvG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jijhPvG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE352C4CED6;
	Wed, 11 Dec 2024 01:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733879015;
	bh=TrHCoADE8JT11M3lnU6mcXonHA9slEv/qwu+yORIlqE=;
	h=Date:To:From:Subject:From;
	b=jijhPvG4IBPgHgBSFGfzzXJFzu/XRPAMC1e57rtLuHEuF0EwJIckZq1/Q6J4uVdNA
	 RPVnDUGkyh6YJ7IfvpvA9TM+cB7OFXLPbV2j5rCCLuz82+0z3DQy2eu296vJEdcd2U
	 hjxKJC1CNQ5STuiFMhv30OOEYpk5L7+/uyGXEqqE=
Date: Tue, 10 Dec 2024 17:03:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,vbabka@suse.cz,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch removed from -mm tree
Message-Id: <20241211010335.AE352C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: conditionally split > pageblock_order pages in free_one_page() and move_freepages_block_isolate()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate.patch

This patch was dropped because an updated version will be issued

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
Acked-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-conditionally-split-pageblock_order-pages-in-free_one_page-and-move_freepages_block_isolate
+++ a/mm/page_alloc.c
@@ -1256,7 +1256,24 @@ static void free_one_page(struct zone *z
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
@@ -1792,7 +1809,7 @@ bool move_freepages_block_isolate(struct
 		del_page_from_free_list(buddy, zone, order,
 					get_pfnblock_migratetype(buddy, pfn));
 		set_pageblock_migratetype(page, migratetype);
-		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
+		__free_one_page_maybe_split(zone, buddy, pfn, order, FPI_NONE);
 		return true;
 	}
 
@@ -1803,7 +1820,7 @@ bool move_freepages_block_isolate(struct
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

mm-page_alloc-dont-call-pfn_to_page-on-possibly-non-existent-pfn-in-split_large_buddy.patch
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
mm-page_isolation-fixup-isolate_single_pageblock-comment-regarding-splitting-free-pages.patch
mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch
mm-memory_hotplug-dont-use-__gfp_hardwall-when-migrating-pages-via-memory-offlining.patch

