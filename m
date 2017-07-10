From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch removed from
 -mm tree
Date: Mon, 10 Jul 2017 15:28:08 -0700
Message-ID: <5963ff78.9j44BmzR220W+9ul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754233AbdGJW2J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:28:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, shli@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap-add-block-io-poll-in-swapin-path-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch

This patch was dropped because it was folded into swap-add-block-io-poll-in-swapin-path.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swap-add-block-io-poll-in-swapin-path-checkpatch-fixes

WARNING: function definition argument 'struct page *' should also have an identifier name
#60: FILE: include/linux/swap.h:334:
+extern int swap_readpage(struct page *, bool do_poll);

WARNING: line over 80 characters
#164: FILE: mm/swap_state.c:415:
+			struct vm_area_struct *vma, unsigned long addr, bool do_poll)

total: 0 errors, 2 warnings, 140 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/swap-add-block-io-poll-in-swapin-path.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap_state.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes include/linux/swap.h
--- a/include/linux/swap.h~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes
+++ a/include/linux/swap.h
@@ -331,7 +331,7 @@ extern void kswapd_stop(int nid);
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 /* linux/mm/page_io.c */
-extern int swap_readpage(struct page *, bool do_poll);
+extern int swap_readpage(struct page *page, bool do_poll);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
 extern void end_swap_bio_write(struct bio *bio);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
diff -puN mm/swap_state.c~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes mm/swap_state.c
--- a/mm/swap_state.c~swap-add-block-io-poll-in-swapin-path-checkpatch-fixes
+++ a/mm/swap_state.c
@@ -412,7 +412,7 @@ struct page *__read_swap_cache_async(swp
  * the swap entry is no longer in use.
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-			struct vm_area_struct *vma, unsigned long addr, bool do_poll)
+		struct vm_area_struct *vma, unsigned long addr, bool do_poll)
 {
 	bool page_was_allocated;
 	struct page *retpage = __read_swap_cache_async(entry, gfp_mask,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swap-add-block-io-poll-in-swapin-path.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

