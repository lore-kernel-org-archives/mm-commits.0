From: akpm@linux-foundation.org
Subject: [merged] mm-optimize-pfn-calculation-in-online_page.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:18 -0700
Message-ID: <201104181758.p3IHwTjA016033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab1DRSAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, cl@linux.com, dave@linux.vnet.ibm.com, fengguang.wu@intel.com, jj@chaosbits.net, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vg


The patch titled
     mm: optimize pfn calculation in online_page()
has been removed from the -mm tree.  Its filename was
     mm-optimize-pfn-calculation-in-online_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: optimize pfn calculation in online_page()
From: Daniel Kiper <dkiper@net-space.pl>

If CONFIG_FLATMEM is enabled pfn is calculated in online_page() more than
once.  It is possible to optimize that and use value established at
beginning of that function.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-optimize-pfn-calculation-in-online_page mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-optimize-pfn-calculation-in-online_page
+++ a/mm/memory_hotplug.c
@@ -375,7 +375,7 @@ void online_page(struct page *page)
 #endif
 
 #ifdef CONFIG_FLATMEM
-	max_mapnr = max(page_to_pfn(page), max_mapnr);
+	max_mapnr = max(pfn, max_mapnr);
 #endif
 
 	ClearPageReserved(page);
_

Patches currently in -mm which might be from dkiper@net-space.pl are

origin.patch

