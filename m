From: akpm@linux-foundation.org
Subject: - memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:47 -0800
Message-ID: <200811102032.mAAKWl8o024124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106AbYKJUjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:39:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nfont@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: fix page_zone() calculation in test_pages_isolated()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: fix page_zone() calculation in test_pages_isolated()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

My last bugfix here (adding zone->lock) introduced a new problem: Using
page_zone(pfn_to_page(pfn)) to get the zone after the for() loop is wrong.
 pfn will then be >= end_pfn, which may be in a different zone or not
present at all.  This may lead to an addressing exception in page_zone()
or spin_lock_irqsave().

Now I use __first_valid_page() again after the loop to find a valid page
for page_zone().

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated mm/page_isolation.c
--- a/mm/page_isolation.c~memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated
+++ a/mm/page_isolation.c
@@ -130,10 +130,11 @@ int test_pages_isolated(unsigned long st
 		if (page && get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 			break;
 	}
-	if (pfn < end_pfn)
+	page = __first_valid_page(start_pfn, end_pfn - start_pfn);
+	if ((pfn < end_pfn) || !page)
 		return -EBUSY;
 	/* Check all pages are free or Marked as ISOLATED */
-	zone = page_zone(pfn_to_page(pfn));
+	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	ret = __test_page_isolated_in_pageblock(start_pfn, end_pfn);
 	spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch

