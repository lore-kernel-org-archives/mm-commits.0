From: akpm@linux-foundation.org
Subject: [merged] mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:25 -0700
Message-ID: <20130325194525.7B3D35A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:46460 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab3CYTp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:26 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so209015yen.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, jiang.liu@huawei.com, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hotplug: only free wait_table if it's allocated by vmalloc
has been removed from the -mm tree.  Its filename was
     mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/hotplug: only free wait_table if it's allocated by vmalloc

zone->wait_table may be allocated from bootmem, it can not be freed.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-only-free-wait_table-if-its-allocated-by-vmalloc
+++ a/mm/memory_hotplug.c
@@ -1779,7 +1779,11 @@ void try_offline_node(int nid)
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
-		if (zone->wait_table)
+		/*
+		 * wait_table may be allocated from boot memory,
+		 * here only free if it's allocated by vmalloc.
+		 */
+		if (is_vmalloc_addr(zone->wait_table))
 			vfree(zone->wait_table);
 	}
 
_

Patches currently in -mm which might be from wujianguo@huawei.com are

linux-next.patch
arch-x86-mm-init_64c-fix-build-warning-when-config_memory_hotremove=n.patch
mm-migrate-fix-comment-typo-syncronous-synchronous.patch

