Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3386C11F68
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD26C61D1F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhF2Cpe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhF2Cpd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BDB461D1A;
        Tue, 29 Jun 2021 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934585;
        bh=F1olh+fMz1kMPmWOeuOt9CUZ/SbGiXmVE2FGavY8ziA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=co0r6wkvjkTcXRaz5MyFZmiIukPsSyg5Qg5t0b7nXGWzd3hqQIS8FwGl3V9g8DLpj
         XJP+jS9MJq2UtIxdQE4TYjoC8LIQ8Djq9AXQUoNtqB24KkarH2qW4W0hOkpZwc/6+K
         ms+wa3bM+NKvxcVljIWQJ840fH+R4VnZa4vFtaCo=
Date:   Mon, 28 Jun 2021 19:43:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, corbet@lwn.net,
        david@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, rth@twiddle.net, torvalds@linux-foundation.org,
        vgupta@synopsys.com
Subject:  [patch 188/192] mm: replace CONFIG_FLAT_NODE_MEM_MAP with
 CONFIG_FLATMEM
Message-ID: <20210629024305.MWvICiS7a%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: replace CONFIG_FLAT_NODE_MEM_MAP with CONFIG_FLATMEM

After removal of the DISCONTIGMEM memory model the FLAT_NODE_MEM_MAP
configuration option is equivalent to FLATMEM.

Drop CONFIG_FLAT_NODE_MEM_MAP and use CONFIG_FLATMEM instead.

Link: https://lkml.kernel.org/r/20210608091316.3622-10-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 kernel/crash_core.c    |    2 +-
 mm/Kconfig             |    4 ----
 mm/page_alloc.c        |    6 +++---
 mm/page_ext.c          |    2 +-
 5 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/mmzone.h~mm-replace-config_flat_node_mem_map-with-config_flatmem
+++ a/include/linux/mmzone.h
@@ -788,7 +788,7 @@ typedef struct pglist_data {
 	struct zonelist node_zonelists[MAX_ZONELISTS];
 
 	int nr_zones; /* number of populated zones in this node */
-#ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
+#ifdef CONFIG_FLATMEM	/* means !SPARSEMEM */
 	struct page *node_mem_map;
 #ifdef CONFIG_PAGE_EXTENSION
 	struct page_ext *node_page_ext;
@@ -878,7 +878,7 @@ typedef struct pglist_data {
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
 #define node_spanned_pages(nid)	(NODE_DATA(nid)->node_spanned_pages)
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
+#ifdef CONFIG_FLATMEM
 #define pgdat_page_nr(pgdat, pagenr)	((pgdat)->node_mem_map + (pagenr))
 #else
 #define pgdat_page_nr(pgdat, pagenr)	pfn_to_page((pgdat)->node_start_pfn + (pagenr))
--- a/kernel/crash_core.c~mm-replace-config_flat_node_mem_map-with-config_flatmem
+++ a/kernel/crash_core.c
@@ -484,7 +484,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
+#ifdef CONFIG_FLATMEM
 	VMCOREINFO_OFFSET(pglist_data, node_mem_map);
 #endif
 	VMCOREINFO_OFFSET(pglist_data, node_start_pfn);
--- a/mm/Kconfig~mm-replace-config_flat_node_mem_map-with-config_flatmem
+++ a/mm/Kconfig
@@ -55,10 +55,6 @@ config FLATMEM
 	def_bool y
 	depends on !SPARSEMEM || FLATMEM_MANUAL
 
-config FLAT_NODE_MEM_MAP
-	def_bool y
-	depends on !SPARSEMEM
-
 #
 # SPARSEMEM_EXTREME (which is the default) does some bootmem
 # allocations when sparse_init() is called.  If this cannot
--- a/mm/page_alloc.c~mm-replace-config_flat_node_mem_map-with-config_flatmem
+++ a/mm/page_alloc.c
@@ -6547,7 +6547,7 @@ static void __meminit zone_init_free_lis
 	}
 }
 
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+#if !defined(CONFIG_FLATMEM)
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
@@ -7403,7 +7403,7 @@ static void __init free_area_init_core(s
 	}
 }
 
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
+#ifdef CONFIG_FLATMEM
 static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
@@ -7451,7 +7451,7 @@ static void __ref alloc_node_mem_map(str
 }
 #else
 static void __ref alloc_node_mem_map(struct pglist_data *pgdat) { }
-#endif /* CONFIG_FLAT_NODE_MEM_MAP */
+#endif /* CONFIG_FLATMEM */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
--- a/mm/page_ext.c~mm-replace-config_flat_node_mem_map-with-config_flatmem
+++ a/mm/page_ext.c
@@ -191,7 +191,7 @@ fail:
 	panic("Out of memory");
 }
 
-#else /* CONFIG_FLAT_NODE_MEM_MAP */
+#else /* CONFIG_FLATMEM */
 
 struct page_ext *lookup_page_ext(const struct page *page)
 {
_
