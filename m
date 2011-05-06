From: akpm@linux-foundation.org
Subject: + mm-use-alloc_bootmem_node_nopanic-on-really-needed-path.patch added to -mm tree
Date: Fri, 06 May 2011 15:39:21 -0700
Message-ID: <201105062239.p46MdLpC008751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab1EFWkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2011 18:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hpa@linux.intel.com, mingo@elte.hu, stefan@the2masters.de, tglx@linutronix.de


The patch titled
     mm: use alloc_bootmem_node_nopanic() on really needed path
has been added to the -mm tree.  Its filename is
     mm-use-alloc_bootmem_node_nopanic-on-really-needed-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use alloc_bootmem_node_nopanic() on really needed path
From: Yinghai Lu <yinghai@kernel.org>

Stefan found nobootmem does not work on his system that has only 8M of
RAM. It turns out that we should ignore the low limit of 16M.

Use alloc_bootmem_node_nopanic() in this case.

Signed-off-by: Yinghai LU <yinghai@kernel.org>
Reported-by: Stefan Hellermann <stefan@the2masters.de>
Tested-by: Stefan Hellermann <stefan@the2masters.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    2 ++
 mm/page_alloc.c         |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/bootmem.h~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path
+++ a/include/linux/bootmem.h
@@ -111,6 +111,8 @@ extern void *__alloc_bootmem_low_node(pg
 	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_node_nopanic(pgdat, x) \
+	__alloc_bootmem_node_nopanic(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
diff -puN mm/page_alloc.c~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-alloc_bootmem_node_nopanic-on-really-needed-path
+++ a/mm/page_alloc.c
@@ -3564,7 +3564,7 @@ int zone_wait_table_init(struct zone *zo
 
 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
-			alloc_bootmem_node(pgdat, alloc_size);
+			alloc_bootmem_node_nopanic(pgdat, alloc_size);
 	} else {
 		/*
 		 * This case means that a zone whose size was 0 gets new memory
@@ -4141,7 +4141,7 @@ static void __init setup_usemap(struct p
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
 	if (usemapsize)
-		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
+		zone->pageblock_flags = alloc_bootmem_node_nopanic(pgdat, usemapsize);
 }
 #else
 static inline void setup_usemap(struct pglist_data *pgdat,
@@ -4307,7 +4307,7 @@ static void __init_refok alloc_node_mem_
 		size =  (end - start) * sizeof(struct page);
 		map = alloc_remap(pgdat->node_id, size);
 		if (!map)
-			map = alloc_bootmem_node(pgdat, size);
+			map = alloc_bootmem_node_nopanic(pgdat, size);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
mm-use-alloc_bootmem_node_nopanic-on-really-needed-path.patch
memblock-add-error-return-when-config_have_memblock-is-not-set.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

