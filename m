From: akpm@linux-foundation.org
Subject: + mm-share-pg_readahead-and-pg_reclaim-fix.patch added to -mm tree
Date: Sun, 20 May 2007 21:36:22 -0700
Message-ID: <200705210436.l4L4aLmP002496@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbXEUEhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     mm-share-pg_readahead-and-pg_reclaim fix
has been added to the -mm tree.  Its filename is
     mm-share-pg_readahead-and-pg_reclaim-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm-share-pg_readahead-and-pg_reclaim fix
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

We should first check (page!=NULL) before PageWriteback(page).

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/readahead.c~mm-share-pg_readahead-and-pg_reclaim-fix mm/readahead.c
--- a/mm/readahead.c~mm-share-pg_readahead-and-pg_reclaim-fix
+++ a/mm/readahead.c
@@ -447,11 +447,13 @@ page_cache_readahead_ondemand(struct add
 	if (!ra->ra_pages)
 		return 0;
 
-	/* It's PG_reclaim! */
-	if (PageWriteback(page))
-		return 0;
-
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
