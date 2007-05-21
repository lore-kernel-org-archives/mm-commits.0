From: akpm@linux-foundation.org
Subject: + mm-share-pg_readahead-and-pg_reclaim-fix-2.patch added to -mm tree
Date: Mon, 21 May 2007 00:07:18 -0700
Message-ID: <200705210707.l4L77HBo004614@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbXEUHIm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 03:08:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     mm-share-pg_readahead-and-pg_reclaim fix 2
has been added to the -mm tree.  Its filename is
     mm-share-pg_readahead-and-pg_reclaim-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-share-pg_readahead-and-pg_reclaim fix 2
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

And fix bad_page() warnings.

Now it's safe. I'm running it :)

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/page_alloc.c~mm-share-pg_readahead-and-pg_reclaim-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-share-pg_readahead-and-pg_reclaim-fix-2
+++ a/mm/page_alloc.c
@@ -481,12 +481,6 @@ static inline int free_pages_check(struc
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
 	if (PageLazyFree(page))
@@ -633,7 +627,6 @@ static int prep_new_page(struct page *pa
 			1 << PG_locked	|
 			1 << PG_active	|
 			1 << PG_dirty	|
-			1 << PG_reclaim	|
 			1 << PG_slab    |
 			1 << PG_swapcache |
 			1 << PG_writeback |
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
mm-share-pg_readahead-and-pg_reclaim-fix.patch
mm-share-pg_readahead-and-pg_reclaim-fix-2.patch
