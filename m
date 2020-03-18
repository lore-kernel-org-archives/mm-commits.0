From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-allow-to-specify-a-default-online_type.patch added to -mm
 tree
Date: Tue, 17 Mar 2020 21:08:49 -0700
Message-ID: <20200318040849.emAW_vG7V%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgCREIw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 00:08:52 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: mm/memory_hotplug: allow to specify a default online_type
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-allow-to-specify-a-default-online_type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-allow-to-specify-a-default-online_type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-allow-to-specify-a-default-online_type.patch

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
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-hyperv@vger.kernel.org, David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>, "Rafael J. Wysocki" <rafael@kernel.org>, Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 8/8] mm/memory_hotplug: allow to specify a default online_type
Date: Tue, 17 Mar 2020 11:49:42 +0100

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
hotplugging it, which can result in strange OOM situations. This waiting
slows down adding of a bigger amount of memory.

Let's allow to specify a default online_type, not just "online" and
"offline". This allows distributions to configure the default online_type
when booting up and be done with it.

We can now specify "offline", "online", "online_movable" and
"online_kernel" via
- "memhp_default_state=" on the kernel cmdline
- /sys/devices/system/memory/auto_online_blocks
just like we are able to specify for a single memory block via
/sys/devices/system/memory/memoryX/state

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c          | 11 +++++------
 include/linux/memory_hotplug.h |  2 ++
 mm/memory_hotplug.c            |  8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 8d3e16dab69f..2b09b68b9f78 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -35,7 +35,7 @@ static const char *const online_type_to_str[] = {
 	[MMOP_ONLINE_MOVABLE] = "online_movable",
 };
 
-static int memhp_online_type_from_str(const char *str)
+int memhp_online_type_from_str(const char *str)
 {
 	int i;
 
@@ -394,13 +394,12 @@ static ssize_t auto_online_blocks_store(struct device *dev,
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
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index c6e090b34c4b..ef55115320fb 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -117,6 +117,8 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
 			struct mhp_restrictions *restrictions);
 extern u64 max_mem_size;
 
+extern int memhp_online_type_from_str(const char *str);
+
 /* Default online_type (MMOP_*) when new memory blocks are added. */
 extern int memhp_default_online_type;
 /* If movable_node boot option specified */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1975a2b99a2b..9916977b6ee1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -74,10 +74,10 @@ int memhp_default_online_type = MMOP_ONLINE;
 
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
-- 
2.24.1

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
powernv-memtrace-always-online-added-memory-blocks.patch
hv_balloon-dont-check-for-memhp_auto_online-manually.patch
mm-memory_hotplug-unexport-memhp_auto_online.patch
mm-memory_hotplug-convert-memhp_auto_online-to-store-an-online_type.patch
mm-memory_hotplug-allow-to-specify-a-default-online_type.patch
