Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4644C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B229D6113C
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347371AbhIHC4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234389AbhIHC41 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9931561102;
        Wed,  8 Sep 2021 02:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069720;
        bh=Ojebz7jR+TJJ7hGv2zNgmAcuhd2Z7+0tu1v2EuupHiE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FSkh6mjoiuJ6ddOuphsU2FvaR6zC4zE6wuITYdDs1SSpeen8MrySxrhm4yE98mZNO
         3OWPj8634p2mlt1IFds6b1uyEuRvDfTopExvp4NOc5vby2QeSE2mdtSAxa1TzVlvJP
         ziUZ78Ym1INiETFDvdApOGjbOXAl5NvfsBwE+4a4=
Date:   Tue, 07 Sep 2021 19:55:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, jasowang@redhat.com,
        lenb@kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
        mkedzier@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pasha.tatashin@soleen.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, teawater@gmail.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, vkuznets@redhat.com
Subject:  [patch 042/147] mm: track present early pages per zone
Message-ID: <20210908025519.c3lju8kIj%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: track present early pages per zone

Patch series "mm/memory_hotplug: "auto-movable" online policy and memory groups", v3.

I. Goal

The goal of this series is improving in-kernel auto-online support.  It
tackles the fundamental problems that:

 1) We can create zone imbalances when onlining all memory blindly to
    ZONE_MOVABLE, in the worst case crashing the system. We have to know
    upfront how much memory we are going to hotplug such that we can
    safely enable auto-onlining of all hotplugged memory to ZONE_MOVABLE
    via "online_movable". This is far from practical and only applicable in
    limited setups -- like inside VMs under the RHV/oVirt hypervisor which
    will never hotplug more than 3 times the boot memory (and the
    limitation is only in place due to the Linux limitation).

 2) We see more setups that implement dynamic VM resizing, hot(un)plugging
    memory to resize VM memory. In these setups, we might hotplug a lot of
    memory, but it might happen in various small steps in both directions
    (e.g., 2 GiB -> 8 GiB -> 4 GiB -> 16 GiB ...). virtio-mem is the
    primary driver of this upstream right now, performing such dynamic
    resizing NUMA-aware via multiple virtio-mem devices.

    Onlining all hotplugged memory to ZONE_NORMAL means we basically have
    no hotunplug guarantees. Onlining all to ZONE_MOVABLE means we can
    easily run into zone imbalances when growing a VM. We want a mixture,
    and we want as much memory as reasonable/configured in ZONE_MOVABLE.
    Details regarding zone imbalances can be found at [1].

 3) Memory devices consist of 1..X memory block devices, however, the
    kernel doesn't really track the relationship. Consequently, also user
    space has no idea. We want to make per-device decisions.

    As one example, for memory hotunplug it doesn't make sense to use a
    mixture of zones within a single DIMM: we want all MOVABLE if
    possible, otherwise all !MOVABLE, because any !MOVABLE part will easily
    block the whole DIMM from getting hotunplugged.

    As another example, virtio-mem operates on individual units that span
    1..X memory blocks. Similar to a DIMM, we want a unit to either be all
    MOVABLE or !MOVABLE. A "unit" can be thought of like a DIMM, however,
    all units of a virtio-mem device logically belong together and are
    managed (added/removed) by a single driver. We want as much memory of
    a virtio-mem device to be MOVABLE as possible.

 4) We want memory onlining to be done right from the kernel while adding
    memory, not triggered by user space via udev rules; for example, this
    is reqired for fast memory hotplug for drivers that add individual
    memory blocks, like virito-mem. We want a way to configure a policy in
    the kernel and avoid implementing advanced policies in user space.

The auto-onlining support we have in the kernel is not sufficient.  All we
have is a) online everything MOVABLE (online_movable) b) online everything
!MOVABLE (online_kernel) c) keep zones contiguous (online).  This series
allows configuring c) to mean instead "online movable if possible
according to the coniguration, driven by a maximum MOVABLE:KERNEL ratio"
-- a new onlining policy.


II. Approach

This series does 3 things:

 1) Introduces the "auto-movable" online policy that initially operates on
    individual memory blocks only. It uses a maximum MOVABLE:KERNEL ratio
    to make a decision whether a memory block will be onlined to
    ZONE_MOVABLE or not. However, in the basic form, hotplugged KERNEL
    memory does not allow for more MOVABLE memory (details in the
    patches). CMA memory is treated like MOVABLE memory.

 2) Introduces static (e.g., DIMM) and dynamic (e.g., virtio-mem) memory
    groups and uses group information to make decisions in the
    "auto-movable" online policy across memory blocks of a single memory
    device (modeled as memory group). More details can be found in patch
    #3 or in the DIMM example below.

 3) Maximizes ZONE_MOVABLE memory within dynamic memory groups, by
    allowing ZONE_NORMAL memory within a dynamic memory group to allow for
    more ZONE_MOVABLE memory within the same memory group. The target use
    case is dynamic VM resizing using virtio-mem. See the virtio-mem
    example below.

I remember that the basic idea of using a ratio to implement a policy in
the kernel was once mentioned by Vitaly Kuznetsov, but I might be wrong (I
lost the pointer to that discussion).

For me, the main use case is using it along with virtio-mem (and DIMMs /
ppc64 dlpar where necessary) for dynamic resizing of VMs, increasing the
amount of memory we can hotunplug reliably again if we might eventually
hotplug a lot of memory to a VM.


III. Target Usage

The target usage will be:

 1) Linux boots with "mhp_default_online_type=offline"

 2) User space (e.g., systemd unit) configures memory onlining (according
    to a config file and system properties), for example:
    * Setting memory_hotplug.online_policy=auto-movable
    * Setting memory_hotplug.auto_movable_ratio=301
    * Setting memory_hotplug.auto_movable_numa_aware=true

 3) User space enabled auto onlining via "echo online >
    /sys/devices/system/memory/auto_online_blocks"

 4) User space triggers manual onlining of all already-offline memory
    blocks (go over offline memory blocks and set them to "online")


IV. Example

For DIMMs, hotplugging 4 GiB DIMMs to a 4 GiB VM with a configured ratio of
301% results in the following layout:
	Memory block 0-15:    DMA32   (early)
	Memory block 32-47:   Normal  (early)
	Memory block 48-79:   Movable (DIMM 0)
	Memory block 80-111:  Movable (DIMM 1)
	Memory block 112-143: Movable (DIMM 2)
	Memory block 144-275: Normal  (DIMM 3)
	Memory block 176-207: Normal  (DIMM 4)
	... all Normal
	(-> hotplugged Normal memory does not allow for more Movable memory)

For virtio-mem, using a simple, single virtio-mem device with a 4 GiB VM
will result in the following layout:
	Memory block 0-15:    DMA32   (early)
	Memory block 32-47:   Normal  (early)
	Memory block 48-143:  Movable (virtio-mem, first 12 GiB)
	Memory block 144:     Normal  (virtio-mem, next 128 MiB)
	Memory block 145-147: Movable (virtio-mem, next 384 MiB)
	Memory block 148:     Normal  (virtio-mem, next 128 MiB)
	Memory block 149-151: Movable (virtio-mem, next 384 MiB)
	... Normal/Movable mixture as above
	(-> hotplugged Normal memory allows for more Movable memory within
	    the same device)

Which gives us maximum flexibility when dynamically growing/shrinking a
VM in smaller steps.


V. Doc Update

I'll update the memory-hotplug.rst documentation, once the overhaul [1] is
usptream. Until then, details can be found in patch #2.


VI. Future Work

 1) Use memory groups for ppc64 dlpar
 2) Being able to specify a portion of (early) kernel memory that will be
    excluded from the ratio. Like "128 MiB globally/per node" are excluded.

    This might be helpful when starting VMs with extremely small memory
    footprint (e.g., 128 MiB) and hotplugging memory later -- not wanting
    the first hotplugged units getting onlined to ZONE_MOVABLE. One
    alternative would be a trigger to not consider ZONE_DMA memory
    in the ratio. We'll have to see if this is really rrequired.
 3) Indicate to user space that MOVABLE might be a bad idea -- especially
    relevant when memory ballooning without support for balloon compaction
    is active.


This patch (of 9):

For implementing a new memory onlining policy, which determines when to
online memory blocks to ZONE_MOVABLE semi-automatically, we need the
number of present early (boot) pages -- present pages excluding hotplugged
pages.  Let's track these pages per zone.

Pass a page instead of the zone to adjust_present_page_count(), similar as
adjust_managed_page_count() and derive the zone from the page.

It's worth noting that a memory block to be offlined/onlined is either
completely "early" or "not early".  add_memory() and friends can only add
complete memory blocks and we only online/offline complete (individual)
memory blocks.

Link: https://lkml.kernel.org/r/20210806124715.17090-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210806124715.17090-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Marek Kedzierski <mkedzier@redhat.com>
Cc: Hui Zhu <teawater@gmail.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   14 +++++++-------
 include/linux/memory_hotplug.h |    2 +-
 include/linux/mmzone.h         |    7 +++++++
 mm/memory_hotplug.c            |   14 +++++++++++---
 mm/page_alloc.c                |    3 +++
 5 files changed, 29 insertions(+), 11 deletions(-)

--- a/drivers/base/memory.c~mm-track-present-early-pages-per-zone
+++ a/drivers/base/memory.c
@@ -205,7 +205,8 @@ static int memory_block_online(struct me
 	 * now already properly populated.
 	 */
 	if (nr_vmemmap_pages)
-		adjust_present_page_count(zone, nr_vmemmap_pages);
+		adjust_present_page_count(pfn_to_page(start_pfn),
+					  nr_vmemmap_pages);
 
 	return ret;
 }
@@ -215,24 +216,23 @@ static int memory_block_offline(struct m
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
 	unsigned long nr_vmemmap_pages = mem->nr_vmemmap_pages;
-	struct zone *zone;
 	int ret;
 
 	/*
 	 * Unaccount before offlining, such that unpopulated zone and kthreads
 	 * can properly be torn down in offline_pages().
 	 */
-	if (nr_vmemmap_pages) {
-		zone = page_zone(pfn_to_page(start_pfn));
-		adjust_present_page_count(zone, -nr_vmemmap_pages);
-	}
+	if (nr_vmemmap_pages)
+		adjust_present_page_count(pfn_to_page(start_pfn),
+					  -nr_vmemmap_pages);
 
 	ret = offline_pages(start_pfn + nr_vmemmap_pages,
 			    nr_pages - nr_vmemmap_pages);
 	if (ret) {
 		/* offline_pages() failed. Account back. */
 		if (nr_vmemmap_pages)
-			adjust_present_page_count(zone, nr_vmemmap_pages);
+			adjust_present_page_count(pfn_to_page(start_pfn),
+						  nr_vmemmap_pages);
 		return ret;
 	}
 
--- a/include/linux/memory_hotplug.h~mm-track-present-early-pages-per-zone
+++ a/include/linux/memory_hotplug.h
@@ -95,7 +95,7 @@ static inline void zone_seqlock_init(str
 extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
-extern void adjust_present_page_count(struct zone *zone, long nr_pages);
+extern void adjust_present_page_count(struct page *page, long nr_pages);
 /* VM interface that may be used by firmware interface */
 extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 				     struct zone *zone);
--- a/include/linux/mmzone.h~mm-track-present-early-pages-per-zone
+++ a/include/linux/mmzone.h
@@ -540,6 +540,10 @@ struct zone {
 	 * is calculated as:
 	 *	present_pages = spanned_pages - absent_pages(pages in holes);
 	 *
+	 * present_early_pages is present pages existing within the zone
+	 * located on memory available since early boot, excluding hotplugged
+	 * memory.
+	 *
 	 * managed_pages is present pages managed by the buddy system, which
 	 * is calculated as (reserved_pages includes pages allocated by the
 	 * bootmem allocator):
@@ -572,6 +576,9 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+#if defined(CONFIG_MEMORY_HOTPLUG)
+	unsigned long		present_early_pages;
+#endif
 #ifdef CONFIG_CMA
 	unsigned long		cma_pages;
 #endif
--- a/mm/memory_hotplug.c~mm-track-present-early-pages-per-zone
+++ a/mm/memory_hotplug.c
@@ -724,8 +724,16 @@ struct zone *zone_for_pfn_range(int onli
  * This function should only be called by memory_block_{online,offline},
  * and {online,offline}_pages.
  */
-void adjust_present_page_count(struct zone *zone, long nr_pages)
+void adjust_present_page_count(struct page *page, long nr_pages)
 {
+	struct zone *zone = page_zone(page);
+
+	/*
+	 * We only support onlining/offlining/adding/removing of complete
+	 * memory blocks; therefore, either all is either early or hotplugged.
+	 */
+	if (early_section(__pfn_to_section(page_to_pfn(page))))
+		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 }
@@ -826,7 +834,7 @@ int __ref online_pages(unsigned long pfn
 	}
 
 	online_pages_range(pfn, nr_pages);
-	adjust_present_page_count(zone, nr_pages);
+	adjust_present_page_count(pfn_to_page(pfn), nr_pages);
 
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
@@ -1697,7 +1705,7 @@ int __ref offline_pages(unsigned long st
 
 	/* removal success */
 	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
-	adjust_present_page_count(zone, -nr_pages);
+	adjust_present_page_count(pfn_to_page(start_pfn), -nr_pages);
 
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
--- a/mm/page_alloc.c~mm-track-present-early-pages-per-zone
+++ a/mm/page_alloc.c
@@ -7254,6 +7254,9 @@ static void __init calculate_node_totalp
 			zone->zone_start_pfn = 0;
 		zone->spanned_pages = size;
 		zone->present_pages = real_size;
+#if defined(CONFIG_MEMORY_HOTPLUG)
+		zone->present_early_pages = real_size;
+#endif
 
 		totalpages += size;
 		realtotalpages += real_size;
_
