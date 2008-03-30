From: akpm@linux-foundation.org
Subject: + alpha-fix-alsa-dma-mmap-crash.patch added to -mm tree
Date: Sun, 30 Mar 2008 16:46:52 -0700
Message-ID: <200803302346.m2UNkqHD013289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbYC3Xr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 30 Mar 2008 19:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mcree@orcon.net.nz, perex@perex.cz, rth@twiddle.net, tiwai@suse.de


The patch titled
     alpha: fix ALSA DMA mmap crash
has been added to the -mm tree.  Its filename is
     alpha-fix-alsa-dma-mmap-crash.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix ALSA DMA mmap crash
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Make dma_alloc_coherent respect gfp flags (__GFP_COMP is one that matters).

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Tested-by: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c   |    8 +++++---
 include/asm-alpha/dma-mapping.h |    2 +-
 include/asm-alpha/pci.h         |    8 +++++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-fix-alsa-dma-mmap-crash arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-fix-alsa-dma-mmap-crash
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -424,11 +424,13 @@ EXPORT_SYMBOL(pci_unmap_page);
    else DMA_ADDRP is undefined.  */
 
 void *
-pci_alloc_consistent(struct pci_dev *pdev, size_t size, dma_addr_t *dma_addrp)
+__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
+		       dma_addr_t *dma_addrp, gfp_t gfp)
 {
 	void *cpu_addr;
 	long order = get_order(size);
-	gfp_t gfp = GFP_ATOMIC;
+
+	gfp &= ~GFP_DMA;
 
 try_again:
 	cpu_addr = (void *)__get_free_pages(gfp, order);
@@ -458,7 +460,7 @@ try_again:
 
 	return cpu_addr;
 }
-EXPORT_SYMBOL(pci_alloc_consistent);
+EXPORT_SYMBOL(__pci_alloc_consistent);
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must
diff -puN include/asm-alpha/dma-mapping.h~alpha-fix-alsa-dma-mmap-crash include/asm-alpha/dma-mapping.h
--- a/include/asm-alpha/dma-mapping.h~alpha-fix-alsa-dma-mmap-crash
+++ a/include/asm-alpha/dma-mapping.h
@@ -11,7 +11,7 @@
 #define dma_unmap_single(dev, addr, size, dir)		\
 		pci_unmap_single(alpha_gendev_to_pci(dev), addr, size, dir)
 #define dma_alloc_coherent(dev, size, addr, gfp)	\
-		pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr)
+	      __pci_alloc_consistent(alpha_gendev_to_pci(dev), size, addr, gfp)
 #define dma_free_coherent(dev, size, va, addr)		\
 		pci_free_consistent(alpha_gendev_to_pci(dev), size, va, addr)
 #define dma_map_page(dev, page, off, size, dir)		\
diff -puN include/asm-alpha/pci.h~alpha-fix-alsa-dma-mmap-crash include/asm-alpha/pci.h
--- a/include/asm-alpha/pci.h~alpha-fix-alsa-dma-mmap-crash
+++ a/include/asm-alpha/pci.h
@@ -76,7 +76,13 @@ extern inline void pcibios_penalize_isa_
    successful and sets *DMA_ADDRP to the pci side dma address as well,
    else DMA_ADDRP is undefined.  */
 
-extern void *pci_alloc_consistent(struct pci_dev *, size_t, dma_addr_t *);
+extern void *__pci_alloc_consistent(struct pci_dev *, size_t,
+				    dma_addr_t *, gfp_t);
+static inline void *
+pci_alloc_consistent(struct pci_dev *dev, size_t size, dma_addr_t *dma)
+{
+	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC);
+}
 
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
alpha-fix-alsa-dma-mmap-crash.patch
alpha-get_current-dont-add-zero-to-current_thread_info-task.patch
alpha-handle-kcalloc-failure.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
arch-alpha-kernel-trapsc-use-time_-macros.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch
make-sure-nobodys-leaking-resources.patch

