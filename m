Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7706C4743D
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F5A6613BE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhFIA1p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232302AbhFIA1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA4D061375;
        Wed,  9 Jun 2021 00:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623198351;
        bh=l6Vbr6RucYDyrfQjdSRxGT0SpIlNVsbHz8rUjZFw2WI=;
        h=Date:From:To:Subject:From;
        b=irHD7b5/PXv00w34MnYBPB63PzMfuVjv+nAutZVCXI+fO8e3wLjgTIadP02EU0QNB
         hcp3rxYD/234g3S7/BF0sr8cdYNM2R5Fo7HNxQpA/m5mjzw5t7UNwGEH8q0NLdFOip
         idX0qPOOLKwiVKaYwIHlgpzJJFRGJBNI+OE6fBLc=
Date:   Tue, 08 Jun 2021 17:25:50 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, geert@linux-m68k.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  + mm-remove-config_discontigmem.patch added to -mm tree
Message-ID: <20210609002550.cbUE2kx-T%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove CONFIG_DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     mm-remove-config_discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-config_discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-config_discontigmem.patch

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
Subject: mm: remove CONFIG_DISCONTIGMEM

There are no architectures that support DISCONTIGMEM left.

Remove the configuration option and the dead code it was guarding in the
generic memory management code.

Link: https://lkml.kernel.org/r/20210608091316.3622-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |   37 ++-------------------------
 include/linux/mmzone.h             |    8 +++--
 mm/Kconfig                         |   25 ++----------------
 mm/page_alloc.c                    |   13 ---------
 4 files changed, 12 insertions(+), 71 deletions(-)

--- a/include/asm-generic/memory_model.h~mm-remove-config_discontigmem
+++ a/include/asm-generic/memory_model.h
@@ -6,47 +6,18 @@
 
 #ifndef __ASSEMBLY__
 
+/*
+ * supports 3 memory models.
+ */
 #if defined(CONFIG_FLATMEM)
 
 #ifndef ARCH_PFN_OFFSET
 #define ARCH_PFN_OFFSET		(0UL)
 #endif
 
-#elif defined(CONFIG_DISCONTIGMEM)
-
-#ifndef arch_pfn_to_nid
-#define arch_pfn_to_nid(pfn)	pfn_to_nid(pfn)
-#endif
-
-#ifndef arch_local_page_offset
-#define arch_local_page_offset(pfn, nid)	\
-	((pfn) - NODE_DATA(nid)->node_start_pfn)
-#endif
-
-#endif /* CONFIG_DISCONTIGMEM */
-
-/*
- * supports 3 memory models.
- */
-#if defined(CONFIG_FLATMEM)
-
 #define __pfn_to_page(pfn)	(mem_map + ((pfn) - ARCH_PFN_OFFSET))
 #define __page_to_pfn(page)	((unsigned long)((page) - mem_map) + \
 				 ARCH_PFN_OFFSET)
-#elif defined(CONFIG_DISCONTIGMEM)
-
-#define __pfn_to_page(pfn)			\
-({	unsigned long __pfn = (pfn);		\
-	unsigned long __nid = arch_pfn_to_nid(__pfn);  \
-	NODE_DATA(__nid)->node_mem_map + arch_local_page_offset(__pfn, __nid);\
-})
-
-#define __page_to_pfn(pg)						\
-({	const struct page *__pg = (pg);					\
-	struct pglist_data *__pgdat = NODE_DATA(page_to_nid(__pg));	\
-	(unsigned long)(__pg - __pgdat->node_mem_map) +			\
-	 __pgdat->node_start_pfn;					\
-})
 
 #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
 
@@ -70,7 +41,7 @@
 	struct mem_section *__sec = __pfn_to_section(__pfn);	\
 	__section_mem_map_addr(__sec) + __pfn;		\
 })
-#endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
+#endif /* CONFIG_FLATMEM/SPARSEMEM */
 
 /*
  * Convert a physical address to a Page Frame Number and back
--- a/include/linux/mmzone.h~mm-remove-config_discontigmem
+++ a/include/linux/mmzone.h
@@ -767,10 +767,12 @@ struct zonelist {
 	struct zoneref _zonerefs[MAX_ZONES_PER_ZONELIST + 1];
 };
 
-#ifndef CONFIG_DISCONTIGMEM
-/* The array of struct pages - for discontigmem use pgdat->lmem_map */
+/*
+ * The array of struct pages for flatmem.
+ * It must be declared for SPARSEMEM as well because there are configurations
+ * that rely on that.
+ */
 extern struct page *mem_map;
-#endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 struct deferred_split {
--- a/mm/Kconfig~mm-remove-config_discontigmem
+++ a/mm/Kconfig
@@ -19,7 +19,7 @@ choice
 
 config FLATMEM_MANUAL
 	bool "Flat Memory"
-	depends on !(ARCH_DISCONTIGMEM_ENABLE || ARCH_SPARSEMEM_ENABLE) || ARCH_FLATMEM_ENABLE
+	depends on !ARCH_SPARSEMEM_ENABLE || ARCH_FLATMEM_ENABLE
 	help
 	  This option is best suited for non-NUMA systems with
 	  flat address space. The FLATMEM is the most efficient
@@ -32,21 +32,6 @@ config FLATMEM_MANUAL
 
 	  If unsure, choose this option (Flat Memory) over any other.
 
-config DISCONTIGMEM_MANUAL
-	bool "Discontiguous Memory"
-	depends on ARCH_DISCONTIGMEM_ENABLE
-	help
-	  This option provides enhanced support for discontiguous
-	  memory systems, over FLATMEM.  These systems have holes
-	  in their physical address spaces, and this option provides
-	  more efficient handling of these holes.
-
-	  Although "Discontiguous Memory" is still used by several
-	  architectures, it is considered deprecated in favor of
-	  "Sparse Memory".
-
-	  If unsure, choose "Sparse Memory" over this option.
-
 config SPARSEMEM_MANUAL
 	bool "Sparse Memory"
 	depends on ARCH_SPARSEMEM_ENABLE
@@ -62,17 +47,13 @@ config SPARSEMEM_MANUAL
 
 endchoice
 
-config DISCONTIGMEM
-	def_bool y
-	depends on (!SELECT_MEMORY_MODEL && ARCH_DISCONTIGMEM_ENABLE) || DISCONTIGMEM_MANUAL
-
 config SPARSEMEM
 	def_bool y
 	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
 
 config FLATMEM
 	def_bool y
-	depends on (!DISCONTIGMEM && !SPARSEMEM) || FLATMEM_MANUAL
+	depends on !SPARSEMEM || FLATMEM_MANUAL
 
 config FLAT_NODE_MEM_MAP
 	def_bool y
@@ -85,7 +66,7 @@ config FLAT_NODE_MEM_MAP
 #
 config NEED_MULTIPLE_NODES
 	def_bool y
-	depends on DISCONTIGMEM || NUMA
+	depends on NUMA
 
 #
 # SPARSEMEM_EXTREME (which is the default) does some bootmem
--- a/mm/page_alloc.c~mm-remove-config_discontigmem
+++ a/mm/page_alloc.c
@@ -349,20 +349,7 @@ compound_page_dtor * const compound_page
 
 int min_free_kbytes = 1024;
 int user_min_free_kbytes = -1;
-#ifdef CONFIG_DISCONTIGMEM
-/*
- * DiscontigMem defines memory ranges as separate pg_data_t even if the ranges
- * are not on separate NUMA nodes. Functionally this works but with
- * watermark_boost_factor, it can reclaim prematurely as the ranges can be
- * quite small. By default, do not boost watermarks on discontigmem as in
- * many cases very high-order allocations like THP are likely to be
- * unsupported and the premature reclaim offsets the advantage of long-term
- * fragmentation avoidance.
- */
-int watermark_boost_factor __read_mostly;
-#else
 int watermark_boost_factor __read_mostly = 15000;
-#endif
 int watermark_scale_factor = 10;
 
 static unsigned long nr_kernel_pages __initdata;
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
alpha-remove-discontigmem-and-numa.patch
arc-update-comment-about-highmem-implementation.patch
arc-remove-support-for-discontigmem.patch
m68k-remove-support-for-discontigmem.patch
mm-remove-config_discontigmem.patch
arch-mm-remove-stale-mentions-of-disconigmem.patch
docs-remove-description-of-discontigmem.patch
mm-replace-config_need_multiple_nodes-with-config_numa.patch
mm-replace-config_flat_node_mem_map-with-config_flatmem.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

