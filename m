Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB3EC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 20 Mar 2023 22:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCTWM5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Mar 2023 18:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCTWMa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Mar 2023 18:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D7DBD4
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 15:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A09CE61853
        for <mm-commits@vger.kernel.org>; Mon, 20 Mar 2023 22:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0256DC433EF;
        Mon, 20 Mar 2023 22:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679350313;
        bh=PMv5hQlf/Lnt7f8Btq2A6JYVmv80snPZKlqsYxA4xAw=;
        h=Date:To:From:Subject:From;
        b=1i73GiFdC+PoHYFgudPRcH377nSB6E+PkdmUfLxMx2oqWiyWE3bottvXonIsE6D4C
         F4Q7Pou5kqUF26iGZsR5FyJ2uAKNBC8K/kboG3Ceu/UOjEypGoARp5OpC8ISOGjVqr
         YJC+CKTzbZxUr6Pzjx3HOINODW6CpcB4BCxXhGRQ=
Date:   Mon, 20 Mar 2023 15:11:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, mhocko@kernel.org, mgorman@suse.de,
        david@redhat.com, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-mem_init_print_info-to-mm_initc.patch added to mm-unstable branch
Message-Id: <20230320221153.0256DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move mem_init_print_info() to mm_init.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-mem_init_print_info-to-mm_initc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-mem_init_print_info-to-mm_initc.patch

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
Subject: mm: move mem_init_print_info() to mm_init.c
Date: Mon, 20 Mar 2023 00:00:05 +0200

mem_init_print_info() is only called from mm_core_init().

Move it close to the caller and make it static.

Link: https://lkml.kernel.org/r/20230319220008.2138576-13-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-move-mem_init_print_info-to-mm_initc
+++ a/include/linux/mm.h
@@ -2925,7 +2925,6 @@ extern unsigned long free_reserved_area(
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
 
@@ -2635,6 +2637,57 @@ static void __init report_meminit(void)
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

