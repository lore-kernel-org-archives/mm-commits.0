From: akpm@linux-foundation.org
Subject: + mm-more-intensive-memory-corruption-debug-fix.patch added to -mm tree
Date: Tue, 22 Nov 2011 13:56:35 -0800
Message-ID: <201111222157.pAMLuZik001954@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:60138 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1KVV5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 16:57:04 -0500
Received: by mail-ww0-f74.google.com with SMTP id 5so26112wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 13:57:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, cl@linux-foundation.org, mgorman@suse.de, penberg@cs.helsinki.fi, rjw@sisk.pl, sgruszka@redhat.com


The patch titled
     Subject: mm-more-intensive-memory-corruption-debug-fix
has been added to the -mm tree.  Its filename is
     mm-more-intensive-memory-corruption-debug-fix.patch

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
@@ -625,21 +625,22 @@ bytes respectively. Such letter suffixes
 
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
@@ -441,18 +441,18 @@ static int __init debug_guardpage_minord
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
@@ -578,7 +578,7 @@ static inline void __free_one_page(struc
 		 * merge with it and move up one order.
 		 */
 		if (page_is_guard(buddy)) {
-			clear_page_guard_flg(buddy);
+			clear_page_guard_flag(buddy);
 			set_page_private(page, 0);
 			__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 		} else {
@@ -821,7 +821,7 @@ static inline void expand(struct zone *z
 			 * pages will stay not present in virtual address space
 			 */
 			INIT_LIST_HEAD(&page[size].lru);
-			set_page_guard_flg(&page[size]);
+			set_page_guard_flag(&page[size]);
 			set_page_private(&page[size], high);
 			/* Guard pages are not available for any usage */
 			__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << high));
_
Subject: Subject: mm-more-intensive-memory-corruption-debug-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

