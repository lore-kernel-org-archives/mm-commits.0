Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9664C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5FE61C79
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhGFTSR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231889AbhGFTSQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 990BD61C6C;
        Tue,  6 Jul 2021 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598937;
        bh=Fzpl9aQ7DyopSXFCEH8iWBKZH2pGwCRzMxiOKlN+Rbw=;
        h=Date:From:To:Subject:From;
        b=v15pqU6KQB7/jztsFYE94/IUJYpmZTbuAJD6Wf0uvPLWnAnc0Wl/pSuFbuNQ+VjRB
         THvZ372/xmBdajHX8i+K3dx1VpzeJcG2Ehy6MC+huZQhQ7c2X5enFP+cVDIDoUZAbc
         D/H+z9RNgzwlLUd8VSsjsFYqUHR6wmvPdtdbIOW4=
Date:   Tue, 06 Jul 2021 12:15:37 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, david@redhat.com,
        geert@linux-m68k.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  [merged]
 arch-mm-remove-stale-mentions-of-disconigmem.patch removed from -mm tree
Message-ID: <20210706191537.PzgytCUvr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch, mm: remove stale mentions of DISCONIGMEM
has been removed from the -mm tree.  Its filename was
     arch-mm-remove-stale-mentions-of-disconigmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch, mm: remove stale mentions of DISCONIGMEM

There are several places that mention DISCONIGMEM in comments or have
stale code guarded by CONFIG_DISCONTIGMEM.

Remove the dead code and update the comments.

Link: https://lkml.kernel.org/r/20210608091316.3622-7-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/topology.c     |    5 ++---
 arch/ia64/mm/numa.c             |    5 ++---
 arch/mips/include/asm/mmzone.h  |    6 ------
 arch/mips/mm/init.c             |    3 ---
 arch/nds32/include/asm/memory.h |    6 ------
 arch/xtensa/include/asm/page.h  |    4 ----
 include/linux/gfp.h             |    4 ++--
 7 files changed, 6 insertions(+), 27 deletions(-)

--- a/arch/ia64/kernel/topology.c~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/arch/ia64/kernel/topology.c
@@ -3,9 +3,8 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * This file contains NUMA specific variables and functions which can
- * be split away from DISCONTIGMEM and are used on NUMA machines with
- * contiguous memory.
+ * This file contains NUMA specific variables and functions which are used on
+ * NUMA machines with contiguous memory.
  * 		2002/08/07 Erich Focht <efocht@ess.nec.de>
  * Populate cpu entries in sysfs for non-numa systems as well
  *  	Intel Corporation - Ashok Raj
--- a/arch/ia64/mm/numa.c~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/arch/ia64/mm/numa.c
@@ -3,9 +3,8 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * This file contains NUMA specific variables and functions which can
- * be split away from DISCONTIGMEM and are used on NUMA machines with
- * contiguous memory.
+ * This file contains NUMA specific variables and functions which are used on
+ * NUMA machines with contiguous memory.
  * 
  *                         2002/08/07 Erich Focht <efocht@ess.nec.de>
  */
--- a/arch/mips/include/asm/mmzone.h~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/arch/mips/include/asm/mmzone.h
@@ -20,10 +20,4 @@
 #define nid_to_addrbase(nid) 0
 #endif
 
-#ifdef CONFIG_DISCONTIGMEM
-
-#define pfn_to_nid(pfn)		pa_to_nid((pfn) << PAGE_SHIFT)
-
-#endif /* CONFIG_DISCONTIGMEM */
-
 #endif /* _ASM_MMZONE_H_ */
--- a/arch/mips/mm/init.c~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/arch/mips/mm/init.c
@@ -454,9 +454,6 @@ void __init mem_init(void)
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (_PFN_SHIFT > PAGE_SHIFT));
 
 #ifdef CONFIG_HIGHMEM
-#ifdef CONFIG_DISCONTIGMEM
-#error "CONFIG_HIGHMEM and CONFIG_DISCONTIGMEM dont work together yet"
-#endif
 	max_mapnr = highend_pfn ? highend_pfn : max_low_pfn;
 #else
 	max_mapnr = max_low_pfn;
--- a/arch/nds32/include/asm/memory.h~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/arch/nds32/include/asm/memory.h
@@ -76,18 +76,12 @@
  *  virt_to_page(k)	convert a _valid_ virtual address to struct page *
  *  virt_addr_valid(k)	indicates whether a virtual address is valid
  */
-#ifndef CONFIG_DISCONTIGMEM
-
 #define ARCH_PFN_OFFSET		PHYS_PFN_OFFSET
 #define pfn_valid(pfn)		((pfn) >= PHYS_PFN_OFFSET && (pfn) < (PHYS_PFN_OFFSET + max_mapnr))
 
 #define virt_to_page(kaddr)	(pfn_to_page(__pa(kaddr) >> PAGE_SHIFT))
 #define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >= PAGE_OFFSET && (unsigned long)(kaddr) < (unsigned long)high_memory)
 
-#else /* CONFIG_DISCONTIGMEM */
-#error CONFIG_DISCONTIGMEM is not supported yet.
-#endif /* !CONFIG_DISCONTIGMEM */
-
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
 #endif
--- a/arch/xtensa/include/asm/page.h~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/arch/xtensa/include/asm/page.h
@@ -192,10 +192,6 @@ static inline unsigned long ___pa(unsign
 #define pfn_valid(pfn) \
 	((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
 
-#ifdef CONFIG_DISCONTIGMEM
-# error CONFIG_DISCONTIGMEM not supported
-#endif
-
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define page_to_virt(page)	__va(page_to_pfn(page) << PAGE_SHIFT)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
--- a/include/linux/gfp.h~arch-mm-remove-stale-mentions-of-disconigmem
+++ a/include/linux/gfp.h
@@ -494,8 +494,8 @@ static inline int gfp_zonelist(gfp_t fla
  * There are two zonelists per node, one for all zones with memory and
  * one containing just zones from the node the zonelist belongs to.
  *
- * For the normal case of non-DISCONTIGMEM systems the NODE_DATA() gets
- * optimized to &contig_page_data at compile-time.
+ * For the case of non-NUMA systems the NODE_DATA() gets optimized to
+ * &contig_page_data at compile-time.
  */
 static inline struct zonelist *node_zonelist(int nid, gfp_t flags)
 {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

