From: akpm@linux-foundation.org
Subject: +
 mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
 added to -mm tree
Date: Thu, 19 Mar 2015 15:19:58 -0700
Message-ID: <550b4b8e.CmsQHsacEivJA4AK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbCSWT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Mar 2015 18:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, gong.chen@linux.intel.com, rostedt@goodmis.org, tony.luck@intel.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: define page types for action_result() in one place
has been added to the -mm tree.  Its filename is
     mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: define page types for action_result() in one place

This cleanup patch moves all strings passed to action_result() into a
singl= e array action_page_type so that a reader can easily find which
kind of actio= n results are possible.  And this patch also fixes the odd
lines to be printed out, like "unknown page state page" or "free buddy,
2nd try page".

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Xie XiuQi" <xiexiuqi@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  107 +++++++++++++++++++++++++++++-------------
 1 file changed, 76 insertions(+), 31 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place
+++ a/mm/memory-failure.c
@@ -521,6 +521,52 @@ static const char *action_name[] = {
 	[RECOVERED] = "Recovered",
 };
 
+enum page_type {
+	KERNEL,
+	KERNEL_HIGH_ORDER,
+	SLAB,
+	DIFFERENT_COMPOUND,
+	POISONED_HUGE,
+	HUGE,
+	FREE_HUGE,
+	UNMAP_FAILED,
+	DIRTY_SWAPCACHE,
+	CLEAN_SWAPCACHE,
+	DIRTY_MLOCKED_LRU,
+	CLEAN_MLOCKED_LRU,
+	DIRTY_UNEVICTABLE_LRU,
+	CLEAN_UNEVICTABLE_LRU,
+	DIRTY_LRU,
+	CLEAN_LRU,
+	TRUNCATED_LRU,
+	BUDDY,
+	BUDDY_2ND,
+	UNKNOWN,
+};
+
+static const char *action_page_type[] = {
+	[KERNEL]		= "reserved kernel page",
+	[KERNEL_HIGH_ORDER]	= "high-order kernel page",
+	[SLAB]			= "kernel slab page",
+	[DIFFERENT_COMPOUND]	= "different compound page after locking",
+	[POISONED_HUGE]		= "huge page already hardware poisoned",
+	[HUGE]			= "huge page",
+	[FREE_HUGE]		= "free huge page",
+	[UNMAP_FAILED]		= "unmapping failed page",
+	[DIRTY_SWAPCACHE]	= "dirty swapcache page",
+	[CLEAN_SWAPCACHE]	= "clean swapcache page",
+	[DIRTY_MLOCKED_LRU]	= "dirty mlocked LRU page",
+	[CLEAN_MLOCKED_LRU]	= "clean mlocked LRU page",
+	[DIRTY_UNEVICTABLE_LRU]	= "dirty unevictable LRU page",
+	[CLEAN_UNEVICTABLE_LRU]	= "clean unevictable LRU page",
+	[DIRTY_LRU]		= "dirty LRU page",
+	[CLEAN_LRU]		= "clean LRU page",
+	[TRUNCATED_LRU]		= "already truncated LRU page",
+	[BUDDY]			= "free buddy page",
+	[BUDDY_2ND]		= "free buddy page (2nd try)",
+	[UNKNOWN]		= "unknown page",
+};
+
 /*
  * XXX: It is possible that a page is isolated from LRU cache,
  * and then kept in swap cache or failed to remove from page cache.
@@ -777,10 +823,10 @@ static int me_huge_page(struct page *p,
 static struct page_state {
 	unsigned long mask;
 	unsigned long res;
-	char *msg;
+	int type;
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
-	{ reserved,	reserved,	"reserved kernel",	me_kernel },
+	{ reserved,	reserved,	KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -791,31 +837,31 @@ static struct page_state {
 	 * currently unused objects without touching them. But just
 	 * treat it as standard kernel for now.
 	 */
-	{ slab,		slab,		"kernel slab",	me_kernel },
+	{ slab,		slab,		SLAB,	me_kernel },
 
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
-	{ head,		head,		"huge",		me_huge_page },
-	{ tail,		tail,		"huge",		me_huge_page },
+	{ head,		head,		HUGE,		me_huge_page },
+	{ tail,		tail,		HUGE,		me_huge_page },
 #else
-	{ compound,	compound,	"huge",		me_huge_page },
+	{ compound,	compound,	HUGE,		me_huge_page },
 #endif
 
-	{ sc|dirty,	sc|dirty,	"dirty swapcache",	me_swapcache_dirty },
-	{ sc|dirty,	sc,		"clean swapcache",	me_swapcache_clean },
+	{ sc|dirty,	sc|dirty,	DIRTY_SWAPCACHE,	me_swapcache_dirty },
+	{ sc|dirty,	sc,		CLEAN_SWAPCACHE,	me_swapcache_clean },
 
-	{ mlock|dirty,	mlock|dirty,	"dirty mlocked LRU",	me_pagecache_dirty },
-	{ mlock|dirty,	mlock,		"clean mlocked LRU",	me_pagecache_clean },
+	{ mlock|dirty,	mlock|dirty,	DIRTY_MLOCKED_LRU,	me_pagecache_dirty },
+	{ mlock|dirty,	mlock,		CLEAN_MLOCKED_LRU,	me_pagecache_clean },
 
-	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
-	{ unevict|dirty, unevict,	"clean unevictable LRU", me_pagecache_clean },
+	{ unevict|dirty, unevict|dirty,	DIRTY_UNEVICTABLE_LRU,	me_pagecache_dirty },
+	{ unevict|dirty, unevict,	DIRTY_UNEVICTABLE_LRU,	me_pagecache_clean },
 
-	{ lru|dirty,	lru|dirty,	"dirty LRU",	me_pagecache_dirty },
-	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
+	{ lru|dirty,	lru|dirty,	DIRTY_LRU,	me_pagecache_dirty },
+	{ lru|dirty,	lru,		CLEAN_LRU,	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.
 	 */
-	{ 0,		0,		"unknown page state",	me_unknown },
+	{ 0,		0,		UNKNOWN,	me_unknown },
 };
 
 #undef dirty
@@ -835,10 +881,10 @@ static struct page_state {
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
-static void action_result(unsigned long pfn, char *msg, int result)
+static void action_result(unsigned long pfn, int type, int result)
 {
-	pr_err("MCE %#lx: %s page recovery: %s\n",
-		pfn, msg, action_name[result]);
+	pr_err("MCE %#lx: recovery action for %s: %s\n",
+		pfn, action_page_type[type], action_name[result]);
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -854,11 +900,11 @@ static int page_action(struct page_state
 		count--;
 	if (count != 0) {
 		printk(KERN_ERR
-		       "MCE %#lx: %s page still referenced by %d users\n",
-		       pfn, ps->msg, count);
+		       "MCE %#lx: %s still referenced by %d users\n",
+		       pfn, action_page_type[ps->type], count);
 		result = FAILED;
 	}
-	action_result(pfn, ps->msg, result);
+	action_result(pfn, ps->type, result);
 
 	/* Could do more checks here if page looks ok */
 	/*
@@ -1106,7 +1152,7 @@ int memory_failure(unsigned long pfn, in
 	if (!(flags & MF_COUNT_INCREASED) &&
 		!get_page_unless_zero(hpage)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, "free buddy", DELAYED);
+			action_result(pfn, BUDDY, DELAYED);
 			return 0;
 		} else if (PageHuge(hpage)) {
 			/*
@@ -1123,12 +1169,12 @@ int memory_failure(unsigned long pfn, in
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
-			action_result(pfn, "free huge",
+			action_result(pfn, FREE_HUGE,
 				      res ? IGNORED : DELAYED);
 			unlock_page(hpage);
 			return res;
 		} else {
-			action_result(pfn, "high order kernel", IGNORED);
+			action_result(pfn, KERNEL_HIGH_ORDER, IGNORED);
 			return -EBUSY;
 		}
 	}
@@ -1150,9 +1196,9 @@ int memory_failure(unsigned long pfn, in
 			 */
 			if (is_free_buddy_page(p)) {
 				if (flags & MF_COUNT_INCREASED)
-					action_result(pfn, "free buddy", DELAYED);
+					action_result(pfn, BUDDY, DELAYED);
 				else
-					action_result(pfn, "free buddy, 2nd try", DELAYED);
+					action_result(pfn, BUDDY_2ND, DELAYED);
 				return 0;
 			}
 		}
@@ -1165,7 +1211,7 @@ int memory_failure(unsigned long pfn, in
 	 * If this happens just bail out.
 	 */
 	if (compound_head(p) != hpage) {
-		action_result(pfn, "different compound page after locking", IGNORED);
+		action_result(pfn, DIFFERENT_COMPOUND, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1205,8 +1251,7 @@ int memory_failure(unsigned long pfn, in
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
 	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
-		action_result(pfn, "hugepage already hardware poisoned",
-				IGNORED);
+		action_result(pfn, POISONED_HUGE, IGNORED);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1235,7 +1280,7 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
 	    != SWAP_SUCCESS) {
-		action_result(pfn, "unmapping failed", IGNORED);
+		action_result(pfn, UNMAP_FAILED, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1244,7 +1289,7 @@ int memory_failure(unsigned long pfn, in
 	 * Torn down by someone else?
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
-		action_result(pfn, "already truncated LRU", IGNORED);
+		action_result(pfn, TRUNCATED_LRU, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
mm-page_alloc-call-kernel_map_pages-in-unset_migrateype_isolate.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

