From: akpm@linux-foundation.org
Subject: - vmscam-kill-unused-lru-functions.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:22 -0700
Message-ID: <200810202033.m9KKXMGi010608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575AbYJTUeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: kill unused lru functions
has been removed from the -mm tree.  Its filename was
     vmscam-kill-unused-lru-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: kill unused lru functions
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Several LRU manupuration function are not used now.  So they can be
removed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   48 ------------------------------------
 1 file changed, 48 deletions(-)

diff -puN include/linux/mm_inline.h~vmscam-kill-unused-lru-functions include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscam-kill-unused-lru-functions
+++ a/include/linux/mm_inline.h
@@ -38,54 +38,6 @@ del_page_from_lru_list(struct zone *zone
 }
 
 static inline void
-add_page_to_inactive_anon_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_INACTIVE_ANON);
-}
-
-static inline void
-add_page_to_active_anon_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_ACTIVE_ANON);
-}
-
-static inline void
-add_page_to_inactive_file_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
-add_page_to_active_file_list(struct zone *zone, struct page *page)
-{
-	add_page_to_lru_list(zone, page, LRU_ACTIVE_FILE);
-}
-
-static inline void
-del_page_from_inactive_anon_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_ANON);
-}
-
-static inline void
-del_page_from_active_anon_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_ACTIVE_ANON);
-}
-
-static inline void
-del_page_from_inactive_file_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
-
-static inline void
-del_page_from_active_file_list(struct zone *zone, struct page *page)
-{
-	del_page_from_lru_list(zone, page, LRU_INACTIVE_FILE);
-}
