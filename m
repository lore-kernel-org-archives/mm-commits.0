From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-add-move_pfn_range.patch removed from -mm tree
Date: Wed, 27 Jul 2016 11:59:39 -0700
Message-ID: <5799049b.c4BjqUcWlJcZJzns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbcG0S7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arbab@linux.vnet.ibm.com, abanman@sgi.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, shaohua.li@intel.com, slaoub@gmail.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, vkuznets@redhat.com, y-goto@jp.fujitsu.com, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: add move_pfn_range()
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-move_pfn_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: memory-hotplug: add move_pfn_range()

Add move_pfn_range(), a wrapper to call move_pfn_range_left() or
move_pfn_range_right().

No functional change. This will be utilized by a later patch.

Link: http://lkml.kernel.org/r/1462816419-4479-2-git-send-email-arbab@linux.vnet.ibm.com
Signed-off-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
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

 mm/memory_hotplug.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-add-move_pfn_range mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-add-move_pfn_range
+++ a/mm/memory_hotplug.c
@@ -449,6 +449,25 @@ out_fail:
 	return -1;
 }
 
+static struct zone * __meminit move_pfn_range(int zone_shift,
+		unsigned long start_pfn, unsigned long end_pfn)
+{
+	struct zone *zone = page_zone(pfn_to_page(start_pfn));
+	int ret = 0;
+
+	if (zone_shift < 0)
+		ret = move_pfn_range_left(zone + zone_shift, zone,
+					  start_pfn, end_pfn);
+	else if (zone_shift)
+		ret = move_pfn_range_right(zone, zone + zone_shift,
+					   start_pfn, end_pfn);
+
+	if (ret)
+		return NULL;
+
+	return zone + zone_shift;
+}
+
 static void __meminit grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
 				      unsigned long end_pfn)
 {
@@ -1039,6 +1058,7 @@ int __ref online_pages(unsigned long pfn
 	int nid;
 	int ret;
 	struct memory_notify arg;
+	int zone_shift = 0;
 
 	/*
 	 * This doesn't need a lock to do pfn_to_page().
@@ -1053,18 +1073,16 @@ int __ref online_pages(unsigned long pfn
 		return -EINVAL;
 
 	if (online_type == MMOP_ONLINE_KERNEL &&
-	    zone_idx(zone) == ZONE_MOVABLE) {
-		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages))
-			return -EINVAL;
-	}
+	    zone_idx(zone) == ZONE_MOVABLE)
+		zone_shift = -1;
+
 	if (online_type == MMOP_ONLINE_MOVABLE &&
-	    zone_idx(zone) == ZONE_MOVABLE - 1) {
-		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages))
-			return -EINVAL;
-	}
+	    zone_idx(zone) == ZONE_MOVABLE - 1)
+		zone_shift = 1;
 
-	/* Previous code may changed the zone of the pfn range */
-	zone = page_zone(pfn_to_page(pfn));
+	zone = move_pfn_range(zone_shift, pfn, pfn + nr_pages);
+	if (!zone)
+		return -EINVAL;
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
_

Patches currently in -mm which might be from arbab@linux.vnet.ibm.com are


