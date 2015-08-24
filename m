From: akpm@linux-foundation.org
Subject: +
 memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node.patch added to -mm tree
Date: Mon, 24 Aug 2015 12:36:13 -0700
Message-ID: <55db722d.LHttygKmlk6gO41E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbbHXTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: add hot-added memory ranges to memblock before allocate node_data for a node.
has been added to the -mm tree.  Its filename is
     memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: memory-hotplug: add hot-added memory ranges to memblock before allocate node_data for a node.

f9126ab9241f66562de ("memory-hotplug: fix wrong edge when hot add a new
node") hot-added memory range to memblock, after creating pgdat for new
node.

But there is a problem:

add_memory()
|--> hotadd_new_pgdat()
     |--> free_area_init_node()
          |--> get_pfn_range_for_nid()
               |--> find start_pfn and end_pfn in memblock
|--> ......
|--> memblock_add_node(start, size, nid)    --------    Here, just too late.

get_pfn_range_for_nid() will find that start_pfn and end_pfn are both 0.
As a result, when adding memory, dmesg will give the following wrong message.

[ 2007.577000] Initmem setup node 5 [mem 0x0000000000000000-0xffffffffffffffff]
[ 2007.584000] On node 5 totalpages: 0
[ 2007.585000] Built 5 zonelists in Node order, mobility grouping on.  Total pages: 32588823
[ 2007.594000] Policy zone: Normal
[ 2007.598000] init_memory_mapping: [mem 0x60000000000-0x607ffffffff]

The solution is simple, just add the memory range to memblock a little
earlier, before hotadd_new_pgdat().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node
+++ a/mm/memory_hotplug.c
@@ -1248,6 +1248,14 @@ int __ref add_memory(int nid, u64 start,
 
 	mem_hotplug_begin();
 
+	/*
+	 * Add new range to memblock so that when hotadd_new_pgdat() is called to
+	 * allocate new pgdat, get_pfn_range_for_nid() will be able to find this
+	 * new range and calculate total pages correctly. The range will be remove
+	 * at hot-remove time.
+	 */
+	memblock_add_node(start, size, nid);
+
 	new_node = !node_online(nid);
 	if (new_node) {
 		pgdat = hotadd_new_pgdat(nid, start);
@@ -1277,7 +1285,6 @@ int __ref add_memory(int nid, u64 start,
 
 	/* create new memmap entry */
 	firmware_map_add_hotplug(start, start + size, "System RAM");
-	memblock_add_node(start, size, nid);
 
 	goto out;
 
@@ -1286,6 +1293,7 @@ error:
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
 	release_memory_resource(res);
+	memblock_remove(start, size);
 
 out:
 	mem_hotplug_done();
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

memhp-add-hot-added-memory-ranges-to-memblock-before-allocate-node_data-for-a-node.patch
memblock-make-memblock_overlaps_region-return-bool.patch
mem-hotplug-handle-node-hole-when-initializing-numa_meminfo.patch

