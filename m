From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 034/127] arch/kmap: don't hard code kmap_prot
 values
Date: Thu, 04 Jun 2020 16:47:54 -0700
Message-ID: <20200604234754.tf-o_cCTW%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:47:57 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk

=46rom: Ira Weiny <ira.weiny@intel.com>
Subject: arch/kmap: don't hard code kmap_prot values

To support kmap_atomic_prot() on all architectures each arch must support
protections passed in to them.

Change csky, mips, nds32 and xtensa to use their global constant kmap_prot
rather than a hard coded value which was equal.

Link: http://lkml.kernel.org/r/20200507150004.1423069-10-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
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

 arch/csky/mm/highmem.c   |    2 +-
 arch/mips/mm/highmem.c   |    2 +-
 arch/nds32/mm/highmem.c  |    2 +-
 arch/xtensa/mm/highmem.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/csky/mm/highmem.c~arch-kmap-dont-hard-code-kmap_prot-values
+++ a/arch/csky/mm/highmem.c
@@ -32,7 +32,7 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 #endif
-	set_pte(kmap_pte-idx, mk_pte(page, PAGE_KERNEL));
+	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
 	flush_tlb_one((unsigned long)vaddr);
=20
 	return (void *)vaddr;
--- a/arch/mips/mm/highmem.c~arch-kmap-dont-hard-code-kmap_prot-values
+++ a/arch/mips/mm/highmem.c
@@ -29,7 +29,7 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 #endif
-	set_pte(kmap_pte-idx, mk_pte(page, PAGE_KERNEL));
+	set_pte(kmap_pte-idx, mk_pte(page, kmap_prot));
 	local_flush_tlb_one((unsigned long)vaddr);
=20
 	return (void*) vaddr;
--- a/arch/nds32/mm/highmem.c~arch-kmap-dont-hard-code-kmap_prot-values
+++ a/arch/nds32/mm/highmem.c
@@ -21,7 +21,7 @@ void *kmap_atomic_high(struct page *page
=20
 	idx =3D type + KM_TYPE_NR * smp_processor_id();
 	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	pte =3D (page_to_pfn(page) << PAGE_SHIFT) | (PAGE_KERNEL);
+	pte =3D (page_to_pfn(page) << PAGE_SHIFT) | (kmap_prot);
 	ptep =3D pte_offset_kernel(pmd_off_k(vaddr), vaddr);
 	set_pte(ptep, pte);
=20
--- a/arch/xtensa/mm/highmem.c~arch-kmap-dont-hard-code-kmap_prot-values
+++ a/arch/xtensa/mm/highmem.c
@@ -48,7 +48,7 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte + idx)));
 #endif
-	set_pte(kmap_pte + idx, mk_pte(page, PAGE_KERNEL_EXEC));
+	set_pte(kmap_pte + idx, mk_pte(page, kmap_prot));
=20
 	return (void *)vaddr;
 }
_
