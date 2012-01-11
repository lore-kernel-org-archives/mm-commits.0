From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-pagevec_free.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:20 -0800
Message-ID: <20120111212621.579BF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:47994 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKV0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:23 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44194eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused pagevec_free
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-pagevec_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: remove unused pagevec_free

It not exported and now nobody uses it.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    7 -------
 mm/page_alloc.c         |   10 ----------
 2 files changed, 17 deletions(-)

diff -puN include/linux/pagevec.h~mm-remove-unused-pagevec_free include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-remove-unused-pagevec_free
+++ a/include/linux/pagevec.h
@@ -21,7 +21,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
@@ -67,12 +66,6 @@ static inline void pagevec_release(struc
 		__pagevec_release(pvec);
 }
 
-static inline void pagevec_free(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_free(pvec);
-}
-
 static inline void __pagevec_lru_add_anon(struct pagevec *pvec)
 {
 	____pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
diff -puN mm/page_alloc.c~mm-remove-unused-pagevec_free mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unused-pagevec_free
+++ a/mm/page_alloc.c
@@ -2319,16 +2319,6 @@ unsigned long get_zeroed_page(gfp_t gfp_
 }
 EXPORT_SYMBOL(get_zeroed_page);
 
-void __pagevec_free(struct pagevec *pvec)
-{
-	int i = pagevec_count(pvec);
-
-	while (--i >= 0) {
-		trace_mm_pagevec_free(pvec->pages[i], pvec->cold);
-		free_hot_cold_page(pvec->pages[i], pvec->cold);
-	}
-}
