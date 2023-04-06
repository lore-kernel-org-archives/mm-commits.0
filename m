Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB38C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbjDFCrk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbjDFCpv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFDA9775
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9933C642AB
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35ECC43446;
        Thu,  6 Apr 2023 02:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749121;
        bh=V5ICgpCb1UL+ZzQ4tuhKOEoFfZD02yclM+CaKggtE+0=;
        h=Date:To:From:Subject:From;
        b=niRpdZobJRRO44wRgHe4BtqzqDm0uHdB3XSW2+AD/JKN9++O5ZuSHgjRZ1n/QZsFp
         qKtmdTRwqpM46dAmeNZPeLzKoNZFRKvj13OJGjznbdkz0qflgbTI9XVSbxOgRh2GRy
         8f94kJ/ltk0qgEiGXBYiLz3USU+cdCnElyYYxPcY=
Date:   Wed, 05 Apr 2023 19:45:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, opendmb@gmail.com, mhocko@kernel.org,
        mgorman@suse.de, david@redhat.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-mem_init_print_info-to-mm_initc.patch removed from -mm tree
Message-Id: <20230406024520.F35ECC43446@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move mem_init_print_info() to mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-move-mem_init_print_info-to-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move mem_init_print_info() to mm_init.c
Date: Tue, 21 Mar 2023 19:05:10 +0200

mem_init_print_info() is only called from mm_core_init().

Move it close to the caller and make it static.

Link: https://lkml.kernel.org/r/20230321170513.2401534-12-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/internal.h      |    1 
 mm/mm_init.c       |   53 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c    |   53 -------------------------------------------
 4 files changed, 54 insertions(+), 54 deletions(-)

--- a/include/linux/mm.h~mm-move-mem_init_print_info-to-mm_initc
+++ a/include/linux/mm.h
@@ -2780,7 +2780,6 @@ extern unsigned long free_reserved_area(
 					int poison, const char *s);
 
 extern void adjust_managed_page_count(struct page *page, long count);
-extern void mem_init_print_info(void);
 
 extern void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
 
--- a/mm/internal.h~mm-move-mem_init_print_info-to-mm_initc
+++ a/mm/internal.h
@@ -201,6 +201,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm,
 /*
  * in mm/page_alloc.c
  */
+#define K(x) ((x) << (PAGE_SHIFT-10))
 
 extern char * const zone_names[MAX_NR_ZONES];
 
--- a/mm/mm_init.c~mm-move-mem_init_print_info-to-mm_initc
+++ a/mm/mm_init.c
@@ -24,6 +24,8 @@
 #include <linux/page_ext.h>
 #include <linux/pti.h>
 #include <linux/pgtable.h>
+#include <linux/swap.h>
+#include <linux/cma.h>
 #include "internal.h"
 #include "shuffle.h"
 
@@ -2649,6 +2651,57 @@ static void __init report_meminit(void)
 		pr_info("mem auto-init: clearing system memory may take some time...\n");
 }
 
+static void __init mem_init_print_info(void)
+{
+	unsigned long physpages, codesize, datasize, rosize, bss_size;
+	unsigned long init_code_size, init_data_size;
+
+	physpages = get_num_physpages();
+	codesize = _etext - _stext;
+	datasize = _edata - _sdata;
+	rosize = __end_rodata - __start_rodata;
+	bss_size = __bss_stop - __bss_start;
+	init_data_size = __init_end - __init_begin;
+	init_code_size = _einittext - _sinittext;
+
+	/*
+	 * Detect special cases and adjust section sizes accordingly:
+	 * 1) .init.* may be embedded into .data sections
+	 * 2) .init.text.* may be out of [__init_begin, __init_end],
+	 *    please refer to arch/tile/kernel/vmlinux.lds.S.
+	 * 3) .rodata.* may be embedded into .text or .data sections.
+	 */
+#define adj_init_size(start, end, size, pos, adj) \
+	do { \
+		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
+			size -= adj; \
+	} while (0)
+
+	adj_init_size(__init_begin, __init_end, init_data_size,
+		     _sinittext, init_code_size);
+	adj_init_size(_stext, _etext, codesize, _sinittext, init_code_size);
+	adj_init_size(_sdata, _edata, datasize, __init_begin, init_data_size);
+	adj_init_size(_stext, _etext, codesize, __start_rodata, rosize);
+	adj_init_size(_sdata, _edata, datasize, __start_rodata, rosize);
+
+#undef	adj_init_size
+
+	pr_info("Memory: %luK/%luK available (%luK kernel code, %luK rwdata, %luK rodata, %luK init, %luK bss, %luK reserved, %luK cma-reserved"
+#ifdef	CONFIG_HIGHMEM
+		", %luK highmem"
+#endif
+		")\n",
+		K(nr_free_pages()), K(physpages),
+		codesize / SZ_1K, datasize / SZ_1K, rosize / SZ_1K,
+		(init_data_size + init_code_size) / SZ_1K, bss_size / SZ_1K,
+		K(physpages - totalram_pages() - totalcma_pages),
+		K(totalcma_pages)
+#ifdef	CONFIG_HIGHMEM
+		, K(totalhigh_pages())
+#endif
+		);
+}
+
 /*
  * Set up kernel memory allocators
  */
--- a/mm/page_alloc.c~mm-move-mem_init_print_info-to-mm_initc
+++ a/mm/page_alloc.c
@@ -5246,8 +5246,6 @@ static bool show_mem_node_skip(unsigned
 	return !node_isset(nid, *nodemask);
 }
 
-#define K(x) ((x) << (PAGE_SHIFT-10))
-
 static void show_migration_types(unsigned char type)
 {
 	static const char types[MIGRATE_TYPES] = {
@@ -6207,57 +6205,6 @@ unsigned long free_reserved_area(void *s
 	return pages;
 }
 
-void __init mem_init_print_info(void)
-{
-	unsigned long physpages, codesize, datasize, rosize, bss_size;
-	unsigned long init_code_size, init_data_size;
-
-	physpages = get_num_physpages();
-	codesize = _etext - _stext;
-	datasize = _edata - _sdata;
-	rosize = __end_rodata - __start_rodata;
-	bss_size = __bss_stop - __bss_start;
-	init_data_size = __init_end - __init_begin;
-	init_code_size = _einittext - _sinittext;
-
-	/*
-	 * Detect special cases and adjust section sizes accordingly:
-	 * 1) .init.* may be embedded into .data sections
-	 * 2) .init.text.* may be out of [__init_begin, __init_end],
-	 *    please refer to arch/tile/kernel/vmlinux.lds.S.
-	 * 3) .rodata.* may be embedded into .text or .data sections.
-	 */
-#define adj_init_size(start, end, size, pos, adj) \
-	do { \
-		if (&start[0] <= &pos[0] && &pos[0] < &end[0] && size > adj) \
-			size -= adj; \
-	} while (0)
-
-	adj_init_size(__init_begin, __init_end, init_data_size,
-		     _sinittext, init_code_size);
-	adj_init_size(_stext, _etext, codesize, _sinittext, init_code_size);
-	adj_init_size(_sdata, _edata, datasize, __init_begin, init_data_size);
-	adj_init_size(_stext, _etext, codesize, __start_rodata, rosize);
-	adj_init_size(_sdata, _edata, datasize, __start_rodata, rosize);
-
-#undef	adj_init_size
-
-	pr_info("Memory: %luK/%luK available (%luK kernel code, %luK rwdata, %luK rodata, %luK init, %luK bss, %luK reserved, %luK cma-reserved"
-#ifdef	CONFIG_HIGHMEM
-		", %luK highmem"
-#endif
-		")\n",
-		K(nr_free_pages()), K(physpages),
-		codesize / SZ_1K, datasize / SZ_1K, rosize / SZ_1K,
-		(init_data_size + init_code_size) / SZ_1K, bss_size / SZ_1K,
-		K(physpages - totalram_pages() - totalcma_pages),
-		K(totalcma_pages)
-#ifdef	CONFIG_HIGHMEM
-		, K(totalhigh_pages())
-#endif
-		);
-}
-
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
 	struct zone *zone;
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch

