From: akpm@linux-foundation.org
Subject: - mm-share-pg_readahead-and-pg_reclaim-fix-2.patch removed from -mm tree
Date: Mon, 11 Jun 2007 20:19:21 -0700
Message-ID: <200706120319.l5C3JLYC003112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbXFLDTf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 23:19:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     mm-share-pg_readahead-and-pg_reclaim fix 2
has been removed from the -mm tree.  Its filename was
     mm-share-pg_readahead-and-pg_reclaim-fix-2.patch

This patch was dropped because it was folded into mm-share-pg_readahead-and-pg_reclaim.patch

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
@@ -454,12 +454,6 @@ static inline int free_pages_check(struc
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
@@ -604,7 +598,6 @@ static int prep_new_page(struct page *pa
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
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
mm-share-pg_readahead-and-pg_reclaim-fix-2.patch
