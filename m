From: akpm@linux-foundation.org
Subject: [patch 030/126] memory-hotplug: use zone_can_shift() for sysfs
 valid_zones attribute
Date: Tue, 26 Jul 2016 15:22:27 -0700
Message-ID: <5797e2a3.G7NpKWtXloKKtHww%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbcGZWW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, abanman@sgi.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, david.vrabel@citrix.com, gregkh@linuxfoundation.org, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, shaohua.li@intel.com, slaoub@gmail.com, tangchen@cn.fujitsu.com, vbabka@suse.cz, vkuznets@redhat.com, y-goto@jp.fujitsu.com, zhenzhang.zhang@huawei.com

From: Reza Arbab <arbab@linux.vnet.ibm.com>
Subject: memory-hotplug: use zone_can_shift() for sysfs valid_zones attribute

Since zone_can_shift() is being used to validate the target zone during
onlining, it should also be used to determine the content of valid_zones.

Link: http://lkml.kernel.org/r/1462816419-4479-4-git-send-email-arbab@linux.vnet.ibm.com
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

 drivers/base/memory.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-use-zone_can_shift-for-sysfs-valid_zones-attribute drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-use-zone_can_shift-for-sysfs-valid_zones-attribute
+++ a/drivers/base/memory.c
@@ -391,6 +391,7 @@ static ssize_t show_valid_zones(struct d
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	struct page *first_page;
 	struct zone *zone;
+	int zone_shift = 0;
 
 	start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	end_pfn = start_pfn + nr_pages;
@@ -402,21 +403,26 @@ static ssize_t show_valid_zones(struct d
 
 	zone = page_zone(first_page);
 
-	if (zone_idx(zone) == ZONE_MOVABLE - 1) {
-		/*The mem block is the last memoryblock of this zone.*/
-		if (end_pfn == zone_end_pfn(zone))
-			return sprintf(buf, "%s %s\n",
-					zone->name, (zone + 1)->name);
+	/* MMOP_ONLINE_KEEP */
+	sprintf(buf, "%s", zone->name);
+
+	/* MMOP_ONLINE_KERNEL */
+	zone_shift = zone_can_shift(start_pfn, nr_pages, ZONE_NORMAL);
+	if (zone_shift) {
+		strcat(buf, " ");
+		strcat(buf, (zone + zone_shift)->name);
 	}
 
-	if (zone_idx(zone) == ZONE_MOVABLE) {
-		/*The mem block is the first memoryblock of ZONE_MOVABLE.*/
-		if (start_pfn == zone->zone_start_pfn)
-			return sprintf(buf, "%s %s\n",
-					zone->name, (zone - 1)->name);
+	/* MMOP_ONLINE_MOVABLE */
+	zone_shift = zone_can_shift(start_pfn, nr_pages, ZONE_MOVABLE);
+	if (zone_shift) {
+		strcat(buf, " ");
+		strcat(buf, (zone + zone_shift)->name);
 	}
 
-	return sprintf(buf, "%s\n", zone->name);
+	strcat(buf, "\n");
+
+	return strlen(buf);
 }
 static DEVICE_ATTR(valid_zones, 0444, show_valid_zones, NULL);
 #endif
_
