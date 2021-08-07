Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7DBC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3B546103B
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhHGTOF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhHGTOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E36660551;
        Sat,  7 Aug 2021 19:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363626;
        bh=wNnLiRwECzebaAe4CUBneD1eVg+SdelTeL1dx2kcTRQ=;
        h=Date:From:To:Subject:From;
        b=oWyQ/MZtE8+Vv6GfD0BiSq3AKPARuOosjT5wNQzf5bdZHV4T3bkKVdx911li0UWwH
         x1Vh7prXr269emtfwFXaB0RFVSof+Bok3TIeESQWdpsTP5wtSY1N44X2ZcgmboCAHx
         JcBNT/rRbBsS52c4H4i7Ry0aI3OEWrh573FPfjNw=
Date:   Sat, 07 Aug 2021 12:13:45 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vkuznets@redhat.com, vbabka@suse.cz,
        teawater@gmail.com, rppt@kernel.org, rjw@rjwysocki.net,
        richard.weiyang@linux.alibaba.com, rafael.j.wysocki@intel.com,
        pasha.tatashin@soleen.com, pankaj.gupta.linux@gmail.com,
        osalvador@suse.de, mst@redhat.com, mkedzier@redhat.com,
        mhocko@kernel.org, lenb@kernel.org, jasowang@redhat.com,
        gregkh@linuxfoundation.org, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, anshuman.khandual@arm.com,
        david@redhat.com
Subject:  [to-be-updated]
 =?us-ascii?Q?mm-memory=5Fhotplug-improved-dynamic-memory-group-aware-auto?=
 =?us-ascii?Q?-movable-online-policy.patch?= removed from -mm tree
Message-ID: <20210807191345.cGkki%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: improved dynamic memory group aware "auto-movable" online policy
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: improved dynamic memory group aware "auto-movable" online policy

Currently, the "auto-movable" online policy does not allow for hotplugged
KERNEL (ZONE_NORMAL) memory to increase the amount of MOVABLE memory we
can have, primarily, because there is no coordiantion across memory
devices and we don't want to create zone-imbalances accidentially when
unplugging memory.

However, within a single memory device it's different.  Let's allow for
KERNEL memory within a dynamic memory group to allow for more MOVABLE
within the same memory group.  The only thing we have to take care of is
that the managing driver avoids zone imbalances by unplugging MOVABLE
memory first, otherwise there can be corner cases where unplug of memory
could result in (accidential) zone imbalances.

virtio-mem is the only user of dynamic memory groups and recently added
support for prioritizing unplug of ZONE_MOVABLE over ZONE_NORMAL, so we
don't need a new toggle to enable it for dynamic memory groups.

We limit this handling to dynamic memory groups, because:

* We want to keep the runtime overhead for collecting stats when onlining
  a single memory block small. We tend to have only a handful of dynamic
  memory groups, but we can have quite some static memory groups (e.g., 256
  DIMMs).
* It doesn't make too much sense for static memory groups, as we try
  onlining all applicable memory blocks either completely to ZONE_MOVABLE
  or not. In ordinary operation, we won't have a mixture of zones
  within a static memory group.

When adding memory to a dynamic memory group, we'll first online memory to
ZONE_MOVABLE as long as early KERNEL memory allows for it.  Then, we'll
online the next unit(s) to ZONE_NORMAL, until we can online the next
unit(s) to ZONE_MOVABLE.

For a simple virtio-mem device with a MOVABLE:KERNEL ratio of 3:1, it
will result in a layout like:

  [M][M][M][M][M][M][M][M][N][M][M][M][N][M][M][M]...
  ^ movable memory due to early kernel memory
			   ^ allows for more movable memory ...
			      ^-----^ ... here
				       ^ allows for more movable memory ...
				          ^-----^ ... here

While the created layout is sub-optimal when it comes to contiguous zones,
it gives us the maximum flexibility when dynamically growing/shrinking a
device; we can grow small VMs really big in small steps, and still shrink
reliably to e.g., 1/4 of the maximum VM size in this example, removing
full memory blocks along with meta data more reliably.

Mark dynamic memory groups in the xarray such that we can efficiently
iterate over them when collecting stats.  In usual setups, we have one
virtio-mem device per NUMA node, and usually only a small number of NUMA
nodes.

Note: for now, there seems to be no compelling reason to make this
behavior configurable.

Link: https://lkml.kernel.org/r/20210723125210.29987-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Marek Kedzierski <mkedzier@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   25 ++++++++++++++++
 include/linux/memory.h |    3 +
 mm/memory_hotplug.c    |   60 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 4 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy
+++ a/drivers/base/memory.c
@@ -86,6 +86,7 @@ static DEFINE_XARRAY(memory_blocks);
  * Memory groups, indexed by memory group identification (mgid).
  */
 static DEFINE_XARRAY_FLAGS(memory_groups, XA_FLAGS_ALLOC);
+#define MEMORY_GROUP_MARK_DYNAMIC	XA_MARK_1
 
 static BLOCKING_NOTIFIER_HEAD(memory_chain);
 
@@ -931,6 +932,8 @@ static int register_memory_group(struct
 		       GFP_KERNEL);
 	if (ret)
 		kfree(new_group);
+	else if (group.is_dynamic)
+		xa_set_mark(&memory_groups, mgid, MEMORY_GROUP_MARK_DYNAMIC);
 	return ret ? ret : mgid;
 }
 
@@ -987,3 +990,25 @@ struct memory_group *get_memory_group(in
 {
 	return xa_load(&memory_groups, mgid);
 }
+
+int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
+			       struct memory_group *excluded, void *arg)
+{
+	struct memory_group *group;
+	unsigned long index;
+	int ret = 0;
+
+	xa_for_each_marked(&memory_groups, index, group,
+			   MEMORY_GROUP_MARK_DYNAMIC) {
+		if (group == excluded)
+			continue;
+#ifdef CONFIG_NUMA
+		if (nid != NUMA_NO_NODE && group->nid != nid)
+			continue;
+#endif /* CONFIG_NUMA */
+		ret = func(group, arg);
+		if (ret)
+			break;
+	}
+	return ret;
+}
--- a/include/linux/memory.h~mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy
+++ a/include/linux/memory.h
@@ -142,6 +142,9 @@ extern int register_static_memory_group(
 extern int register_dynamic_memory_group(int nid, unsigned long unit_pages);
 extern int unregister_memory_group(int mgid);
 struct memory_group *get_memory_group(int mgid);
+typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
+int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
+			       struct memory_group *excluded, void *arg);
 
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy
+++ a/mm/memory_hotplug.c
@@ -752,11 +752,44 @@ static void auto_movable_stats_account_z
 #endif /* CONFIG_CMA */
 	}
 }
+struct auto_movable_group_stats {
+	unsigned long movable_pages;
+	unsigned long req_kernel_early_pages;
+};
 
-static bool auto_movable_can_online_movable(int nid, unsigned long nr_pages)
+static int auto_movable_stats_account_group(struct memory_group *group,
+					   void *arg)
+{
+	const int ratio = READ_ONCE(auto_movable_ratio);
+	struct auto_movable_group_stats *stats = arg;
+	long pages;
+
+	/*
+	 * We don't support modifying the config while the auto-movable online
+	 * mode is already enabled. Just avoid the division by zero below.
+	 */
+	if (!ratio)
+		return 0;
+
+	/*
+	 * Calculate how many early kernel pages this group requires to
+	 * satisfy the configured zone ratio.
+	 */
+	pages = group->present_movable_pages * 100 / ratio;
+	pages -= group->present_kernel_pages;
+
+	if (pages > 0)
+		stats->req_kernel_early_pages += pages;
+	stats->movable_pages += group->present_movable_pages;
+	return 0;
+}
+
+static bool auto_movable_can_online_movable(int nid, struct memory_group *group,
+					    unsigned long nr_pages)
 {
-	struct auto_movable_stats stats = {};
 	unsigned long kernel_early_pages, movable_pages;
+	struct auto_movable_group_stats group_stats = {};
+	struct auto_movable_stats stats = {};
 	pg_data_t *pgdat = NODE_DATA(nid);
 	struct zone *zone;
 	int i;
@@ -778,6 +811,21 @@ static bool auto_movable_can_online_mova
 	movable_pages = stats.movable_pages;
 
 	/*
+	 * Kernel memory inside dynamic memory group allows for more MOVABLE
+	 * memory within the same group. Remove the effect of all but the
+	 * current group from the stats.
+	 */
+	walk_dynamic_memory_groups(nid, auto_movable_stats_account_group,
+				   group, &group_stats);
+	if (kernel_early_pages <= group_stats.req_kernel_early_pages)
+		return false;
+	kernel_early_pages -= group_stats.req_kernel_early_pages;
+	movable_pages -= group_stats.movable_pages;
+
+	if (group && group->is_dynamic)
+		kernel_early_pages += group->present_kernel_pages;
+
+	/*
 	 * Test if we could online the given number of pages to ZONE_MOVABLE
 	 * and still stay in the configured ratio.
 	 */
@@ -834,6 +882,10 @@ static struct zone *default_kernel_zone_
  *    with unmovable allocations). While there are corner cases where it might
  *    still work, it is barely relevant in practice.
  *
+ * Exceptions are dynamic memory groups, which allow for more MOVABLE
+ * memory within the same memory group -- because in that case, there is
+ * coordination within the single memory device managed by a single driver.
+ *
  * We rely on "present pages" instead of "managed pages", as the latter is
  * highly unreliable and dynamic in virtualized environments, and does not
  * consider boot time allocations. For example, memory ballooning adjusts the
@@ -899,12 +951,12 @@ static struct zone *auto_movable_zone_fo
 	 * nobody interferes, all will be MOVABLE if possible.
 	 */
 	nr_pages = max_pages - online_pages;
-	if (!auto_movable_can_online_movable(NUMA_NO_NODE, nr_pages))
+	if (!auto_movable_can_online_movable(NUMA_NO_NODE, group, nr_pages))
 		goto kernel_zone;
 
 #ifdef CONFIG_NUMA
 	if (auto_movable_numa_aware &&
-	    !auto_movable_can_online_movable(nid, nr_pages))
+	    !auto_movable_can_online_movable(nid, group, nr_pages))
 		goto kernel_zone;
 #endif /* CONFIG_NUMA */
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch

