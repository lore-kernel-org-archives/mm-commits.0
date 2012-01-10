From: akpm@linux-foundation.org
Subject: [folded] mm-add-free_hot_cold_page_list-helper-v2.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:42:54 -0800
Message-ID: <20120110224256.AAFC810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:54748 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2AJWm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:42:58 -0500
Received: by ggnk3 with SMTP id k3so14454ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:42:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-free_hot_cold_page_list-helper-v2
has been removed from the -mm tree.  Its filename was
     mm-add-free_hot_cold_page_list-helper-v2.patch

This patch was dropped because it was folded into mm-add-free_hot_cold_page_list-helper.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm-add-free_hot_cold_page_list-helper-v2

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper-v2
+++ a/mm/page_alloc.c
@@ -1188,6 +1188,9 @@ out:
 	local_irq_restore(flags);
 }
 
+/*
+ * Free a list of 0-order pages
+ */
 void free_hot_cold_page_list(struct list_head *list, int cold)
 {
 	struct page *page, *next;
@@ -1196,8 +1199,6 @@ void free_hot_cold_page_list(struct list
 		trace_mm_pagevec_free(page, cold);
 		free_hot_cold_page(page, cold);
 	}
