From: akpm@linux-foundation.org
Subject: + kmap-remove-kmap_atomic_to_page.patch added to -mm tree
Date: Mon, 04 May 2020 15:19:49 -0700
Message-ID: <20200504221949.f3B4v9oq2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgEDWTv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 May 2020 18:19:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: kmap: remove kmap_atomic_to_page()
has been added to the -mm tree.  Its filename is
     kmap-remove-kmap_atomic_to_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmap-remove-kmap_atomic_to_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmap-remove-kmap_atomic_to_page.patch

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
Subject: kmap: remove kmap_atomic_to_page()

Patch series "kmap cleanup 2".

Continue the kmap clean up with 2 follow on patches.


This patch (of 2):

kmap_atomic_to_page() has no callers and is only defined on 1 arch and
declared on another.  Remove it.

Link: http://lkml.kernel.org/r/20200504052415.984585-2-ira.weiny@intel.com
Link: http://lkml.kernel.org/r/20200504052415.984585-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/highmem.h  |    1 -
 arch/csky/mm/highmem.c           |   13 -------------
 arch/nds32/include/asm/highmem.h |    1 -
 3 files changed, 15 deletions(-)

--- a/arch/csky/include/asm/highmem.h~kmap-remove-kmap_atomic_to_page
+++ a/arch/csky/include/asm/highmem.h
@@ -33,7 +33,6 @@ extern pte_t *pkmap_page_table;
 #define ARCH_HAS_KMAP_FLUSH_TLB
 extern void kmap_flush_tlb(unsigned long addr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
-extern struct page *kmap_atomic_to_page(void *ptr);
 
 #define flush_cache_kmaps() do {} while (0)
 
--- a/arch/csky/mm/highmem.c~kmap-remove-kmap_atomic_to_page
+++ a/arch/csky/mm/highmem.c
@@ -81,19 +81,6 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	return (void *) vaddr;
 }
 
-struct page *kmap_atomic_to_page(void *ptr)
-{
-	unsigned long idx, vaddr = (unsigned long)ptr;
-	pte_t *pte;
-
-	if (vaddr < FIXADDR_START)
-		return virt_to_page(ptr);
-
-	idx = virt_to_fix(vaddr);
-	pte = kmap_pte - (idx - FIX_KMAP_BEGIN);
-	return pte_page(*pte);
-}
-
 static void __init kmap_pages_init(void)
 {
 	unsigned long vaddr;
--- a/arch/nds32/include/asm/highmem.h~kmap-remove-kmap_atomic_to_page
+++ a/arch/nds32/include/asm/highmem.h
@@ -52,7 +52,6 @@ extern void kmap_init(void);
  */
 #ifdef CONFIG_HIGHMEM
 extern void *kmap_atomic_pfn(unsigned long pfn);
-extern struct page *kmap_atomic_to_page(void *ptr);
 #endif
 
 #endif
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
