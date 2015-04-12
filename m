From: akpm@linux-foundation.org
Subject: [failures] mm-make-every-pte-dirty-on-do_swap_page.patch removed
 from -mm tree
Date: Sat, 11 Apr 2015 18:50:54 -0700
Message-ID: <5529cf7e.lBFHSUITULZZ8+RH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbDLBqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 11 Apr 2015 21:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, gorcunov@gmail.com, hughd@google.com, xemul@parallels.com, yalin.wang@sonymobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make every pte dirty on do_swap_page
has been removed from the -mm tree.  Its filename was
     mm-make-every-pte-dirty-on-do_swap_page.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: make every pte dirty on do_swap_page

Bascially, MADV_FREE relys on the dirty bit in page table entry to decide
whether VM allows to discard the page or not.  IOW, if page table entry
includes marked dirty bit, VM shouldn't discard the page.

However, if swap-in by read fault happens, page table entry point out the
page doesn't have marked dirty bit so MADV_FREE might discard the page
wrongly.  For avoiding the problem, MADV_FREE did more checks with
PageDirty and PageSwapCache.  It worked out because swapped-in page lives
on swap cache and since it was evicted from the swap cache, the page has
PG_dirty flag.  So both page flags checks effectvely prevent wrong
discarding by MADV_FREE.

A problem in above logic is that swapped-in page has PG_dirty since they
are removed from swap cache so VM cannot consider those pages as freeable
any more alghouth madvise_free is called in future.  Look at below example
for detail.

ptr = malloc();
memset(ptr);
..
..
.. heavy memory pressure so all of pages are swapped out
..
..
var = *ptr; -> a page swapped-in and removed from swapcache.
               page table doesn't mark dirty bit and page
               descriptor includes PG_dirty
..
..
madvise_free(ptr);
..
..
..
.. heavy memory pressure again.
.. In this time, VM cannot discard the page because the page
.. has *PG_dirty*

Rather than relying on the PG_dirty of page descriptor for preventing
discarding a page, dirty bit in page table is more straightforward and
simple.  So, this patch makes page table dirty bit marked whenever swap-in
happens.  Inherenty, page table entry point out swapped-out page had dirty
bit so I think it's no prblem.

With this, it removes complicated logic and makes freeable page checking
by madvise_free simple.  Of course, we could solve above mentioned
example.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Yalin Wang <yalin.wang@sonymobile.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 mm/memory.c  |   10 ++++++++--
 mm/rmap.c    |    2 +-
 mm/vmscan.c  |    3 +--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/madvise.c~mm-make-every-pte-dirty-on-do_swap_page mm/madvise.c
--- a/mm/madvise.c~mm-make-every-pte-dirty-on-do_swap_page
+++ a/mm/madvise.c
@@ -325,7 +325,6 @@ static int madvise_free_pte_range(pmd_t
 				continue;
 			}
 
-			ClearPageDirty(page);
 			unlock_page(page);
 		}
 
diff -puN mm/memory.c~mm-make-every-pte-dirty-on-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-make-every-pte-dirty-on-do_swap_page
+++ a/mm/memory.c
@@ -2555,9 +2555,15 @@ static int do_swap_page(struct mm_struct
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	dec_mm_counter_fast(mm, MM_SWAPENTS);
-	pte = mk_pte(page, vma->vm_page_prot);
+
+	/*
+	 * The page is swapping in now was dirty before it was swapped out
+	 * so restore the state again(ie, pte_mkdirty) because MADV_FREE
+	 * relies on the dirty bit on page table.
+	 */
+	pte = pte_mkdirty(mk_pte(page, vma->vm_page_prot));
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
-		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
+		pte = maybe_mkwrite(pte, vma);
 		flags &= ~FAULT_FLAG_WRITE;
 		ret |= VM_FAULT_WRITE;
 		exclusive = 1;
diff -puN mm/rmap.c~mm-make-every-pte-dirty-on-do_swap_page mm/rmap.c
--- a/mm/rmap.c~mm-make-every-pte-dirty-on-do_swap_page
+++ a/mm/rmap.c
@@ -1275,7 +1275,7 @@ static int try_to_unmap_one(struct page
 
 		if (flags & TTU_FREE) {
 			VM_BUG_ON_PAGE(PageSwapCache(page), page);
-			if (!dirty && !PageDirty(page)) {
+			if (!dirty) {
 				/* It's a freeable page by MADV_FREE */
 				dec_mm_counter(mm, MM_ANONPAGES);
 				goto discard;
diff -puN mm/vmscan.c~mm-make-every-pte-dirty-on-do_swap_page mm/vmscan.c
--- a/mm/vmscan.c~mm-make-every-pte-dirty-on-do_swap_page
+++ a/mm/vmscan.c
@@ -805,8 +805,7 @@ static enum page_references page_check_r
 		return PAGEREF_KEEP;
 	}
 
-	if (PageAnon(page) && !pte_dirty && !PageSwapCache(page) &&
-			!PageDirty(page))
+	if (PageAnon(page) && !pte_dirty && !PageSwapCache(page))
 		*freeable = true;
 
 	/* Reclaim if clean, defer dirty pages to writeback */
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-change-deactivate_page-with-deactivate_file_page.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-support-compaction-fix.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zsmalloc-zsmalloc-documentation.patch
mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch
zram-remove-num_migrated-device-attr.patch
zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-generic-start-end-io-accounting.patch
zram-describe-device-attrs-in-documentation.patch
zram-export-new-io_stat-sysfs-attrs.patch
zram-export-new-mm_stat-sysfs-attrs.patch
zram-deprecate-zram-attrs-sysfs-nodes.patch
zsmalloc-remove-synchronize_rcu-from-zs_compact.patch
zsmalloc-micro-optimize-zs_object_copy.patch
zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch
zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch
zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch
zram-fix-error-return-code.patch
linux-next.patch

