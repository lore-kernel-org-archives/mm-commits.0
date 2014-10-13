From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-add-sysfs-zones_online_to-attribute.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:01 -0700
Message-ID: <543c1795.2CiS5o0x5TjIjNmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaJMSTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, dave.hansen@intel.com, isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, toshi.kani@hp.com, wangnan0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: add sysfs valid_zones attribute
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-sysfs-zones_online_to-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: memory-hotplug: add sysfs valid_zones attribute

Currently memory-hotplug has two limits:

1. If the memory block is in ZONE_NORMAL, you can change it to
   ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.

2. If the memory block is in ZONE_MOVABLE, you can change it to
   ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.

With this patch, we can easy to know a memory block can be onlined to
which zone, and don't need to know the above two limits.

Updated the related Documentation.

[akpm@linux-foundation.org: use conventional comment layout]
[akpm@linux-foundation.org: fix build with CONFIG_MEMORY_HOTREMOVE=n]
[akpm@linux-foundation.org: remove unused local zone_prev]
Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory |    8 ++
 Documentation/memory-hotplug.txt               |   11 +++
 drivers/base/memory.c                          |   42 +++++++++++++++
 include/linux/memory_hotplug.h                 |    1 
 mm/memory_hotplug.c                            |    2 
 5 files changed, 62 insertions(+), 2 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-devices-memory~memory-hotplug-add-sysfs-zones_online_to-attribute Documentation/ABI/testing/sysfs-devices-memory
--- a/Documentation/ABI/testing/sysfs-devices-memory~memory-hotplug-add-sysfs-zones_online_to-attribute
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -61,6 +61,14 @@ Users:		hotplug memory remove tools
 		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
 
 
+What:           /sys/devices/system/memory/memoryX/valid_zones
+Date:           July 2014
+Contact:	Zhang Zhen <zhenzhang.zhang@huawei.com>
+Description:
+		The file /sys/devices/system/memory/memoryX/valid_zones	is
+		read-only and is designed to show which zone this memory
+		block can be onlined to.
+
 What:		/sys/devices/system/memoryX/nodeY
 Date:		October 2009
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
diff -puN Documentation/memory-hotplug.txt~memory-hotplug-add-sysfs-zones_online_to-attribute Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory-hotplug-add-sysfs-zones_online_to-attribute
+++ a/Documentation/memory-hotplug.txt
@@ -155,6 +155,7 @@ Under each memory block, you can see 4 f
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
 /sys/devices/system/memory/memoryXXX/removable
+/sys/devices/system/memory/memoryXXX/valid_zones
 
 'phys_index'      : read-only and contains memory block id, same as XXX.
 'state'           : read-write
@@ -170,6 +171,15 @@ Under each memory block, you can see 4 f
                     block is removable and a value of 0 indicates that
                     it is not removable. A memory block is removable only if
                     every section in the block is removable.
+'valid_zones'     : read-only: designed to show which zones this memory block
+		    can be onlined to.
+		    The first column shows it's default zone.
+		    "memory6/valid_zones: Normal Movable" shows this memoryblock
+		    can be onlined to ZONE_NORMAL by default and to ZONE_MOVABLE
+		    by online_movable.
+		    "memory7/valid_zones: Movable Normal" shows this memoryblock
+		    can be onlined to ZONE_MOVABLE by default and to ZONE_NORMAL
+		    by online_kernel.
 
 NOTE:
   These directories/files appear after physical memory hotplug phase.
@@ -408,7 +418,6 @@ node if necessary.
   - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
     sysctl or new control file.
   - showing memory block and physical device relationship.
-  - showing memory block is under ZONE_MOVABLE or not
   - test and make it better memory offlining.
   - support HugeTLB page migration and offlining.
   - memmap removing at memory offline.
diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute
+++ a/drivers/base/memory.c
@@ -373,6 +373,45 @@ static ssize_t show_phys_device(struct d
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+static ssize_t show_valid_zones(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct memory_block *mem = to_memory_block(dev);
+	unsigned long start_pfn, end_pfn;
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	struct page *first_page;
+	struct zone *zone;
+
+	start_pfn = section_nr_to_pfn(mem->start_section_nr);
+	end_pfn = start_pfn + nr_pages;
+	first_page = pfn_to_page(start_pfn);
+
+	/* The block contains more than one zone can not be offlined. */
+	if (!test_pages_in_a_zone(start_pfn, end_pfn))
+		return sprintf(buf, "none\n");
+
+	zone = page_zone(first_page);
+
+	if (zone_idx(zone) == ZONE_MOVABLE - 1) {
+		/*The mem block is the last memoryblock of this zone.*/
+		if (end_pfn == zone_end_pfn(zone))
+			return sprintf(buf, "%s %s\n",
+					zone->name, (zone + 1)->name);
+	}
+
+	if (zone_idx(zone) == ZONE_MOVABLE) {
+		/*The mem block is the first memoryblock of ZONE_MOVABLE.*/
+		if (start_pfn == zone->zone_start_pfn)
+			return sprintf(buf, "%s %s\n",
+					zone->name, (zone - 1)->name);
+	}
+
+	return sprintf(buf, "%s\n", zone->name);
+}
+static DEVICE_ATTR(valid_zones, 0444, show_valid_zones, NULL);
+#endif
+
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
 static DEVICE_ATTR(state, 0644, show_mem_state, store_mem_state);
 static DEVICE_ATTR(phys_device, 0444, show_phys_device, NULL);
@@ -523,6 +562,9 @@ static struct attribute *memory_memblk_a
 	&dev_attr_state.attr,
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
+#ifdef CONFIG_MEMORY_HOTREMOVE
+	&dev_attr_valid_zones.attr,
+#endif
 	NULL
 };
 
diff -puN include/linux/memory_hotplug.h~memory-hotplug-add-sysfs-zones_online_to-attribute include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-hotplug-add-sysfs-zones_online_to-attribute
+++ a/include/linux/memory_hotplug.h
@@ -84,6 +84,7 @@ extern int zone_grow_waitqueues(struct z
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long, int);
+extern int test_pages_in_a_zone(unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
 
 typedef void (*online_page_callback_t)(struct page *page);
diff -puN mm/memory_hotplug.c~memory-hotplug-add-sysfs-zones_online_to-attribute mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-add-sysfs-zones_online_to-attribute
+++ a/mm/memory_hotplug.c
@@ -1307,7 +1307,7 @@ int is_mem_section_removable(unsigned lo
 /*
  * Confirm all pages in a range [start, end) is belongs to the same zone.
  */
-static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
+int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long pfn;
 	struct zone *zone = NULL;
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

origin.patch

