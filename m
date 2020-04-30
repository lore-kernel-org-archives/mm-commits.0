From: akpm@linux-foundation.org
Subject: + arch-kmap-dont-hard-code-kmap_prot-values.patch added
 to -mm tree
Date: Thu, 30 Apr 2020 14:21:13 -0700
Message-ID: <20200430212113.q_khzSoJl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3VVQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Apr 2020 17:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, ray.huang@amd.com, tglx@linutronix.de, thellstrom@vmware.com, tsbogend@alpha.franken.de


The patch titled
     Subject: arch/kmap: don't hard code kmap_prot values
has been added to the -mm tree.  Its filename is
     arch-kmap-dont-hard-code-kmap_prot-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-kmap-dont-hard-code-kmap_prot-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-kmap-dont-hard-code-kmap_prot-values.patch

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
Subject: arch/kmap: don't hard code kmap_prot values

To support kmap_atomic_prot() on all architectures each arch must support
protections passed in to them.

Change csky, mips, nds32 and xtensa to use their global kmap_prot value
rather than a hard coded value which was equal.

Link: http://lkml.kernel.org/r/20200430203845.582900-9-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
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
 
 	return (void*) vaddr;
--- a/arch/nds32/mm/highmem.c~arch-kmap-dont-hard-code-kmap_prot-values
+++ a/arch/nds32/mm/highmem.c
@@ -21,7 +21,7 @@ void *kmap_atomic_high(struct page *page
 
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
-	pte = (page_to_pfn(page) << PAGE_SHIFT) | (PAGE_KERNEL);
+	pte = (page_to_pfn(page) << PAGE_SHIFT) | (kmap_prot);
 	ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
 	set_pte(ptep, pte);
 
--- a/arch/xtensa/mm/highmem.c~arch-kmap-dont-hard-code-kmap_prot-values
+++ a/arch/xtensa/mm/highmem.c
@@ -48,7 +48,7 @@ void *kmap_atomic_high(struct page *page
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte + idx)));
 #endif
-	set_pte(kmap_pte + idx, mk_pte(page, PAGE_KERNEL_EXEC));
+	set_pte(kmap_pte + idx, mk_pte(page, kmap_prot));
 
 	return (void *)vaddr;
 }
_

Patches currently in -mm which might be from ira.weiny@intel.com are

arch-kmap-remove-bug_on.patch
arch-xtensa-move-kmap-build-bug-out-of-the-way.patch
arch-kmap-remove-redundant-arch-specific-kmaps.patch
arch-kunmap-remove-duplicate-kunmap-implementations.patch
arch-kmap_atomic-consolidate-duplicate-code.patch
arch-kunmap_atomic-consolidate-duplicate-code.patch
arch-kmap-ensure-kmap_prot-visibility.patch
arch-kmap-dont-hard-code-kmap_prot-values.patch
arch-kmap-define-kmap_atomic_prot-for-all-archs.patch
drm-remove-drm-specific-kmap_atomic-code.patch
