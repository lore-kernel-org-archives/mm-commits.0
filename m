From: akpm@linux-foundation.org
Subject: [folded] mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:45:42 -0800
Message-ID: <20120110224543.3BB531E0260@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37918 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:45:44 -0500
Received: by yhpp56 with SMTP id p56so13467yhp.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:45:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, mgorman@suse.de, nai.xia@gmail.com, pluto@agmk.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update
has been removed from the -mm tree.  Its filename was
     mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch

This patch was dropped because it was folded into mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pawel Sikora <pluto@agmk.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c   |    6 +++---
 mm/mremap.c |   10 +++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update mm/mmap.c
--- a/mm/mmap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update
+++ a/mm/mmap.c
@@ -2355,7 +2355,7 @@ struct vm_area_struct *copy_vma(struct v
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
 	 */
-	if (!vma->vm_file && !vma->anon_vma) {
+	if (unlikely(!vma->vm_file && !vma->anon_vma)) {
 		pgoff = addr >> PAGE_SHIFT;
 		faulted_in_anon_vma = false;
 	}
@@ -2367,8 +2367,8 @@ struct vm_area_struct *copy_vma(struct v
 		/*
 		 * Source vma may have been merged into new_vma
 		 */
-		if (vma_start >= new_vma->vm_start &&
-		    vma_start < new_vma->vm_end) {
+		if (unlikely(vma_start >= new_vma->vm_start &&
+			     vma_start < new_vma->vm_end)) {
 			/*
 			 * The only way we can get a vma_merge with
 			 * self during an mremap is if the vma hasn't
diff -puN mm/mremap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update mm/mremap.c
--- a/mm/mremap.c~mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update
+++ a/mm/mremap.c
@@ -221,11 +221,19 @@ static unsigned long move_vma(struct vm_
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len);
 	if (moved_len < old_len) {
 		/*
+		 * Before moving the page tables from the new vma to
+		 * the old vma, we need to be sure the old vma is
+		 * queued after new vma in the same_anon_vma list to
+		 * prevent SMP races with rmap_walk (that could lead
+		 * rmap_walk to miss some page table).
+		 */
+		anon_vma_moveto_tail(vma);
+
+		/*
 		 * On error, move entries back from new area to old,
 		 * which will succeed since page tables still there,
 		 * and then proceed to unmap new area instead of old.
 		 */
-		anon_vma_moveto_tail(vma);
 		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len);
 		vma = new_vma;
 		old_len = new_len;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-more-intensive-memory-corruption-debug.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mm-vmscanc-consider-swap-space-when-deciding-whether-to-continue-reclaim.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch

