Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0508C49EBD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7845822CB2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgLOX7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:59718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbgLOXWh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:37 -0500
Date:   Tue, 15 Dec 2020 15:21:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074466;
        bh=EhzK8WY8PllKhtk1IOiUHKHyfGgphqx8K1Fd+3yN698=;
        h=From:To:Subject:From;
        b=cFXKLDhGXwRpgcduBRqhcnLWKsAIscmGBLvqPZ0Un+MylmeXme9tz5WG5wI8Ny0J8
         VHKnq6s2yc1m94iCh1vKyu2qHqiQTbDjpPI3BYavlT9dXqyCCVJ6RsxiTLn9vkYWWK
         SyfKzEvChFz82hyVIhK1TpARjITKdvTm2Y5EIYY8=
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, catalin.marinas@arm.com, corbet@lwn.net,
        geert@linux-m68k.org, gerg@linux-m68k.org,
        glaubitz@physik.fu-berlin.de, linux@armlinux.org.uk,
        mattst88@gmail.com, mm-commits@vger.kernel.org, mroos@linux.ee,
        rppt@linux.ibm.com, schmitzmic@gmail.com, tony.luck@intel.com,
        vgupta@synopsys.com, will@kernel.org
Subject:  [merged]
 m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
 removed from -mm tree
Message-ID: <20201215232105.eYGXZoL0n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: make node data and node setup depend on CONFIG_DISCONTIGMEM
has been removed from the -mm tree.  Its filename was
     m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: m68k/mm: make node data and node setup depend on CONFIG_DISCONTIGMEM

The pg_data_t node structures and their initialization currently depends on
!CONFIG_SINGLE_MEMORY_CHUNK. Since they are required only for DISCONTIGMEM
make this dependency explicit and replace usage of
CONFIG_SINGLE_MEMORY_CHUNK with CONFIG_DISCONTIGMEM where appropriate.

The CONFIG_SINGLE_MEMORY_CHUNK was implicitly disabled on the ColdFire MMU
variant, although it always presumed a single memory bank. As there is no
actual need for DISCONTIGMEM in this case, make sure that ColdFire MMU
systems set CONFIG_SINGLE_MEMORY_CHUNK to 'y'.

Link: https://lkml.kernel.org/r/20201101170454.9567-12-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig.cpu               |    4 ++--
 arch/m68k/include/asm/page_mm.h     |    2 +-
 arch/m68k/include/asm/virtconvert.h |    2 +-
 arch/m68k/mm/init.c                 |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/m68k/include/asm/page_mm.h~m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem
+++ a/arch/m68k/include/asm/page_mm.h
@@ -126,7 +126,7 @@ static inline void *__va(unsigned long x
 
 extern int m68k_virt_to_node_shift;
 
-#ifdef CONFIG_SINGLE_MEMORY_CHUNK
+#ifndef CONFIG_DISCONTIGMEM
 #define __virt_to_node(addr)	(&pg_data_map[0])
 #else
 extern struct pglist_data *pg_data_table[];
--- a/arch/m68k/include/asm/virtconvert.h~m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem
+++ a/arch/m68k/include/asm/virtconvert.h
@@ -29,7 +29,7 @@ static inline void *phys_to_virt(unsigne
 }
 
 /* Permanent address of a page. */
-#if defined(CONFIG_MMU) && defined(CONFIG_SINGLE_MEMORY_CHUNK)
+#if defined(CONFIG_MMU) && !defined(CONFIG_DISCONTIGMEM)
 #define page_to_phys(page) \
 	__pa(PAGE_OFFSET + (((page) - pg_data_map[0].node_mem_map) << PAGE_SHIFT))
 #else
--- a/arch/m68k/Kconfig.cpu~m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem
+++ a/arch/m68k/Kconfig.cpu
@@ -373,7 +373,7 @@ config RMW_INSNS
 config SINGLE_MEMORY_CHUNK
 	bool "Use one physical chunk of memory only" if ADVANCED && !SUN3
 	depends on MMU
-	default y if SUN3
+	default y if SUN3 || MMU_COLDFIRE
 	select NEED_MULTIPLE_NODES
 	help
 	  Ignore all but the first contiguous chunk of physical memory for VM
@@ -406,7 +406,7 @@ config M68K_L2_CACHE
 config NODES_SHIFT
 	int
 	default "3"
-	depends on !SINGLE_MEMORY_CHUNK
+	depends on DISCONTIGMEM
 
 config CPU_HAS_NO_BITFIELDS
 	bool
--- a/arch/m68k/mm/init.c~m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem
+++ a/arch/m68k/mm/init.c
@@ -47,14 +47,14 @@ EXPORT_SYMBOL(pg_data_map);
 
 int m68k_virt_to_node_shift;
 
-#ifndef CONFIG_SINGLE_MEMORY_CHUNK
+#ifdef CONFIG_DISCONTIGMEM
 pg_data_t *pg_data_table[65];
 EXPORT_SYMBOL(pg_data_table);
 #endif
 
 void __init m68k_setup_node(int node)
 {
-#ifndef CONFIG_SINGLE_MEMORY_CHUNK
+#ifdef CONFIG_DISCONTIGMEM
 	struct m68k_mem_info *info = m68k_memory + node;
 	int i, end;
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-enforce-overlap-of-memorymemblock-and-memoryreserved.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

