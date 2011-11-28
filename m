From: akpm@linux-foundation.org
Subject: + mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch added to -mm tree
Date: Mon, 28 Nov 2011 14:30:15 -0800
Message-ID: <201111282230.pASMUKJ9016751@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:59847 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1WaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:30:23 -0500
Received: by ghrr18 with SMTP id r18so238474ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 14:30:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com


The patch titled
     Subject: mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()
has been added to the -mm tree.  Its filename is
     mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()

Tell the page allocator that pages allocated through
grab_cache_page_write_begin() are expected to become dirty soon.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin mm/filemap.c
--- a/mm/filemap.c~mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin
+++ a/mm/filemap.c
@@ -2354,8 +2354,11 @@ struct page *grab_cache_page_write_begin
 					pgoff_t index, unsigned flags)
 {
 	int status;
+	gfp_t gfp_mask;
 	struct page *page;
 	gfp_t gfp_notmask = 0;
+
+	gfp_mask = mapping_gfp_mask(mapping) | __GFP_WRITE;
 	if (flags & AOP_FLAG_NOFS)
 		gfp_notmask = __GFP_FS;
 repeat:
@@ -2363,7 +2366,7 @@ repeat:
 	if (page)
 		goto found;
 
-	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
+	page = __page_cache_alloc(gfp_mask & ~gfp_notmask);
 	if (!page)
 		return NULL;
 	status = add_to_page_cache_lru(page, mapping, index,
_
Subject: Subject: mm: filemap: pass __GFP_WRITE from grab_cache_page_write_begin()

Patches currently in -mm which might be from jweiner@redhat.com are

mm-add-extra-free-kbytes-tunable.patch
mm-migrate-one-less-atomic-operation.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

