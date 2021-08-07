Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7DAC4338F
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC4B61050
	for <mm-commits@archiver.kernel.org>; Sat,  7 Aug 2021 19:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhHGTTy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Aug 2021 15:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhHGTTx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Aug 2021 15:19:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEA8F60E96;
        Sat,  7 Aug 2021 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628363976;
        bh=wjeqeY5OsrYKcdmil4YV1FpJ2AkNTNtvdkUDuReY8xI=;
        h=Date:From:To:Subject:From;
        b=dDukOsovU9zUN9Y6kHNO7G+SsYUdH2Tn1zDQGwvd9UBnh+OlJVwDyzCNpXBS8gZCN
         rl/kMN9mJNYv8ow/uEX3fnmOuM4fuXpeNKKUwU3xL/geS7/qPd+6Hi3Td1IGIrd2mi
         lcLynJjZnUayZoh4kAvkxdOPtLEJ44y0IykvmuEU=
Date:   Sat, 07 Aug 2021 12:19:35 -0700
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
 mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch added
 to -mm tree
Message-ID: <20210807191935.-Yqnz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: memory group aware "auto-movable" online policy
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch

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
Subject: mm/memory_hotplug: memory group aware "auto-movable" online policy

Use memory groups to improve our "auto-movable" onlining policy:

1. For static memory groups (e.g., a DIMM), online a memory block MOVABLE
   only if all other memory blocks in the group are either MOVABLE or could
   be onlined MOVABLE. A DIMM will either be MOVABLE or not, not a mixture.

2. For dynamic memory groups (e.g., a virtio-mem device), online a
   memory block MOVABLE only if all other memory blocks inside the
   current unit are either MOVABLE or could be onlined MOVABLE. For a
   virtio-mem device with a device block size with 512 MiB, all 128 MiB
   memory blocks wihin a 512 MiB unit will either be MOVABLE or not, not
   a mixture.

We have to pass the memory group to zone_for_pfn_range() to take the
memory group into account.

Note: for now, there seems to be no compelling reason to make this
behavior configurable.

Link: https://lkml.kernel.org/r/20210806124715.17090-9-david@redhat.com
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

 drivers/base/memory.c          |   18 ++++++-----
 include/linux/memory_hotplug.h |    3 +
 mm/memory_hotplug.c            |   48 +++++++++++++++++++++++++++++--
 3 files changed, 57 insertions(+), 12 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-memory-group-aware-auto-movable-online-policy
+++ a/drivers/base/memory.c
@@ -182,7 +182,8 @@ static int memory_block_online(struct me
 	struct zone *zone;
 	int ret;
 
-	zone = zone_for_pfn_range(mem->online_type, mem->nid, start_pfn, nr_pages);
+	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
+				  start_pfn, nr_pages);
 
 	/*
 	 * Although vmemmap pages have a different lifecycle than the pages
@@ -379,12 +380,13 @@ static ssize_t phys_device_show(struct d
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static int print_allowed_zone(char *buf, int len, int nid,
+			      struct memory_group *group,
 			      unsigned long start_pfn, unsigned long nr_pages,
 			      int online_type, struct zone *default_zone)
 {
 	struct zone *zone;
 
-	zone = zone_for_pfn_range(online_type, nid, start_pfn, nr_pages);
+	zone = zone_for_pfn_range(online_type, nid, group, start_pfn, nr_pages);
 	if (zone == default_zone)
 		return 0;
 
@@ -397,9 +399,10 @@ static ssize_t valid_zones_show(struct d
 	struct memory_block *mem = to_memory_block(dev);
 	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	struct memory_group *group = mem->group;
 	struct zone *default_zone;
+	int nid = mem->nid;
 	int len = 0;
-	int nid;
 
 	/*
 	 * Check the existing zone. Make sure that we do that only on the
@@ -418,14 +421,13 @@ static ssize_t valid_zones_show(struct d
 		goto out;
 	}
 
-	nid = mem->nid;
-	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, start_pfn,
-					  nr_pages);
+	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, group,
+					  start_pfn, nr_pages);
 
 	len += sysfs_emit_at(buf, len, "%s", default_zone->name);
-	len += print_allowed_zone(buf, len, nid, start_pfn, nr_pages,
+	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 				  MMOP_ONLINE_KERNEL, default_zone);
-	len += print_allowed_zone(buf, len, nid, start_pfn, nr_pages,
+	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 				  MMOP_ONLINE_MOVABLE, default_zone);
 out:
 	len += sysfs_emit_at(buf, len, "\n");
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-memory-group-aware-auto-movable-online-policy
+++ a/include/linux/memory_hotplug.h
@@ -349,7 +349,8 @@ extern void sparse_remove_section(struct
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
 extern struct zone *zone_for_pfn_range(int online_type, int nid,
-		unsigned long start_pfn, unsigned long nr_pages);
+		struct memory_group *group, unsigned long start_pfn,
+		unsigned long nr_pages);
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
--- a/mm/memory_hotplug.c~mm-memory_hotplug-memory-group-aware-auto-movable-online-policy
+++ a/mm/memory_hotplug.c
@@ -852,12 +852,53 @@ static struct zone *default_kernel_zone_
  *    "present pages" is an upper limit that can get reached at runtime. As
  *    we base our calculations on KERNEL_EARLY, this is not an issue.
  */
-static struct zone *auto_movable_zone_for_pfn(int nid, unsigned long pfn,
+static struct zone *auto_movable_zone_for_pfn(int nid,
+					      struct memory_group *group,
+					      unsigned long pfn,
 					      unsigned long nr_pages)
 {
+	unsigned long online_pages = 0, max_pages, end_pfn;
+	struct page *page;
+
 	if (!auto_movable_ratio)
 		goto kernel_zone;
 
+	if (group && !group->is_dynamic) {
+		max_pages = group->s.max_pages;
+		online_pages = group->present_movable_pages;
+
+		/* If anything is !MOVABLE online the rest !MOVABLE. */
+		if (group->present_kernel_pages)
+			goto kernel_zone;
+	} else if (!group || group->d.unit_pages == nr_pages) {
+		max_pages = nr_pages;
+	} else {
+		max_pages = group->d.unit_pages;
+		/*
+		 * Take a look at all online sections in the current unit.
+		 * We can safely assume that all pages within a section belong
+		 * to the same zone, because dynamic memory groups only deal
+		 * with hotplugged memory.
+		 */
+		pfn = ALIGN_DOWN(pfn, group->d.unit_pages);
+		end_pfn = pfn + group->d.unit_pages;
+		for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+			page = pfn_to_online_page(pfn);
+			if (!page)
+				continue;
+			/* If anything is !MOVABLE online the rest !MOVABLE. */
+			if (page_zonenum(page) != ZONE_MOVABLE)
+				goto kernel_zone;
+			online_pages += PAGES_PER_SECTION;
+		}
+	}
+
+	/*
+	 * Online MOVABLE if we could *currently* online all remaining parts
+	 * MOVABLE. We expect to (add+) online them immediately next, so if
+	 * nobody interferes, all will be MOVABLE if possible.
+	 */
+	nr_pages = max_pages - online_pages;
 	if (!auto_movable_can_online_movable(NUMA_NO_NODE, nr_pages))
 		goto kernel_zone;
 
@@ -897,7 +938,8 @@ static inline struct zone *default_zone_
 }
 
 struct zone *zone_for_pfn_range(int online_type, int nid,
-		unsigned long start_pfn, unsigned long nr_pages)
+		struct memory_group *group, unsigned long start_pfn,
+		unsigned long nr_pages)
 {
 	if (online_type == MMOP_ONLINE_KERNEL)
 		return default_kernel_zone_for_pfn(nid, start_pfn, nr_pages);
@@ -906,7 +948,7 @@ struct zone *zone_for_pfn_range(int onli
 		return &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
 
 	if (online_policy == ONLINE_POLICY_AUTO_MOVABLE)
-		return auto_movable_zone_for_pfn(nid, start_pfn, nr_pages);
+		return auto_movable_zone_for_pfn(nid, group, start_pfn, nr_pages);
 
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

