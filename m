Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F96BC12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62449613CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbhGNWfa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhGNWfa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 18:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 025FA613C2;
        Wed, 14 Jul 2021 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626301957;
        bh=hR0oxYP+51OnEvfqSSwJ3g9zpLTRHrVEvDU+rc63n5g=;
        h=Date:From:To:Subject:From;
        b=NZrQ/TYYo3YU+ObcN9MfAzufx3hEx9Su8mJpa/Nj7Krg/lNcC6HnAPdIE57tb8VEr
         E9bBeCA4udleSyxc0wB0HnluAZm48z79GRyeMxCDgdCFb6HQtJkniNkxTYb2ACeGd0
         YgdAEV1Jt9uuJ0C7+BcBbW/hhjeDgcPkqdfTsO+w=
Date:   Wed, 14 Jul 2021 15:32:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, monstr@monstr.eu, rppt@linux.ibm.com
Subject:  +
 mm-page_alloc-always-initialize-memory-map-for-the-holes.patch added to -mm
 tree
Message-ID: <20210714223236.7XHBX89u2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: always initialize memory map for the holes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-always-initialize-memory-map-for-the-holes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-always-initialize-memory-map-for-the-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20210714123739.16493-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210714123739.16493-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 --------
 1 file changed, 8 deletions(-)

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

mm-page_alloc-always-initialize-memory-map-for-the-holes.patch
microblaze-simplify-pte_alloc_one_kernel.patch
mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch
memblock-stop-poisoning-raw-allocations.patch
mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

