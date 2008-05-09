From: akpm@linux-foundation.org
Subject: + memory-hotplug-memmap_init_zone-called-twice.patch added to -mm tree
Date: Fri, 09 May 2008 14:14:40 -0700
Message-ID: <200805092114.m49LEepR025923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754361AbYEIVP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com


The patch titled
     memory hotplug: memmap_init_zone called twice
has been added to the -mm tree.  Its filename is
     memory-hotplug-memmap_init_zone-called-twice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
memory-hotplug-memmap_init_zone-called-twice.patch

