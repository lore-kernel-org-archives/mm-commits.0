From: akpm@linux-foundation.org
Subject: [merged] mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:00 -0700
Message-ID: <200909222039.n8MKd0Ge002526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbZIVUmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: perform non-atomic test-clear of PG_mlocked on free
has been removed from the -mm tree.  Its filename was
     mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
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
 
@@ -1026,7 +1026,7 @@ static void free_hot_cold_page(struct pa
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
-	int wasMlocked = TestClearPageMlocked(page);
+	int wasMlocked = __TestClearPageMlocked(page);
 
 	kmemcheck_free_shadow(page, 0);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

