From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_isolation-check-pfn-validity-before-access.patch removed from -mm
 tree
Date: Mon, 14 Sep 2015 10:46:17 -0700
Message-ID: <55f707e9.L1cr7cMgyabX7mjV%akpm__48365.2608505965$1442252791$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50191 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbINRqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, mina86@mina86.com, minchan@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_isolation: check pfn validity before access
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-check-pfn-validity-before-access.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm: page_isolation: check pfn validity before access

In the undo path of start_isolate_page_range(), we need to check the pfn
validity before accessing its page, or it will trigger an addressing
exception if there is hole in the zone.

This issue is found by code-review not a test-trigger.  In
"CONFIG_HOLES_IN_ZONE" environment, there is a certain chance that it
would casue an addressing exception when start_isolate_page_range()
fails, this could affect CMA, hugepage and memory-hotplug function.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-check-pfn-validity-before-access mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-check-pfn-validity-before-access
+++ a/mm/page_isolation.c
@@ -179,8 +179,11 @@ int start_isolate_page_range(unsigned lo
 undo:
 	for (pfn = start_pfn;
 	     pfn < undo_pfn;
-	     pfn += pageblock_nr_pages)
-		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
+	     pfn += pageblock_nr_pages) {
+		page = __first_valid_page(pfn, pageblock_nr_pages);
+		if (page)
+			unset_migratetype_isolate(page, migratetype);
+	}
 
 	return -EBUSY;
 }
_

Patches currently in -mm which might be from weijie.yang@samsung.com are


