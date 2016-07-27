From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-more-general-validation-of-zone-during-online.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 11:59:42 -0700
Message-ID: <5799049e.xnzsZO/OCPM6ulgo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbcG0S7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, abanman@sgi.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, shaohua.li@intel.com, slaoub@gmail.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, vkuznets@redhat.com, y-goto@jp.fujitsu.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: more general validation of zone during online
has been removed from the -mm tree.  Its filename was
     memory-hotplug-more-general-validation-of-zone-during-online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: memory-hotplug: more general validation of zone during online

When memory is onlined, we are only able to rezone from ZONE_MOVABLE to
ZONE_KERNEL, or from (ZONE_MOVABLE - 1) to ZONE_MOVABLE.

To be more flexible, use the following criteria instead; to online memory
from zone X into zone Y,

* Any zones between X and Y must be unused.
* If X is lower than Y, the onlined memory must lie at the end of X.
* If X is higher than Y, the onlined memory must lie at the start of X.

Add zone_can_shift() to make this determination.

Link: http://lkml.kernel.org/r/1462816419-4479-3-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Reviewd-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Banman <abanman@sgi.com>
Cc: Chen Yucong <slaoub@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 +
 mm/memory_hotplug.c            |   42 +++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 7 deletions(-)

diff -puN include/linux/memory_hotplug.h~memory-hotplug-more-general-validation-of-zone-during-online include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-more-general-validation-of-zone-during-online
+++ a/include/linux/memory_hotplug.h
@@ -284,5 +284,7 @@ extern void sparse_remove_one_section(st
 		unsigned long map_offset);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
+extern int zone_can_shift(unsigned long pfn, unsigned long nr_pages,
+			  enum zone_type target);
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff -puN mm/memory_hotplug.c~memory-hotplug-more-general-validation-of-zone-during-online mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-more-general-validation-of-zone-during-online
+++ a/mm/memory_hotplug.c
@@ -1047,6 +1047,37 @@ static void node_states_set_node(int nod
 	node_set_state(node, N_MEMORY);
 }
 
+int zone_can_shift(unsigned long pfn, unsigned long nr_pages,
+		   enum zone_type target)
+{
+	struct zone *zone = page_zone(pfn_to_page(pfn));
+	enum zone_type idx = zone_idx(zone);
+	int i;
+
+	if (idx < target) {
+		/* pages must be at end of current zone */
+		if (pfn + nr_pages != zone_end_pfn(zone))
+			return 0;
+
+		/* no zones in use between current zone and target */
+		for (i = idx + 1; i < target; i++)
+			if (zone_is_initialized(zone - idx + i))
+				return 0;
+	}
+
+	if (target < idx) {
+		/* pages must be at beginning of current zone */
+		if (pfn != zone->zone_start_pfn)
+			return 0;
+
+		/* no zones in use between current zone and target */
+		for (i = target + 1; i < idx; i++)
+			if (zone_is_initialized(zone - idx + i))
+				return 0;
+	}
+
+	return target - idx;
+}
 
 /* Must be protected by mem_hotplug_begin() */
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
@@ -1072,13 +1103,10 @@ int __ref online_pages(unsigned long pfn
 	    !can_online_high_movable(zone))
 		return -EINVAL;
 
-	if (online_type == MMOP_ONLINE_KERNEL &&
-	    zone_idx(zone) == ZONE_MOVABLE)
-		zone_shift = -1;
