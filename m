From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:28 -0700
Message-ID: <200909222037.n8MKbSJJ031923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZIVUiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: exclude isolated page from pco page alloc
has been removed from the -mm tree.  Its filename was
     memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: exclude isolated page from pco page alloc
From: Shaohua Li <shaohua.li@intel.com>

Pages marked as isolated should not be allocated again.  If such pages
reside in pcp list, they can be allocated too, so there is a ping-pong
memory offline frees some pages to pcp list and the pages get allocated
and then memory offline frees them again, this loop will happen again and
again.

This should have no impact in normal code path, because in normal code
path, pages in pcp list aren't isolated, and below loop will break in the
first entry.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yakui Zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-exclude-isolated-page-from-pco-page-alloc mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-exclude-isolated-page-from-pco-page-alloc
+++ a/mm/page_alloc.c
@@ -1143,10 +1143,20 @@ again:
 
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
+			int get_one_page = 0;
+
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list,
 					migratetype, cold);
-			page = list_entry(pcp->list.next, struct page, lru);
+			list_for_each_entry(page, &pcp->list, lru) {
+				if (get_pageblock_migratetype(page) !=
+					    MIGRATE_ISOLATE) {
+					get_one_page = 1;
+					break;
+				}
+			}
+			if (!get_one_page)
+				goto failed;
 		}
 
 		list_del(&page->lru);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

