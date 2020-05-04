From: akpm@linux-foundation.org
Subject: + parisc-kmap-remove-duplicate-kmap-code.patch added to
 -mm tree
Date: Mon, 04 May 2020 15:19:52 -0700
Message-ID: <20200504221952.mxiAzJBjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgEDWTx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 18:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: parisc/kmap: remove duplicate kmap code
has been added to the -mm tree.  Its filename is
     parisc-kmap-remove-duplicate-kmap-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-kmap-remove-duplicate-kmap-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-kmap-remove-duplicate-kmap-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: parisc/kmap: remove duplicate kmap code

parisc reimplements the kmap calls except to flush it's dcache.  This is
arguably an abuse of kmap but regardless it is messy and confusing.

Remove the duplicate code and have parisc define ARCH_HAS_FLUSH_ON_KUNMAP
for a kunmap_flush_on_unmap() architecture specific call to flush the
cache.

Link: http://lkml.kernel.org/r/20200504052415.984585-3-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/cacheflush.h |   28 +------------------------
 include/linux/highmem.h              |   10 ++++++--
 2 files changed, 9 insertions(+), 29 deletions(-)

--- a/arch/parisc/include/asm/cacheflush.h~parisc-kmap-remove-duplicate-kmap-code
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -100,35 +100,11 @@ flush_anon_page(struct vm_area_struct *v
 	}
 }
 
-#include <asm/kmap_types.h>
-
-#define ARCH_HAS_KMAP
-
-static inline void *kmap(struct page *page)
-{
-	might_sleep();
-	return page_address(page);
-}
-
-static inline void kunmap(struct page *page)
-{
-	flush_kernel_dcache_page_addr(page_address(page));
-}
-
-static inline void *kmap_atomic(struct page *page)
-{
-	preempt_disable();
-	pagefault_disable();
-	return page_address(page);
-}
-
-static inline void kunmap_atomic_high(void *addr)
+#define ARCH_HAS_FLUSH_ON_KUNMAP
+static inline void kunmap_flush_on_unmap(void *addr)
 {
 	flush_kernel_dcache_page_addr(addr);
 }
 
-#define kmap_atomic_prot(page, prot)	kmap_atomic(page)
-#define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
-
 #endif /* _PARISC_CACHEFLUSH_H */
 
--- a/include/linux/highmem.h~parisc-kmap-remove-duplicate-kmap-code
+++ a/include/linux/highmem.h
@@ -129,7 +129,6 @@ static inline struct page *kmap_to_page(
 
 static inline unsigned long totalhigh_pages(void) { return 0UL; }
 
-#ifndef ARCH_HAS_KMAP
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
@@ -138,6 +137,9 @@ static inline void *kmap(struct page *pa
 
 static inline void kunmap(struct page *page)
 {
+#ifdef ARCH_HAS_FLUSH_ON_KUNMAP
+	kunmap_flush_on_unmap(page_address(page));
+#endif
 }
 
 static inline void *kmap_atomic(struct page *page)
@@ -150,14 +152,16 @@ static inline void *kmap_atomic(struct p
 
 static inline void kunmap_atomic_high(void *addr)
 {
-	/* Nothing to do in the CONFIG_HIGHMEM=n case as kunmap_atomic()
+	/* Mostly nothing to do in the CONFIG_HIGHMEM=n case as kunmap_atomic()
 	 * handles re-enabling faults + preemption */
+#ifdef ARCH_HAS_FLUSH_ON_KUNMAP
+	kunmap_flush_on_unmap(addr);
+#endif
 }
 
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
 
 #define kmap_flush_unused()	do {} while(0)
-#endif
 
 #endif /* CONFIG_HIGHMEM */
 
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
x86powerpcmicroblaze-kmap-move-preempt-disable.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
kmap-remove-kmap_atomic_to_page.patch
parisc-kmap-remove-duplicate-kmap-code.patch
