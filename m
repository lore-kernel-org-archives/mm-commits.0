From: akpm@linux-foundation.org
Subject: + mm-share-pg_readahead-and-pg_reclaim.patch added to -mm tree
Date: Sun, 20 May 2007 21:10:03 -0700
Message-ID: <200705210410.l4L4A277002050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     mm: share PG_readahead and PG_reclaim
has been added to the -mm tree.  Its filename is
     mm-share-pg_readahead-and-pg_reclaim.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    3 ++-
 mm/page-writeback.c        |    1 +
 mm/readahead.c             |    4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-share-pg_readahead-and-pg_reclaim include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-share-pg_readahead-and-pg_reclaim
+++ a/include/linux/page-flags.h
@@ -92,7 +92,8 @@
 #define PG_lazyfree		19	/* MADV_FREE potential throwaway */
 #define PG_booked		20	/* Has blocks reserved on-disk */
 
-#define PG_readahead		21	/* Reminder to do async read-ahead */
+/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
+#define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
diff -puN mm/page-writeback.c~mm-share-pg_readahead-and-pg_reclaim mm/page-writeback.c
--- a/mm/page-writeback.c~mm-share-pg_readahead-and-pg_reclaim
+++ a/mm/page-writeback.c
@@ -922,6 +922,7 @@ int clear_page_dirty_for_io(struct page 
 
 	BUG_ON(!PageLocked(page));
 
+	ClearPageReclaim(page);
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
diff -puN mm/readahead.c~mm-share-pg_readahead-and-pg_reclaim mm/readahead.c
--- a/mm/readahead.c~mm-share-pg_readahead-and-pg_reclaim
+++ a/mm/readahead.c
@@ -447,6 +447,10 @@ page_cache_readahead_ondemand(struct add
 	if (!ra->ra_pages)
 		return 0;
 
+	/* It's PG_reclaim! */
+	if (PageWriteback(page))
+		return 0;
+
 	if (page) {
 		ClearPageReadahead(page);
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
mm-share-pg_readahead-and-pg_reclaim.patch
