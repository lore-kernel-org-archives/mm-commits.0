From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone.patch added to -mm tree
Date: Tue, 29 May 2007 20:06:37 -0700
Message-ID: <200705300306.l4U36aHi018079@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXE3DGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com


The patch titled
     memory hotplug: fix unnecessary calling of init_currenty_empty_zone()
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory hotplug: fix unnecessary calling of init_currenty_empty_zone()
From: Yasunori Goto <y-goto@jp.fujitsu.com>

zone->present_pages is updated in online_pages().  But, __add_zone() can be
called twice or more before calling online_pages().  So,
init_currenty_empty_zone() can be called unnecessary times.  It is cause of
memory leak of zone's wait_table.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone
+++ a/mm/memory_hotplug.c
@@ -65,7 +65,7 @@ static int __add_zone(struct zone *zone,
 	int zone_type;
 
 	zone_type = zone - pgdat->node_zones;
-	if (!populated_zone(zone)) {
+	if (!zone->wait_table) {
 		int ret = 0;
 		ret = init_currently_empty_zone(zone, phys_start_pfn,
 						nr_pages, MEMMAP_HOTPLUG);
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

memory-hotplug-fix-unnecessary-calling-of-init_currenty_empty_zone.patch
move-three-functions-that-are-only-needed-for.patch
move-free-pages-between-lists-on-steal.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-generic.patch
