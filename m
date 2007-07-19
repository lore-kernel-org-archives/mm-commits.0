From: akpm@linux-foundation.org
Subject: - mm-share-pg_readahead-and-pg_reclaim.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:27 -0700
Message-ID: <200707192001.l6JK1RWb019537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760811AbXGSUVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: share PG_readahead and PG_reclaim
has been removed from the -mm tree.  Its filename was
     mm-share-pg_readahead-and-pg_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: share PG_readahead and PG_reclaim
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Share the same page flag bit for PG_readahead and PG_reclaim.

One is used only on file reads, another is only for emergency writes.  One
is used mostly for fresh/young pages, another is for old pages.

Combinations of possible interactions are:

a) clear PG_reclaim => implicit clear of PG_readahead
	it will delay an asynchronous readahead into a synchronous one
	it actually does _good_ for readahead:
		the pages will be reclaimed soon, it's readahead thrashing!
		in this case, synchronous readahead makes more sense.

b) clear PG_readahead => implicit clear of PG_reclaim
	one(and only one) page will not be reclaimed in time
	it can be avoided by checking PageWriteback(page) in readahead first

c) set PG_reclaim => implicit set of PG_readahead
	will confuse readahead and make it restart the size rampup process
	it's a trivial problem, and can mostly be avoided by checking
	PageWriteback(page) first in readahead

d) set PG_readahead => implicit set of PG_reclaim
	PG_readahead will never be set on already cached pages.
	PG_reclaim will always be cleared on dirtying a page.
	so not a problem.

In summary,
	a)   we get better behavior
	b,d) possible interactions can be avoided
	c)   racy condition exists that might affect readahead, but the chance
	     is _really_ low, and the hurt on readahead is trivial.

Compound pages also use PG_reclaim, but for now they do not interact with
reclaim/readahead code.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 +++-
 mm/page-writeback.c        |    1 +
 mm/page_alloc.c            |    7 -------
 mm/readahead.c             |    6 ++++++
 4 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/page-flags.h~mm-share-pg_readahead-and-pg_reclaim include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-share-pg_readahead-and-pg_reclaim
+++ a/include/linux/page-flags.h
@@ -83,7 +83,6 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
-#define PG_readahead		13	/* Reminder to do async read-ahead */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
@@ -91,6 +90,9 @@
 #define PG_reclaim		17	/* To be reclaimed asap */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
+/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
+#define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
+
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 #define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
diff -puN mm/page-writeback.c~mm-share-pg_readahead-and-pg_reclaim mm/page-writeback.c
--- a/mm/page-writeback.c~mm-share-pg_readahead-and-pg_reclaim
+++ a/mm/page-writeback.c
@@ -920,6 +920,7 @@ int clear_page_dirty_for_io(struct page 
 
 	BUG_ON(!PageLocked(page));
 
+	ClearPageReclaim(page);
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
diff -puN mm/page_alloc.c~mm-share-pg_readahead-and-pg_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-share-pg_readahead-and-pg_reclaim
+++ a/mm/page_alloc.c
@@ -453,12 +453,6 @@ static inline int free_pages_check(struc
 			1 << PG_reserved |
 			1 << PG_buddy ))))
 		bad_page(page);
-	/*
-	 * PageReclaim == PageTail. It is only an error
-	 * for PageReclaim to be set if PageCompound is clear.
-	 */
-	if (unlikely(!PageCompound(page) && PageReclaim(page)))
-		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
 	/*
@@ -602,7 +596,6 @@ static int prep_new_page(struct page *pa
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_dirty	|
-			1 << PG_reclaim	|
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
diff -puN mm/readahead.c~mm-share-pg_readahead-and-pg_reclaim mm/readahead.c
--- a/mm/readahead.c~mm-share-pg_readahead-and-pg_reclaim
+++ a/mm/readahead.c
@@ -448,6 +448,12 @@ page_cache_readahead_ondemand(struct add
 		return 0;
 
 	if (page) {
+		/*
+		 * It can be PG_reclaim.
+		 */
+		if (PageWriteback(page))
+			return 0;
+
 		ClearPageReadahead(page);
 
 		/*
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
