Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A9EC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F4756194E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhGFTSI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231831AbhGFTSH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C6C360FE3;
        Tue,  6 Jul 2021 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598929;
        bh=bvOvp7xm6uQtdAiqAnUX4VAvBk1wvWbDO42aN72mH9s=;
        h=Date:From:To:Subject:From;
        b=oRYLwb0H1jLdnnZQXSdyY/V5QdXrfcs7lvfumkTYQcUgstvL2Qr4A0J7IM0etADz0
         KSQcXV+NRyQwdrGT57AmiI9YJClHUPxIBIIZyyPVL5LJzbuqedmuMqR83pys+f3oSv
         /0N31KjuiPAioiEbo6XQQSAwZX8QBr4/YcOp4MdA=
Date:   Tue, 06 Jul 2021 12:15:28 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, david@redhat.com,
        geert@linux-m68k.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  [merged] arc-remove-support-for-discontigmem.patch
 removed from -mm tree
Message-ID: <20210706191528.sAy51MHGi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc: remove support for DISCONTIGMEM
has been removed from the -mm tree.  Its filename was
     arc-remove-support-for-discontigmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.ibm.com are

mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

