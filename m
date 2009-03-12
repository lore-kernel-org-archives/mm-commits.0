From: akpm@linux-foundation.org
Subject: + use-debug_kmap_atomic.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:31:54 -0700
Message-ID: <200903122231.n2CMVtLT012279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbZCLWez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:34:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de


The patch titled
     mm: use debug_kmap_atomic
has been added to the -mm tree.  Its filename is
     use-debug_kmap_atomic.patch

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
Subject: mm: use debug_kmap_atomic
From: Akinobu Mita <akinobu.mita@gmail.com>

Use debug_kmap_atomic in kmap_atomic, kmap_atomic_pfn, and
iomap_atomic_prot_pfn.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/highmem.c             |    2 ++
 arch/powerpc/include/asm/highmem.h |    2 ++
 arch/sparc/mm/highmem.c            |    1 +
 arch/x86/mm/highmem_32.c           |    1 +
 arch/x86/mm/iomap_32.c             |    2 ++
 include/asm-frv/highmem.h          |    2 ++
 include/asm-mn10300/highmem.h      |    2 ++
 7 files changed, 12 insertions(+)

diff -puN arch/mips/mm/highmem.c~use-debug_kmap_atomic arch/mips/mm/highmem.c
--- a/arch/mips/mm/highmem.c~use-debug_kmap_atomic
+++ a/arch/mips/mm/highmem.c
@@ -43,6 +43,7 @@ void *__kmap_atomic(struct page *page, e
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
@@ -91,6 +92,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
diff -puN arch/powerpc/include/asm/highmem.h~use-debug_kmap_atomic arch/powerpc/include/asm/highmem.h
--- a/arch/powerpc/include/asm/highmem.h~use-debug_kmap_atomic
+++ a/arch/powerpc/include/asm/highmem.h
@@ -24,6 +24,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/highmem.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
@@ -94,6 +95,7 @@ static inline void *kmap_atomic_prot(str
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
diff -puN arch/sparc/mm/highmem.c~use-debug_kmap_atomic arch/sparc/mm/highmem.c
--- a/arch/sparc/mm/highmem.c~use-debug_kmap_atomic
+++ a/arch/sparc/mm/highmem.c
@@ -39,6 +39,7 @@ void *kmap_atomic(struct page *page, enu
 	if (!PageHighMem(page))
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
diff -puN arch/x86/mm/highmem_32.c~use-debug_kmap_atomic arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~use-debug_kmap_atomic
+++ a/arch/x86/mm/highmem_32.c
@@ -88,6 +88,7 @@ void *kmap_atomic_pfn(unsigned long pfn,
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, kmap_prot));
diff -puN arch/x86/mm/iomap_32.c~use-debug_kmap_atomic arch/x86/mm/iomap_32.c
--- a/arch/x86/mm/iomap_32.c~use-debug_kmap_atomic
+++ a/arch/x86/mm/iomap_32.c
@@ -19,6 +19,7 @@
 #include <asm/iomap.h>
 #include <asm/pat.h>
 #include <linux/module.h>
+#include <linux/highmem.h>
 
 int is_io_mapping_possible(resource_size_t base, unsigned long size)
 {
@@ -41,6 +42,7 @@ iomap_atomic_prot_pfn(unsigned long pfn,
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	/*
 	 * For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
 	 * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
diff -puN include/asm-frv/highmem.h~use-debug_kmap_atomic include/asm-frv/highmem.h
--- a/include/asm-frv/highmem.h~use-debug_kmap_atomic
+++ a/include/asm-frv/highmem.h
@@ -18,6 +18,7 @@
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#include <linux/highmem.h>
 #include <asm/mem-layout.h>
 #include <asm/spr-regs.h>
 #include <asm/mb-regs.h>
@@ -116,6 +117,7 @@ static inline void *kmap_atomic(struct p
 	unsigned long paddr;
 
 	pagefault_disable();
+	debug_kmap_atomic(type);
 	paddr = page_to_phys(page);
 
 	switch (type) {
diff -puN include/asm-mn10300/highmem.h~use-debug_kmap_atomic include/asm-mn10300/highmem.h
--- a/include/asm-mn10300/highmem.h~use-debug_kmap_atomic
+++ a/include/asm-mn10300/highmem.h
@@ -16,6 +16,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/highmem.h>
 #include <asm/kmap_types.h>
 #include <asm/pgtable.h>
 
@@ -77,6 +78,7 @@ static inline unsigned long kmap_atomic(
 	if (page < highmem_start_page)
 		return page_address(page);
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #if HIGHMEM_DEBUG
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

generic-debug-pagealloc-v4.patch
generic-debug-pagealloc-depend-on-config_debug_kernel.patch
generic-debug-pagealloc-cannot-depend-on-hibernation.patch
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch
loop-add-ioctl-to-resize-a-loop-device.patch

