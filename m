From: akpm@linux-foundation.org
Subject: + memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
 added to -mm tree
Date: Wed, 27 Aug 2014 13:25:05 -0700
Message-ID: <53fe3ea1.P/COnnNui7q8znPs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:51255 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938AbaH0UZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 16:25:06 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so133899obc.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 13:25:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, dave.hansen@intel.com, isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, toshi.kani@hp.com, wangnan0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: fix not enough check of valid zones
has been added to the -mm tree.  Its filename is
     memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: memory-hotplug: fix not enough check of valid zones

As Yasuaki Ishimatsu described the check here is not enough
if memory has hole as follows:

PFN       0x00          0xd0          0xe0          0xf0
             +-------------+-------------+-------------+
zone type   |   Normal    |     hole    |   Normal    |
             +-------------+-------------+-------------+

In this case, the check can't guarantee that this is "the last block of
memory".  The check of ZONE_MOVABLE has the same problem.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3 drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3
+++ a/drivers/base/memory.c
@@ -374,20 +374,6 @@ static ssize_t show_phys_device(struct d
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static int __zones_online_to(unsigned long end_pfn,
-				struct page *first_page, unsigned long nr_pages)
-{
-	struct zone *zone_next;
-
-	/* The mem block is the last block of memory. */
-	if (!pfn_valid(end_pfn + 1))
-		return 1;
-	zone_next = page_zone(first_page + nr_pages);
-	if (zone_idx(zone_next) == ZONE_MOVABLE)
-		return 1;
-	return 0;
-}
-
 static ssize_t show_zones_online_to(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -407,28 +393,18 @@ static ssize_t show_zones_online_to(stru
 
 	zone = page_zone(first_page);
 
-#ifdef CONFIG_HIGHMEM
-	if (zone_idx(zone) == ZONE_HIGHMEM) {
-		if (__zones_online_to(end_pfn, first_page, nr_pages))
+	if (zone_idx(zone) == ZONE_MOVABLE - 1) {
+		/*The mem block is the last memoryblock of this zone.*/
+		if (end_pfn == zone_end_pfn(zone))
 			return sprintf(buf, "%s %s\n",
 					zone->name, (zone + 1)->name);
 	}
-#else
-	if (zone_idx(zone) == ZONE_NORMAL) {
-		if (__zones_online_to(end_pfn, first_page, nr_pages))
-			return sprintf(buf, "%s %s\n",
-					zone->name, (zone + 1)->name);
-	}
-#endif
 
 	if (zone_idx(zone) == ZONE_MOVABLE) {
-		if (!pfn_valid(start_pfn - nr_pages))
-			return sprintf(buf, "%s %s\n",
-						zone->name, (zone - 1)->name);
-		zone_prev = page_zone(first_page - nr_pages);
-		if (zone_idx(zone_prev) != ZONE_MOVABLE)
+		/*The mem block is the first memoryblock of ZONE_MOVABLE.*/
+		if (start_pfn == zone->zone_start_pfn)
 			return sprintf(buf, "%s %s\n",
-						zone->name, (zone - 1)->name);
+					zone->name, (zone - 1)->name);
 	}
 
 	return sprintf(buf, "%s\n", zone->name);
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

memory-hotplug-add-sysfs-zones_online_to-attribute.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-3.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch

