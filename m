From: akpm@linux-foundation.org
Subject: + mm-add-free_hot_cold_page_list-helper-v2.patch added to -mm tree
Date: Thu, 10 Nov 2011 15:43:28 -0800
Message-ID: <201111102343.pAANhSfK007088@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:62882 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab1KJXnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 18:43:33 -0500
Received: by faas12 with SMTP id s12so83517faa.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 15:43:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm-add-free_hot_cold_page_list-helper-v2
has been added to the -mm tree.  Its filename is
     mm-add-free_hot_cold_page_list-helper-v2.patch

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
Subject: mm-add-free_hot_cold_page_list-helper-v2

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper-v2
+++ a/mm/page_alloc.c
@@ -1210,6 +1210,9 @@ out:
 	local_irq_restore(flags);
 }
 
+/*
+ * Free a list of 0-order pages
+ */
 void free_hot_cold_page_list(struct list_head *list, int cold)
 {
 	struct page *page, *next;
@@ -1218,8 +1221,6 @@ void free_hot_cold_page_list(struct list
 		trace_mm_pagevec_free(page, cold);
 		free_hot_cold_page(page, cold);
 	}
