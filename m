From: akpm@linux-foundation.org
Subject: [nacked]
 mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly.patch
 removed from -mm tree
Date: Thu, 17 Sep 2015 11:26:42 -0700
Message-ID: <55fb05e2.QcpWflIMr3eeRb+F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbIQS0n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 14:26:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuchangcheng@inspur.com, dave.hansen@intel.com, fandd@inspur.com, guz.fnst@cn.fujitsu.com, hutao@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com, qiuxishi@huawei.com, tangchen@cn.fujitsu.com, toshi.kani@hp.com, wangnan0@huawei.com, yanxiaofeng@inspur.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory hot-add: memory can not be added to movable zone by default
has been removed from the -mm tree.  Its filename was
     mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Changsheng Liu <liuchangcheng@inspur.com>
Subject: mm: memory hot-add: memory can not be added to movable zone by default

After the user config CONFIG_MOVABLE_NODE and movable_node kernel option,
when the memory is hot added, should_add_memory_movable() returns 0
because all zones including movable zone are empty.  So the memory that
was hot added will be added to the normal zone and the normal zone will be
created first.  But we want the whole node to be added to movable zone by
default.

So we change should_add_memory_movable(): if the user config
CONFIG_MOVABLE_NODE and movable_node kernel option it will always return 1
and all zones are empty at the same time, so that the movable zone will be
created first and then the whole node will be added to movable zone by
default.  If we want the node to be added to normal zone, we can do it as
follows: "echo online_kernel > /sys/devices/system/memory/memoryXXX/state"

Signed-off-by: Xiaofeng Yan <yanxiaofeng@inspur.com>
Signed-off-by: Changsheng Liu <liuchangcheng@inspur.com>
Tested-by: Dongdong Fan <fandd@inspur.com>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/memory_hotplug.c~mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hot-add-memory-can-not-be-added-to-movable-zone-defaultly
+++ a/mm/memory_hotplug.c
@@ -1201,6 +1201,9 @@ static int check_hotplug_memory_range(u6
 /*
  * If movable zone has already been setup, newly added memory should be check.
  * If its address is higher than movable zone, it should be added as movable.
+ * And if system boots up with movable_node and config CONFIG_MOVABLE_NOD and
+ * added memory does not overlap the zone before MOVABLE_ZONE,
+ * the memory is added as movable
  * Without this check, movable zone may overlap with other zone.
  */
 static int should_add_memory_movable(int nid, u64 start, u64 size)
@@ -1208,6 +1211,11 @@ static int should_add_memory_movable(int
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	pg_data_t *pgdat = NODE_DATA(nid);
 	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
+	struct zone *pre_zone = pgdat->node_zones + (ZONE_MOVABLE - 1);
+
+	if (movable_node_is_enabled()
+	&& zone_end_pfn(pre_zone) <= start_pfn)
+		return 1;
 
 	if (zone_is_empty(movable_zone))
 		return 0;
_

Patches currently in -mm which might be from liuchangcheng@inspur.com are


