From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:54:34 -0800
Message-ID: <20121211235435.814A420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:50755 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2LKXyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:54:38 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so2152wib.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:54:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, laijs@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

This patch was dropped because it was folded into mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix

use min_t, cleanups

Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   20 ++++++++++++--------
 mm/memory_hotplug.c   |    1 -
 2 files changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/base/memory.c~mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix
+++ a/drivers/base/memory.c
@@ -341,14 +341,18 @@ store_mem_state(struct device *dev,
 
 	mem = container_of(dev, struct memory_block, dev);
 
-	if (!strncmp(buf, "online_kernel", min((int)count, 13)))
-		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE, ONLINE_KERNEL);
-	else if (!strncmp(buf, "online_movable", min((int)count, 14)))
-		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE, ONLINE_MOVABLE);
-	else if (!strncmp(buf, "online", min((int)count, 6)))
-		ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE, ONLINE_KEEP);
-	else if(!strncmp(buf, "offline", min((int)count, 7)))
-		ret = memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE, -1);
+	if (!strncmp(buf, "online_kernel", min_t(int, count, 13)))
+		ret = memory_block_change_state(mem, MEM_ONLINE,
+						MEM_OFFLINE, ONLINE_KERNEL);
+	else if (!strncmp(buf, "online_movable", min_t(int, count, 14)))
+		ret = memory_block_change_state(mem, MEM_ONLINE,
+						MEM_OFFLINE, ONLINE_MOVABLE);
+	else if (!strncmp(buf, "online", min_t(int, count, 6)))
+		ret = memory_block_change_state(mem, MEM_ONLINE,
+						MEM_OFFLINE, ONLINE_KEEP);
+	else if(!strncmp(buf, "offline", min_t(int, count, 7)))
+		ret = memory_block_change_state(mem, MEM_OFFLINE,
+						MEM_ONLINE, -1);
 
 	if (ret)
 		return ret;
diff -puN mm/memory_hotplug.c~mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix
+++ a/mm/memory_hotplug.c
@@ -217,7 +217,6 @@ static void grow_zone_span(struct zone *
 static void resize_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-
 	zone_span_writelock(zone);
 
 	zone->zone_start_pfn = start_pfn;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch

