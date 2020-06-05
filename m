From: akpm@linux-foundation.org
Subject: [merged] kmap-remove-kmap_atomic_to_page.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:17:37 -0700
Message-ID: <20200605201737.HghRjZSsr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgFEURi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: kmap: remove kmap_atomic_to_page()
has been removed from the -mm tree.  Its filename was
     kmap-remove-kmap_atomic_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: kmap: remove kmap_atomic_to_page()

kmap_atomic_to_page() has no callers and is only defined on 1 arch and
declared on another.  Remove it.

Link: http://lkml.kernel.org/r/20200507150004.1423069-13-ira.weiny@intel.com
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
=20
 #define flush_cache_kmaps() do {} while (0)
=20
--- a/arch/csky/mm/highmem.c~kmap-remove-kmap_atomic_to_page
+++ a/arch/csky/mm/highmem.c
@@ -81,19 +81,6 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	return (void *) vaddr;
 }
=20
-struct page *kmap_atomic_to_page(void *ptr)
-{
-	unsigned long idx, vaddr =3D (unsigned long)ptr;
-	pte_t *pte;
-
-	if (vaddr < FIXADDR_START)
-		return virt_to_page(ptr);
-
-	idx =3D virt_to_fix(vaddr);
-	pte =3D kmap_pte - (idx - FIX_KMAP_BEGIN);
-	return pte_page(*pte);
-}
