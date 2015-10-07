From: akpm@linux-foundation.org
Subject: + kmap_atomic_to_page-has-no-users-remove-it.patch added to -mm
 tree
Date: Wed, 07 Oct 2015 15:36:11 -0700
Message-ID: <56159e5b.JA2C7x1aEqSxrEFt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbJGWgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 18:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.pitre@linaro.org, nico@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmap_atomic_to_page() has no users, remove it
has been added to the -mm tree.  Its filename is
     kmap_atomic_to_page-has-no-users-remove-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmap_atomic_to_page-has-no-users-remove-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmap_atomic_to_page-has-no-users-remove-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: kmap_atomic_to_page() has no users, remove it

Removal started in 5bbeed12bdc3 ("sparc32: drop unused
kmap_atomic_to_page").  Let's do it across the whole tree.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/highmem.h        |    1 -
 arch/arm/mm/highmem.c                 |   10 ----------
 arch/frv/include/asm/highmem.h        |    2 --
 arch/frv/mm/highmem.c                 |    5 -----
 arch/metag/include/asm/highmem.h      |    1 -
 arch/metag/mm/highmem.c               |   14 --------------
 arch/microblaze/include/asm/highmem.h |   13 -------------
 arch/mips/include/asm/highmem.h       |    1 -
 arch/mips/mm/highmem.c                |   13 -------------
 arch/parisc/include/asm/cacheflush.h  |    1 -
 arch/powerpc/include/asm/highmem.h    |   13 -------------
 arch/tile/include/asm/highmem.h       |    1 -
 arch/tile/mm/highmem.c                |   12 ------------
 arch/x86/include/asm/highmem.h        |    1 -
 arch/x86/mm/highmem_32.c              |   14 --------------
 include/linux/highmem.h               |    1 -
 16 files changed, 103 deletions(-)

diff -puN arch/arm/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/arm/include/asm/highmem.h
--- a/arch/arm/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/arm/include/asm/highmem.h
@@ -68,7 +68,6 @@ extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
-extern struct page *kmap_atomic_to_page(const void *ptr);
 #endif
 
 #endif
diff -puN arch/arm/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it arch/arm/mm/highmem.c
--- a/arch/arm/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/arm/mm/highmem.c
@@ -147,13 +147,3 @@ void *kmap_atomic_pfn(unsigned long pfn)
 
 	return (void *)vaddr;
 }
-
-struct page *kmap_atomic_to_page(const void *ptr)
-{
-	unsigned long vaddr = (unsigned long)ptr;
-
-	if (vaddr < FIXADDR_START)
-		return virt_to_page(ptr);
-
-	return pte_page(get_fixmap_pte(vaddr));
-}
diff -puN arch/frv/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/frv/include/asm/highmem.h
--- a/arch/frv/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/frv/include/asm/highmem.h
@@ -62,8 +62,6 @@ extern void kunmap_high(struct page *pag
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
 
-extern struct page *kmap_atomic_to_page(void *ptr);
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff -puN arch/frv/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it arch/frv/mm/highmem.c
--- a/arch/frv/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/frv/mm/highmem.c
@@ -32,11 +32,6 @@ void kunmap(struct page *page)
 
 EXPORT_SYMBOL(kunmap);
 
-struct page *kmap_atomic_to_page(void *ptr)
-{
-	return virt_to_page(ptr);
-}
-
 void *kmap_atomic(struct page *page)
 {
 	unsigned long paddr;
diff -puN arch/metag/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/metag/include/asm/highmem.h
--- a/arch/metag/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/metag/include/asm/highmem.h
@@ -56,7 +56,6 @@ extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
-extern struct page *kmap_atomic_to_page(void *ptr);
 #endif
 
 #endif
diff -puN arch/metag/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it arch/metag/mm/highmem.c
--- a/arch/metag/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/metag/mm/highmem.c
@@ -111,20 +111,6 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	return (void *)vaddr;
 }
 
-struct page *kmap_atomic_to_page(void *ptr)
-{
-	unsigned long vaddr = (unsigned long)ptr;
-	int idx;
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
 void __init kmap_init(void)
 {
 	unsigned long kmap_vstart;
diff -puN arch/microblaze/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/microblaze/include/asm/highmem.h
--- a/arch/microblaze/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/microblaze/include/asm/highmem.h
@@ -76,19 +76,6 @@ static inline void *kmap_atomic(struct p
 	return kmap_atomic_prot(page, kmap_prot);
 }
 
-static inline struct page *kmap_atomic_to_page(void *ptr)
-{
-	unsigned long idx, vaddr = (unsigned long) ptr;
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
 #define flush_cache_kmaps()	{ flush_icache(); flush_dcache(); }
 
 #endif /* __KERNEL__ */
diff -puN arch/mips/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/mips/include/asm/highmem.h
--- a/arch/mips/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/mips/include/asm/highmem.h
@@ -49,7 +49,6 @@ extern void kunmap(struct page *page);
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
-extern struct page *kmap_atomic_to_page(void *ptr);
 
 #define flush_cache_kmaps()	flush_cache_all()
 
diff -puN arch/mips/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it arch/mips/mm/highmem.c
--- a/arch/mips/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/mips/mm/highmem.c
@@ -118,19 +118,6 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	return (void*) vaddr;
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
 void __init kmap_init(void)
 {
 	unsigned long kmap_vstart;
diff -puN arch/parisc/include/asm/cacheflush.h~kmap_atomic_to_page-has-no-users-remove-it arch/parisc/include/asm/cacheflush.h
--- a/arch/parisc/include/asm/cacheflush.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -156,7 +156,6 @@ static inline void __kunmap_atomic(void
 
 #define kmap_atomic_prot(page, prot)	kmap_atomic(page)
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
-#define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
 
 #endif /* _PARISC_CACHEFLUSH_H */
 
diff -puN arch/powerpc/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/powerpc/include/asm/highmem.h
--- a/arch/powerpc/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/powerpc/include/asm/highmem.h
@@ -84,19 +84,6 @@ static inline void *kmap_atomic(struct p
 	return kmap_atomic_prot(page, kmap_prot);
 }
 
-static inline struct page *kmap_atomic_to_page(void *ptr)
-{
-	unsigned long idx, vaddr = (unsigned long) ptr;
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
 
 #define flush_cache_kmaps()	flush_cache_all()
 
diff -puN arch/tile/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/tile/include/asm/highmem.h
--- a/arch/tile/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/tile/include/asm/highmem.h
@@ -63,7 +63,6 @@ void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
-struct page *kmap_atomic_to_page(void *ptr);
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 void kmap_atomic_fix_kpte(struct page *page, int finished);
 
diff -puN arch/tile/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it arch/tile/mm/highmem.c
--- a/arch/tile/mm/highmem.c~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/tile/mm/highmem.c
@@ -275,15 +275,3 @@ void *kmap_atomic_prot_pfn(unsigned long
 {
 	return kmap_atomic_prot(pfn_to_page(pfn), prot);
 }
-
-struct page *kmap_atomic_to_page(void *ptr)
-{
-	pte_t *pte;
-	unsigned long vaddr = (unsigned long)ptr;
-
-	if (vaddr < FIXADDR_START)
-		return virt_to_page(ptr);
-
-	pte = kmap_get_pte(vaddr);
-	return pte_page(*pte);
-}
diff -puN arch/x86/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it arch/x86/include/asm/highmem.h
--- a/arch/x86/include/asm/highmem.h~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/x86/include/asm/highmem.h
@@ -68,7 +68,6 @@ void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
-struct page *kmap_atomic_to_page(void *ptr);
 
 #define flush_cache_kmaps()	do { } while (0)
 
diff -puN arch/x86/mm/highmem_32.c~kmap_atomic_to_page-has-no-users-remove-it arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~kmap_atomic_to_page-has-no-users-remove-it
+++ a/arch/x86/mm/highmem_32.c
@@ -104,20 +104,6 @@ void __kunmap_atomic(void *kvaddr)
 }
 EXPORT_SYMBOL(__kunmap_atomic);
 
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
-EXPORT_SYMBOL(kmap_atomic_to_page);
