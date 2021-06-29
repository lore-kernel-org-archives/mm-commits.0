Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CD0C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0138A61D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhF2CmX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhF2CmX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758D1611AE;
        Tue, 29 Jun 2021 02:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934396;
        bh=HiaTXG0ttNO+UsA3fG8O2N23+IlSjKEcyOA/FjiE2Fw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ea+kVMRqsFGIatLLs1SOuZ2SWWkMXF8kTwECNplBUcOd4CJCrFSjK8yo9gFWvEdOT
         ZR2hBnntq/8ZDrA2f/JtYewg0iXBvkSRqTbPgelg2n5/mSRm77VNs04j/08V6fP+nF
         GY97uyv2BZEkZxXnRQE9FM62ntNKeW5c7OVGpT3A=
Date:   Mon, 28 Jun 2021 19:39:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenli@uniontech.com, chris@zankel.net,
        geert@linux-m68k.org, jonas@southpole.se, linux-mm@kvack.org,
        linux@armlinux.org.uk, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 127/192] mm: update legacy flush_tlb_* to use vma
Message-ID: <20210629023956.adLwXPCCQ%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chen Li <chenli@uniontech.com>
Subject: mm: update legacy flush_tlb_* to use vma

1. These tlb flush functions have been using vma instead mm long time
   ago, but there is still some coments use mm as parameter.

2. the actual struct we use is vm_area_struct instead of vma_struct.

3. remove unused flush_kern_tlb_page.

Link: https://lkml.kernel.org/r/87k0oaq311.wl-chenli@uniontech.com
Signed-off-by: Chen Li <chenli@uniontech.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlbflush.h      |   13 +++----------
 arch/arm/mm/tlb-v6.S                 |    2 +-
 arch/arm/mm/tlb-v7.S                 |    2 +-
 arch/ia64/kernel/efi_stub.S          |    2 +-
 arch/m68k/include/asm/tlbflush.h     |    2 +-
 arch/openrisc/include/asm/tlbflush.h |    2 +-
 arch/xtensa/include/asm/tlbflush.h   |    4 ++--
 7 files changed, 10 insertions(+), 17 deletions(-)

--- a/arch/arm/include/asm/tlbflush.h~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/arm/include/asm/tlbflush.h
@@ -253,7 +253,7 @@ extern struct cpu_tlb_fns cpu_tlb;
  *		space.
  *		- mm	- mm_struct describing address space
  *
- *	flush_tlb_range(mm,start,end)
+ *	flush_tlb_range(vma,start,end)
  *
  *		Invalidate a range of TLB entries in the specified
  *		address space.
@@ -261,18 +261,11 @@ extern struct cpu_tlb_fns cpu_tlb;
  *		- start - start address (may not be aligned)
  *		- end	- end address (exclusive, may not be aligned)
  *
- *	flush_tlb_page(vaddr,vma)
+ *	flush_tlb_page(vma, uaddr)
  *
  *		Invalidate the specified page in the specified address range.
+ *		- vma	- vm_area_struct describing address range
  *		- vaddr - virtual address (may not be aligned)
- *		- vma	- vma_struct describing address range
- *
- *	flush_kern_tlb_page(kaddr)
- *
- *		Invalidate the TLB entry for the specified page.  The address
- *		will be in the kernels virtual memory space.  Current uses
- *		only require the D-TLB to be invalidated.
- *		- kaddr - Kernel virtual memory address
  */
 
 /*
--- a/arch/arm/mm/tlb-v6.S~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/arm/mm/tlb-v6.S
@@ -24,7 +24,7 @@
  *
  *	- start - start address (may not be aligned)
  *	- end   - end address (exclusive, may not be aligned)
- *	- vma   - vma_struct describing address range
+ *	- vma   - vm_area_struct describing address range
  *
  *	It is assumed that:
  *	- the "Invalidate single entry" instruction will invalidate
--- a/arch/arm/mm/tlb-v7.S~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/arm/mm/tlb-v7.S
@@ -23,7 +23,7 @@
  *
  *	- start - start address (may not be aligned)
  *	- end   - end address (exclusive, may not be aligned)
- *	- vma   - vma_struct describing address range
+ *	- vma   - vm_area_struct describing address range
  *
  *	It is assumed that:
  *	- the "Invalidate single entry" instruction will invalidate
--- a/arch/ia64/kernel/efi_stub.S~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/ia64/kernel/efi_stub.S
@@ -7,7 +7,7 @@
  *
  * This stub allows us to make EFI calls in physical mode with interrupts
  * turned off.  We need this because we can't call SetVirtualMap() until
- * the kernel has booted far enough to allow allocation of struct vma_struct
+ * the kernel has booted far enough to allow allocation of struct vm_area_struct
  * entries (which we would need to map stuff with memory attributes other
  * than uncached or writeback...).  Since the GetTime() service gets called
  * earlier than that, we need to be able to make physical mode EFI calls from
--- a/arch/m68k/include/asm/tlbflush.h~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/m68k/include/asm/tlbflush.h
@@ -263,7 +263,7 @@ static inline void flush_tlb_page(struct
 	BUG();
 }
 
-static inline void flush_tlb_range(struct mm_struct *mm,
+static inline void flush_tlb_range(struct vm_area_struct *vma,
 				   unsigned long start, unsigned long end)
 {
 	BUG();
--- a/arch/openrisc/include/asm/tlbflush.h~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/openrisc/include/asm/tlbflush.h
@@ -25,7 +25,7 @@
  *  - flush_tlb_all() flushes all processes TLBs
  *  - flush_tlb_mm(mm) flushes the specified mm context TLB's
  *  - flush_tlb_page(vma, vmaddr) flushes one page
- *  - flush_tlb_range(mm, start, end) flushes a range of pages
+ *  - flush_tlb_range(vma, start, end) flushes a range of pages
  */
 extern void local_flush_tlb_all(void);
 extern void local_flush_tlb_mm(struct mm_struct *mm);
--- a/arch/xtensa/include/asm/tlbflush.h~mm-update-legacy-flush_tlb_-to-use-vma
+++ a/arch/xtensa/include/asm/tlbflush.h
@@ -26,8 +26,8 @@
  *
  *  - flush_tlb_all() flushes all processes TLB entries
  *  - flush_tlb_mm(mm) flushes the specified mm context TLB entries
- *  - flush_tlb_page(mm, vmaddr) flushes a single page
- *  - flush_tlb_range(mm, start, end) flushes a range of pages
+ *  - flush_tlb_page(vma, page) flushes a single page
+ *  - flush_tlb_range(vma, vmaddr, end) flushes a range of pages
  */
 
 void local_flush_tlb_all(void);
_
