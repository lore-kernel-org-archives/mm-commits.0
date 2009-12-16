From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:46:02 -0800
Message-ID: <200912160046.nBG0k3ox024255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbZLPAqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     mm: warn once when a page is freed with PG_mlocked set
has been removed from the -mm tree.  Its filename was
     mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: warn once when a page is freed with PG_mlocked set
From: Mel Gorman <mel@csn.ul.ie>

When a page is freed with the PG_mlocked set, it is considered an
unexpected but recoverable situation.  A counter records how often this
event happens but it is easy to miss that this event has occured at
all.  This patch warns once when PG_mlocked is set to prompt debuggers
to check the counter to see how often it is happening.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/page_alloc.c~mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set mm/page_alloc.c
--- a/mm/page_alloc.c~mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set
+++ a/mm/page_alloc.c
@@ -495,6 +495,11 @@ static inline void __free_one_page(struc
  */
 static inline void free_page_mlock(struct page *page)
 {
+	WARN_ONCE(1, KERN_WARNING
+		"Page flag mlocked set for process %s at pfn:%05lx\n"
+		"page:%p flags:%#lx\n",
+		current->comm, page_to_pfn(page),
+		page, page->flags|__PG_MLOCKED);
 	__dec_zone_page_state(page, NR_MLOCK);
 	__count_vm_event(UNEVICTABLE_MLOCKFREED);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch

