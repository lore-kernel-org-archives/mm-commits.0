From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
 added to -mm tree
Date: Wed, 11 Mar 2020 17:00:38 -0700
Message-ID: <20200312000038.7eEMA0mSM%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgCLAAl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:00:41 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, kys@microsoft.com, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, tglx@linutronix.de, wei.liu@kernel.org


The patch titled
     Subject: mm/memory_hotplug: convert memhp_auto_online to store an online_type
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: convert memhp_auto_online to store an online_type

...  and rename it to memhp_default_online_type.  This is a preparation
for more detailed default online behavior.

Link: http://lkml.kernel.org/r/20200311123026.16071-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/memtrace.c |    2 +-
 drivers/base/memory.c                     |   10 ++++------
 drivers/hv/hv_balloon.c                   |    2 +-
 include/linux/memory_hotplug.h            |    3 ++-
 mm/memory_hotplug.c                       |   13 +++++++------
 5 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/powerpc/platforms/powernv/memtrace.c~mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type
+++ a/arch/powerpc/platforms/powernv/memtrace.c
@@ -240,7 +240,7 @@ static int memtrace_online(void)
 		 * If kernel isn't compiled with the auto online option
 		 * we need to online the memory ourselves.
 		 */
-		if (!memhp_auto_online) {
+		if (memhp_default_online_type == MMOP_OFFLINE) {
 			lock_device_hotplug();
 			walk_memory_blocks(ent->start, ent->size, NULL,
 					   online_mem_block);
--- a/drivers/base/memory.c~mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type
+++ a/drivers/base/memory.c
@@ -386,10 +386,8 @@ static DEVICE_ATTR_RO(block_size_bytes);
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
@@ -397,9 +395,9 @@ static ssize_t auto_online_blocks_store(
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
 
--- a/drivers/hv/hv_balloon.c~mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type
+++ a/drivers/hv/hv_balloon.c
@@ -727,7 +727,7 @@ static void hv_mem_hot_add(unsigned long
 		spin_unlock_irqrestore(&dm_device.ha_lock, flags);
 
 		init_completion(&dm_device.ol_waitevent);
-		dm_device.ha_waiting = !memhp_auto_online;
+		dm_device.ha_waiting = memhp_default_online_type == MMOP_OFFLINE;
 
 		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
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
@@ -67,18 +67,18 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 #ifndef CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
-bool memhp_auto_online;
+int memhp_default_online_type = MMOP_OFFLINE;
 #else
-bool memhp_auto_online = true;
+int memhp_default_online_type = MMOP_ONLINE;
 #endif
-EXPORT_SYMBOL_GPL(memhp_auto_online);
+EXPORT_SYMBOL_GPL(memhp_default_online_type);
 
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
@@ -991,6 +991,7 @@ static int check_hotplug_memory_range(u6
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
+	mem->online_type = memhp_default_online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1063,7 +1064,7 @@ int __ref add_memory_resource(int nid, s
 	mem_hotplug_done();
 
 	/* online pages if requested */
-	if (memhp_auto_online)
+	if (memhp_default_online_type != MMOP_OFFLINE)
 		walk_memory_blocks(start, size, NULL, online_memory_block);
 
 	return ret;
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
virtio-balloon-switch-back-to-oom-handler-for-virtio_balloon_f_deflate_on_oom.patch
drivers-base-memoryc-indicate-all-memory-blocks-as-removable.patch
drivers-base-memoryc-drop-section_count.patch
drivers-base-memoryc-drop-pages_correctly_probed.patch
mm-page_extc-drop-pfn_present-check-when-onlining.patch
mm-memory_hotplug-simplify-calculation-of-number-of-pages-in-__remove_pages.patch
mm-memory_hotplug-cleanup-__add_pages.patch
drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch
drivers-base-memory-map-mmop_offline-to-0.patch
drivers-base-memory-store-mapping-between-mmop_-and-string-in-an-array.patch
mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
mm-memory_hotplug-allow-to-specify-a-default-online_type.patch
