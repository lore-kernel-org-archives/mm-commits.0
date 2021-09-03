Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E65C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDCDB61107
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350079AbhICVA3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349960AbhICVA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE09B610FD;
        Fri,  3 Sep 2021 20:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702769;
        bh=Ojbr8ZhbYusEz3UASHzgqx7lI681bqUglggdVIQUy28=;
        h=Date:From:To:Subject:From;
        b=lVk6YIwUNeDzQ44nn0XogkmCfbdhM6NZ0grHrOdlgQRwpdmOIvyboB0UVcbjeqvSZ
         gHQUR5sfwq5zIXj4ahCoPR7kTI8pOfzEkLADNvXrFZ66i/seMOtu8QIeEA0Pjl1nFi
         BVR0/mJ1v+3OeC+q2ayAPgTHEV5jQpr6/LHgn1lY=
Date:   Fri, 03 Sep 2021 13:59:28 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, linux@roeck-us.net, mm-commits@vger.kernel.org,
        monstr@monstr.eu, rppt@linux.ibm.com
Subject:  [merged]
 mm-page_alloc-always-initialize-memory-map-for-the-holes.patch removed from
 -mm tree
Message-ID: <20210903205928.7otHdRBRK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: always initialize memory map for the holes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-always-initialize-memory-map-for-the-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/page_alloc: always initialize memory map for the holes

Patch series "mm: ensure consistency of memory map poisoning".

Currently memory map allocation for FLATMEM case does not poison the
struct pages regardless of CONFIG_PAGE_POISON setting.

This happens because allocation of the memory map for FLATMEM and SPARSMEM
use different memblock functions and those that are used for SPARSMEM case
(namely memblock_alloc_try_nid_raw() and memblock_alloc_exact_nid_raw())
implicitly poison the allocated memory.

Another side effect of this implicit poisoning is that early setup code
that uses the same functions to allocate memory burns cycles for the
memory poisoning even if it was not intended.

These patches introduce memmap_alloc() wrapper that ensure that the memory
map allocation is consistent for different memory models.


This patch (of 4):

Currently memory map for the holes is initialized only when SPARSEMEM
memory model is used.  Yet, even with FLATMEM there could be holes in the
physical memory layout that have memory map entries.

For instance, the memory reserved using e820 API on i386 or
"reserved-memory" nodes in device tree would not appear in memblock.memory
and hence the struct pages for such holes will be skipped during memory
map initialization.

These struct pages will be zeroed because the memory map for FLATMEM
systems is allocated with memblock_alloc_node() that clears the allocated
memory.  While zeroed struct pages do not cause immediate problems, the
correct behaviour is to initialize every page using __init_single_page(). 
Besides, enabling page poison for FLATMEM case will trigger
PF_POISONED_CHECK() unless the memory map is properly initialized.

Make sure init_unavailable_range() is called for both SPARSEMEM and
FLATMEM so that struct pages representing memory holes would appear as
PG_Reserved with any memory layout.

[rppt@kernel.org: fix microblaze]
  Link: https://lkml.kernel.org/r/YQWW3RCE4eWBuMu/@kernel.org
Link: https://lkml.kernel.org/r/20210714123739.16493-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210714123739.16493-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/page.h |    3 +--
 mm/page_alloc.c                    |    8 --------
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/arch/microblaze/include/asm/page.h~mm-page_alloc-always-initialize-memory-map-for-the-holes
+++ a/arch/microblaze/include/asm/page.h
@@ -112,8 +112,7 @@ extern int page_is_ram(unsigned long pfn
 #  define page_to_phys(page)     (page_to_pfn(page) << PAGE_SHIFT)
 
 #  define ARCH_PFN_OFFSET	(memory_start >> PAGE_SHIFT)
-#  define pfn_valid(pfn)	((pfn) < (max_mapnr + ARCH_PFN_OFFSET))
-
+#  define pfn_valid(pfn)	((pfn) >= ARCH_PFN_OFFSET && (pfn) < (max_mapnr + ARCH_PFN_OFFSET))
 # endif /* __ASSEMBLY__ */
 
 #define	virt_addr_valid(vaddr)	(pfn_valid(virt_to_pfn(vaddr)))
--- a/mm/page_alloc.c~mm-page_alloc-always-initialize-memory-map-for-the-holes
+++ a/mm/page_alloc.c
@@ -6642,7 +6642,6 @@ static void __meminit zone_init_free_lis
 	}
 }
 
-#if !defined(CONFIG_FLATMEM)
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
@@ -6687,13 +6686,6 @@ static void __init init_unavailable_rang
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges",
 			node, zone_names[zone], pgcnt);
 }
-#else
-static inline void init_unavailable_range(unsigned long spfn,
-					  unsigned long epfn,
-					  int zone, int node)
-{
-}
-#endif
 
 static void __init memmap_init_zone_range(struct zone *zone,
 					  unsigned long start_pfn,
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

