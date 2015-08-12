From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node.patch
 added to -mm tree
Date: Wed, 12 Aug 2015 14:24:08 -0700
Message-ID: <55cbb978.3w8riKPdOdlnWxIE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbbHLVYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 17:24:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix wrong edge when hot add a new node
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: memory-hotplug: fix wrong edge when hot add a new node

When we add a new node, the edge of memory may be wrong.

e.g. system has 4 nodes, and node3 is movable, node3 mem:[24G-32G],

1. hotremove the node3,
2. then hotadd node3 with a part of memory, mem:[26G-30G],
3. call hotadd_new_pgdat()
	free_area_init_node()
		get_pfn_range_for_nid()
4. it will return wrong start_pfn and end_pfn, because we have not
update the memblock.

This patch also fixes a BUG_ON during hot-addition, please see
http://marc.info/?l=linux-kernel&m=142961156129456&w=2

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 +++
 mm/page_alloc.c     |    8 ++++++++
 2 files changed, 11 insertions(+)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node
+++ a/mm/memory_hotplug.c
@@ -1277,6 +1277,7 @@ int __ref add_memory(int nid, u64 start,
 
 	/* create new memmap entry */
 	firmware_map_add_hotplug(start, start + size, "System RAM");
+	memblock_add_node(start, size, nid);
 
 	goto out;
 
@@ -2013,6 +2014,8 @@ void __ref remove_memory(int nid, u64 st
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
+	memblock_free(start, size);
+	memblock_remove(start, size);
 
 	arch_remove_memory(start, size);
 
diff -puN mm/page_alloc.c~memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node
+++ a/mm/page_alloc.c
@@ -5060,6 +5060,10 @@ static unsigned long __meminit zone_span
 {
 	unsigned long zone_start_pfn, zone_end_pfn;
 
+	/* When hotadd a new node, the node should be empty */
+	if (!node_start_pfn && !node_end_pfn)
+		return 0;
+
 	/* Get the start and end of the zone */
 	zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
 	zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
@@ -5123,6 +5127,10 @@ static unsigned long __meminit zone_abse
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	unsigned long zone_start_pfn, zone_end_pfn;
 
+	/* When hotadd a new node, the node should be empty */
+	if (!node_start_pfn && !node_end_pfn)
+		return 0;
+
 	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

memory-hotplug-fix-wrong-edge-when-hot-add-a-new-node.patch
memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch
memory-hotplug-remove-reset_node_managed_pages-and-reset_node_managed_pages-in-hotadd_new_pgdat.patch

