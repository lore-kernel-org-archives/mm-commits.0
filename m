Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36C2C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D12F261209
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346441AbhIIVDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347220AbhIIVDD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC50761213;
        Thu,  9 Sep 2021 21:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221313;
        bh=y6ByZ2xaLKhmoqrWP0cXAoso/vPzAt5539SJ4leK05E=;
        h=Date:From:To:Subject:From;
        b=qppimoIJlvrHG5ChG3qwYVKiUBTLJHXF21uVy+9tGGkLuy1cJlqRKF3mi4PyYoW3L
         xowYWQN3+kk6u4nIchYaigxUmYWFM4ZCC81RPYwx5BD7XaH1SobVPzco4YmlPdQOtM
         clCmFqYiXk2A6NtfBcl/30hhslGVW86RJVrlDMws=
Date:   Thu, 09 Sep 2021 14:01:52 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, jasowang@redhat.com, lenb@kernel.org,
        mhocko@kernel.org, mkedzier@redhat.com, mm-commits@vger.kernel.org,
        mst@redhat.com, osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        pasha.tatashin@soleen.com, rafael.j.wysocki@intel.com,
        richard.weiyang@linux.alibaba.com, rjw@rjwysocki.net,
        rppt@kernel.org, teawater@gmail.com, vbabka@suse.cz,
        vkuznets@redhat.com
Subject:  [merged]
 mm-memory_hotplug-track-present-pages-in-memory-groups.patch removed from
 -mm tree
Message-ID: <20210909210152.cdWai6ugY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: track present pages in memory groups
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-track-present-pages-in-memory-groups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: track present pages in memory groups

Let's track all present pages in each memory group.  Especially, track
memory present in ZONE_MOVABLE and memory present in one of the kernel
zones (which really only is ZONE_NORMAL right now as memory groups only
apply to hotplugged memory) separately within a memory group, to prepare
for making smart auto-online decision for individual memory blocks within
a memory group based on group statistics.

Link: https://lkml.kernel.org/r/20210806124715.17090-5-david@redhat.com
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

 drivers/base/memory.c          |   10 +++++-----
 include/linux/memory.h         |    6 ++++++
 include/linux/memory_hotplug.h |   13 +++++++++----
 mm/memory_hotplug.c            |   19 ++++++++++++++-----
 4 files changed, 34 insertions(+), 14 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-track-present-pages-in-memory-groups
+++ a/drivers/base/memory.c
@@ -198,7 +198,7 @@ static int memory_block_online(struct me
 	}
 
 	ret = online_pages(start_pfn + nr_vmemmap_pages,
-			   nr_pages - nr_vmemmap_pages, zone);
+			   nr_pages - nr_vmemmap_pages, zone, mem->group);
 	if (ret) {
 		if (nr_vmemmap_pages)
 			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
@@ -210,7 +210,7 @@ static int memory_block_online(struct me
 	 * now already properly populated.
 	 */
 	if (nr_vmemmap_pages)
-		adjust_present_page_count(pfn_to_page(start_pfn),
+		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  nr_vmemmap_pages);
 
 	return ret;
@@ -228,16 +228,16 @@ static int memory_block_offline(struct m
 	 * can properly be torn down in offline_pages().
 	 */
 	if (nr_vmemmap_pages)
-		adjust_present_page_count(pfn_to_page(start_pfn),
+		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  -nr_vmemmap_pages);
 
 	ret = offline_pages(start_pfn + nr_vmemmap_pages,
-			    nr_pages - nr_vmemmap_pages);
+			    nr_pages - nr_vmemmap_pages, mem->group);
 	if (ret) {
 		/* offline_pages() failed. Account back. */
 		if (nr_vmemmap_pages)
 			adjust_present_page_count(pfn_to_page(start_pfn),
-						  nr_vmemmap_pages);
+						  mem->group, nr_vmemmap_pages);
 		return ret;
 	}
 
--- a/include/linux/memory.h~mm-memory_hotplug-track-present-pages-in-memory-groups
+++ a/include/linux/memory.h
@@ -27,6 +27,10 @@
  * struct memory_group - a logical group of memory blocks
  * @nid: The node id for all memory blocks inside the memory group.
  * @blocks: List of all memory blocks belonging to this memory group.
+ * @present_kernel_pages: Present (online) memory outside ZONE_MOVABLE of this
+ *			  memory group.
+ * @present_movable_pages: Present (online) memory in ZONE_MOVABLE of this
+ *			   memory group.
  * @is_dynamic: The memory group type: static vs. dynamic
  * @s.max_pages: Valid with &memory_group.is_dynamic == false. The maximum
  *		 number of pages we'll have in this static memory group.
@@ -48,6 +52,8 @@
 struct memory_group {
 	int nid;
 	struct list_head memory_blocks;
+	unsigned long present_kernel_pages;
+	unsigned long present_movable_pages;
 	bool is_dynamic;
 	union {
 		struct {
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-track-present-pages-in-memory-groups
+++ a/include/linux/memory_hotplug.h
@@ -12,6 +12,7 @@ struct zone;
 struct pglist_data;
 struct mem_section;
 struct memory_block;
+struct memory_group;
 struct resource;
 struct vmem_altmap;
 
@@ -100,13 +101,15 @@ static inline void zone_seqlock_init(str
 extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
-extern void adjust_present_page_count(struct page *page, long nr_pages);
+extern void adjust_present_page_count(struct page *page,
+				      struct memory_group *group,
+				      long nr_pages);
 /* VM interface that may be used by firmware interface */
 extern int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
 				     struct zone *zone);
 extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
-			struct zone *zone);
+			struct zone *zone, struct memory_group *group);
 extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern void __offline_isolated_pages(unsigned long start_pfn,
@@ -296,7 +299,8 @@ static inline void pgdat_resize_init(str
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern void try_offline_node(int nid);
-extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
+extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+			 struct memory_group *group);
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
@@ -304,7 +308,8 @@ extern int offline_and_remove_memory(u64
 #else
 static inline void try_offline_node(int nid) {}
 
-static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+				struct memory_group *group)
 {
 	return -EINVAL;
 }
--- a/mm/memory_hotplug.c~mm-memory_hotplug-track-present-pages-in-memory-groups
+++ a/mm/memory_hotplug.c
@@ -915,9 +915,11 @@ struct zone *zone_for_pfn_range(int onli
  * This function should only be called by memory_block_{online,offline},
  * and {online,offline}_pages.
  */
-void adjust_present_page_count(struct page *page, long nr_pages)
+void adjust_present_page_count(struct page *page, struct memory_group *group,
+			       long nr_pages)
 {
 	struct zone *zone = page_zone(page);
+	const bool movable = zone_idx(zone) == ZONE_MOVABLE;
 
 	/*
 	 * We only support onlining/offlining/adding/removing of complete
@@ -927,6 +929,11 @@ void adjust_present_page_count(struct pa
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
+
+	if (group && movable)
+		group->present_movable_pages += nr_pages;
+	else if (group && !movable)
+		group->present_kernel_pages += nr_pages;
 }
 
 int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
@@ -972,7 +979,8 @@ void mhp_deinit_memmap_on_memory(unsigne
 	kasan_remove_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
 }
 
-int __ref online_pages(unsigned long pfn, unsigned long nr_pages, struct zone *zone)
+int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
+		       struct zone *zone, struct memory_group *group)
 {
 	unsigned long flags;
 	int need_zonelists_rebuild = 0;
@@ -1025,7 +1033,7 @@ int __ref online_pages(unsigned long pfn
 	}
 
 	online_pages_range(pfn, nr_pages);
-	adjust_present_page_count(pfn_to_page(pfn), nr_pages);
+	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	node_states_set_node(nid, &arg);
 	if (need_zonelists_rebuild)
@@ -1769,7 +1777,8 @@ static int count_system_ram_pages_cb(uns
 	return 0;
 }
 
-int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages)
+int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages,
+			struct memory_group *group)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn, system_ram_pages = 0;
@@ -1905,7 +1914,7 @@ int __ref offline_pages(unsigned long st
 
 	/* removal success */
 	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
-	adjust_present_page_count(pfn_to_page(start_pfn), -nr_pages);
+	adjust_present_page_count(pfn_to_page(start_pfn), group, -nr_pages);
 
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
_

Patches currently in -mm which might be from david@redhat.com are


