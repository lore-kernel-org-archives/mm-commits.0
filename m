From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:21 -0700
Message-ID: <552fe889.pmEHeDK6muex7GG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbbDPQpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, gong.chen@linux.intel.com, rientjes@google.com, rostedt@goodmis.org, tony.luck@intel.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: define page types for action_result() in one place
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/memory-failure.c: define page types for action_result() in one place

This cleanup patch moves all strings passed to action_result() into a
singl= e array action_page_type so that a reader can easily find which
kind of actio= n results are possible.  And this patch also fixes the odd
lines to be printed out, like "unknown page state page" or "free buddy,
2nd try page".

[akpm@linux-foundation.org: rename messages, per David]
[akpm@linux-foundation.org: s/DIRTY_UNEVICTABLE_LRU/CLEAN_UNEVICTABLE_LRU', per Andi]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Xie XiuQi" <xiexiuqi@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  108 +++++++++++++++++++++++++++++-------------
 1 file changed, 77 insertions(+), 31 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failurec-define-page-types-for-action_result-in-one-place
+++ a/mm/memory-failure.c
@@ -521,6 +521,52 @@ static const char *action_name[] = {
 	[RECOVERED] = "Recovered",
 };
 
+enum action_page_type {
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
+};
+
+static const char * const action_page_types[] = {
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
+	enum action_page_type type;
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
-	{ reserved,	reserved,	"reserved kernel",	me_kernel },
+	{ reserved,	reserved,	MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -791,31 +837,31 @@ static struct page_state {
 	 * currently unused objects without touching them. But just
 	 * treat it as standard kernel for now.
 	 */
-	{ slab,		slab,		"kernel slab",	me_kernel },
+	{ slab,		slab,		MSG_SLAB,	me_kernel },
 
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
-	{ head,		head,		"huge",		me_huge_page },
-	{ tail,		tail,		"huge",		me_huge_page },
+	{ head,		head,		MSG_HUGE,		me_huge_page },
+	{ tail,		tail,		MSG_HUGE,		me_huge_page },
 #else
-	{ compound,	compound,	"huge",		me_huge_page },
+	{ compound,	compound,	MSG_HUGE,		me_huge_page },
 #endif
 
-	{ sc|dirty,	sc|dirty,	"dirty swapcache",	me_swapcache_dirty },
-	{ sc|dirty,	sc,		"clean swapcache",	me_swapcache_clean },
+	{ sc|dirty,	sc|dirty,	MSG_DIRTY_SWAPCACHE,	me_swapcache_dirty },
+	{ sc|dirty,	sc,		MSG_CLEAN_SWAPCACHE,	me_swapcache_clean },
 
-	{ mlock|dirty,	mlock|dirty,	"dirty mlocked LRU",	me_pagecache_dirty },
-	{ mlock|dirty,	mlock,		"clean mlocked LRU",	me_pagecache_clean },
+	{ mlock|dirty,	mlock|dirty,	MSG_DIRTY_MLOCKED_LRU,	me_pagecache_dirty },
+	{ mlock|dirty,	mlock,		MSG_CLEAN_MLOCKED_LRU,	me_pagecache_clean },
 
-	{ unevict|dirty, unevict|dirty,	"dirty unevictable LRU", me_pagecache_dirty },
-	{ unevict|dirty, unevict,	"clean unevictable LRU", me_pagecache_clean },
+	{ unevict|dirty, unevict|dirty,	MSG_DIRTY_UNEVICTABLE_LRU,	me_pagecache_dirty },
+	{ unevict|dirty, unevict,	MSG_CLEAN_UNEVICTABLE_LRU,	me_pagecache_clean },
 
-	{ lru|dirty,	lru|dirty,	"dirty LRU",	me_pagecache_dirty },
-	{ lru|dirty,	lru,		"clean LRU",	me_pagecache_clean },
+	{ lru|dirty,	lru|dirty,	MSG_DIRTY_LRU,	me_pagecache_dirty },
+	{ lru|dirty,	lru,		MSG_CLEAN_LRU,	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.
 	 */
-	{ 0,		0,		"unknown page state",	me_unknown },
+	{ 0,		0,		MSG_UNKNOWN,	me_unknown },
 };
 
 #undef dirty
@@ -835,10 +881,10 @@ static struct page_state {
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
-static void action_result(unsigned long pfn, char *msg, int result)
+static void action_result(unsigned long pfn, enum action_page_type type, int result)
 {
-	pr_err("MCE %#lx: %s page recovery: %s\n",
-		pfn, msg, action_name[result]);
+	pr_err("MCE %#lx: recovery action for %s: %s\n",
+		pfn, action_page_types[type], action_name[result]);
 }
 
 static int page_action(struct page_state *ps, struct page *p,
@@ -854,11 +900,11 @@ static int page_action(struct page_state
 		count--;
 	if (count != 0) {
 		printk(KERN_ERR
-		       "MCE %#lx: %s page still referenced by %d users\n",
-		       pfn, ps->msg, count);
+		       "MCE %#lx: %s still referenced by %d users\n",
+		       pfn, action_page_types[ps->type], count);
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
+			action_result(pfn, MSG_BUDDY, DELAYED);
 			return 0;
 		} else if (PageHuge(hpage)) {
 			/*
@@ -1123,12 +1169,12 @@ int memory_failure(unsigned long pfn, in
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
-			action_result(pfn, "free huge",
+			action_result(pfn, MSG_FREE_HUGE,
 				      res ? IGNORED : DELAYED);
 			unlock_page(hpage);
 			return res;
 		} else {
-			action_result(pfn, "high order kernel", IGNORED);
+			action_result(pfn, MSG_KERNEL_HIGH_ORDER, IGNORED);
 			return -EBUSY;
 		}
 	}
@@ -1150,9 +1196,10 @@ int memory_failure(unsigned long pfn, in
 			 */
 			if (is_free_buddy_page(p)) {
 				if (flags & MF_COUNT_INCREASED)
-					action_result(pfn, "free buddy", DELAYED);
+					action_result(pfn, MSG_BUDDY, DELAYED);
 				else
-					action_result(pfn, "free buddy, 2nd try", DELAYED);
+					action_result(pfn, MSG_BUDDY_2ND,
+						      DELAYED);
 				return 0;
 			}
 		}
@@ -1165,7 +1212,7 @@ int memory_failure(unsigned long pfn, in
 	 * If this happens just bail out.
 	 */
 	if (compound_head(p) != hpage) {
-		action_result(pfn, "different compound page after locking", IGNORED);
+		action_result(pfn, MSG_DIFFERENT_COMPOUND, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1205,8 +1252,7 @@ int memory_failure(unsigned long pfn, in
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
 	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
-		action_result(pfn, "hugepage already hardware poisoned",
-				IGNORED);
+		action_result(pfn, MSG_POISONED_HUGE, IGNORED);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1235,7 +1281,7 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
 	    != SWAP_SUCCESS) {
-		action_result(pfn, "unmapping failed", IGNORED);
+		action_result(pfn, MSG_UNMAP_FAILED, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1244,7 +1290,7 @@ int memory_failure(unsigned long pfn, in
 	 * Torn down by someone else?
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
-		action_result(pfn, "already truncated LRU", IGNORED);
+		action_result(pfn, MSG_TRUNCATED_LRU, IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

