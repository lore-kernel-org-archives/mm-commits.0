Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38ACFC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083BA223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgLODQr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgLODMg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:36 -0500
Date:   Mon, 14 Dec 2020 19:10:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001827;
        bh=nCUGA8pmn24sthU8GLhA+co6ErEuQNqqUYEuGrQE1QE=;
        h=From:To:Subject:In-Reply-To:From;
        b=wUmriyjwDGEldVy5FD65Mxk+OmEYP4yqOOWhzxoM3UjbsNGqLlE72zcJ4JSOvG1QY
         wyJSVnuTDD5uP648FPxD+17bay9pBCBEiVXi+La1hQ1O8HhFkuxlUZKzAPiOv8w9N7
         XFu3BOejUHi0BoC2x2iyUk4/RR61VvlEk8Lypaw4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aou@eecs.berkeley.edu,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dave.hansen@linux.intel.com,
        davem@davemloft.net, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hpa@zytor.com, iamjoonsoo.kim@lge.com,
        kirill.shutemov@linux.intel.com, len.brown@intel.com,
        linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, pavel@ucw.cz,
        penberg@kernel.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rick.p.edgecombe@intel.com,
        rientjes@google.com, rjw@rjwysocki.net, rppt@linux.ibm.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org
Subject:  [patch 120/200] PM: hibernate: make direct map
 manipulations more explicit
Message-ID: <20201215031025.-RTbrMHpo%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2934,16 +2934,6 @@ static inline bool debug_pagealloc_enabl
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
@@ -2960,8 +2950,6 @@ static inline void debug_pagealloc_unmap
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
