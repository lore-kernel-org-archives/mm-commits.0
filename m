Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CD0EB64D7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jun 2023 16:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjFTQui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jun 2023 12:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjFTQuh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2023 12:50:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F62312C
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 09:50:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7DFF60F66
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 16:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5C3C433C0;
        Tue, 20 Jun 2023 16:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687279835;
        bh=071hJzhIzkG7b71R8gDkGrra2255YVkcUjbVKz+uXCw=;
        h=Date:To:From:Subject:From;
        b=IsyzNgvoZEkSClzJofFyO6RzxI+5d+7Xy99F67agqTKBgO5ITcUE5Oknw+2pHR8ej
         Ay96icINFfwkGAWW7VPg6311ueP+BXqxJ3uIx8otoQwAk/wbdJY895vrUZDVe/43rb
         xbyRpy6c/BGt6aFdSjezDumz/jfh1uWGSCurgL+A=
Date:   Tue, 20 Jun 2023 09:50:34 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, yajun.deng@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-nid-to-reserve_bootmem_region.patch added to mm-unstable branch
Message-Id: <20230620165034.EE5C3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pass nid to reserve_bootmem_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-nid-to-reserve_bootmem_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-nid-to-reserve_bootmem_region.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: pass nid to reserve_bootmem_region()
Date: Mon, 19 Jun 2023 10:34:06 +0800

early_pfn_to_nid() is called frequently in init_reserved_page(), it
returns the node id of the PFN.  These PFN are probably from the same
memory region, they have the same node id.  It's not necessary to call
early_pfn_to_nid() for each PFN.

Pass nid to reserve_bootmem_region() and drop the call to
early_pfn_to_nid() in init_reserved_page().  Also, set nid on all reserved
pages before doing this, as some reserved memory regions may not be set
nid.

The most beneficial function is memmap_init_reserved_pages() if
CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.

The following data was tested on an x86 machine with 190GB of RAM.

before:
memmap_init_reserved_pages()  67ms

after:
memmap_init_reserved_pages()  20ms

Link: https://lkml.kernel.org/r/20230619023406.424298-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 mm/memblock.c      |   31 +++++++++++++++++++++----------
 mm/mm_init.c       |   30 +++++++++++++++++-------------
 3 files changed, 40 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-pass-nid-to-reserve_bootmem_region
+++ a/include/linux/mm.h
@@ -2940,7 +2940,8 @@ extern unsigned long free_reserved_area(
 
 extern void adjust_managed_page_count(struct page *page, long count);
 
-extern void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
+extern void reserve_bootmem_region(phys_addr_t start,
+				   phys_addr_t end, int nid);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
 static inline void free_reserved_page(struct page *page)
--- a/mm/memblock.c~mm-pass-nid-to-reserve_bootmem_region
+++ a/mm/memblock.c
@@ -2082,19 +2082,30 @@ static void __init memmap_init_reserved_
 {
 	struct memblock_region *region;
 	phys_addr_t start, end;
-	u64 i;
+	int nid;
+
+	/*
+	 * set nid on all reserved pages and also treat struct
+	 * pages for the NOMAP regions as PageReserved
+	 */
+	for_each_mem_region(region) {
+		nid = memblock_get_region_node(region);
+		start = region->base;
+		end = start + region->size;
+
+		if (memblock_is_nomap(region))
+			reserve_bootmem_region(start, end, nid);
+
+		memblock_set_node(start, end, &memblock.reserved, nid);
+	}
 
 	/* initialize struct pages for the reserved regions */
-	for_each_reserved_mem_range(i, &start, &end)
-		reserve_bootmem_region(start, end);
+	for_each_reserved_mem_region(region) {
+		nid = memblock_get_region_node(region);
+		start = region->base;
+		end = start + region->size;
 
-	/* and also treat struct pages for the NOMAP regions as PageReserved */
-	for_each_mem_region(region) {
-		if (memblock_is_nomap(region)) {
-			start = region->base;
-			end = start + region->size;
-			reserve_bootmem_region(start, end);
-		}
+		reserve_bootmem_region(start, end, nid);
 	}
 }
 
--- a/mm/mm_init.c~mm-pass-nid-to-reserve_bootmem_region
+++ a/mm/mm_init.c
@@ -646,10 +646,8 @@ static inline void pgdat_set_deferred_ra
 }
 
 /* Returns true if the struct page for the pfn is initialised */
-static inline bool __meminit early_page_initialised(unsigned long pfn)
+static inline bool __meminit early_page_initialised(unsigned long pfn, int nid)
 {
-	int nid = early_pfn_to_nid(pfn);
-
 	if (node_online(nid) && pfn >= NODE_DATA(nid)->first_deferred_pfn)
 		return false;
 
@@ -695,15 +693,14 @@ defer_init(int nid, unsigned long pfn, u
 	return false;
 }
 
-static void __meminit init_reserved_page(unsigned long pfn)
+static void __meminit init_reserved_page(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat;
-	int nid, zid;
+	int zid;
 
-	if (early_page_initialised(pfn))
+	if (early_page_initialised(pfn, nid))
 		return;
 
-	nid = early_pfn_to_nid(pfn);
 	pgdat = NODE_DATA(nid);
 
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
@@ -717,7 +714,7 @@ static void __meminit init_reserved_page
 #else
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
 
-static inline bool early_page_initialised(unsigned long pfn)
+static inline bool early_page_initialised(unsigned long pfn, int nid)
 {
 	return true;
 }
@@ -727,7 +724,7 @@ static inline bool defer_init(int nid, u
 	return false;
 }
 
-static inline void init_reserved_page(unsigned long pfn)
+static inline void init_reserved_page(unsigned long pfn, int nid)
 {
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
@@ -738,7 +735,8 @@ static inline void init_reserved_page(un
  * marks the pages PageReserved. The remaining valid pages are later
  * sent to the buddy page allocator.
  */
-void __meminit reserve_bootmem_region(phys_addr_t start, phys_addr_t end)
+void __meminit reserve_bootmem_region(phys_addr_t start,
+				      phys_addr_t end, int nid)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long end_pfn = PFN_UP(end);
@@ -747,7 +745,7 @@ void __meminit reserve_bootmem_region(ph
 		if (pfn_valid(start_pfn)) {
 			struct page *page = pfn_to_page(start_pfn);
 
-			init_reserved_page(start_pfn);
+			init_reserved_page(start_pfn, nid);
 
 			/* Avoid false-positive PageTail() */
 			INIT_LIST_HEAD(&page->lru);
@@ -2572,8 +2570,14 @@ void __init set_dma_reserve(unsigned lon
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
-	if (!early_page_initialised(pfn))
-		return;
+
+	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
+		int nid = early_pfn_to_nid(pfn);
+
+		if (!early_page_initialised(pfn, nid))
+			return;
+	}
+
 	if (!kmsan_memblock_free_pages(page, order)) {
 		/* KMSAN will take care of these pages. */
 		return;
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

dma-contiguous-support-per-numa-cma-for-all-architectures.patch
mm-pass-nid-to-reserve_bootmem_region.patch

