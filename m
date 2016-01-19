From: akpm@linux-foundation.org
Subject: [merged] mm-move-lru_to_page-to-mm_inlineh.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:11 -0800
Message-ID: <569e95cb.WAhp1Hb8MVSB6YQm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcASUAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move lru_to_page to mm_inline.h
has been removed from the -mm tree.  Its filename was
     mm-move-lru_to_page-to-mm_inlineh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm: move lru_to_page to mm_inline.h

Move lru_to_page() from internal.h to mm_inline.h.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    2 ++
 mm/internal.h             |    2 --
 mm/readahead.c            |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/mm_inline.h~mm-move-lru_to_page-to-mm_inlineh include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-move-lru_to_page-to-mm_inlineh
+++ a/include/linux/mm_inline.h
@@ -100,4 +100,6 @@ static __always_inline enum lru_list pag
 	return lru;
 }
 
+#define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
+
 #endif
diff -puN mm/internal.h~mm-move-lru_to_page-to-mm_inlineh mm/internal.h
--- a/mm/internal.h~mm-move-lru_to_page-to-mm_inlineh
+++ a/mm/internal.h
@@ -119,8 +119,6 @@ extern int isolate_lru_page(struct page
 extern void putback_lru_page(struct page *page);
 extern bool zone_reclaimable(struct zone *zone);
 
-#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
