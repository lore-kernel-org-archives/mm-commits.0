Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A60C6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCTWML (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCTWMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683D3EB5E
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D5C161857
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFE2C433D2;
        Mon, 20 Mar 2023 22:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350287;
        bh=215dYmgDZYAf8RGKHzq0NbV7vxM3nCUMqN9qtbdkmME=;
        h=Date:To:From:Subject:From;
        b=to+l5v8It3TMs3Lr3gnqaKmI8hGV2beTqpj/NvgJSz1c547ysb0zD2oimKiXZVnWP
         NYHc9eUzOMkjFUZtouxKf9NWdtLZAJTssOmbxr05hEwX690jNu9xjace7nD6cn8/iw
         heFn133rziLasIp0e97V5ArWqQSS5t+/QBghKz54=
Date:   Mon, 20 Mar 2023 15:11:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static.patch added to mm-unstable branch
Message-Id: <20230320221127.8CFE2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: move init_cma_reserved_pages() to cma.c and make it static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm/cma: move init_cma_reserved_pages() to cma.c and make it static
Date: Sun, 19 Mar 2023 23:59:55 +0200

init_cma_reserved_pages() only used in cma.c, no point of having it in
page_alloc.c.

Move init_cma_reserved_pages() to cma.c and make it static.

Link: https://lkml.kernel.org/r/20230319220008.2138576-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/gfp.h~mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static
+++ a/include/linux/gfp.h
@@ -361,9 +361,4 @@ extern struct page *alloc_contig_pages(u
 #endif
 void free_contig_range(unsigned long pfn, unsigned long nr_pages);
 
-#ifdef CONFIG_CMA
-/* CMA stuff */
-extern void init_cma_reserved_pageblock(struct page *page);
-#endif
-
 #endif /* __LINUX_GFP_H */
--- a/mm/cma.c~mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static
+++ a/mm/cma.c
@@ -31,8 +31,10 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
+#include <linux/page-isolation.h>
 #include <trace/events/cma.h>
 
+#include "internal.h"
 #include "cma.h"
 
 struct cma cma_areas[MAX_CMA_AREAS];
@@ -93,6 +95,25 @@ static void cma_clear_bitmap(struct cma
 	spin_unlock_irqrestore(&cma->lock, flags);
 }
 
+/* Free whole pageblock and set its migration type to MIGRATE_CMA. */
+static void init_cma_reserved_pageblock(struct page *page)
+{
+	unsigned i = pageblock_nr_pages;
+	struct page *p = page;
+
+	do {
+		__ClearPageReserved(p);
+		set_page_count(p, 0);
+	} while (++p, --i);
+
+	set_pageblock_migratetype(page, MIGRATE_CMA);
+	set_page_refcounted(page);
+	__free_pages(page, pageblock_order);
+
+	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long base_pfn = cma->base_pfn, pfn;
--- a/mm/page_alloc.c~mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static
+++ a/mm/page_alloc.c
@@ -2287,27 +2287,6 @@ void __init page_alloc_init_late(void)
 		set_zone_contiguous(zone);
 }
 
-#ifdef CONFIG_CMA
-/* Free whole pageblock and set its migration type to MIGRATE_CMA. */
-void __init init_cma_reserved_pageblock(struct page *page)
-{
-	unsigned i = pageblock_nr_pages;
-	struct page *p = page;
-
-	do {
-		__ClearPageReserved(p);
-		set_page_count(p, 0);
-	} while (++p, --i);
-
-	set_pageblock_migratetype(page, MIGRATE_CMA);
-	set_page_refcounted(page);
-	__free_pages(page, pageblock_order);
-
-	adjust_managed_page_count(page, pageblock_nr_pages);
-	page_zone(page)->cma_pages += pageblock_nr_pages;
-}
-#endif
-
 /*
  * The order of subdivision here is critical for the IO subsystem.
  * Please do not alter this order without good reasons and regression
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-move-get_page_from_free_area-to-mm-page_allocc.patch
mips-fix-comment-about-pgtable_init.patch
mm-cma-move-init_cma_reserved_pages-to-cmac-and-make-it-static.patch
mm-page_alloc-add-helper-for-checking-if-check_pages_enabled.patch
mm-move-most-of-core-mm-initialization-to-mm-mm_initc.patch
mm-handle-hashdist-initialization-in-mm-mm_initc.patch
mm-page_alloc-rename-page_alloc_init-to-page_alloc_init_cpuhp.patch
init-fold-build_all_zonelists-and-page_alloc_init_cpuhp-to-mm_init.patch
initmm-move-mm_init-to-mm-mm_initc-and-rename-it-to-mm_core_init.patch
mm-move-pgtable_init-to-mm-mm_initc-and-make-it-static.patch
mm-move-init_mem_debugging_and_hardening-to-mm-mm_initc.patch
initmm-fold-late-call-to-page_ext_init-to-page_alloc_init_late.patch
mm-move-mem_init_print_info-to-mm_initc.patch
mm-move-kmem_cache_init-declaration-to-mm-slabh.patch
mm-move-vmalloc_init-declaration-to-mm-internalh.patch
maintainers-extend-memblock-entry-to-include-mm-initialization.patch

