From: akpm@linux-foundation.org
Subject: [folded] mm-more-intensive-memory-corruption-debug-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:44:43 -0800
Message-ID: <20120110224443.8EBDB1000A6@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38950 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:44:44 -0500
Received: by ghrr15 with SMTP id r15so12699ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:44:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, cl@linux-foundation.org, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl, sgruszka@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-more-intensive-memory-corruption-debug-fix
has been removed from the -mm tree.  Its filename was
     mm-more-intensive-memory-corruption-debug-fix.patch

This patch was dropped because it was folded into mm-more-intensive-memory-corruption-debug.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-more-intensive-memory-corruption-debug-fix

tweak documentation, s/flg/flag/

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   31 +++++++++++++-------------
 mm/page_alloc.c                     |   12 +++++-----
 2 files changed, 22 insertions(+), 21 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-more-intensive-memory-corruption-debug-fix Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-more-intensive-memory-corruption-debug-fix
+++ a/Documentation/kernel-parameters.txt
@@ -630,21 +630,22 @@ bytes respectively. Such letter suffixes
 
 	debug_guardpage_minorder=
 			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
-			parameter allows control order of pages that will be
-			intentionally kept free (and hence protected) by buddy
-			allocator. Bigger value increase probability of
-			catching random memory corruption, but reduce amount
-			of memory for normal system use. Maximum possible
-			value is MAX_ORDER/2. Setting this parameter to 1 or 2,
-			should be enough to identify most random memory
-			corruption problems caused by bugs in kernel/drivers
-			code when CPU write to (or read from) random memory
-			location. Note that there exist class of memory
-			corruptions problems caused by buggy H/W or F/W or by
-			drivers badly programing DMA (basically when memory is
-			written at bus level and CPU MMU is bypassed), which
-			are not detectable by CONFIG_DEBUG_PAGEALLOC, hence this
-			option would not help tracking down these problems too.
+			parameter allows control of the order of pages that will
+			be intentionally kept free (and hence protected) by the
+			buddy allocator. Bigger value increase the probability
+			of catching random memory corruption, but reduce the
+			amount of memory for normal system use. The maximum
+			possible value is MAX_ORDER/2.  Setting this parameter
+			to 1 or 2 should be enough to identify most random
+			memory corruption problems caused by bugs in kernel or
+			driver code when a CPU writes to (or reads from) a
+			random memory location. Note that there exists a class
+			of memory corruptions problems caused by buggy H/W or
+			F/W or by drivers badly programing DMA (basically when
+			memory is written at bus level and the CPU MMU is
+			bypassed) which are not detectable by
+			CONFIG_DEBUG_PAGEALLOC, hence this option will not help
+			tracking down these problems.
 
 	debugpat	[X86] Enable PAT debugging
 
diff -puN mm/page_alloc.c~mm-more-intensive-memory-corruption-debug-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-intensive-memory-corruption-debug-fix
+++ a/mm/page_alloc.c
@@ -419,18 +419,18 @@ static int __init debug_guardpage_minord
 }
 __setup("debug_guardpage_minorder=", debug_guardpage_minorder_setup);
 
-static inline void set_page_guard_flg(struct page *page)
+static inline void set_page_guard_flag(struct page *page)
 {
 	__set_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
 }
 
-static inline void clear_page_guard_flg(struct page *page)
+static inline void clear_page_guard_flag(struct page *page)
 {
 	__clear_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
 }
 #else
-static inline void set_page_guard_flg(struct page *page) { }
-static inline void clear_page_guard_flg(struct page *page) { }
+static inline void set_page_guard_flag(struct page *page) { }
+static inline void clear_page_guard_flag(struct page *page) { }
 #endif
 
 static inline void set_page_order(struct page *page, int order)
@@ -556,7 +556,7 @@ static inline void __free_one_page(struc
 		 * merge with it and move up one order.
 		 */
 		if (page_is_guard(buddy)) {
-			clear_page_guard_flg(buddy);
+			clear_page_guard_flag(buddy);
 			set_page_private(page, 0);
 			__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 		} else {
@@ -799,7 +799,7 @@ static inline void expand(struct zone *z
 			 * pages will stay not present in virtual address space
 			 */
 			INIT_LIST_HEAD(&page[size].lru);
-			set_page_guard_flg(&page[size]);
+			set_page_guard_flag(&page[size]);
 			set_page_private(&page[size], high);
 			/* Guard pages are not available for any usage */
 			__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << high));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mempool-fix-first-round-failure-behavior-fix.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

