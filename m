Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB446C388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6512240C
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459523;
	bh=hIFi9SS7i/33d1n027WRtL2Mk/r12GeSvEknR9mp06c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bK+qnSH89L1PxIkK6TdTjSE69BKPkSaVdtU5nPVW2flLTH00OUkGIhvHWO+AfttUb
	 gD2icEckGn2+OEgO8716M11Wi35I8IzBB51J8zHM8R5X2JZeBHdRF1VQvzo41mMA4E
	 V3fhzena7HaL1QEEpLYBYq+ZWKcXnM9/Ogc9VhjY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbgKDDMD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbgKDDMC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:12:02 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186AD20657;
        Wed,  4 Nov 2020 03:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459522;
        bh=hIFi9SS7i/33d1n027WRtL2Mk/r12GeSvEknR9mp06c=;
        h=Date:From:To:Subject:From;
        b=ohoZh0j5QiGp/xCeLjv0LIVCyYKoif+5BHKJANxe0Zd/nDM2Jkx/gY32m/bvF1Z5z
         prPr0Izty4OF6G8k19VxK8nXx56jWizYB2EO+PqFVucHDEdeiNRylMPwHyALYQL+gs
         LjuivyfIJ+Gkn0F7H4dRmT0fBlawcKQnuM3PlCIk=
Date:   Tue, 03 Nov 2020 19:11:51 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  +
 m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
 added to -mm tree
Message-ID: <20201104031151.EYBT6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/mm: make node data and node setup depend on CONFIG_DISCONTIGMEM
has been added to the -mm tree.  Its filename is
     m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch

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

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch

