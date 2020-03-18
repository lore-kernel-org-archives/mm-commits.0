From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch added to
 -mm tree
Date: Tue, 17 Mar 2020 21:08:36 -0700
Message-ID: <20200318040836.OC6qSrp9F%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgCREIi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 00:08:38 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, ehabkost@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, imammedo@redhat.com, kys@microsoft.com, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, vkuznets@redhat.com, wei.liu@kernel.org, yuhuang@redhat.com


The patch titled
     Subject: drivers/base/memory: rename MMOP_ONLINE_KEEP to MMOP_ONLINE
has been added to the -mm tree.  Its filename is
     drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memory-rename-mmop_online_keep-to-mmop_online.patch

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
Subject: [PATCH v2 1/8] drivers/base/memory: rename MMOP_ONLINE_KEEP to MMOP_ONLINE
Date: Tue, 17 Mar 2020 11:49:35 +0100

The name is misleading and it's not really clear what is "kept". Let's just
name it like the online_type name we expose to user space ("online").

Add some documentation to the types.

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
 drivers/base/memory.c          | 9 +++++----
 include/linux/memory_hotplug.h | 6 +++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 6448c9ece2cb..8c5ce42c0fc3 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -216,7 +216,7 @@ static int memory_subsys_online(struct device *dev)
 	 * attribute and need to set the online_type.
 	 */
 	if (mem->online_type < 0)
-		mem->online_type = MMOP_ONLINE_KEEP;
+		mem->online_type = MMOP_ONLINE;
 
 	ret = memory_block_change_state(mem, MEM_ONLINE, MEM_OFFLINE);
 
@@ -251,7 +251,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	else if (sysfs_streq(buf, "online_movable"))
 		online_type = MMOP_ONLINE_MOVABLE;
 	else if (sysfs_streq(buf, "online"))
-		online_type = MMOP_ONLINE_KEEP;
+		online_type = MMOP_ONLINE;
 	else if (sysfs_streq(buf, "offline"))
 		online_type = MMOP_OFFLINE;
 	else {
@@ -262,7 +262,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	switch (online_type) {
 	case MMOP_ONLINE_KERNEL:
 	case MMOP_ONLINE_MOVABLE:
-	case MMOP_ONLINE_KEEP:
+	case MMOP_ONLINE:
 		/* mem->online_type is protected by device_hotplug_lock */
 		mem->online_type = online_type;
 		ret = device_online(&mem->dev);
@@ -342,7 +342,8 @@ static ssize_t valid_zones_show(struct device *dev,
 	}
 
 	nid = mem->nid;
-	default_zone = zone_for_pfn_range(MMOP_ONLINE_KEEP, nid, start_pfn, nr_pages);
+	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, start_pfn,
+					  nr_pages);
 	strcat(buf, default_zone->name);
 
 	print_allowed_zone(buf, nid, start_pfn, nr_pages, MMOP_ONLINE_KERNEL,
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f4d59155f3d4..261dbf010d5d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -47,9 +47,13 @@ enum {
 
 /* Types for control the zone type of onlined and offlined memory */
 enum {
+	/* Offline the memory. */
 	MMOP_OFFLINE = -1,
-	MMOP_ONLINE_KEEP,
+	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
+	MMOP_ONLINE,
+	/* Online the memory to ZONE_NORMAL. */
 	MMOP_ONLINE_KERNEL,
+	/* Online the memory to ZONE_MOVABLE. */
 	MMOP_ONLINE_MOVABLE,
 };
 
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
