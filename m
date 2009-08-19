From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:32:21 -0700
Message-ID: <200908192132.n7JLWLoQ018703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbZHSVdM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:33:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, haveblue@us.ibm.com, jbeulich@novell.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, pbadari@us.ibm.com, rusty@rustcorp.com.au, y-goto@jp.fujitsu.com


The patch titled
     memory hotplug: fix updating of num_physpages for hot plugged memory
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch

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
Subject: memory hotplug: fix updating of num_physpages for hot plugged memory
From: "Jan Beulich" <JBeulich@novell.com>

Sizing of memory allocations shouldn't depend on the number of physical
pages found in a system, as that generally includes (perhaps a huge amount
of) non-RAM pages.  The amount of what actually is usable as storage
should instead be used as a basis here.

In line with that, the memory hotplug code should update num_physpages in
a way that it retains its original (post-boot) meaning; in particular,
decreasing the value should at best be done with great care - this patch
doesn't try to ever decrease this value at all as it doesn't really seem
meaningful to do so.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory
+++ a/mm/memory_hotplug.c
@@ -339,8 +339,11 @@ EXPORT_SYMBOL_GPL(__remove_pages);
 
 void online_page(struct page *page)
 {
+	unsigned long pfn = page_to_pfn(page);
+
 	totalram_pages++;
-	num_physpages++;
+	if (pfn >= num_physpages)
+		num_physpages = pfn + 1;
 
 #ifdef CONFIG_HIGHMEM
 	if (PageHighMem(page))
@@ -832,7 +835,6 @@ repeat:
 	zone->present_pages -= offlined_pages;
 	zone->zone_pgdat->node_present_pages -= offlined_pages;
 	totalram_pages -= offlined_pages;
-	num_physpages -= offlined_pages;
 
 	setup_per_zone_wmarks();
 	calculate_zone_inactive_ratio(zone);
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch

