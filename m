From: akpm@linux-foundation.org
Subject: + mm-fix-race-in-kunmap_atomic.patch added to -mm tree
Date: Wed, 27 Oct 2010 10:20:17 -0700
Message-ID: <201010271720.o9RHKiq5005018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab0J0R1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Oct 2010 13:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, hch@infradead.org


The patch titled
     mm: fix race in kunmap_atomic()
has been added to the -mm tree.  Its filename is
     mm-fix-race-in-kunmap_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix race in kunmap_atomic()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Christoph reported a nice splat which illustrated a race in the new stack
based kmap_atomic implementation.

The problem is that we pop our stack slot before we're completely done
resetting its state -- in particular clearing the PTE (sometimes that's
CONFIG_DEBUG_HIGHMEM).  If an interrupt happens before we actually clear
the PTE used for the last slot, that interrupt can reuse the slot in a
dirty state, which triggers a BUG in kmap_atomic().

Fix this by introducing kmap_atomic_idx() which reports the current slot
index without actually releasing it and use that to find the PTE and delay
the _pop() until after we're completely done.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/highmem.c              |    3 ++-
 arch/frv/mm/highmem.c              |    3 ++-
 arch/mips/mm/highmem.c             |    3 ++-
 arch/mn10300/include/asm/highmem.h |    4 +++-
 arch/powerpc/mm/highmem.c          |    4 +++-
 arch/sparc/mm/highmem.c            |    4 +++-
 arch/tile/mm/highmem.c             |    3 ++-
 arch/x86/mm/highmem_32.c           |    3 ++-
 arch/x86/mm/iomap_32.c             |    3 ++-
 include/linux/highmem.h            |    5 +++++
 10 files changed, 26 insertions(+), 9 deletions(-)

diff -puN arch/arm/mm/highmem.c~mm-fix-race-in-kunmap_atomic arch/arm/mm/highmem.c
--- a/arch/arm/mm/highmem.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/arm/mm/highmem.c
@@ -89,7 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 	int idx, type;
 
 	if (kvaddr >= (void *)FIXADDR_START) {
-		type = kmap_atomic_idx_pop();
+		type = kmap_atomic_idx();
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 		if (cache_is_vivt())
@@ -101,6 +101,7 @@ void __kunmap_atomic(void *kvaddr)
 #else
 		(void) idx;  /* to kill a warning */
 #endif
+		kmap_atomic_idx_pop();
 	} else if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
 		/* this address was obtained through kmap_high_get() */
 		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
diff -puN arch/frv/mm/highmem.c~mm-fix-race-in-kunmap_atomic arch/frv/mm/highmem.c
--- a/arch/frv/mm/highmem.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/frv/mm/highmem.c
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(__kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
-	int type = kmap_atomic_idx_pop();
+	int type = kmap_atomic_idx();
 	switch (type) {
 	case 0:		__kunmap_atomic_primary(4, 6);	break;
 	case 1:		__kunmap_atomic_primary(5, 7);	break;
@@ -83,6 +83,7 @@ void __kunmap_atomic(void *kvaddr)
 	default:
 		BUG();
 	}
+	kmap_atomic_idx_pop();
 	pagefault_enable();
 }
 EXPORT_SYMBOL(__kunmap_atomic);
diff -puN arch/mips/mm/highmem.c~mm-fix-race-in-kunmap_atomic arch/mips/mm/highmem.c
--- a/arch/mips/mm/highmem.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/mips/mm/highmem.c
@@ -74,7 +74,7 @@ void __kunmap_atomic(void *kvaddr)
 		return;
 	}
 
-	type = kmap_atomic_idx_pop();
+	type = kmap_atomic_idx();
 #ifdef CONFIG_DEBUG_HIGHMEM
 	{
 		int idx = type + KM_TYPE_NR * smp_processor_id();
@@ -89,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		local_flush_tlb_one(vaddr);
 	}
 #endif
+	kmap_atomic_idx_pop();
 	pagefault_enable();
 }
 EXPORT_SYMBOL(__kunmap_atomic);
diff -puN arch/mn10300/include/asm/highmem.h~mm-fix-race-in-kunmap_atomic arch/mn10300/include/asm/highmem.h
--- a/arch/mn10300/include/asm/highmem.h~mm-fix-race-in-kunmap_atomic
+++ a/arch/mn10300/include/asm/highmem.h
@@ -101,7 +101,7 @@ static inline void __kunmap_atomic(unsig
 		return;
 	}
 
-	type = kmap_atomic_idx_pop();
+	type = kmap_atomic_idx();
 
 #if HIGHMEM_DEBUG
 	{
@@ -119,6 +119,8 @@ static inline void __kunmap_atomic(unsig
 		__flush_tlb_one(vaddr);
 	}
 #endif
+
+	kmap_atomic_idx_pop();
 	pagefault_enable();
 }
 #endif /* __KERNEL__ */
diff -puN arch/powerpc/mm/highmem.c~mm-fix-race-in-kunmap_atomic arch/powerpc/mm/highmem.c
--- a/arch/powerpc/mm/highmem.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/powerpc/mm/highmem.c
@@ -62,7 +62,7 @@ void __kunmap_atomic(void *kvaddr)
 		return;
 	}
 
-	type = kmap_atomic_idx_pop();
+	type = kmap_atomic_idx();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 	{
@@ -79,6 +79,8 @@ void __kunmap_atomic(void *kvaddr)
 		local_flush_tlb_page(NULL, vaddr);
 	}
 #endif
+
+	kmap_atomic_idx_pop();
 	pagefault_enable();
 }
 EXPORT_SYMBOL(__kunmap_atomic);
diff -puN arch/sparc/mm/highmem.c~mm-fix-race-in-kunmap_atomic arch/sparc/mm/highmem.c
--- a/arch/sparc/mm/highmem.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/sparc/mm/highmem.c
@@ -75,7 +75,7 @@ void __kunmap_atomic(void *kvaddr)
 		return;
 	}
 
-	type = kmap_atomic_idx_pop();
+	type = kmap_atomic_idx();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
 	{
@@ -104,6 +104,8 @@ void __kunmap_atomic(void *kvaddr)
 #endif
 	}
 #endif
+
+	kmap_atomic_idx_pop();
 	pagefault_enable();
 }
 EXPORT_SYMBOL(__kunmap_atomic);
diff -puN arch/tile/mm/highmem.c~mm-fix-race-in-kunmap_atomic arch/tile/mm/highmem.c
--- a/arch/tile/mm/highmem.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/tile/mm/highmem.c
@@ -241,7 +241,7 @@ void __kunmap_atomic(void *kvaddr)
 		pte_t pteval = *pte;
 		int idx, type;
 
-		type = kmap_atomic_idx_pop();
+		type = kmap_atomic_idx();
 		idx = type + KM_TYPE_NR*smp_processor_id();
 
 		/*
@@ -252,6 +252,7 @@ void __kunmap_atomic(void *kvaddr)
 		BUG_ON(!pte_present(pteval) && !pte_migrating(pteval));
 		kmap_atomic_unregister(pte_page(pteval), vaddr);
 		kpte_clear_flush(pte, vaddr);
+		kmap_atomic_idx_pop();
 	} else {
 		/* Must be a lowmem page */
 		BUG_ON(vaddr < PAGE_OFFSET);
diff -puN arch/x86/mm/highmem_32.c~mm-fix-race-in-kunmap_atomic arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/x86/mm/highmem_32.c
@@ -74,7 +74,7 @@ void __kunmap_atomic(void *kvaddr)
 	    vaddr <= __fix_to_virt(FIX_KMAP_BEGIN)) {
 		int idx, type;
 
-		type = kmap_atomic_idx_pop();
+		type = kmap_atomic_idx();
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -87,6 +87,7 @@ void __kunmap_atomic(void *kvaddr)
 		 * attributes or becomes a protected page in a hypervisor.
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
+		kmap_atomic_idx_pop();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {
diff -puN arch/x86/mm/iomap_32.c~mm-fix-race-in-kunmap_atomic arch/x86/mm/iomap_32.c
--- a/arch/x86/mm/iomap_32.c~mm-fix-race-in-kunmap_atomic
+++ a/arch/x86/mm/iomap_32.c
@@ -98,7 +98,7 @@ iounmap_atomic(void __iomem *kvaddr)
 	    vaddr <= __fix_to_virt(FIX_KMAP_BEGIN)) {
 		int idx, type;
 
-		type = kmap_atomic_idx_pop();
+		type = kmap_atomic_idx();
 		idx = type + KM_TYPE_NR * smp_processor_id();
 
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -111,6 +111,7 @@ iounmap_atomic(void __iomem *kvaddr)
 		 * attributes or becomes a protected page in a hypervisor.
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
+		kmap_atomic_idx_pop();
 	}
 
 	pagefault_enable();
diff -puN include/linux/highmem.h~mm-fix-race-in-kunmap_atomic include/linux/highmem.h
--- a/include/linux/highmem.h~mm-fix-race-in-kunmap_atomic
+++ a/include/linux/highmem.h
@@ -88,6 +88,11 @@ static inline int kmap_atomic_idx_push(v
 	return idx;
 }
 
+static inline int kmap_atomic_idx(void)
+{
+	return __get_cpu_var(__kmap_atomic_idx) - 1;
+}
+
 static inline int kmap_atomic_idx_pop(void)
 {
 	int idx = --__get_cpu_var(__kmap_atomic_idx);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch
mm-strictly-nested-kmap_atomic.patch
mm-stack-based-kmap_atomic.patch
mm-remove-pte_map_nested.patch
perf-x86-fix-up-kmap_atomic-type.patch
mm-highmem-documentation.patch
mm-filemap_fault-unique-path-for-locking-page.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
x86-access_error-api-cleanup.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch
workqueues-s-on_stack-onstack.patch
kernel-remove-pf_flusher.patch
mmx86-fix-kmap_atomic_push-vs-ioremap_32c.patch
mm-fix-race-in-kunmap_atomic.patch
linux-next.patch

