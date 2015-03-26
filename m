From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch removed from -mm tree
Date: Thu, 26 Mar 2015 12:35:20 -0700
Message-ID: <55145f78.n2Yi+bqILDMqgSa/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbCZTfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Mar 2015 15:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, gong.chen@linux.intel.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, rostedt@goodmis.org, tony.luck@intel.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2.patch

This patch was dropped because it was folded into mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2

rename messages, per David

Cc: "Xie XiuQi" <xiexiuqi@huawei.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  127 +++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 63 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix-2
+++ a/mm/memory-failure.c
@@ -522,49 +522,49 @@ static const char *action_name[] = {
 };
 
 enum page_type {
-	KERNEL,
-	KERNEL_HIGH_ORDER,
-	SLAB,
-	DIFFERENT_COMPOUND,
-	POISONED_HUGE,
-	HUGE,
-	FREE_HUGE,
-	UNMAP_FAILED,
-	DIRTY_SWAPCACHE,
-	CLEAN_SWAPCACHE,
-	DIRTY_MLOCKED_LRU,
-	CLEAN_MLOCKED_LRU,
-	DIRTY_UNEVICTABLE_LRU,
-	CLEAN_UNEVICTABLE_LRU,
-	DIRTY_LRU,
-	CLEAN_LRU,
-	TRUNCATED_LRU,
-	BUDDY,
-	BUDDY_2ND,
-	UNKNOWN,
+	MSG_KERNEL,
+	MSG_KERNEL_HIGH_ORDER,
+	MSG_SLAB,
+	MSG_DIFFERENT_COMPOUND,
+	MSG_POISONED_HUGE,
+	MSG_HUGE,
+	MSG_FREE_HUGE,
+	MSG_UNMAP_FAILED,
+	MSG_DIRTY_SWAPCACHE,
+	MSG_CLEAN_SWAPCACHE,
+	MSG_DIRTY_MLOCKED_LRU,
+	MSG_CLEAN_MLOCKED_LRU,
+	MSG_DIRTY_UNEVICTABLE_LRU,
+	MSG_CLEAN_UNEVICTABLE_LRU,
+	MSG_DIRTY_LRU,
+	MSG_CLEAN_LRU,
+	MSG_TRUNCATED_LRU,
+	MSG_BUDDY,
+	MSG_BUDDY_2ND,
+	MSG_UNKNOWN,
 };
 
 static const char *action_page_type[] = {
-	[KERNEL]		= "reserved kernel page",
-	[KERNEL_HIGH_ORDER]	= "high-order kernel page",
-	[SLAB]			= "kernel slab page",
-	[DIFFERENT_COMPOUND]	= "different compound page after locking",
-	[POISONED_HUGE]		= "huge page already hardware poisoned",
-	[HUGE]			= "huge page",
-	[FREE_HUGE]		= "free huge page",
-	[UNMAP_FAILED]		= "unmapping failed page",
-	[DIRTY_SWAPCACHE]	= "dirty swapcache page",
-	[CLEAN_SWAPCACHE]	= "clean swapcache page",
-	[DIRTY_MLOCKED_LRU]	= "dirty mlocked LRU page",
-	[CLEAN_MLOCKED_LRU]	= "clean mlocked LRU page",
-	[DIRTY_UNEVICTABLE_LRU]	= "dirty unevictable LRU page",
-	[CLEAN_UNEVICTABLE_LRU]	= "clean unevictable LRU page",
-	[DIRTY_LRU]		= "dirty LRU page",
-	[CLEAN_LRU]		= "clean LRU page",
-	[TRUNCATED_LRU]		= "already truncated LRU page",
-	[BUDDY]			= "free buddy page",
-	[BUDDY_2ND]		= "free buddy page (2nd try)",
-	[UNKNOWN]		= "unknown page",
+	[MSG_KERNEL]			= "reserved kernel page",
+	[MSG_KERNEL_HIGH_ORDER]		= "high-order kernel page",
+	[MSG_SLAB]			= "kernel slab page",
+	[MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
+	[MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
+	[MSG_HUGE]			= "huge page",
+	[MSG_FREE_HUGE]			= "free huge page",
+	[MSG_UNMAP_FAILED]		= "unmapping failed page",
+	[MSG_DIRTY_SWAPCACHE]		= "dirty swapcache page",
+	[MSG_CLEAN_SWAPCACHE]		= "clean swapcache page",
+	[MSG_DIRTY_MLOCKED_LRU]		= "dirty mlocked LRU page",
+	[MSG_CLEAN_MLOCKED_LRU]		= "clean mlocked LRU page",
+	[MSG_DIRTY_UNEVICTABLE_LRU]	= "dirty unevictable LRU page",
+	[MSG_CLEAN_UNEVICTABLE_LRU]	= "clean unevictable LRU page",
+	[MSG_DIRTY_LRU]			= "dirty LRU page",
+	[MSG_CLEAN_LRU]			= "clean LRU page",
+	[MSG_TRUNCATED_LRU]		= "already truncated LRU page",
+	[MSG_BUDDY]			= "free buddy page",
+	[MSG_BUDDY_2ND]			= "free buddy page (2nd try)",
+	[MSG_UNKNOWN]			= "unknown page",
 };
 
 /*
@@ -826,7 +826,7 @@ static struct page_state {
 	int type;
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
-	{ reserved,	reserved,	KERNEL,	me_kernel },
+	{ reserved,	reserved,	MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -837,31 +837,31 @@ static struct page_state {
 	 * currently unused objects without touching them. But just
 	 * treat it as standard kernel for now.
 	 */
-	{ slab,		slab,		SLAB,	me_kernel },
+	{ slab,		slab,		MSG_SLAB,	me_kernel },
 
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
-	{ head,		head,		HUGE,		me_huge_page },
-	{ tail,		tail,		HUGE,		me_huge_page },
+	{ head,		head,		MSG_HUGE,		me_huge_page },
+	{ tail,		tail,		MSG_HUGE,		me_huge_page },
 #else
-	{ compound,	compound,	HUGE,		me_huge_page },
+	{ compound,	compound,	MSG_HUGE,		me_huge_page },
 #endif
 
-	{ sc|dirty,	sc|dirty,	DIRTY_SWAPCACHE,	me_swapcache_dirty },
-	{ sc|dirty,	sc,		CLEAN_SWAPCACHE,	me_swapcache_clean },
+	{ sc|dirty,	sc|dirty,	MSG_DIRTY_SWAPCACHE,	me_swapcache_dirty },
+	{ sc|dirty,	sc,		MSG_CLEAN_SWAPCACHE,	me_swapcache_clean },
 
-	{ mlock|dirty,	mlock|dirty,	DIRTY_MLOCKED_LRU,	me_pagecache_dirty },
-	{ mlock|dirty,	mlock,		CLEAN_MLOCKED_LRU,	me_pagecache_clean },
+	{ mlock|dirty,	mlock|dirty,	MSG_DIRTY_MLOCKED_LRU,	me_pagecache_dirty },
+	{ mlock|dirty,	mlock,		MSG_CLEAN_MLOCKED_LRU,	me_pagecache_clean },
 
-	{ unevict|dirty, unevict|dirty,	DIRTY_UNEVICTABLE_LRU,	me_pagecache_dirty },
-	{ unevict|dirty, unevict,	DIRTY_UNEVICTABLE_LRU,	me_pagecache_clean },
+	{ unevict|dirty, unevict|dirty,	MSG_DIRTY_UNEVICTABLE_LRU,	me_pagecache_dirty },
+	{ unevict|dirty, unevict,	MSG_DIRTY_UNEVICTABLE_LRU,	me_pagecache_clean },
 
-	{ lru|dirty,	lru|dirty,	DIRTY_LRU,	me_pagecache_dirty },
-	{ lru|dirty,	lru,		CLEAN_LRU,	me_pagecache_clean },
+	{ lru|dirty,	lru|dirty,	MSG_DIRTY_LRU,	me_pagecache_dirty },
+	{ lru|dirty,	lru,		MSG_CLEAN_LRU,	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.
 	 */
-	{ 0,		0,		UNKNOWN,	me_unknown },
+	{ 0,		0,		MSG_UNKNOWN,	me_unknown },
 };
 
 #undef dirty
@@ -1152,7 +1152,7 @@ int memory_failure(unsigned long pfn, in
 	if (!(flags & MF_COUNT_INCREASED) &&
 		!get_page_unless_zero(hpage)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, BUDDY, DELAYED);
+			action_result(pfn, MSG_BUDDY, DELAYED);
 			return 0;
 		} else if (PageHuge(hpage)) {
 			/*
@@ -1169,12 +1169,12 @@ int memory_failure(unsigned long pfn, in
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
-			action_result(pfn, FREE_HUGE,
+			action_result(pfn, MSG_FREE_HUGE,
 				      res ? IGNORED : DELAYED);
 			unlock_page(hpage);
 			return res;
 		} else {
-			action_result(pfn, KERNEL_HIGH_ORDER, IGNORED);
+			action_result(pfn, MSG_KERNEL_HIGH_ORDER, IGNORED);
 			return -EBUSY;
 		}
 	}
@@ -1196,9 +1196,10 @@ int memory_failure(unsigned long pfn, in
 			 */
 			if (is_free_buddy_page(p)) {
 				if (flags & MF_COUNT_INCREASED)
-					action_result(pfn, BUDDY, DELAYED);
+					action_result(pfn, MSG_BUDDY, DELAYED);
 				else
-					action_result(pfn, BUDDY_2ND, DELAYED);
+					action_result(pfn, MSG_BUDDY_2ND,
+						      DELAYED);
 				return 0;
 			}
 		}
@@ -1211,7 +1212,7 @@ int memory_failure(unsigned long pfn, in
 	 * If this happens just bail out.
 	 */
 	if (compound_head(p) != hpage) {
-		action_result(pfn, DIFFERENT_COMPOUND, IGNORED);
+		action_result(pfn, MSG_DIFFERENT_COMPOUND, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1251,7 +1252,7 @@ int memory_failure(unsigned long pfn, in
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
 	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
-		action_result(pfn, POISONED_HUGE, IGNORED);
+		action_result(pfn, MSG_POISONED_HUGE, IGNORED);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1280,7 +1281,7 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
 	    != SWAP_SUCCESS) {
-		action_result(pfn, UNMAP_FAILED, IGNORED);
+		action_result(pfn, MSG_UNMAP_FAILED, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1289,7 +1290,7 @@ int memory_failure(unsigned long pfn, in
 	 * Torn down by someone else?
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
-		action_result(pfn, TRUNCATED_LRU, IGNORED);
+		action_result(pfn, MSG_TRUNCATED_LRU, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
include-sound-fix-build.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

