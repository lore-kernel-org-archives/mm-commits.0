Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6942AC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B8C64F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZBRc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhBZBRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E06E464F21;
        Fri, 26 Feb 2021 01:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302226;
        bh=3t4H1JUg57hrOGbEzh9QNX2VQg7B10Y9ojwQ+DEa0Ko=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gkcQEHUPgdHFXpPGwL1KEjULiqbEoGlHtCnqeyPeQwtyz1gNAGnwRyfuMn3zeRIHF
         Yx0KtZ4Le7TCG+UhFqlUkxaVGHleBpzVt/fdBa5KsM1zVZq6YEWFax9qMQtgYzONbc
         KXiDE1Zyid8jpN8pnfyg9EGUjgWQ5/gz7LRijU2M=
Date:   Thu, 25 Feb 2021 17:17:05 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, dan.j.williams@intel.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, torvalds@linux-foundation.org
Subject:  [patch 028/118] mm: teach pfn_to_online_page() about
 ZONE_DEVICE section collisions
Message-ID: <20210226011705.edw68Ijlc%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions

While pfn_to_online_page() is able to determine pfn_valid() at subsection
granularity it is not able to reliably determine if a given pfn is also
online if the section is mixes ZONE_{NORMAL,MOVABLE} with ZONE_DEVICE. 
This means that pfn_to_online_page() may return invalid @page objects. 
For example with a memory map like:

100000000-1fbffffff : System RAM
  142000000-143002e16 : Kernel code
  143200000-143713fff : Kernel rodata
  143800000-143b15b7f : Kernel data
  144227000-144ffffff : Kernel bss
1fc000000-2fbffffff : Persistent Memory (legacy)
  1fc000000-2fbffffff : namespace0.0

This command:

echo 0x1fc000000 > /sys/devices/system/memory/soft_offline_page

...succeeds when it should fail.  When it succeeds it touches an
uninitialized page and may crash or cause other damage (see
dissolve_free_huge_page()).

While the memory map above is contrived via the memmap=ss!nn kernel
command line option, the collision happens in practice on shipping
platforms.  The memory controller resources that decode spans of physical
address space are a limited resource.  One technique platform-firmware
uses to conserve those resources is to share a decoder across 2 devices to
keep the address range contiguous.  Unfortunately the unit of operation of
a decoder is 64MiB while the Linux section size is 128MiB.  This results
in situations where, without subsection hotplug memory mappings with
different lifetimes collide into one object that can only express one
lifetime.

Update move_pfn_range_to_zone() to flag (SECTION_TAINT_ZONE_DEVICE) a
section that mixes ZONE_DEVICE pfns with other online pfns.  With
SECTION_TAINT_ZONE_DEVICE to delineate, pfn_to_online_page() can fall back
to a slow-path check for ZONE_DEVICE pfns in an online section.  In the
fast path online_section() for a full ZONE_DEVICE section returns false.

Because the collision case is rare, and for simplicity, the
SECTION_TAINT_ZONE_DEVICE flag is never cleared once set.

[dan.j.williams@intel.com: fix CONFIG_ZONE_DEVICE=n build]
  Link: https://lkml.kernel.org/r/CAPcyv4iX+7LAgAeSqx7Zw-Zd=ZV9gBv8Bo7oTbwCOOqJoZ3+Yg@mail.gmail.com
Link: https://lkml.kernel.org/r/161058500675.1840162.7887862152161279354.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   34 +++++++++++++++++++++++++++-------
 mm/memory_hotplug.c    |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-teach-pfn_to_online_page-about-zone_device-section-collisions
+++ a/include/linux/mmzone.h
@@ -918,6 +918,18 @@ static inline int local_memory_node(int
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
+#ifdef CONFIG_ZONE_DEVICE
+static inline bool zone_is_zone_device(struct zone *zone)
+{
+	return zone_idx(zone) == ZONE_DEVICE;
+}
+#else
+static inline bool zone_is_zone_device(struct zone *zone)
+{
+	return false;
+}
+#endif
+
 /*
  * Returns true if a zone has pages managed by the buddy allocator.
  * All the reclaim decisions have to use this function rather than
@@ -1306,13 +1318,14 @@ extern size_t mem_section_usage_size(voi
  *      which results in PFN_SECTION_SHIFT equal 6.
  * To sum it up, at least 6 bits are available.
  */
-#define	SECTION_MARKED_PRESENT	(1UL<<0)
-#define SECTION_HAS_MEM_MAP	(1UL<<1)
-#define SECTION_IS_ONLINE	(1UL<<2)
-#define SECTION_IS_EARLY	(1UL<<3)
-#define SECTION_MAP_LAST_BIT	(1UL<<4)
-#define SECTION_MAP_MASK	(~(SECTION_MAP_LAST_BIT-1))
-#define SECTION_NID_SHIFT	3
+#define SECTION_MARKED_PRESENT		(1UL<<0)
+#define SECTION_HAS_MEM_MAP		(1UL<<1)
+#define SECTION_IS_ONLINE		(1UL<<2)
+#define SECTION_IS_EARLY		(1UL<<3)
+#define SECTION_TAINT_ZONE_DEVICE	(1UL<<4)
+#define SECTION_MAP_LAST_BIT		(1UL<<5)
+#define SECTION_MAP_MASK		(~(SECTION_MAP_LAST_BIT-1))
+#define SECTION_NID_SHIFT		3
 
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
@@ -1351,6 +1364,13 @@ static inline int online_section(struct
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
 }
 
+static inline int online_device_section(struct mem_section *section)
+{
+	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
+
+	return section && ((section->section_mem_map & flags) == flags);
+}
+
 static inline int online_section_nr(unsigned long nr)
 {
 	return online_section(__nr_to_section(nr));
--- a/mm/memory_hotplug.c~mm-teach-pfn_to_online_page-about-zone_device-section-collisions
+++ a/mm/memory_hotplug.c
@@ -308,6 +308,7 @@ static int check_hotplug_memory_addressa
 struct page *pfn_to_online_page(unsigned long pfn)
 {
 	unsigned long nr = pfn_to_section_nr(pfn);
+	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
 
 	if (nr >= NR_MEM_SECTIONS)
@@ -327,6 +328,22 @@ struct page *pfn_to_online_page(unsigned
 	if (!pfn_section_valid(ms, pfn))
 		return NULL;
 
+	if (!online_device_section(ms))
+		return pfn_to_page(pfn);
+
+	/*
+	 * Slowpath: when ZONE_DEVICE collides with
+	 * ZONE_{NORMAL,MOVABLE} within the same section some pfns in
+	 * the section may be 'offline' but 'valid'. Only
+	 * get_dev_pagemap() can determine sub-section online status.
+	 */
+	pgmap = get_dev_pagemap(pfn, NULL);
+	put_dev_pagemap(pgmap);
+
+	/* The presence of a pgmap indicates ZONE_DEVICE offline pfn */
+	if (pgmap)
+		return NULL;
+
 	return pfn_to_page(pfn);
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
@@ -709,6 +726,14 @@ static void __meminit resize_pgdat_range
 	pgdat->node_spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - pgdat->node_start_pfn;
 
 }
+
+static void section_taint_zone_device(unsigned long pfn)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+
+	ms->section_mem_map |= SECTION_TAINT_ZONE_DEVICE;
+}
+
 /*
  * Associate the pfn range with the given zone, initializing the memmaps
  * and resizing the pgdat/zone data to span the added pages. After this
@@ -739,6 +764,19 @@ void __ref move_pfn_range_to_zone(struct
 	pgdat_resize_unlock(pgdat, &flags);
 
 	/*
+	 * Subsection population requires care in pfn_to_online_page().
+	 * Set the taint to enable the slow path detection of
+	 * ZONE_DEVICE pages in an otherwise  ZONE_{NORMAL,MOVABLE}
+	 * section.
+	 */
+	if (zone_is_zone_device(zone)) {
+		if (!IS_ALIGNED(start_pfn, PAGES_PER_SECTION))
+			section_taint_zone_device(start_pfn);
+		if (!IS_ALIGNED(start_pfn + nr_pages, PAGES_PER_SECTION))
+			section_taint_zone_device(start_pfn + nr_pages);
+	}
+
+	/*
 	 * TODO now we have a visible range of pages which are not associated
 	 * with their zone properly. Not nice but set_pfnblock_flags_mask
 	 * expects the zone spans the pfn range. All the pages in the range
_
