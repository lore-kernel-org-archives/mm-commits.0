From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-allow-to-specify-a-default-online_type.patch added to -mm
 tree
Date: Wed, 11 Mar 2020 17:00:45 -0700
Message-ID: <20200312000045.jE7qcsaPk%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgCLAAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:00:49 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bhe@redhat.com, david@redhat.com, gregkh@linuxfoundation.org, haiyangz@microsoft.com, kys@microsoft.com, mhocko@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de, paulus@samba.org, rafael@kernel.org, richard.weiyang@gmail.com, sthemmin@microsoft.com, tglx@linutronix.de, wei.liu@kernel.org


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
Subject: mm/memory_hotplug: allow to specify a default online_type

For now, distributions implement advanced udev rules to essentially
- Don't online any hotplugged memory (s390x)
- Online all memory to ZONE_NORMAL (e.g., most virt environments like
  hyperv)
- Online all memory to ZONE_MOVABLE in case the zone imbalance is taken
  care of (e.g., bare metal, special virt environments)

In summary: All memory is usually onlined the same way, however, the
kernel always has to ask userspace to come up with the same answer.  E.g.,
HyperV always waits for a memory block to get onlined before continuing,
otherwise it might end up adding memory faster than hotplugging it, which
can result in strange OOM situations.

Let's allow to specify a default online_type, not just "online" and
"offline".  This allows distributions to configure the default online_type
when booting up and be done with it.

We can now specify "offline", "online", "online_movable" and
"online_kernel" via
- "memhp_default_state=3D" on the kernel cmdline
- /sys/devices/systemn/memory/auto_online_blocks
just like we are able to specify for a single memory block via
/sys/devices/systemn/memory/memoryX/state

Link: http://lkml.kernel.org/r/20200311123026.16071-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   11 +++++------
 include/linux/memory_hotplug.h |    2 ++
 mm/memory_hotplug.c            |    8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-allow-to-specify-a-default-online_type
+++ a/drivers/base/memory.c
@@ -35,7 +35,7 @@ static const char *const online_type_to_
 	[MMOP_ONLINE_MOVABLE] = "online_movable",
 };
 
-static int memhp_online_type_from_str(const char *str)
+int memhp_online_type_from_str(const char *str)
 {
 	int i;
 
@@ -394,13 +394,12 @@ static ssize_t auto_online_blocks_store(
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
@@ -75,10 +75,10 @@ EXPORT_SYMBOL_GPL(memhp_default_online_t
 
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
