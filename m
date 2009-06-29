From: akpm@linux-foundation.org
Subject: + memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:49:52 -0700
Message-ID: <200906291949.n5TJnrsO028716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819AbZF2Tuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com


The patch titled
     memory hotplug: exclude isolated page from pco page alloc
has been added to the -mm tree.  Its filename is
     memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch

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

 mm/page_alloc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-exclude-isolated-page-from-pco-page-alloc mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-exclude-isolated-page-from-pco-page-alloc
+++ a/mm/page_alloc.c
@@ -1137,9 +1137,18 @@ again:
 
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
+			int get_one_page = 0;
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
-			page = list_entry(pcp->list.next, struct page, lru);
+			list_for_each_entry(page, &pcp->list, lru) {
+				if (get_pageblock_migratetype(page) !=
+				    MIGRATE_ISOLATE) {
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

linux-next.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch

