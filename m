From: akpm@linux-foundation.org
Subject: + memory-failure-export-page_type-and-action-result.patch added
 to -mm tree
Date: Fri, 08 May 2015 15:41:55 -0700
Message-ID: <554d3bb3.RN9oKwn9knQ9SPW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbbEHWl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2015 18:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, n-horiguchi@ah.jp.nec.com, rostedt@goodmis.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: export page_type and action result
has been added to the -mm tree.  Its filename is
     memory-failure-export-page_type-and-action-result.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-failure-export-page_type-and-action-result.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-export-page_type-and-action-result.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: memory-failure: export page_type and action result

Export 'outcome' and 'action_page_type' to mm.h, so we can use these emnus
outside.

This patch is preparation for adding trace events for memory-failure
recovery action.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   34 ++++++++
 mm/memory-failure.c |  168 ++++++++++++++++--------------------------
 2 files changed, 101 insertions(+), 101 deletions(-)

diff -puN include/linux/mm.h~memory-failure-export-page_type-and-action-result include/linux/mm.h
--- a/include/linux/mm.h~memory-failure-export-page_type-and-action-result
+++ a/include/linux/mm.h
@@ -2156,6 +2156,40 @@ extern void shake_page(struct page *p, i
 extern atomic_long_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
+
+/*
+ * Error handlers for various types of pages.
+ */
+enum mf_outcome {
+	MF_IGNORED,	/* Error: cannot be handled */
+	MF_FAILED,	/* Error: handling failed */
+	MF_DELAYED,	/* Will be handled later */
+	MF_RECOVERED,	/* Successfully recovered */
+};
+
+enum mf_action_page_type {
+	MF_MSG_KERNEL,
+	MF_MSG_KERNEL_HIGH_ORDER,
+	MF_MSG_SLAB,
+	MF_MSG_DIFFERENT_COMPOUND,
+	MF_MSG_POISONED_HUGE,
+	MF_MSG_HUGE,
+	MF_MSG_FREE_HUGE,
+	MF_MSG_UNMAP_FAILED,
+	MF_MSG_DIRTY_SWAPCACHE,
+	MF_MSG_CLEAN_SWAPCACHE,
+	MF_MSG_DIRTY_MLOCKED_LRU,
+	MF_MSG_CLEAN_MLOCKED_LRU,
+	MF_MSG_DIRTY_UNEVICTABLE_LRU,
+	MF_MSG_CLEAN_UNEVICTABLE_LRU,
+	MF_MSG_DIRTY_LRU,
+	MF_MSG_CLEAN_LRU,
+	MF_MSG_TRUNCATED_LRU,
+	MF_MSG_BUDDY,
+	MF_MSG_BUDDY_2ND,
+	MF_MSG_UNKNOWN,
+};
+
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr,
diff -puN mm/memory-failure.c~memory-failure-export-page_type-and-action-result mm/memory-failure.c
--- a/mm/memory-failure.c~memory-failure-export-page_type-and-action-result
+++ a/mm/memory-failure.c
@@ -504,68 +504,34 @@ static void collect_procs(struct page *p
 	kfree(tk);
 }
 
-/*
- * Error handlers for various types of pages.
- */
-
-enum outcome {
-	IGNORED,	/* Error: cannot be handled */
-	FAILED,		/* Error: handling failed */
-	DELAYED,	/* Will be handled later */
-	RECOVERED,	/* Successfully recovered */
-};
-
 static const char *action_name[] = {
-	[IGNORED] = "Ignored",
-	[FAILED] = "Failed",
-	[DELAYED] = "Delayed",
-	[RECOVERED] = "Recovered",
-};
-
-enum action_page_type {
-	MSG_KERNEL,
-	MSG_KERNEL_HIGH_ORDER,
-	MSG_SLAB,
-	MSG_DIFFERENT_COMPOUND,
-	MSG_POISONED_HUGE,
-	MSG_HUGE,
-	MSG_FREE_HUGE,
-	MSG_UNMAP_FAILED,
-	MSG_DIRTY_SWAPCACHE,
-	MSG_CLEAN_SWAPCACHE,
-	MSG_DIRTY_MLOCKED_LRU,
-	MSG_CLEAN_MLOCKED_LRU,
-	MSG_DIRTY_UNEVICTABLE_LRU,
-	MSG_CLEAN_UNEVICTABLE_LRU,
-	MSG_DIRTY_LRU,
-	MSG_CLEAN_LRU,
-	MSG_TRUNCATED_LRU,
-	MSG_BUDDY,
-	MSG_BUDDY_2ND,
-	MSG_UNKNOWN,
+	[MF_IGNORED] = "Ignored",
+	[MF_FAILED] = "Failed",
+	[MF_DELAYED] = "Delayed",
+	[MF_RECOVERED] = "Recovered",
 };
 
 static const char * const action_page_types[] = {
-	[MSG_KERNEL]			= "reserved kernel page",
-	[MSG_KERNEL_HIGH_ORDER]		= "high-order kernel page",
-	[MSG_SLAB]			= "kernel slab page",
-	[MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
-	[MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
-	[MSG_HUGE]			= "huge page",
-	[MSG_FREE_HUGE]			= "free huge page",
-	[MSG_UNMAP_FAILED]		= "unmapping failed page",
-	[MSG_DIRTY_SWAPCACHE]		= "dirty swapcache page",
-	[MSG_CLEAN_SWAPCACHE]		= "clean swapcache page",
-	[MSG_DIRTY_MLOCKED_LRU]		= "dirty mlocked LRU page",
-	[MSG_CLEAN_MLOCKED_LRU]		= "clean mlocked LRU page",
-	[MSG_DIRTY_UNEVICTABLE_LRU]	= "dirty unevictable LRU page",
-	[MSG_CLEAN_UNEVICTABLE_LRU]	= "clean unevictable LRU page",
-	[MSG_DIRTY_LRU]			= "dirty LRU page",
-	[MSG_CLEAN_LRU]			= "clean LRU page",
-	[MSG_TRUNCATED_LRU]		= "already truncated LRU page",
-	[MSG_BUDDY]			= "free buddy page",
-	[MSG_BUDDY_2ND]			= "free buddy page (2nd try)",
-	[MSG_UNKNOWN]			= "unknown page",
+	[MF_MSG_KERNEL]			= "reserved kernel page",
+	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
+	[MF_MSG_SLAB]			= "kernel slab page",
+	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
+	[MF_MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
+	[MF_MSG_HUGE]			= "huge page",
+	[MF_MSG_FREE_HUGE]		= "free huge page",
+	[MF_MSG_UNMAP_FAILED]		= "unmapping failed page",
+	[MF_MSG_DIRTY_SWAPCACHE]	= "dirty swapcache page",
+	[MF_MSG_CLEAN_SWAPCACHE]	= "clean swapcache page",
+	[MF_MSG_DIRTY_MLOCKED_LRU]	= "dirty mlocked LRU page",
+	[MF_MSG_CLEAN_MLOCKED_LRU]	= "clean mlocked LRU page",
+	[MF_MSG_DIRTY_UNEVICTABLE_LRU]	= "dirty unevictable LRU page",
+	[MF_MSG_CLEAN_UNEVICTABLE_LRU]	= "clean unevictable LRU page",
+	[MF_MSG_DIRTY_LRU]		= "dirty LRU page",
+	[MF_MSG_CLEAN_LRU]		= "clean LRU page",
+	[MF_MSG_TRUNCATED_LRU]		= "already truncated LRU page",
+	[MF_MSG_BUDDY]			= "free buddy page",
+	[MF_MSG_BUDDY_2ND]		= "free buddy page (2nd try)",
+	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
 /*
@@ -599,7 +565,7 @@ static int delete_from_lru_cache(struct
  */
 static int me_kernel(struct page *p, unsigned long pfn)
 {
-	return IGNORED;
+	return MF_IGNORED;
 }
 
 /*
@@ -608,7 +574,7 @@ static int me_kernel(struct page *p, uns
 static int me_unknown(struct page *p, unsigned long pfn)
 {
 	printk(KERN_ERR "MCE %#lx: Unknown page state\n", pfn);
-	return FAILED;
+	return MF_FAILED;
 }
 
 /*
@@ -617,7 +583,7 @@ static int me_unknown(struct page *p, un
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
 	int err;
-	int ret = FAILED;
+	int ret = MF_FAILED;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -627,7 +593,7 @@ static int me_pagecache_clean(struct pag
 	 * should be the one m_f() holds.
 	 */
 	if (PageAnon(p))
-		return RECOVERED;
+		return MF_RECOVERED;
 
 	/*
 	 * Now truncate the page in the page cache. This is really
@@ -641,7 +607,7 @@ static int me_pagecache_clean(struct pag
 		/*
 		 * Page has been teared down in the meanwhile
 		 */
-		return FAILED;
+		return MF_FAILED;
 	}
 
 	/*
@@ -658,7 +624,7 @@ static int me_pagecache_clean(struct pag
 				!try_to_release_page(p, GFP_NOIO)) {
 			pr_info("MCE %#lx: failed to release buffers\n", pfn);
 		} else {
-			ret = RECOVERED;
+			ret = MF_RECOVERED;
 		}
 	} else {
 		/*
@@ -666,7 +632,7 @@ static int me_pagecache_clean(struct pag
 		 * This fails on dirty or anything with private pages
 		 */
 		if (invalidate_inode_page(p))
-			ret = RECOVERED;
+			ret = MF_RECOVERED;
 		else
 			printk(KERN_INFO "MCE %#lx: Failed to invalidate\n",
 				pfn);
@@ -752,9 +718,9 @@ static int me_swapcache_dirty(struct pag
 	ClearPageUptodate(p);
 
 	if (!delete_from_lru_cache(p))
-		return DELAYED;
+		return MF_DELAYED;
 	else
-		return FAILED;
+		return MF_FAILED;
 }
 
 static int me_swapcache_clean(struct page *p, unsigned long pfn)
@@ -762,9 +728,9 @@ static int me_swapcache_clean(struct pag
 	delete_from_swap_cache(p);
 
 	if (!delete_from_lru_cache(p))
-		return RECOVERED;
+		return MF_RECOVERED;
 	else
-		return FAILED;
+		return MF_FAILED;
 }
 
 /*
@@ -790,9 +756,9 @@ static int me_huge_page(struct page *p,
 	if (!(page_mapping(hpage) || PageAnon(hpage))) {
 		res = dequeue_hwpoisoned_huge_page(hpage);
 		if (!res)
-			return RECOVERED;
+			return MF_RECOVERED;
 	}
-	return DELAYED;
+	return MF_DELAYED;
 }
 
 /*
@@ -824,10 +790,10 @@ static int me_huge_page(struct page *p,
 static struct page_state {
 	unsigned long mask;
 	unsigned long res;
-	enum action_page_type type;
+	enum mf_action_page_type type;
 	int (*action)(struct page *p, unsigned long pfn);
 } error_states[] = {
-	{ reserved,	reserved,	MSG_KERNEL,	me_kernel },
+	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -838,31 +804,31 @@ static struct page_state {
 	 * currently unused objects without touching them. But just
 	 * treat it as standard kernel for now.
 	 */
-	{ slab,		slab,		MSG_SLAB,	me_kernel },
+	{ slab,		slab,		MF_MSG_SLAB,	me_kernel },
 
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
-	{ head,		head,		MSG_HUGE,		me_huge_page },
-	{ tail,		tail,		MSG_HUGE,		me_huge_page },
+	{ head,		head,		MF_MSG_HUGE,		me_huge_page },
+	{ tail,		tail,		MF_MSG_HUGE,		me_huge_page },
 #else
-	{ compound,	compound,	MSG_HUGE,		me_huge_page },
+	{ compound,	compound,	MF_MSG_HUGE,		me_huge_page },
 #endif
 
-	{ sc|dirty,	sc|dirty,	MSG_DIRTY_SWAPCACHE,	me_swapcache_dirty },
-	{ sc|dirty,	sc,		MSG_CLEAN_SWAPCACHE,	me_swapcache_clean },
+	{ sc|dirty,	sc|dirty,	MF_MSG_DIRTY_SWAPCACHE,	me_swapcache_dirty },
+	{ sc|dirty,	sc,		MF_MSG_CLEAN_SWAPCACHE,	me_swapcache_clean },
 
-	{ mlock|dirty,	mlock|dirty,	MSG_DIRTY_MLOCKED_LRU,	me_pagecache_dirty },
-	{ mlock|dirty,	mlock,		MSG_CLEAN_MLOCKED_LRU,	me_pagecache_clean },
+	{ mlock|dirty,	mlock|dirty,	MF_MSG_DIRTY_MLOCKED_LRU,	me_pagecache_dirty },
+	{ mlock|dirty,	mlock,		MF_MSG_CLEAN_MLOCKED_LRU,	me_pagecache_clean },
 
-	{ unevict|dirty, unevict|dirty,	MSG_DIRTY_UNEVICTABLE_LRU,	me_pagecache_dirty },
-	{ unevict|dirty, unevict,	MSG_CLEAN_UNEVICTABLE_LRU,	me_pagecache_clean },
+	{ unevict|dirty, unevict|dirty,	MF_MSG_DIRTY_UNEVICTABLE_LRU,	me_pagecache_dirty },
+	{ unevict|dirty, unevict,	MF_MSG_CLEAN_UNEVICTABLE_LRU,	me_pagecache_clean },
 
-	{ lru|dirty,	lru|dirty,	MSG_DIRTY_LRU,	me_pagecache_dirty },
-	{ lru|dirty,	lru,		MSG_CLEAN_LRU,	me_pagecache_clean },
+	{ lru|dirty,	lru|dirty,	MF_MSG_DIRTY_LRU,	me_pagecache_dirty },
+	{ lru|dirty,	lru,		MF_MSG_CLEAN_LRU,	me_pagecache_clean },
 
 	/*
 	 * Catchall entry: must be at end.
 	 */
-	{ 0,		0,		MSG_UNKNOWN,	me_unknown },
+	{ 0,		0,		MF_MSG_UNKNOWN,	me_unknown },
 };
 
 #undef dirty
@@ -882,7 +848,7 @@ static struct page_state {
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
-static void action_result(unsigned long pfn, enum action_page_type type, int result)
+static void action_result(unsigned long pfn, enum mf_action_page_type type, int result)
 {
 	pr_err("MCE %#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
@@ -897,13 +863,13 @@ static int page_action(struct page_state
 	result = ps->action(p, pfn);
 
 	count = page_count(p) - 1;
-	if (ps->action == me_swapcache_dirty && result == DELAYED)
+	if (ps->action == me_swapcache_dirty && result == MF_DELAYED)
 		count--;
 	if (count != 0) {
 		printk(KERN_ERR
 		       "MCE %#lx: %s still referenced by %d users\n",
 		       pfn, action_page_types[ps->type], count);
-		result = FAILED;
+		result = MF_FAILED;
 	}
 	action_result(pfn, ps->type, result);
 
@@ -912,7 +878,7 @@ static int page_action(struct page_state
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
 
-	return (result == RECOVERED || result == DELAYED) ? 0 : -EBUSY;
+	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
 /*
@@ -1153,7 +1119,7 @@ int memory_failure(unsigned long pfn, in
 	if (!(flags & MF_COUNT_INCREASED) &&
 		!get_page_unless_zero(hpage)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, MSG_BUDDY, DELAYED);
+			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
 			return 0;
 		} else if (PageHuge(hpage)) {
 			/*
@@ -1170,12 +1136,12 @@ int memory_failure(unsigned long pfn, in
 			}
 			set_page_hwpoison_huge_page(hpage);
 			res = dequeue_hwpoisoned_huge_page(hpage);
-			action_result(pfn, MSG_FREE_HUGE,
-				      res ? IGNORED : DELAYED);
+			action_result(pfn, MF_MSG_FREE_HUGE,
+				      res ? MF_IGNORED : MF_DELAYED);
 			unlock_page(hpage);
 			return res;
 		} else {
-			action_result(pfn, MSG_KERNEL_HIGH_ORDER, IGNORED);
+			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			return -EBUSY;
 		}
 	}
@@ -1197,10 +1163,10 @@ int memory_failure(unsigned long pfn, in
 			 */
 			if (is_free_buddy_page(p)) {
 				if (flags & MF_COUNT_INCREASED)
-					action_result(pfn, MSG_BUDDY, DELAYED);
+					action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
 				else
-					action_result(pfn, MSG_BUDDY_2ND,
-						      DELAYED);
+					action_result(pfn, MF_MSG_BUDDY_2ND,
+						      MF_DELAYED);
 				return 0;
 			}
 		}
@@ -1213,7 +1179,7 @@ int memory_failure(unsigned long pfn, in
 	 * If this happens just bail out.
 	 */
 	if (compound_head(p) != hpage) {
-		action_result(pfn, MSG_DIFFERENT_COMPOUND, IGNORED);
+		action_result(pfn, MF_MSG_DIFFERENT_COMPOUND, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1253,7 +1219,7 @@ int memory_failure(unsigned long pfn, in
 	 * on the head page to show that the hugepage is hwpoisoned
 	 */
 	if (PageHuge(p) && PageTail(p) && TestSetPageHWPoison(hpage)) {
-		action_result(pfn, MSG_POISONED_HUGE, IGNORED);
+		action_result(pfn, MF_MSG_POISONED_HUGE, MF_IGNORED);
 		unlock_page(hpage);
 		put_page(hpage);
 		return 0;
@@ -1282,7 +1248,7 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
 	    != SWAP_SUCCESS) {
-		action_result(pfn, MSG_UNMAP_FAILED, IGNORED);
+		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
@@ -1291,7 +1257,7 @@ int memory_failure(unsigned long pfn, in
 	 * Torn down by someone else?
 	 */
 	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
-		action_result(pfn, MSG_TRUNCATED_LRU, IGNORED);
+		action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch

