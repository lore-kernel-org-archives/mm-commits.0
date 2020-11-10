Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DEAC55ABD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E525207D3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 20:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLzjk20B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgKJU7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJU7q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 15:59:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3912074B;
        Tue, 10 Nov 2020 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605041985;
        bh=/8HZFObobAd5aqy78xFZrRbsCKQJDW6VABe2yArqFPs=;
        h=Date:From:To:Subject:From;
        b=jLzjk20BuPFxfu/Iek1pCxA1uBIrcdaXWOPgJEkBApYKSdeYa6t1rJ7rObs9dDGIw
         OSX1Psnf+5SWPzgfhycVIxHUSaWuYPhvZFx3D/lrkin+0Px+bYFIwnW+9egg5fDCBU
         Pr5yifzFovcAReXIFVj82vak8dkHAfoh5KdGuj88=
Date:   Tue, 10 Nov 2020 12:59:42 -0800
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        cl@linux.com, dave.hansen@linux.intel.com, davem@davemloft.net,
        david@redhat.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hpa@zytor.com, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, len.brown@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, pavel@ucw.cz, penberg@kernel.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rick.p.edgecombe@intel.com, rientjes@google.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, vbabka@suse.cz,
        will@kernel.org
Subject:  +
 pm-hibernate-make-direct-map-manipulations-more-explicit.patch added to -mm
 tree
Message-ID: <20201110205942.MPq0HCpeM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: PM: hibernate: make direct map manipulations more explicit
has been added to the -mm tree.  Its filename is
     pm-hibernate-make-direct-map-manipulations-more-explicit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/pm-hibernate-make-direct-map-manipulations-more-explicit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/pm-hibernate-make-direct-map-manipulations-more-explicit.patch

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
Subject: PM: hibernate: make direct map manipulations more explicit

When DEBUG_PAGEALLOC or ARCH_HAS_SET_DIRECT_MAP is enabled a page may be
not present in the direct map and has to be explicitly mapped before it
could be copied.

Introduce hibernate_map_page() and hibernation_unmap_page() that will
explicitly use set_direct_map_{default,invalid}_noflush() for
ARCH_HAS_SET_DIRECT_MAP case and debug_pagealloc_{map,unmap}_pages() for
DEBUG_PAGEALLOC case.

The remapping of the pages in safe_copy_page() presumes that it only
changes protection bits in an existing PTE and so it is safe to ignore
return value of set_direct_map_{default,invalid}_noflush().

Still, add a pr_warn() so that future changes in set_memory APIs will not
silently break hibernation.

Link: https://lkml.kernel.org/r/20201109192128.960-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |   12 ------------
 kernel/power/snapshot.c |   38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~pm-hibernate-make-direct-map-manipulations-more-explicit
+++ a/include/linux/mm.h
@@ -2912,16 +2912,6 @@ static inline bool debug_pagealloc_enabl
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
 extern void __kernel_map_pages(struct page *page, int numpages, int enable);
 
-/*
- * When called in DEBUG_PAGEALLOC context, the call should most likely be
- * guarded by debug_pagealloc_enabled() or debug_pagealloc_enabled_static()
- */
-static inline void
-kernel_map_pages(struct page *page, int numpages, int enable)
-{
-	__kernel_map_pages(page, numpages, enable);
-}
-
 static inline void debug_pagealloc_map_pages(struct page *page, int numpages)
 {
 	if (debug_pagealloc_enabled_static())
@@ -2938,8 +2928,6 @@ static inline void debug_pagealloc_unmap
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
 #else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
-static inline void
-kernel_map_pages(struct page *page, int numpages, int enable) {}
 static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
 static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
 #ifdef CONFIG_HIBERNATION
--- a/kernel/power/snapshot.c~pm-hibernate-make-direct-map-manipulations-more-explicit
+++ a/kernel/power/snapshot.c
@@ -76,6 +76,40 @@ static inline void hibernate_restore_pro
 static inline void hibernate_restore_unprotect_page(void *page_address) {}
 #endif /* CONFIG_STRICT_KERNEL_RWX  && CONFIG_ARCH_HAS_SET_MEMORY */
 
+
+/*
+ * The calls to set_direct_map_*() should not fail because remapping a page
+ * here means that we only update protection bits in an existing PTE.
+ * It is still worth to have a warning here if something changes and this
+ * will no longer be the case.
+ */
+static inline void hibernate_map_page(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
+		int ret = set_direct_map_default_noflush(page);
+
+		if (ret)
+			pr_warn_once("Failed to remap page\n");
+	} else {
+		debug_pagealloc_map_pages(page, 1);
+	}
+}
+
+static inline void hibernate_unmap_page(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
+		unsigned long addr = (unsigned long)page_address(page);
+		int ret  = set_direct_map_invalid_noflush(page);
+
+		if (ret)
+			pr_warn_once("Failed to remap page\n");
+
+		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+	} else {
+		debug_pagealloc_unmap_pages(page, 1);
+	}
+}
+
 static int swsusp_page_is_free(struct page *);
 static void swsusp_set_page_forbidden(struct page *);
 static void swsusp_unset_page_forbidden(struct page *);
@@ -1355,9 +1389,9 @@ static void safe_copy_page(void *dst, st
 	if (kernel_page_present(s_page)) {
 		do_copy_page(dst, page_address(s_page));
 	} else {
-		kernel_map_pages(s_page, 1, 1);
+		hibernate_map_page(s_page);
 		do_copy_page(dst, page_address(s_page));
-		kernel_map_pages(s_page, 1, 0);
+		hibernate_unmap_page(s_page);
 	}
 }
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

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
mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-on-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch

