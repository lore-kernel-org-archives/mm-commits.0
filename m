From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch added to -mm tree
Date: Thu, 12 Jun 2014 12:28:35 -0700
Message-ID: <5399ff63.GIkKAbM2qTu8CE/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaFLT2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 15:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, hutao@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, gregkh@linuxfoundation.org, tangchen@cn.fujitsu.com

Subject: + mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch added to -mm tree
To: tangchen@cn.fujitsu.com,gregkh@linuxfoundation.org,guz.fnst@cn.fujitsu.com,hutao@cn.fujitsu.com,isimatu.yasuaki@jp.fujitsu.com,laijs@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 12:28:35 -0700


The patch titled
     Subject: mem-hotplug: introduce MMOP_OFFLINE to replace the hard coding -1
has been added to the -mm tree.  Its filename is
     mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch

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
Subject: mem-hotplug: introduce MMOP_OFFLINE to replace the hard coding -1

In store_mem_state(), we have:
......
 334         else if (!strncmp(buf, "offline", min_t(int, count, 7)))
 335                 online_type = -1;
......
 355         case -1:
 356                 ret = device_offline(&mem->dev);
 357                 break;
......

Here, "offline" is hard coded as -1.

This patch does the following renaming:
 ONLINE_KEEP     ->  MMOP_ONLINE_KEEP
 ONLINE_KERNEL   ->  MMOP_ONLINE_KERNEL
 ONLINE_MOVABLE  ->  MMOP_ONLINE_MOVABLE

and introduce MMOP_OFFLINE = -1 to avoid hard coding.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   18 +++++++++---------
 include/linux/memory_hotplug.h |    9 +++++----
 mm/memory_hotplug.c            |    9 ++++++---
 3 files changed, 20 insertions(+), 16 deletions(-)

diff -puN drivers/base/memory.c~mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1 drivers/base/memory.c
--- a/drivers/base/memory.c~mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1
+++ a/drivers/base/memory.c
@@ -284,7 +284,7 @@ static int memory_subsys_online(struct d
 	 * attribute and need to set the online_type.
 	 */
 	if (mem->online_type < 0)
-		mem->online_type = ONLINE_KEEP;
+		mem->online_type = MMOP_ONLINE_KEEP;
 
 	ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
 
@@ -316,22 +316,22 @@ store_mem_state(struct device *dev,
 		return ret;
 
 	if (sysfs_streq(buf, "online_kernel"))
-		online_type = ONLINE_KERNEL;
+		online_type = MMOP_ONLINE_KERNEL;
 	else if (sysfs_streq(buf, "online_movable"))
-		online_type = ONLINE_MOVABLE;
+		online_type = MMOP_ONLINE_MOVABLE;
 	else if (sysfs_streq(buf, "online"))
-		online_type = ONLINE_KEEP;
+		online_type = MMOP_ONLINE_KEEP;
 	else if (sysfs_streq(buf, "offline"))
-		online_type = -1;
+		online_type = MMOP_OFFLINE;
 	else {
 		ret = -EINVAL;
 		goto err;
 	}
 
 	switch (online_type) {
-	case ONLINE_KERNEL:
-	case ONLINE_MOVABLE:
-	case ONLINE_KEEP:
+	case MMOP_ONLINE_KERNEL:
+	case MMOP_ONLINE_MOVABLE:
+	case MMOP_ONLINE_KEEP:
 		/*
 		 * mem->online_type is not protected so there can be a
 		 * race here.  However, when racing online, the first
@@ -342,7 +342,7 @@ store_mem_state(struct device *dev,
 		mem->online_type = online_type;
 		ret = device_online(&mem->dev);
 		break;
-	case -1:
+	case MMOP_OFFLINE:
 		ret = device_offline(&mem->dev);
 		break;
 	default:
diff -puN include/linux/memory_hotplug.h~mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1 include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1
+++ a/include/linux/memory_hotplug.h
@@ -26,11 +26,12 @@ enum {
 	MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE = NODE_INFO,
 };
 
-/* Types for control the zone type of onlined memory */
+/* Types for control the zone type of onlined and offlined memory */
 enum {
-	ONLINE_KEEP,
-	ONLINE_KERNEL,
-	ONLINE_MOVABLE,
+	MMOP_OFFLINE = -1,
+	MMOP_ONLINE_KEEP,
+	MMOP_ONLINE_KERNEL,
+	MMOP_ONLINE_MOVABLE,
 };
 
 /*
diff -puN mm/memory_hotplug.c~mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1
+++ a/mm/memory_hotplug.c
@@ -977,15 +977,18 @@ int __ref online_pages(unsigned long pfn
 	zone = page_zone(pfn_to_page(pfn));
 
 	ret = -EINVAL;
-	if ((zone_idx(zone) > ZONE_NORMAL || online_type == ONLINE_MOVABLE) &&
+	if ((zone_idx(zone) > ZONE_NORMAL ||
+	    online_type == MMOP_ONLINE_MOVABLE) &&
 	    !can_online_high_movable(zone))
 		goto out;
 
-	if (online_type == ONLINE_KERNEL && zone_idx(zone) == ZONE_MOVABLE) {
+	if (online_type == MMOP_ONLINE_KERNEL &&
+	    zone_idx(zone) == ZONE_MOVABLE) {
 		if (move_pfn_range_left(zone - 1, zone, pfn, pfn + nr_pages))
 			goto out;
 	}
-	if (online_type == ONLINE_MOVABLE && zone_idx(zone) == ZONE_MOVABLE - 1) {
+	if (online_type == MMOP_ONLINE_MOVABLE &&
+	    zone_idx(zone) == ZONE_MOVABLE - 1) {
 		if (move_pfn_range_right(zone, zone + 1, pfn, pfn + nr_pages))
 			goto out;
 	}
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch

