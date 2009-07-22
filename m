From: akpm@linux-foundation.org
Subject: + mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch added to -mm tree
Date: Wed, 22 Jul 2009 16:06:54 -0700
Message-ID: <200907222306.n6MN6smd024708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbZGVXIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 19:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: perform non-atomic test-clear of PG_mlocked on free
has been added to the -mm tree.  Its filename is
     mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch

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
Subject: mm: perform non-atomic test-clear of PG_mlocked on free
From: Johannes Weiner <hannes@cmpxchg.org>

By the time PG_mlocked is cleared in the page freeing path, nobody else is
looking at our page->flags anymore.

It is thus safe to make the test-and-clear non-atomic and thereby removing
an unnecessary and expensive operation from a hotpath.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 +++++++++---
 mm/page_alloc.c            |    4 ++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/page-flags.h~mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free
+++ a/include/linux/page-flags.h
@@ -158,6 +158,9 @@ static inline int TestSetPage##uname(str
 static inline int TestClearPage##uname(struct page *page)		\
 		{ return test_and_clear_bit(PG_##lname, &page->flags); }
 
+#define __TESTCLEARFLAG(uname, lname)					\
+static inline int __TestClearPage##uname(struct page *page)		\
+		{ return __test_and_clear_bit(PG_##lname, &page->flags); }
 
 #define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
 	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
@@ -184,6 +187,9 @@ static inline void __ClearPage##uname(st
 #define TESTCLEARFLAG_FALSE(uname)					\
 static inline int TestClearPage##uname(struct page *page) { return 0; }
 
+#define __TESTCLEARFLAG_FALSE(uname)					\
+static inline int __TestClearPage##uname(struct page *page) { return 0; }
+
 struct page;	/* forward declaration */
 
 TESTPAGEFLAG(Locked, locked) TESTSETFLAG(Locked, locked)
@@ -250,11 +256,11 @@ PAGEFLAG(Unevictable, unevictable) __CLE
 #ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 #define MLOCK_PAGES 1
 PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
-	TESTSCFLAG(Mlocked, mlocked)
+	TESTSCFLAG(Mlocked, mlocked) __TESTCLEARFLAG(Mlocked, mlocked)
 #else
 #define MLOCK_PAGES 0
-PAGEFLAG_FALSE(Mlocked)
-	SETPAGEFLAG_NOOP(Mlocked) TESTCLEARFLAG_FALSE(Mlocked)
+PAGEFLAG_FALSE(Mlocked) SETPAGEFLAG_NOOP(Mlocked)
+	TESTCLEARFLAG_FALSE(Mlocked) __TESTCLEARFLAG_FALSE(Mlocked)
 #endif
 
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
diff -puN mm/page_alloc.c~mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free mm/page_alloc.c
--- a/mm/page_alloc.c~mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free
+++ a/mm/page_alloc.c
@@ -557,7 +557,7 @@ static void __free_pages_ok(struct page 
 	unsigned long flags;
 	int i;
 	int bad = 0;
-	int wasMlocked = TestClearPageMlocked(page);
+	int wasMlocked = __TestClearPageMlocked(page);
 
 	kmemcheck_free_shadow(page, order);
 
@@ -1024,7 +1024,7 @@ static void free_hot_cold_page(struct pa
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
-	int wasMlocked = TestClearPageMlocked(page);
+	int wasMlocked = __TestClearPageMlocked(page);
 
 	kmemcheck_free_shadow(page, 0);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch

