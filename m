From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:50 -0800
Message-ID: <20130225205450.D39E731C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41399 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3BYUyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:52 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so348190ggn.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cody@linux.vnet.ibm.com, catalin.marinas@arm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: use pgdat_end_pfn() instead of open coding the same.
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/memory_hotplug: use pgdat_end_pfn() instead of open coding the same.

Replace open coded pgdat_end_pfn() with helper function.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-use-pgdat_end_pfn-instead-of-open-coding-the-same
+++ a/mm/memory_hotplug.c
@@ -218,7 +218,7 @@ void register_page_bootmem_info_node(str
 	}
 
 	pfn = pgdat->node_start_pfn;
-	end_pfn = pfn + pgdat->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(pgdat);
 
 	/* register_section info */
 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch

