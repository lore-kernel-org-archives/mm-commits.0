Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDEDC2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B798B22404
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 00:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451446;
	bh=JZm7J6aMfcFp2NR6nm06eVIdsjiPkbyNPn/BdBK64Qc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=e3Ydsv9E8wqbjPdbhYANkzpiq45nR9KDwvmxs/oXGBBMQLfrhFr0sRsW27Wd3FqWQ
	 9Gx+dYxpo3Ge8WhiCdEBuVayYHevuZNElS+rWrjMv3vCaxYYgsTsbrOGtyvJFbhuKu
	 gnzGwrGVi54WJbAL+wCJCCnQLOYWDEvuTKwpkwcY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgKDA50 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 19:57:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgKDA50 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 19:57:26 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67ACD223C7;
        Wed,  4 Nov 2020 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451445;
        bh=JZm7J6aMfcFp2NR6nm06eVIdsjiPkbyNPn/BdBK64Qc=;
        h=Date:From:To:Subject:From;
        b=1vYZjzoHtWGzBDmfBTJseCaFVco8qbzkVzR9NO+wpWxc4b5FcRvKWQ+lhrOwM+I+0
         cQhPLv5j7ufxbv0O7l1isK6th4O3JyNVE7dRdgBwXhvgOYrMwg3ZcHz06YHETSiwJE
         LrYoBITRukKS2uFd/RI2dMU+9w6gNTAV+uWBpKDI=
Date:   Tue, 03 Nov 2020 16:57:22 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rjw@rjwysocki.net, rientjes@google.com, rick.p.edgecombe@intel.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        penberg@kernel.org, pavel@ucw.cz, paul.walmsley@sifive.com,
        paulus@samba.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, len.brown@intel.com,
        kirill.shutemov@linux.intel.com, iamjoonsoo.kim@lge.com,
        hpa@zytor.com, hca@linux.ibm.com, gor@linux.ibm.com,
        david@redhat.com, davem@davemloft.net, dave.hansen@linux.intel.com,
        cl@linux.com, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@de.ibm.com, benh@kernel.crashing.org,
        aou@eecs.berkeley.edu, rppt@linux.ibm.com
Subject:  + mm-introduce-debug_pagealloc_map_pages-helper.patch added
 to -mm tree
Message-ID: <20201104005722.Ve4bK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce debug_pagealloc_map_pages() helper
has been added to the -mm tree.  Its filename is
     mm-introduce-debug_pagealloc_map_pages-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-debug_pagealloc_map_pages-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-debug_pagealloc_map_pages-helper.patch

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
Subject: mm: introduce debug_pagealloc_map_pages() helper

Patch series "arch, mm: improve robustness of direct map manipulation", v4.

During recent discussion about KVM protected memory, David raised a
concern about usage of __kernel_map_pages() outside of DEBUG_PAGEALLOC
scope [1].

Indeed, for architectures that define CONFIG_ARCH_HAS_SET_DIRECT_MAP it is
possible that __kernel_map_pages() would fail, but since this function is
void, the failure will go unnoticed.

Moreover, there's lack of consistency of __kernel_map_pages() semantics
across architectures as some guard this function with #ifdef
DEBUG_PAGEALLOC, some refuse to update the direct map if page allocation
debugging is disabled at run time and some allow modifying the direct map
regardless of DEBUG_PAGEALLOC settings.

This set straightens this out by restoring dependency of
__kernel_map_pages() on DEBUG_PAGEALLOC and updating the call sites
accordingly.  

Since currently the only user of __kernel_map_pages() outside
DEBUG_PAGEALLOC is hibernation, it is updated to make direct map accesses
there more explicit.

[1] https://lore.kernel.org/lkml/2759b4bf-e1e3-d006-7d86-78a40348269d@redhat.com


This patch (of 4):

When CONFIG_DEBUG_PAGEALLOC is enabled, it unmaps pages from the kernel
direct mapping after free_pages().  The pages than need to be mapped back
before they could be used.  Theese mapping operations use
__kernel_map_pages() guarded with with debug_pagealloc_enabled().

The only place that calls __kernel_map_pages() without checking whether
DEBUG_PAGEALLOC is enabled is the hibernation code that presumes
availability of this function when ARCH_HAS_SET_DIRECT_MAP is set.  Still,
on arm64, __kernel_map_pages() will bail out when DEBUG_PAGEALLOC is not
enabled but set_direct_map_invalid_noflush() may render some pages not
present in the direct map and hibernation code won't be able to save such
pages.

To make page allocation debugging and hibernation interaction more robust,
the dependency on DEBUG_PAGEALLOC or ARCH_HAS_SET_DIRECT_MAP has to be
made more explicit.

Start with combining the guard condition and the call to
__kernel_map_pages() into a single debug_pagealloc_map_pages() function to
emphasize that __kernel_map_pages() should not be called without
DEBUG_PAGEALLOC and use this new function to map/unmap pages when page
allocation debug is enabled.

Link: https://lkml.kernel.org/r/20201103162057.22916-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20201103162057.22916-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
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
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |   10 ++++++++++
 mm/memory_hotplug.c |    3 +--
 mm/page_alloc.c     |    6 ++----
 mm/slab.c           |    8 +++-----
 4 files changed, 16 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-introduce-debug_pagealloc_map_pages-helper
+++ a/include/linux/mm.h
@@ -2924,12 +2924,22 @@ kernel_map_pages(struct page *page, int
 {
 	__kernel_map_pages(page, numpages, enable);
 }
+
+static inline void debug_pagealloc_map_pages(struct page *page,
+					     int numpages, int enable)
+{
+	if (debug_pagealloc_enabled_static())
+		__kernel_map_pages(page, numpages, enable);
+}
+
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif	/* CONFIG_HIBERNATION */
 #else	/* CONFIG_DEBUG_PAGEALLOC || CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
+static inline void debug_pagealloc_map_pages(struct page *page,
+					     int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif	/* CONFIG_HIBERNATION */
--- a/mm/memory_hotplug.c~mm-introduce-debug_pagealloc_map_pages-helper
+++ a/mm/memory_hotplug.c
@@ -614,8 +614,7 @@ void generic_online_page(struct page *pa
 	 * so we should map it first. This is better than introducing a special
 	 * case in page freeing fast path.
 	 */
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 1);
+	debug_pagealloc_map_pages(page, 1 << order, 1);
 	__free_pages_core(page, order);
 	totalram_pages_add(1UL << order);
 #ifdef CONFIG_HIGHMEM
--- a/mm/page_alloc.c~mm-introduce-debug_pagealloc_map_pages-helper
+++ a/mm/page_alloc.c
@@ -1272,8 +1272,7 @@ static __always_inline bool free_pages_p
 	 */
 	arch_free_page(page, order);
 
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 0);
+	debug_pagealloc_map_pages(page, 1 << order, 0);
 
 	kasan_free_nondeferred_pages(page, order);
 
@@ -2270,8 +2269,7 @@ inline void post_alloc_hook(struct page
 	set_page_refcounted(page);
 
 	arch_alloc_page(page, order);
-	if (debug_pagealloc_enabled_static())
-		kernel_map_pages(page, 1 << order, 1);
+	debug_pagealloc_map_pages(page, 1 << order, 1);
 	kasan_alloc_pages(page, order);
 	kernel_poison_pages(page, 1 << order, 1);
 	set_page_owner(page, order, gfp_flags);
--- a/mm/slab.c~mm-introduce-debug_pagealloc_map_pages-helper
+++ a/mm/slab.c
@@ -1431,10 +1431,8 @@ static bool is_debug_pagealloc_cache(str
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static void slab_kernel_map(struct kmem_cache *cachep, void *objp, int map)
 {
-	if (!is_debug_pagealloc_cache(cachep))
-		return;
-
-	kernel_map_pages(virt_to_page(objp), cachep->size / PAGE_SIZE, map);
+	debug_pagealloc_map_pages(virt_to_page(objp),
+				  cachep->size / PAGE_SIZE, map);
 }
 
 #else
@@ -2062,7 +2060,7 @@ done:
 
 #if DEBUG
 	/*
-	 * If we're going to use the generic kernel_map_pages()
+	 * If we're going to use the generic debug_pagealloc_map_pages()
 	 * poisoning, then it's going to smash the contents of
 	 * the redzone and userword anyhow, so switch them off.
 	 */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch

