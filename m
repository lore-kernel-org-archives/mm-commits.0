From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-support-movable_node-for-hotplugable-nodes.patch added to -mm tree
Date: Thu, 15 Jun 2017 15:21:20 -0700
Message-ID: <59430860.WRnY548g/IlHCflw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFOWVW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 18:21:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, daniel.kiper@oracle.com, imammedo@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, qiuxishi@huawei.com, rientjes@google.com, slaoub@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: support movable_node for hotpluggable nodes
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-support-movable_node-for-hotplugable-nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-support-movable_node-for-hotplugable-nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-support-movable_node-for-hotplugable-nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm, memory_hotplug: support movable_node for hotpluggable nodes

movable_node kernel parameter allows making hotpluggable NUMA nodes to put
all the hotplugable memory into movable zone which allows more or less
reliable memory hotremove.  At least this is the case for the NUMA nodes
present during the boot (see find_zone_movable_pfns_for_nodes).

This is not the case for the memory hotplug, though.

	echo online > /sys/devices/system/memory/memoryXYZ/state

will default to a kernel zone (usually ZONE_NORMAL) unless the particular
memblock is already in the movable zone range which is not the case
normally when onlining the memory from the udev rule context for a freshly
hotadded NUMA node.  The only option currently is to have a special udev
rule to echo online_movable to all memblocks belonging to such a node
which is rather clumsy.  Not to mention this is inconsistent as well
because what ended up in the movable zone during the boot will end up in a
kernel zone after hotremove & hotadd without special care.

It would be nice to reuse memblock_is_hotpluggable but the runtime hotplug
doesn't have that information available because the boot and hotplug paths
are not shared and it would be really non trivial to make them use the
same code path because the runtime hotplug doesn't play with the memblock
allocator at all.

Teach move_pfn_range that MMOP_ONLINE_KEEP can use the movable zone if
movable_node is enabled and the range doesn't overlap with the existing
normal zone.  This should provide a reasonable default onlining strategy.

Strictly speaking the semantic is not identical with the boot time
initialization because find_zone_movable_pfns_for_nodes covers only the
hotplugable range as described by the BIOS/FW.  From my experience this is
usually a full node though (except for Node0 which is special and never
goes away completely).  If this turns out to be a problem in the real life
we can tweak the code to store hotplug flag into memblocks but let's keep
this simple now.

Link: http://lkml.kernel.org/r/20170612111227.GI7476@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: <qiuxishi@huawei.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: <slaoub@gmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   12 +++++++++---
 mm/memory_hotplug.c              |   19 ++++++++++++++++---
 2 files changed, 25 insertions(+), 6 deletions(-)

diff -puN Documentation/memory-hotplug.txt~mm-memory_hotplug-support-movable_node-for-hotplugable-nodes Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~mm-memory_hotplug-support-movable_node-for-hotplugable-nodes
+++ a/Documentation/memory-hotplug.txt
@@ -282,20 +282,26 @@ offlined it is possible to change the in
 % echo online > /sys/devices/system/memory/memoryXXX/state
 
 This onlining will not change the ZONE type of the target memory block,
-If the memory block is in ZONE_NORMAL, you can change it to ZONE_MOVABLE:
+If the memory block doesn't belong to any zone an appropriate kernel zone
+(usually ZONE_NORMAL) will be used unless movable_node kernel command line
+option is specified when ZONE_MOVABLE will be used.
+
+You can explicitly request to associate it with ZONE_MOVABLE by
 
 % echo online_movable > /sys/devices/system/memory/memoryXXX/state
 (NOTE: current limit: this memory block must be adjacent to ZONE_MOVABLE)
 
-And if the memory block is in ZONE_MOVABLE, you can change it to ZONE_NORMAL:
+Or you can explicitly request a kernel zone (usually ZONE_NORMAL) by:
 
 % echo online_kernel > /sys/devices/system/memory/memoryXXX/state
 (NOTE: current limit: this memory block must be adjacent to ZONE_NORMAL)
 
+An explicit zone onlining can fail (e.g. when the range is already within
+and existing and incompatible zone already).
+
 After this, memory block XXX's state will be 'online' and the amount of
 available memory will be increased.
 
-Currently, newly added memory is added as ZONE_NORMAL (for powerpc, ZONE_DMA).
 This may be changed in future.
 
 
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-support-movable_node-for-hotplugable-nodes mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-support-movable_node-for-hotplugable-nodes
+++ a/mm/memory_hotplug.c
@@ -943,6 +943,19 @@ struct zone *default_zone_for_pfn(int ni
 	return &pgdat->node_zones[ZONE_NORMAL];
 }
 
+static inline bool movable_pfn_range(int nid, struct zone *default_zone,
+		unsigned long start_pfn, unsigned long nr_pages)
+{
+	if (!allow_online_pfn_range(nid, start_pfn, nr_pages,
+				MMOP_ONLINE_KERNEL))
+		return true;
+
+	if (!movable_node_is_enabled())
+		return false;
+
+	return !zone_intersects(default_zone, start_pfn, nr_pages);
+}
+
 /*
  * Associates the given pfn range with the given node and the zone appropriate
  * for the given online type.
@@ -958,10 +971,10 @@ static struct zone * __meminit move_pfn_
 		/*
 		 * MMOP_ONLINE_KEEP defaults to MMOP_ONLINE_KERNEL but use
 		 * movable zone if that is not possible (e.g. we are within
-		 * or past the existing movable zone)
+		 * or past the existing movable zone). movable_node overrides
+		 * this default and defaults to movable zone
 		 */
-		if (!allow_online_pfn_range(nid, start_pfn, nr_pages,
-					MMOP_ONLINE_KERNEL))
+		if (movable_pfn_range(nid, zone, start_pfn, nr_pages))
 			zone = movable_zone;
 	} else if (online_type == MMOP_ONLINE_MOVABLE) {
 		zone = &pgdat->node_zones[ZONE_MOVABLE];
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-memory_hotplug-support-movable_node-for-hotplugable-nodes.patch

