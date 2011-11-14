From: akpm@linux-foundation.org
Subject: + mm-remove-unused-pagevec_free.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:30:56 -0800
Message-ID: <201111142330.pAENUvlZ018396@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:47646 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1KNXbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:31:00 -0500
Received: by vcbfy13 with SMTP id fy13so547416vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:30:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm: remove unused pagevec_free
has been added to the -mm tree.  Its filename is
     mm-remove-unused-pagevec_free.patch

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
@@ -2341,16 +2341,6 @@ unsigned long get_zeroed_page(gfp_t gfp_
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
