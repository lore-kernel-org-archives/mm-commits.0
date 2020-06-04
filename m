From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 038/127] parisc/kmap: remove duplicate kmap code
Date: Thu, 04 Jun 2020 16:48:10 -0700
Message-ID: <20200604234810.hW1eqRFEl%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXsN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:48:13 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: parisc/kmap: remove duplicate kmap code

parisc reimplements the kmap calls except to flush it's dcache.  This is
arguably an abuse of kmap but regardless it is messy and confusing.

Remove the duplicate code and have parisc define ARCH_HAS_FLUSH_ON_KUNMAP
for a kunmap_flush_on_unmap() architecture specific call to flush the
cache.

Link: http://lkml.kernel.org/r/20200507150004.1423069-14-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/cacheflush.h |   28 +------------------------
 include/linux/highmem.h              |   10 ++++++--
 2 files changed, 9 insertions(+), 29 deletions(-)

--- a/arch/parisc/include/asm/cacheflush.h~parisc-kmap-remove-duplicate-kma=
p-code
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -100,35 +100,11 @@ flush_anon_page(struct vm_area_struct *v
 	}
 }
=20
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
=20
-#define kmap_atomic_prot(page, prot)	kmap_atomic(page)
-#define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
-
 #endif /* _PARISC_CACHEFLUSH_H */
=20
--- a/include/linux/highmem.h~parisc-kmap-remove-duplicate-kmap-code
+++ a/include/linux/highmem.h
@@ -130,7 +130,6 @@ static inline struct page *kmap_to_page(
=20
 static inline unsigned long totalhigh_pages(void) { return 0UL; }
=20
-#ifndef ARCH_HAS_KMAP
 static inline void *kmap(struct page *page)
 {
 	might_sleep();
@@ -143,6 +142,9 @@ static inline void kunmap_high(struct pa
=20
 static inline void kunmap(struct page *page)
 {
+#ifdef ARCH_HAS_FLUSH_ON_KUNMAP
+	kunmap_flush_on_unmap(page_address(page));
+#endif
 }
=20
 static inline void *kmap_atomic(struct page *page)
@@ -156,15 +158,17 @@ static inline void *kmap_atomic(struct p
 static inline void kunmap_atomic_high(void *addr)
 {
 	/*
-	 * Nothing to do in the CONFIG_HIGHMEM=3Dn case as kunmap_atomic()
+	 * Mostly nothing to do in the CONFIG_HIGHMEM=3Dn case as kunmap_atomic()
 	 * handles re-enabling faults + preemption
 	 */
+#ifdef ARCH_HAS_FLUSH_ON_KUNMAP
+	kunmap_flush_on_unmap(addr);
+#endif
 }
=20
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
=20
 #define kmap_flush_unused()	do {} while(0)
-#endif
=20
 #endif /* CONFIG_HIGHMEM */
=20
_
