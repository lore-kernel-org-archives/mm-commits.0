Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAFBC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B3DC61D12
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhF2CpP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2CpO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 841DB61D10;
        Tue, 29 Jun 2021 02:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934566;
        bh=IRQBLvAz+L+e8ybt4ZURmv7/nmdM+HeDxPK/ezgc4W4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VORjAAtJr5MkA1rLj9w5hJpvSUlVvDIYvjTgagIgJJtAk7OQqn41qu2tXqW+ZHCzs
         XLLQ0uBn14SREL8TGNJdwcXiadRJV4f8arfiDOV7lvJU3u6eYbwTEHeeoc8v14M8tu
         GOLNg6hVBDMBvJBLSru/j1aPURQw8Iyt9IkYZwr8=
Date:   Mon, 28 Jun 2021 19:42:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, corbet@lwn.net,
        david@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, rth@twiddle.net, torvalds@linux-foundation.org,
        vgupta@synopsys.com
Subject:  [patch 182/192] arc: remove support for DISCONTIGMEM
Message-ID: <20210629024246.5qzpc0nir%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arc: remove support for DISCONTIGMEM

DISCONTIGMEM was replaced by FLATMEM with freeing of the unused memory map
in v5.11.

Remove the support for DISCONTIGMEM entirely.

Link: https://lkml.kernel.org/r/20210608091316.3622-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig              |   13 ----------
 arch/arc/include/asm/mmzone.h |   40 --------------------------------
 arch/arc/mm/init.c            |    8 ------
 3 files changed, 61 deletions(-)

--- a/arch/arc/include/asm/mmzone.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2016 Synopsys, Inc. (www.synopsys.com)
- */
-
-#ifndef _ASM_ARC_MMZONE_H
-#define _ASM_ARC_MMZONE_H
-
-#ifdef CONFIG_DISCONTIGMEM
-
-extern struct pglist_data node_data[];
-#define NODE_DATA(nid) (&node_data[nid])
-
-static inline int pfn_to_nid(unsigned long pfn)
-{
-	int is_end_low = 1;
-
-	if (IS_ENABLED(CONFIG_ARC_HAS_PAE40))
-		is_end_low = pfn <= virt_to_pfn(0xFFFFFFFFUL);
-
-	/*
-	 * node 0: lowmem:             0x8000_0000   to 0xFFFF_FFFF
-	 * node 1: HIGHMEM w/o  PAE40: 0x0           to 0x7FFF_FFFF
-	 *         HIGHMEM with PAE40: 0x1_0000_0000 to ...
-	 */
-	if (pfn >= ARCH_PFN_OFFSET && is_end_low)
-		return 0;
-
-	return 1;
-}
-
-static inline int pfn_valid(unsigned long pfn)
-{
-	int nid = pfn_to_nid(pfn);
-
-	return (pfn <= node_end_pfn(nid));
-}
-#endif /* CONFIG_DISCONTIGMEM  */
-
-#endif
--- a/arch/arc/Kconfig~arc-remove-support-for-discontigmem
+++ a/arch/arc/Kconfig
@@ -62,10 +62,6 @@ config SCHED_OMIT_FRAME_POINTER
 config GENERIC_CSUM
 	def_bool y
 
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool n
-	depends on BROKEN
-
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
@@ -344,15 +340,6 @@ config ARC_HUGEPAGE_16M
 
 endchoice
 
-config NODES_SHIFT
-	int "Maximum NUMA Nodes (as a power of 2)"
-	default "0" if !DISCONTIGMEM
-	default "1" if DISCONTIGMEM
-	depends on NEED_MULTIPLE_NODES
-	help
-	  Accessing memory beyond 1GB (with or w/o PAE) requires 2 memory
-	  zones.
-
 config ARC_COMPACT_IRQ_LEVELS
 	depends on ISA_ARCOMPACT
 	bool "Setup Timer IRQ as high Priority"
--- a/arch/arc/mm/init.c~arc-remove-support-for-discontigmem
+++ a/arch/arc/mm/init.c
@@ -32,11 +32,6 @@ unsigned long arch_pfn_offset;
 EXPORT_SYMBOL(arch_pfn_offset);
 #endif
 
-#ifdef CONFIG_DISCONTIGMEM
-struct pglist_data node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
-#endif
-
 long __init arc_get_mem_sz(void)
 {
 	return low_mem_sz;
@@ -147,9 +142,6 @@ void __init setup_arch_memory(void)
 	 * to the hole is freed and ARC specific version of pfn_valid()
 	 * handles the hole in the memory map.
 	 */
-#ifdef CONFIG_DISCONTIGMEM
-	node_set_online(1);
-#endif
 
 	min_high_pfn = PFN_DOWN(high_mem_start);
 	max_high_pfn = PFN_DOWN(high_mem_start + high_mem_sz);
_
