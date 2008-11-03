From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated.patch added to -mm tree
Date: Mon, 03 Nov 2008 13:51:52 -0800
Message-ID: <200811032151.mA3Lpqvu020557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbYKCVwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 16:52:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nfont@austin.ibm.com


The patch titled
     memory hotplug: fix page_zone() calculation in test_pages_isolated()
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated.patch

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

memory-hotplug-fix-page_zone-calculation-in-test_pages_isolated.patch
linux-next.patch

