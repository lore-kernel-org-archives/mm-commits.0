Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6840FC43461
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AC51613C2
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhEGBHD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbhEGBHC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A7CD61289;
        Fri,  7 May 2021 01:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349563;
        bh=4h56FvNAu/3KRFglcCIRiYa1htd8afw9q+0GVSKaEwI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FONGn2jkFxXo0SFi71tQQs1/F7b2v6/oGkNOh0aKSrEtPgDJzNF/r9KJHsXIbLAsL
         iKovVQtWo8ZDJhHrmrwUL3efCN+RfkQg3Wiirrz4rTnqDuCAAdAjkMJYMDBz/Nvd+d
         gGv1S2pPNX5ecTkfnVuYNF2HW82aFX8snF2SK+U0=
Date:   Thu, 06 May 2021 18:06:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org,
        benh@kernel.crashing.org, bigeasy@linutronix.de,
        borntraeger@de.ibm.com, christophe.leroy@csgroup.eu,
        dalias@libc.org, davem@davemloft.net, david@redhat.com,
        deller@gmx.de, geert@linux-m68k.org, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, green.hu@gmail.com, gregkh@linuxfoundation.org,
        hca@linux.ibm.com, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jiaxun.yang@flygoat.com,
        krzk@kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-mm@kvack.org, linux@armlinux.org.uk,
        luc.vanoostenryck@gmail.com, mattst88@gmail.com, mcgrof@kernel.org,
        mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        mpatocka@redhat.com, mpe@ellerman.id.au, palmerdabbelt@google.com,
        paulus@samba.org, peterz@infradead.org, pmorel@linux.ibm.com,
        rdunlap@infradead.org, rppt@kernel.org, rth@twiddle.net,
        schnelle@linux.ibm.com, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, ysato@users.sourceforge.jp
Subject:  [patch 75/91] mm: remove xlate_dev_kmem_ptr()
Message-ID: <20210507010601.Wv7G2_H1w%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: remove xlate_dev_kmem_ptr()

Since /dev/kmem has been removed, let's remove the xlate_dev_kmem_ptr()
leftovers.

Link: https://lkml.kernel.org/r/20210324102351.6932-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/io.h     |    5 -----
 arch/arm/include/asm/io.h       |    5 -----
 arch/hexagon/include/asm/io.h   |    1 -
 arch/ia64/include/asm/io.h      |    1 -
 arch/ia64/include/asm/uaccess.h |   18 ------------------
 arch/m68k/include/asm/io_mm.h   |    5 -----
 arch/mips/include/asm/io.h      |    5 -----
 arch/parisc/include/asm/io.h    |    5 -----
 arch/powerpc/include/asm/io.h   |    5 -----
 arch/s390/include/asm/io.h      |    5 -----
 arch/sh/include/asm/io.h        |    5 -----
 arch/sparc/include/asm/io_64.h  |    5 -----
 include/asm-generic/io.h        |   11 -----------
 13 files changed, 76 deletions(-)

--- a/arch/alpha/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/alpha/include/asm/io.h
@@ -602,11 +602,6 @@ extern void outsl (unsigned long port, c
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 #endif /* __KERNEL__ */
 
 #endif /* __ALPHA_IO_H */
--- a/arch/arm/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/arm/include/asm/io.h
@@ -430,11 +430,6 @@ extern void pci_iounmap(struct pci_dev *
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 #include <asm-generic/io.h>
 
 #ifdef CONFIG_MMU
--- a/arch/hexagon/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/hexagon/include/asm/io.h
@@ -64,7 +64,6 @@ static inline void *phys_to_virt(unsigne
  * convert a physical pointer to a virtual kernel pointer for
  * /dev/mem access.
  */
-#define xlate_dev_kmem_ptr(p)    __va(p)
 #define xlate_dev_mem_ptr(p)    __va(p)
 
 /*
--- a/arch/ia64/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/ia64/include/asm/io.h
@@ -277,7 +277,6 @@ extern void memset_io(volatile void __io
 #define memcpy_fromio memcpy_fromio
 #define memcpy_toio memcpy_toio
 #define memset_io memset_io
-#define xlate_dev_kmem_ptr xlate_dev_kmem_ptr
 #define xlate_dev_mem_ptr xlate_dev_mem_ptr
 #include <asm-generic/io.h>
 #undef PCI_IOBASE
--- a/arch/ia64/include/asm/uaccess.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/ia64/include/asm/uaccess.h
@@ -272,22 +272,4 @@ xlate_dev_mem_ptr(phys_addr_t p)
 	return ptr;
 }
 
-/*
- * Convert a virtual cached kernel memory pointer to an uncached pointer
- */
-static __inline__ void *
-xlate_dev_kmem_ptr(void *p)
-{
-	struct page *page;
-	void *ptr;
-
-	page = virt_to_page((unsigned long)p);
-	if (PageUncached(page))
-		ptr = (void *)__pa(p) + __IA64_UNCACHED_OFFSET;
-	else
-		ptr = p;
-
-	return ptr;
-}
-
 #endif /* _ASM_IA64_UACCESS_H */
--- a/arch/m68k/include/asm/io_mm.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/m68k/include/asm/io_mm.h
@@ -397,11 +397,6 @@ static inline void isa_delay(void)
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 #define readb_relaxed(addr)	readb(addr)
 #define readw_relaxed(addr)	readw(addr)
 #define readl_relaxed(addr)	readl(addr)
--- a/arch/mips/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/mips/include/asm/io.h
@@ -564,11 +564,6 @@ extern void (*_dma_cache_inv)(unsigned l
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 void __ioread64_copy(void *to, const void __iomem *from, size_t count);
 
 #endif /* _ASM_IO_H */
--- a/arch/parisc/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/parisc/include/asm/io.h
@@ -316,11 +316,6 @@ extern void iowrite64be(u64 val, void __
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 extern int devmem_is_allowed(unsigned long pfn);
 
 #endif
--- a/arch/powerpc/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/powerpc/include/asm/io.h
@@ -663,11 +663,6 @@ static inline void name at					\
 #define xlate_dev_mem_ptr(p)	__va(p)
 
 /*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-/*
  * We don't do relaxed operations yet, at least not with this semantic
  */
 #define readb_relaxed(addr)	readb(addr)
--- a/arch/s390/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/s390/include/asm/io.h
@@ -20,11 +20,6 @@ void *xlate_dev_mem_ptr(phys_addr_t phys
 #define unxlate_dev_mem_ptr unxlate_dev_mem_ptr
 void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 #define IO_SPACE_LIMIT 0
 
 void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long prot);
--- a/arch/sh/include/asm/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/sh/include/asm/io.h
@@ -283,11 +283,6 @@ static inline void __iomem *ioremap_prot
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 int valid_phys_addr_range(phys_addr_t addr, size_t size);
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
--- a/arch/sparc/include/asm/io_64.h~mm-remove-xlate_dev_kmem_ptr
+++ a/arch/sparc/include/asm/io_64.h
@@ -454,11 +454,6 @@ void sbus_set_sbus64(struct device *, in
  */
 #define xlate_dev_mem_ptr(p)	__va(p)
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
 #endif
 
 #endif /* !(__SPARC64_IO_H) */
--- a/include/asm-generic/io.h~mm-remove-xlate_dev_kmem_ptr
+++ a/include/asm-generic/io.h
@@ -1064,17 +1064,6 @@ static inline void pci_iounmap(struct pc
 #endif
 #endif /* CONFIG_GENERIC_IOMAP */
 
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#ifndef xlate_dev_kmem_ptr
-#define xlate_dev_kmem_ptr xlate_dev_kmem_ptr
-static inline void *xlate_dev_kmem_ptr(void *addr)
-{
-	return addr;
-}
-#endif
-
 #ifndef xlate_dev_mem_ptr
 #define xlate_dev_mem_ptr xlate_dev_mem_ptr
 static inline void *xlate_dev_mem_ptr(phys_addr_t addr)
_
