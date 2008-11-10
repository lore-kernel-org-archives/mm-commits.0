From: akpm@linux-foundation.org
Subject: + mm-get-rid-of-pagevec_release_nonlru.patch added to -mm tree
Date: Mon, 10 Nov 2008 15:28:57 -0800
Message-ID: <200811102328.mAANSvUI014314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYKJX3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 18:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, npiggin@suse.de


The patch titled
     mm: get rid of pagevec_release_nonlru()
has been added to the -mm tree.  Its filename is
     mm-get-rid-of-pagevec_release_nonlru.patch

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
Subject: mm: get rid of pagevec_release_nonlru()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

speculative page references patch (commit:
e286781d5f2e9c846e012a39653a166e9d31777d) removed last
pagevec_release_nonlru() caller.

So this function can be removed now.

This patch doesn't have any functional change.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    7 -------
 mm/swap.c               |   22 ----------------------
 2 files changed, 29 deletions(-)

diff -puN include/linux/pagevec.h~mm-get-rid-of-pagevec_release_nonlru include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-get-rid-of-pagevec_release_nonlru
+++ a/include/linux/pagevec.h
@@ -21,7 +21,6 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_release_nonlru(struct pagevec *pvec);
 void __pagevec_free(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 void pagevec_strip(struct pagevec *pvec);
@@ -69,12 +68,6 @@ static inline void pagevec_release(struc
 		__pagevec_release(pvec);
 }
 
-static inline void pagevec_release_nonlru(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_release_nonlru(pvec);
-}
-
 static inline void pagevec_free(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
diff -puN mm/swap.c~mm-get-rid-of-pagevec_release_nonlru mm/swap.c
--- a/mm/swap.c~mm-get-rid-of-pagevec_release_nonlru
+++ a/mm/swap.c
@@ -411,28 +411,6 @@ void __pagevec_release(struct pagevec *p
 EXPORT_SYMBOL(__pagevec_release);
 
 /*
- * pagevec_release() for pages which are known to not be on the LRU
- *
- * This function reinitialises the caller's pagevec.
- */
-void __pagevec_release_nonlru(struct pagevec *pvec)
-{
-	int i;
-	struct pagevec pages_to_free;
-
-	pagevec_init(&pages_to_free, pvec->cold);
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-
-		VM_BUG_ON(PageLRU(page));
-		if (put_page_testzero(page))
-			pagevec_add(&pages_to_free, page);
-	}
-	pagevec_free(&pages_to_free);
-	pagevec_reinit(pvec);
-}
