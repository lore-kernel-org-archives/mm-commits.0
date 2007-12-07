From: akpm@linux-foundation.org
Subject: + iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch added to -mm tree
Date: Fri, 07 Dec 2007 14:12:31 -0800
Message-ID: <200712072212.lB7MCVNb006214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755061AbXLGWOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:14:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mingo@elte.hu, mulix@mulix.org, tglx@linutronix.de


The patch titled
     iommu sg: kill __clear_bit_string and find_next_zero_string
has been added to the -mm tree.  Its filename is
     iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg: kill __clear_bit_string and find_next_zero_string
From: FUJITA Tomonori <tomof@acm.org>

This kills unused __clear_bit_string and find_next_zero_string (they
were used by only gart and calgary IOMMUs).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <mulix@mulix.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/Makefile_64    |    2 +-
 arch/x86/lib/bitstr_64.c    |   28 ----------------------------
 include/asm-x86/bitops_64.h |   16 ----------------
 3 files changed, 1 insertion(+), 45 deletions(-)

diff -puN arch/x86/lib/Makefile_64~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string arch/x86/lib/Makefile_64
--- a/arch/x86/lib/Makefile_64~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string
+++ a/arch/x86/lib/Makefile_64
@@ -9,5 +9,5 @@ obj-$(CONFIG_SMP)	+= msr-on-cpu.o
 
 lib-y := csum-partial_64.o csum-copy_64.o csum-wrappers_64.o delay_64.o \
 	usercopy_64.o getuser_64.o putuser_64.o  \
-	thunk_64.o clear_page_64.o copy_page_64.o bitstr_64.o bitops_64.o
+	thunk_64.o clear_page_64.o copy_page_64.o bitops_64.o
 lib-y += memcpy_64.o memmove_64.o memset_64.o copy_user_64.o rwlock_64.o copy_user_nocache_64.o
diff -puN arch/x86/lib/bitstr_64.c~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string /dev/null
--- a/arch/x86/lib/bitstr_64.c
+++ /dev/null
@@ -1,28 +0,0 @@
-#include <linux/module.h>
-#include <linux/bitops.h>
-
-/* Find string of zero bits in a bitmap */ 
-unsigned long 
-find_next_zero_string(unsigned long *bitmap, long start, long nbits, int len)
-{ 
-	unsigned long n, end, i; 	
-
- again:
-	n = find_next_zero_bit(bitmap, nbits, start);
-	if (n == -1) 
-		return -1;
-	
-	/* could test bitsliced, but it's hardly worth it */
-	end = n+len;
-	if (end > nbits)
-		return -1; 
-	for (i = n+1; i < end; i++) { 
-		if (test_bit(i, bitmap)) {  
-			start = i+1; 
-			goto again; 
-		} 
-	}
-	return n;
-}
-
-EXPORT_SYMBOL(find_next_zero_string);
diff -puN include/asm-x86/bitops_64.h~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string include/asm-x86/bitops_64.h
--- a/include/asm-x86/bitops_64.h~iommu-sg-kill-__clear_bit_string-and-find_next_zero_string
+++ a/include/asm-x86/bitops_64.h
@@ -37,12 +37,6 @@ static inline long __scanbit(unsigned lo
   ((off)+(__scanbit(~(((*(unsigned long *)addr)) >> (off)),(size)-(off)))) : \
 	find_next_zero_bit(addr,size,off)))
 
-/* 
- * Find string of zero bits in a bitmap. -1 when not found.
- */ 
-extern unsigned long 
-find_next_zero_string(unsigned long *bitmap, long start, long nbits, int len);
-
 static inline void set_bit_string(unsigned long *bitmap, unsigned long i, 
 				  int len) 
 { 
@@ -53,16 +47,6 @@ static inline void set_bit_string(unsign
 	}
 } 
 
-static inline void __clear_bit_string(unsigned long *bitmap, unsigned long i, 
-				    int len) 
-{ 
-	unsigned long end = i + len; 
-	while (i < end) {
-		__clear_bit(i, bitmap); 
-		i++;
-	}
-} 
-
 /**
  * ffz - find first zero in word.
  * @word: The word to search
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
alpha-kill-deprecated-virt_to_bus.patch
