From: akpm@linux-foundation.org
Subject: [nacked]
 memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch removed from -mm tree
Date: Tue, 25 Aug 2015 13:58:13 -0700
Message-ID: <55dcd6e5.NTKcSssjgoTZydZS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbbHYU6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Aug 2015 16:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuchangcheng@inspur.com, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory hot-add: memory can not been added to movable zone
has been removed from the -mm tree.  Its filename was
     memory-hot-addedthe-memory-can-not-been-added-to-movable-zone.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Changsheng Liu <liuchangcheng@inspur.com>
Subject: mm: memory hot-add: memory can not been added to movable zone

When memory is hot added, should_add_memory_movable() always returns 0
because the movable zone is empty, so the memory that was hot added will
add to the normal zone even if we want to remove the memory.

So we change should_add_memory_movable(): if CONFIG_MOVABLE_NODE=y it will
return 1 when the movable zone is empty.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Changsheng Liu <liuchangcheng@inspur.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memory-hot-addedthe-memory-can-not-been-added-to-movable-zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hot-addedthe-memory-can-not-been-added-to-movable-zone
+++ a/mm/memory_hotplug.c
@@ -1207,7 +1207,7 @@ static int should_add_memory_movable(int
 	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
 
 	if (zone_is_empty(movable_zone))
-		return 0;
+		return IS_ENABLED(CONFIG_MOVABLE_NODE);
 
 	if (movable_zone->zone_start_pfn <= start_pfn)
 		return 1;
_

Patches currently in -mm which might be from liuchangcheng@inspur.com are


