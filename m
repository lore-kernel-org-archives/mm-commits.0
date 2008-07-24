From: akpm@linux-foundation.org
Subject: - memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:38 -0700
Message-ID: <200807242324.m6ONOcYw010799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755408AbYGXXYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kent.liu@linux.intel.com, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory-hotplug: don't calculate vm_total_pages twice when rebuilding zonelists in online_pages()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory-hotplug: don't calculate vm_total_pages twice when rebuilding zonelists in online_pages()
From: Kent Liu <kent.liu@linux.intel.com>

If zonelist is required to be rebuilt in online_pages(), there is no need
to recalculate vm_total_pages in that function, as it has been updated in
the call build_all_zonelists().

Signed-off-by: Kent Liu <kent.liu@linux.intel.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages
+++ a/mm/memory_hotplug.c
@@ -429,7 +429,9 @@ int online_pages(unsigned long pfn, unsi
 
 	if (need_zonelists_rebuild)
 		build_all_zonelists();
-	vm_total_pages = nr_free_pagecache_pages();
+	else
+		vm_total_pages = nr_free_pagecache_pages();
+
 	writeback_set_ratelimit();
 
 	if (onlined_pages)
_

Patches currently in -mm which might be from kent.liu@linux.intel.com are

origin.patch

