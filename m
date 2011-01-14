From: akpm@linux-foundation.org
Subject: [merged] thp-transhuge-isolate_migratepages.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:13 -0800
Message-ID: <201101142251.p0EMp3XL005469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab1ANWvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     thp: transhuge isolate_migratepages()
has been removed from the -mm tree.  Its filename was
     thp-transhuge-isolate_migratepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: transhuge isolate_migratepages()
From: Andrea Arcangeli <aarcange@redhat.com>

It's not worth migrating transparent hugepages during compaction.  Those
hugepages don't create fragmentation.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/compaction.c~thp-transhuge-isolate_migratepages mm/compaction.c
--- a/mm/compaction.c~thp-transhuge-isolate_migratepages
+++ a/mm/compaction.c
@@ -295,10 +295,25 @@ static unsigned long isolate_migratepage
 			continue;
 		}
 
+		if (!PageLRU(page))
+			continue;
+
+		/*
+		 * PageLRU is set, and lru_lock excludes isolation,
+		 * splitting and collapsing (collapsing has already
+		 * happened if PageLRU is set).
+		 */
+		if (PageTransHuge(page)) {
+			low_pfn += (1 << compound_order(page)) - 1;
+			continue;
+		}
+
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
 			continue;
 
+		VM_BUG_ON(PageTransCompound(page));
+
 		/* Successfully isolated */
 		del_page_from_lru_list(zone, page, page_lru(page));
 		list_add(&page->lru, migratelist);
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

