Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D147C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9D461D19
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhF2CpX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2CpX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBBB461D16;
        Tue, 29 Jun 2021 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934576;
        bh=yiUcHQTJkT6Gt41tJD4O29MHZCt7UfZDbJropLrxAB0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C41lpMU01RWZy0XHJ6Qcn3B2lN1JgBMe3hfZbdz+5EpWz5+jEHTJFhjMtPFvywXxh
         SUQVr66aKShcrjblux9Q1G9K9ztndEDzbqmR+F7/6PlNgimmi7Do5IwE1RFezuO/h5
         +OeqrEzlTMjquQipbvxBoazNE0KCL5LPMGeQc6fo=
Date:   Mon, 28 Jun 2021 19:42:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, corbet@lwn.net,
        david@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, rth@twiddle.net, torvalds@linux-foundation.org,
        vgupta@synopsys.com
Subject:  [patch 185/192] arch, mm: remove stale mentions of
 DISCONIGMEM
Message-ID: <20210629024255.u9gQRD3Ew%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
