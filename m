From: akpm@linux-foundation.org
Subject: - memory-hotplug-memmap_init_zone-called-twice.patch removed from -mm tree
Date: Fri, 16 May 2008 15:52:53 -0700
Message-ID: <200805162252.m4GMqrTS003096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757611AbYEPWyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: memmap_init_zone called twice
has been removed from the -mm tree.  Its filename was
     memory-hotplug-memmap_init_zone-called-twice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: memmap_init_zone called twice
From: Heiko Carstens <heiko.carstens@de.ibm.com>

__add_zone calls memmap_init_zone twice if memory gets attached to an empty
zone.  Once via init_currently_empty_zone and once explictly right after that
call.

Looks like this is currently not a bug, however the call is superfluous and
might lead to subtle bugs if memmap_init_zone gets changed.  So make sure it
is called only once.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-memmap_init_zone-called-twice mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-memmap_init_zone-called-twice
+++ a/mm/memory_hotplug.c
@@ -167,13 +167,9 @@ static int __add_zone(struct zone *zone,
 	int zone_type;
 
 	zone_type = zone - pgdat->node_zones;
-	if (!zone->wait_table) {
-		int ret = 0;
-		ret = init_currently_empty_zone(zone, phys_start_pfn,
-						nr_pages, MEMMAP_HOTPLUG);
-		if (ret < 0)
-			return ret;
-	}
+	if (!zone->wait_table)
+		return init_currently_empty_zone(zone, phys_start_pfn,
+						 nr_pages, MEMMAP_HOTPLUG);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch

