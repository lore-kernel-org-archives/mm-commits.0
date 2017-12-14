From: akpm@linux-foundation.org
Subject: [patch 10/17] mm/page_alloc.c: avoid excessive IRQ disabled times in free_unref_page_list()
Date: Thu, 14 Dec 2017 15:32:55 -0800
Message-ID: <5a330a27.qDGmoM+vd/ASCYf0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdLNXc5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, l.stach@pengutronix.de, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz

From: Lucas Stach <l.stach@pengutronix.de>
Subject: mm/page_alloc.c: avoid excessive IRQ disabled times in free_unref_page_list()

Since 9cca35d42eb6 ("mm, page_alloc: enable/disable IRQs once when
freeing a list of pages") we see excessive IRQ disabled times of up to
25ms on an embedded ARM system (tracing overhead included).

This is due to graphics buffers being freed back to the system via
release_pages().  Graphics buffers can be huge, so it's not hard to hit
cases where the list of pages to free has 2048 entries.  Disabling IRQs
while freeing all those pages is clearly not a good idea.

Introduce a batch limit, which allows IRQ servicing once every few pages. 
The batch count is the same as used in other parts of the MM subsystem
when dealing with IRQ disabled regions.

Link: http://lkml.kernel.org/r/20171207170314.4419-1-l.stach@pengutronix.de
Fixes: 9cca35d42eb6 ("mm, page_alloc: enable/disable IRQs once when freeing a list of pages")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-excessive-irq-disabled-times-in-free_unref_page_list mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-excessive-irq-disabled-times-in-free_unref_page_list
+++ a/mm/page_alloc.c
@@ -2684,6 +2684,7 @@ void free_unref_page_list(struct list_he
 {
 	struct page *page, *next;
 	unsigned long flags, pfn;
+	int batch_count = 0;
 
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
@@ -2700,6 +2701,16 @@ void free_unref_page_list(struct list_he
 		set_page_private(page, 0);
 		trace_mm_page_free_batched(page);
 		free_unref_page_commit(page, pfn);
+
+		/*
+		 * Guard against excessive IRQ disabled times when we get
+		 * a large list of pages to free.
+		 */
+		if (++batch_count == SWAP_CLUSTER_MAX) {
+			local_irq_restore(flags);
+			batch_count = 0;
+			local_irq_save(flags);
+		}
 	}
 	local_irq_restore(flags);
 }
_
