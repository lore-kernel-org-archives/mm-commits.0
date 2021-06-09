Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE669C47082
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F16613CE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Jun 2021 00:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhFIA2F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 20:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234717AbhFIA2E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 20:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFA0613BE;
        Wed,  9 Jun 2021 00:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623198371;
        bh=w+m+rixl7y8aUl5IXXZsUxYMhZu+LrUxqpUUFU5sLS4=;
        h=Date:From:To:Subject:From;
        b=M/mLDacbjiCEjdiOPcoI0barvSCsz4ivG6b1A6L+HbiOpPPuzeQITbQ6b3U/+Wlut
         W/mOLqEUfPxmUtLEngnuw0jxZQ7DLKYmyUBEqqSxmxZGhEV/1Bjf7S7eBE8A2qpq/m
         U7xh6APMlh3uLdydZLp05CfChjaitiiD4B6vmHH8=
Date:   Tue, 08 Jun 2021 17:26:10 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, geert@linux-m68k.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  +
 mm-replace-config_flat_node_mem_map-with-config_flatmem.patch added to -mm
 tree
Message-ID: <20210609002610.DeKoOr39h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace CONFIG_FLAT_NODE_MEM_MAP with CONFIG_FLATMEM
has been added to the -mm tree.  Its filename is
     mm-replace-config_flat_node_mem_map-with-config_flatmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-replace-config_flat_node_mem_map-with-config_flatmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-config_flat_node_mem_map-with-config_flatmem.patch

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
Subject: mm: replace CONFIG_FLAT_NODE_MEM_MAP with CONFIG_FLATMEM

After removal of the DISCONTIGMEM memory model the FLAT_NODE_MEM_MAP
configuration option is equivalent to FLATMEM.

Drop CONFIG_FLAT_NODE_MEM_MAP and use CONFIG_FLATMEM instead.

Link: https://lkml.kernel.org/r/20210608091316.3622-10-rppt@kernel.org
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

 include/linux/mmzone.h |    4 ++--
 kernel/crash_core.c    |    2 +-
 mm/Kconfig             |    4 ----
 mm/page_alloc.c        |    6 +++---
 mm/page_ext.c          |    2 +-
 5 files changed, 7 insertions(+), 11 deletions(-)

--- a/include/linux/mmzone.h~mm-replace-config_flat_node_mem_map-with-config_flatmem
+++ a/include/linux/mmzone.h
@@ -806,7 +806,7 @@ typedef struct pglist_data {
 	struct zonelist node_zonelists[MAX_ZONELISTS];
 
 	int nr_zones; /* number of populated zones in this node */
-#ifdef CONFIG_FLAT_NODE_MEM_MAP	/* means !SPARSEMEM */
+#ifdef CONFIG_FLATMEM	/* means !SPARSEMEM */
 	struct page *node_mem_map;
 #ifdef CONFIG_PAGE_EXTENSION
 	struct page_ext *node_page_ext;
@@ -896,7 +896,7 @@ typedef struct pglist_data {
 
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
@@ -6612,7 +6612,7 @@ static void __meminit zone_init_free_lis
 	}
 }
 
-#if !defined(CONFIG_FLAT_NODE_MEM_MAP)
+#if !defined(CONFIG_FLATMEM)
 /*
  * Only struct pages that correspond to ranges defined by memblock.memory
  * are zeroed and initialized by going through __init_single_page() during
@@ -7448,7 +7448,7 @@ static void __init free_area_init_core(s
 	}
 }
 
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
+#ifdef CONFIG_FLATMEM
 static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
@@ -7496,7 +7496,7 @@ static void __ref alloc_node_mem_map(str
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

