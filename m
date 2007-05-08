From: akpm@linux-foundation.org
Subject: - readahead-account-i-o-block-times-for-stock-readahead.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:44 -0700
Message-ID: <200705080815.l488FiEH019070@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934651AbXEHIQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: account I/O block times for stock readahead
has been removed from the -mm tree.  Its filename was
     readahead-account-i-o-block-times-for-stock-readahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: account I/O block times for stock readahead
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Account I/O block times for the stock readahead, too.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/readahead.c~readahead-account-i-o-block-times-for-stock-readahead mm/readahead.c
--- a/mm/readahead.c~readahead-account-i-o-block-times-for-stock-readahead
+++ a/mm/readahead.c
@@ -1759,15 +1759,15 @@ EXPORT_SYMBOL_GPL(page_cache_readahead_a
  */
 void readahead_cache_hit(struct file_ra_state *ra, struct page *page)
 {
-	if (!prefer_adaptive_readahead())
-		return;
-
 	if (PageActive(page) || PageReferenced(page))
 		return;
 
 	if (!PageUptodate(page))
 		ra_account(ra, RA_EVENT_IO_BLOCK, 1);
 
+	if (!prefer_adaptive_readahead())
+		return;
+
 	if (!ra_has_index(ra, page->index))
 		return;
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
