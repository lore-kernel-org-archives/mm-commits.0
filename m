From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:19 -0700
Message-ID: <20200408015919.DPNDzAz6_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: mm/memory_hotplug: convert memhp_auto_online to store an online_type
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: convert memhp_auto_online to store an online_type

...  and rename it to memhp_default_online_type.  This is a preparation
for more detailed default online behavior.

Link: http://lkml.kernel.org/r/20200317104942.11178-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Yumei Huang <yuhuang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   10 ++++------
 include/linux/memory_hotplug.h |    3 ++-
 mm/memory_hotplug.c            |   11 ++++++-----
 3 files changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type
+++ a/drivers/base/memory.c
@@ -378,10 +378,8 @@ static DEVICE_ATTR_RO(block_size_bytes);
 static ssize_t auto_online_blocks_show(struct device *dev,
 				       struct device_attribute *attr, char *buf)
 {
-	if (memhp_auto_online)
-		return sprintf(buf, "online\n");
-	else
-		return sprintf(buf, "offline\n");
+	return sprintf(buf, "%s\n",
+		       online_type_to_str[memhp_default_online_type]);
 }
 
 static ssize_t auto_online_blocks_store(struct device *dev,
@@ -389,9 +387,9 @@ static ssize_t auto_online_blocks_store(
 					const char *buf, size_t count)
 {
 	if (sysfs_streq(buf, "online"))
-		memhp_auto_online = true;
+		memhp_default_online_type = MMOP_ONLINE;
 	else if (sysfs_streq(buf, "offline"))
-		memhp_auto_online = false;
+		memhp_default_online_type = MMOP_OFFLINE;
 	else
 		return -EINVAL;
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type
+++ a/include/linux/memory_hotplug.h
@@ -117,7 +117,8 @@ extern int arch_add_memory(int nid, u64
 			struct mhp_restrictions *restrictions);
 extern u64 max_mem_size;
 
-extern bool memhp_auto_online;
+/* Default online_type (MMOP_*) when new memory blocks are added. */
+extern int memhp_default_online_type;
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
 static inline bool movable_node_is_enabled(void)
--- a/mm/memory_hotplug.c~mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type
+++ a/mm/memory_hotplug.c
@@ -67,17 +67,17 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 #ifndef CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
-bool memhp_auto_online;
+int memhp_default_online_type = MMOP_OFFLINE;
 #else
-bool memhp_auto_online = true;
+int memhp_default_online_type = MMOP_ONLINE;
 #endif
 
 static int __init setup_memhp_default_state(char *str)
 {
 	if (!strcmp(str, "online"))
-		memhp_auto_online = true;
+		memhp_default_online_type = MMOP_ONLINE;
 	else if (!strcmp(str, "offline"))
-		memhp_auto_online = false;
+		memhp_default_online_type = MMOP_OFFLINE;
 
 	return 1;
 }
@@ -990,6 +990,7 @@ static int check_hotplug_memory_range(u6
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
+	mem->online_type = memhp_default_online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1062,7 +1063,7 @@ int __ref add_memory_resource(int nid, s
 	mem_hotplug_done();
 
 	/* online pages if requested */
-	if (memhp_auto_online)
+	if (memhp_default_online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
