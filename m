From: akpm@linux-foundation.org
Subject: [folded-merged]
 memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch removed from -mm tree
Date: Thu, 09 Oct 2014 13:32:44 -0700
Message-ID: <5436f0ec.tlbIOAbhUoANyhP5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, dave.hansen@intel.com, isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, toshi.kani@hp.com, wangnan0@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: rename zones_online_to to valid_zones
has been removed from the -mm tree.  Its filename was
     memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4.patch

This patch was dropped because it was folded into memory-hotplug-add-sysfs-zones_online_to-attribute.patch

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: memory-hotplug: rename zones_online_to to valid_zones

Rename the interface to valid_zones according to most pepole's
suggestion.

Sample output of the sysfs files:
	memory0/valid_zones: none
	memory1/valid_zones: DMA32
	memory2/valid_zones: DMA32
	memory3/valid_zones: DMA32
	memory4/valid_zones: Normal
	memory5/valid_zones: Normal
	memory6/valid_zones: Normal Movable
	memory7/valid_zones: Movable Normal
	memory8/valid_zones: Movable

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory |    8 ++++----
 Documentation/memory-hotplug.txt               |   11 +++++++++--
 drivers/base/memory.c                          |    6 +++---
 3 files changed, 16 insertions(+), 9 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-devices-memory~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4 Documentation/ABI/testing/sysfs-devices-memory
--- a/Documentation/ABI/testing/sysfs-devices-memory~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -61,13 +61,13 @@ Users:		hotplug memory remove tools
 		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
 
 
-What:           /sys/devices/system/memory/memoryX/zones_online_to
+What:           /sys/devices/system/memory/memoryX/valid_zones
 Date:           July 2014
 Contact:	Zhang Zhen <zhenzhang.zhang@huawei.com>
 Description:
-		The file /sys/devices/system/memory/memoryX/zones_online_to
-		is read-only and is designed to show which zone this memory block can
-		be onlined to.
+		The file /sys/devices/system/memory/memoryX/valid_zones	is
+		read-only and is designed to show which zone this memory
+		block can be onlined to.
 
 What:		/sys/devices/system/memoryX/nodeY
 Date:		October 2009
diff -puN Documentation/memory-hotplug.txt~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4 Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4
+++ a/Documentation/memory-hotplug.txt
@@ -155,7 +155,7 @@ Under each memory block, you can see 4 f
 /sys/devices/system/memory/memoryXXX/phys_device
 /sys/devices/system/memory/memoryXXX/state
 /sys/devices/system/memory/memoryXXX/removable
-/sys/devices/system/memory/memoryXXX/zones_online_to
+/sys/devices/system/memory/memoryXXX/valid_zones
 
 'phys_index'      : read-only and contains memory block id, same as XXX.
 'state'           : read-write
@@ -171,8 +171,15 @@ Under each memory block, you can see 4 f
                     block is removable and a value of 0 indicates that
                     it is not removable. A memory block is removable only if
                     every section in the block is removable.
-'zones_online_to' : read-only: designed to show which zone this memory block
+'valid_zones'     : read-only: designed to show which zones this memory block
 		    can be onlined to.
+		    The first column shows it's default zone.
+		    "memory6/valid_zones: Normal Movable" shows this memoryblock
+		    can be onlined to ZONE_NORMAL by default and to ZONE_MOVABLE
+		    by online_movable.
+		    "memory7/valid_zones: Movable Normal" shows this memoryblock
+		    can be onlined to ZONE_MOVABLE by default and to ZONE_NORMAL
+		    by online_kernel.
 
 NOTE:
   These directories/files appear after physical memory hotplug phase.
diff -puN drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4 drivers/base/memory.c
--- a/drivers/base/memory.c~memory-hotplug-add-sysfs-zones_online_to-attribute-fix-4
+++ a/drivers/base/memory.c
@@ -374,7 +374,7 @@ static ssize_t show_phys_device(struct d
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static ssize_t show_zones_online_to(struct device *dev,
+static ssize_t show_valid_zones(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct memory_block *mem = to_memory_block(dev);
@@ -409,7 +409,7 @@ static ssize_t show_zones_online_to(stru
 
 	return sprintf(buf, "%s\n", zone->name);
 }
-static DEVICE_ATTR(zones_online_to, 0444, show_zones_online_to, NULL);
+static DEVICE_ATTR(valid_zones, 0444, show_valid_zones, NULL);
 #endif
 
 static DEVICE_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
@@ -563,7 +563,7 @@ static struct attribute *memory_memblk_a
 	&dev_attr_phys_device.attr,
 	&dev_attr_removable.attr,
 #ifdef CONFIG_MEMORY_HOTREMOVE
-	&dev_attr_zones_online_to.attr,
+	&dev_attr_valid_zones.attr,
 #endif
 	NULL
 };
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

memory-hotplug-add-sysfs-zones_online_to-attribute.patch

