From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-allow-to-specify-a-default-online_type.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 18:59:21 -0700
Message-ID: <20200408015921.aVPL82ySg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, pankaj.gupta.linux@gmail.com, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: mm/memory_hotplug: allow to specify a default online_type
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-allow-to-specify-a-default-online_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: allow to specify a default online_type

For now, distributions implement advanced udev rules to essentially
- Don't online any hotplugged memory (s390x)
- Online all memory to ZONE_NORMAL (e.g., most virt environments like
  hyperv)
- Online all memory to ZONE_MOVABLE in case the zone imbalance is taken
  care of (e.g., bare metal, special virt environments)

In summary: All memory is usually onlined the same way, however, the
kernel always has to ask user space to come up with the same answer. 
E.g., Hyper-V always waits for a memory block to get onlined before
continuing, otherwise it might end up adding memory faster than
onlining it, which can result in strange OOM situations.  This waiting
slows down adding of a bigger amount of memory.

Let's allow to specify a default online_type, not just "online" and
"offline".  This allows distributions to configure the default online_type
when booting up and be done with it.

We can now specify "offline", "online", "online_movable" and
"online_kernel" via
- "memhp_default_state=" on the kernel cmdline
- /sys/devices/system/memory/auto_online_blocks
just like we are able to specify for a single memory block via
/sys/devices/system/memory/memoryX/state

Link: http://lkml.kernel.org/r/20200317104942.11178-9-david@redhat.com
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

 drivers/base/memory.c          |   11 +++++------
 include/linux/memory_hotplug.h |    2 ++
 mm/memory_hotplug.c            |    8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-allow-to-specify-a-default-online_type
+++ a/drivers/base/memory.c
@@ -34,7 +34,7 @@ static const char *const online_type_to_
 	[MMOP_ONLINE_MOVABLE] = "online_movable",
 };
 
-static int memhp_online_type_from_str(const char *str)
+int memhp_online_type_from_str(const char *str)
 {
 	int i;
 
@@ -386,13 +386,12 @@ static ssize_t auto_online_blocks_store(
 					struct device_attribute *attr,
 					const char *buf, size_t count)
 {
-	if (sysfs_streq(buf, "online"))
-		memhp_default_online_type = MMOP_ONLINE;
-	else if (sysfs_streq(buf, "offline"))
-		memhp_default_online_type = MMOP_OFFLINE;
-	else
+	const int online_type = memhp_online_type_from_str(buf);
+
+	if (online_type < 0)
 		return -EINVAL;
 
+	memhp_default_online_type = online_type;
 	return count;
 }
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-allow-to-specify-a-default-online_type
+++ a/include/linux/memory_hotplug.h
@@ -117,6 +117,8 @@ extern int arch_add_memory(int nid, u64
 			struct mhp_restrictions *restrictions);
 extern u64 max_mem_size;
 
+extern int memhp_online_type_from_str(const char *str);
+
 /* Default online_type (MMOP_*) when new memory blocks are added. */
 extern int memhp_default_online_type;
 /* If movable_node boot option specified */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-allow-to-specify-a-default-online_type
+++ a/mm/memory_hotplug.c
@@ -74,10 +74,10 @@ int memhp_default_online_type = MMOP_ONL
 
 static int __init setup_memhp_default_state(char *str)
 {
-	if (!strcmp(str, "online"))
-		memhp_default_online_type = MMOP_ONLINE;
-	else if (!strcmp(str, "offline"))
-		memhp_default_online_type = MMOP_OFFLINE;
+	const int online_type = memhp_online_type_from_str(str);
+
+	if (online_type >= 0)
+		memhp_default_online_type = online_type;
 
 	return 1;
 }
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
