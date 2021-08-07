Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0713DC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA5461050
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhHGTTm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhHGTTj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:19:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCBDB61050;
        Sat,  7 Aug 2021 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363961;
        bh=NylbD9nMbNj0SQtgSAaEI4+D9oUFKMUcQwXMtC0LU1A=;
        h=Date:From:To:Subject:From;
        b=CVz6JU1gB5/tWG53uVJ3YKPIsBxPe2G+mcTPwdKGF2UJDGxcRMesrViu4CcoNq3ly
         W8DNM5xVNPQqB8deK0chBldBWHxsXM7bdxJmpMrBDmh+lhqmfRHAyJ4lO3l0KQ63hU
         /Z11IYpshtlltxZQEePwPRadUptDXtyjavyG5OqA=
Date:   Sat, 07 Aug 2021 12:19:20 -0700
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
Subject:  +
 mm-memory_hotplug-introduce-auto-movable-online-policy.patch added to -mm
 tree
Message-ID: <20210807191920.ImZmN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: introduce "auto-movable" online policy
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-introduce-auto-movable-online-policy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-introduce-auto-movable-online-policy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-introduce-auto-movable-online-policy.patch

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
Subject: mm/memory_hotplug: introduce "auto-movable" online policy

When onlining without specifying a zone (using "online" instead of
"online_kernel" or "online_movable"), we currently select a zone such that
existing zones are kept contiguous.  This online policy made sense in the
past, where contiguous zones where required.

We'd like to implement smarter policies, however:

* User space has little insight.  As one example, it has no idea which
  memory blocks logically belong together (e.g., to a DIMM or to a
  virtio-mem device).

* Drivers that add memory in separate memory blocks, especially
  virtio-mem, want memory to get onlined right from the kernel when
  adding.

So we really want to have onlining to differing zones managed in the
kernel, configured by user space.

We see more and more cases where we might eventually hotplug a lot of
memory in the future (e.g., eventually grow a 2 GiB VM to 64 GiB),
however:

* Resizing happens dynamically, in smaller steps in both directions
  (e.g., 2 GiB -> 8 GiB -> 4 GiB -> 16 GiB ...)

* We still want as much flexibility as possible, especially,
  hotunplugging as much memory as possible later.

We can really only use "online_movable" if we know that the amount of
memory we are going to hotplug upfront, and we know that it won't result
in a zone imbalance.  So in our example, a 2 GiB VM that could grow to 64
GiB could currently not use "online_movable", and instead, "online_kernel"
would have to be used, resulting in worse (no) memory hotunplug
reliability.

Let's add a new "auto-movable" online policy that considers the current
zone ratios (global, per-node) to determine, whether we a memory block can
be onlined to ZONE_MOVABLE:

	MOVABLE : KERNEL

However, internally we'll only consider the following ratio for now:

	MOVABLE : KERNEL_EARLY

For now, we don't allow for hotplugged KERNEL memory to allow for more
MOVABLE memory, because there is no coordination across memory devices. 
In follow-up patches, we will allow for more KERNEL memory within a memory
device to allow for more MOVABLE memory within the same memory device --
which only makes sense for special memory device types.

We base our calculation on "present pages", see the code comments for
details.  Hotplugged memory will get online to ZONE_MOVABLE if the
configured ratio allows for it.  Depending on the setup, this can result
in fragmented zones, which can make compaction slower and dynamic
allocation of gigantic pages when not using CMA less reliable (...  which
is already pretty unreliable).

The old policy will be the default and called "contig-zones".  In
follow-up patches, our new policy will use additional information, such as
memory groups, to make even smarter decisions across memory blocks.

Configuration:

* memory_hotplug.online_policy is used to switch between both polices
  and defaults to "contig-zones".

* memory_hotplug.auto_movable_ratio defines the maximum ratio is in
  percent and defaults to "301" -- allowing e.g., most 8 GiB machines to
  grow to 32 GiB and have all hotplugged memory in ZONE_MOVABLE.  The
  additional percent accounts for a handful of lost present pages (e.g.,
  firmware allocations).  User space is expected to adjust this ratio when
  enabling the new "auto-movable" policy, though.

* memory_hotplug.auto_movable_numa_aware considers numa node stats in
  addition to global stats, and defaults to "true".

Note: just like the old policy, the new policy won't take things like
unmovable huge pages or memory ballooning that doesn't support balloon
compaction into account.  User space has to configure onlining
accordingly.

Link: https://lkml.kernel.org/r/20210806124715.17090-3-david@redhat.com
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

 mm/memory_hotplug.c |  191 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 191 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-introduce-auto-movable-online-policy
+++ a/mm/memory_hotplug.c
@@ -52,6 +52,73 @@ module_param(memmap_on_memory, bool, 044
 MODULE_PARM_DESC(memmap_on_memory, "Enable memmap on memory for memory hotplug");
 #endif
 
+enum {
+	ONLINE_POLICY_CONTIG_ZONES = 0,
+	ONLINE_POLICY_AUTO_MOVABLE,
+};
+
+const char *online_policy_to_str[] = {
+	[ONLINE_POLICY_CONTIG_ZONES] = "contig-zones",
+	[ONLINE_POLICY_AUTO_MOVABLE] = "auto-movable",
+};
+
+static int set_online_policy(const char *val, const struct kernel_param *kp)
+{
+	int ret = sysfs_match_string(online_policy_to_str, val);
+
+	if (ret < 0)
+		return ret;
+	*((int *)kp->arg) = ret;
+	return 0;
+}
+
+static int get_online_policy(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%s\n", online_policy_to_str[*((int *)kp->arg)]);
+}
+
+/*
+ * memory_hotplug.online_policy: configure online behavior when onlining without
+ * specifying a zone (MMOP_ONLINE)
+ *
+ * "contig-zones": keep zone contiguous
+ * "auto-movable": online memory to ZONE_MOVABLE if the configuration
+ *                 (auto_movable_ratio, auto_movable_numa_aware) allows for it
+ */
+static int online_policy __read_mostly = ONLINE_POLICY_CONTIG_ZONES;
+static const struct kernel_param_ops online_policy_ops = {
+	.set = set_online_policy,
+	.get = get_online_policy,
+};
+module_param_cb(online_policy, &online_policy_ops, &online_policy, 0644);
+MODULE_PARM_DESC(online_policy,
+		"Set the online policy (\"contig-zones\", \"auto-movable\") "
+		"Default: \"contig-zones\"");
+
+/*
+ * memory_hotplug.auto_movable_ratio: specify maximum MOVABLE:KERNEL ratio
+ *
+ * The ratio represent an upper limit and the kernel might decide to not
+ * online some memory to ZONE_MOVABLE -- e.g., because hotplugged KERNEL memory
+ * doesn't allow for more MOVABLE memory.
+ */
+static unsigned int auto_movable_ratio __read_mostly = 301;
+module_param(auto_movable_ratio, uint, 0644);
+MODULE_PARM_DESC(auto_movable_ratio,
+		"Set the maximum ratio of MOVABLE:KERNEL memory in the system "
+		"in percent for \"auto-movable\" online policy. Default: 301");
+
+/*
+ * memory_hotplug.auto_movable_numa_aware: consider numa node stats
+ */
+#ifdef CONFIG_NUMA
+static bool auto_movable_numa_aware __read_mostly = true;
+module_param(auto_movable_numa_aware, bool, 0644);
+MODULE_PARM_DESC(auto_movable_numa_aware,
+		"Consider numa node stats in addition to global stats in "
+		"\"auto-movable\" online policy. Default: true");
+#endif /* CONFIG_NUMA */
+
 /*
  * online_page_callback contains pointer to current page onlining function.
  * Initially it is generic_online_page(). If it is required it could be
@@ -663,6 +730,61 @@ void __ref move_pfn_range_to_zone(struct
 	set_zone_contiguous(zone);
 }
 
+struct auto_movable_stats {
+	unsigned long kernel_early_pages;
+	unsigned long movable_pages;
+};
+
+static void auto_movable_stats_account_zone(struct auto_movable_stats *stats,
+					    struct zone *zone)
+{
+	if (zone_idx(zone) == ZONE_MOVABLE) {
+		stats->movable_pages += zone->present_pages;
+	} else {
+		stats->kernel_early_pages += zone->present_early_pages;
+#ifdef CONFIG_CMA
+		/*
+		 * CMA pages (never on hotplugged memory) behave like
+		 * ZONE_MOVABLE.
+		 */
+		stats->movable_pages += zone->cma_pages;
+		stats->kernel_early_pages -= zone->cma_pages;
+#endif /* CONFIG_CMA */
+	}
+}
+
+static bool auto_movable_can_online_movable(int nid, unsigned long nr_pages)
+{
+	struct auto_movable_stats stats = {};
+	unsigned long kernel_early_pages, movable_pages;
+	pg_data_t *pgdat = NODE_DATA(nid);
+	struct zone *zone;
+	int i;
+
+	/* Walk all relevant zones and collect MOVABLE vs. KERNEL stats. */
+	if (nid == NUMA_NO_NODE) {
+		/* TODO: cache values */
+		for_each_populated_zone(zone)
+			auto_movable_stats_account_zone(&stats, zone);
+	} else {
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			zone = pgdat->node_zones + i;
+			if (populated_zone(zone))
+				auto_movable_stats_account_zone(&stats, zone);
+		}
+	}
+
+	kernel_early_pages = stats.kernel_early_pages;
+	movable_pages = stats.movable_pages;
+
+	/*
+	 * Test if we could online the given number of pages to ZONE_MOVABLE
+	 * and still stay in the configured ratio.
+	 */
+	movable_pages += nr_pages;
+	return movable_pages <= (auto_movable_ratio * kernel_early_pages) / 100;
+}
+
 /*
  * Returns a default kernel memory zone for the given pfn range.
  * If no kernel zone covers this pfn range it will automatically go
@@ -684,6 +806,72 @@ static struct zone *default_kernel_zone_
 	return &pgdat->node_zones[ZONE_NORMAL];
 }
 
+/*
+ * Determine to which zone to online memory dynamically based on user
+ * configuration and system stats. We care about the following ratio:
+ *
+ *   MOVABLE : KERNEL
+ *
+ * Whereby MOVABLE is memory in ZONE_MOVABLE and KERNEL is memory in
+ * one of the kernel zones. CMA pages inside one of the kernel zones really
+ * behaves like ZONE_MOVABLE, so we treat them accordingly.
+ *
+ * We don't allow for hotplugged memory in a KERNEL zone to increase the
+ * amount of MOVABLE memory we can have, so we end up with:
+ *
+ *   MOVABLE : KERNEL_EARLY
+ *
+ * Whereby KERNEL_EARLY is memory in one of the kernel zones, available sinze
+ * boot. We base our calculation on KERNEL_EARLY internally, because:
+ *
+ * a) Hotplugged memory in one of the kernel zones can sometimes still get
+ *    hotunplugged, especially when hot(un)plugging individual memory blocks.
+ *    There is no coordination across memory devices, therefore "automatic"
+ *    hotunplugging, as implemented in hypervisors, could result in zone
+ *    imbalances.
+ * b) Early/boot memory in one of the kernel zones can usually not get
+ *    hotunplugged again (e.g., no firmware interface to unplug, fragmented
+ *    with unmovable allocations). While there are corner cases where it might
+ *    still work, it is barely relevant in practice.
+ *
+ * We rely on "present pages" instead of "managed pages", as the latter is
+ * highly unreliable and dynamic in virtualized environments, and does not
+ * consider boot time allocations. For example, memory ballooning adjusts the
+ * managed pages when inflating/deflating the balloon, and balloon compaction
+ * can even migrate inflated pages between zones.
+ *
+ * Using "present pages" is better but some things to keep in mind are:
+ *
+ * a) Some memblock allocations, such as for the crashkernel area, are
+ *    effectively unused by the kernel, yet they account to "present pages".
+ *    Fortunately, these allocations are comparatively small in relevant setups
+ *    (e.g., fraction of system memory).
+ * b) Some hotplugged memory blocks in virtualized environments, esecially
+ *    hotplugged by virtio-mem, look like they are completely present, however,
+ *    only parts of the memory block are actually currently usable.
+ *    "present pages" is an upper limit that can get reached at runtime. As
+ *    we base our calculations on KERNEL_EARLY, this is not an issue.
+ */
+static struct zone *auto_movable_zone_for_pfn(int nid, unsigned long pfn,
+					      unsigned long nr_pages)
+{
+	if (!auto_movable_ratio)
+		goto kernel_zone;
+
+	if (!auto_movable_can_online_movable(NUMA_NO_NODE, nr_pages))
+		goto kernel_zone;
+
+#ifdef CONFIG_NUMA
+	if (auto_movable_numa_aware &&
+	    !auto_movable_can_online_movable(nid, nr_pages))
+		goto kernel_zone;
+#endif /* CONFIG_NUMA */
+
+	return &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
+kernel_zone:
+	return default_kernel_zone_for_pfn(nid, pfn, nr_pages);
+}
+
 static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -717,6 +905,9 @@ struct zone *zone_for_pfn_range(int onli
 	if (online_type == MMOP_ONLINE_MOVABLE)
 		return &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
 
+	if (online_policy == ONLINE_POLICY_AUTO_MOVABLE)
+		return auto_movable_zone_for_pfn(nid, start_pfn, nr_pages);
+
 	return default_zone_for_pfn(nid, start_pfn, nr_pages);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
mm-track-present-early-pages-per-zone.patch
mm-memory_hotplug-introduce-auto-movable-online-policy.patch
drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks.patch
mm-memory_hotplug-track-present-pages-in-memory-groups.patch
acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch
dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch
virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch

