From: akpm@linux-foundation.org
Subject: + alpha-use-single-hae-window-on-t2-core-logic-gamma-sable.patch added to -mm tree
Date: Thu, 07 Oct 2010 16:16:45 -0700
Message-ID: <201010072316.o97NGjsc030372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0JGXR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Oct 2010 19:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: use single HAE window on T2 core logic (gamma, sable)
has been added to the -mm tree.  Its filename is
     alpha-use-single-hae-window-on-t2-core-logic-gamma-sable.patch

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
Subject: alpha: use single HAE window on T2 core logic (gamma, sable)
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

T2 are the only alpha SMP systems that do HAE switching at runtime, which
is fundamentally racy on SMP.  This patch limits MMIO space on T2 to HAE0
only, like we did on MCPCIA (rawhide) long ago.  This leaves us with only
112 Mb of PCI MMIO (128 Mb HAE aperture minus 16 Mb reserved for EISA),
but since linux PCI allocations are reasonably tight, it should be enough
for sane hardware configurations.

Also, fix a typo in MCPCIA_FROB_MMIO macro which shouldn't call set_hae()
if MCPCIA_ONE_HAE_WINDOW is defined.  It's more for correctness, as
set_hae() is a no-op anyway in that case.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/core_mcpcia.h |    2 
 arch/alpha/include/asm/core_t2.h     |   54 ++++++++-----------------
 arch/alpha/kernel/core_t2.c          |   11 +++--
 arch/alpha/kernel/machvec_impl.h     |    3 +
 4 files changed, 30 insertions(+), 40 deletions(-)

diff -puN arch/alpha/include/asm/core_mcpcia.h~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable arch/alpha/include/asm/core_mcpcia.h
--- a/arch/alpha/include/asm/core_mcpcia.h~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable
+++ a/arch/alpha/include/asm/core_mcpcia.h
@@ -247,7 +247,7 @@ struct el_MCPCIA_uncorrected_frame_mchec
 #define vip	volatile int __force *
 #define vuip	volatile unsigned int __force *
 
-#ifdef MCPCIA_ONE_HAE_WINDOW
+#ifndef MCPCIA_ONE_HAE_WINDOW
 #define MCPCIA_FROB_MMIO						\
 	if (__mcpcia_is_mmio(hose)) {					\
 		set_hae(hose & 0xffffffff);				\
diff -puN arch/alpha/include/asm/core_t2.h~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable arch/alpha/include/asm/core_t2.h
--- a/arch/alpha/include/asm/core_t2.h~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable
+++ a/arch/alpha/include/asm/core_t2.h
@@ -1,6 +1,9 @@
 #ifndef __ALPHA_T2__H__
 #define __ALPHA_T2__H__
 
+/* Fit everything into one 128MB HAE window. */
+#define T2_ONE_HAE_WINDOW 1
+
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <asm/compiler.h>
@@ -19,7 +22,7 @@
  *
  */
 
-#define T2_MEM_R1_MASK 0x07ffffff  /* Mem sparse region 1 mask is 26 bits */
+#define T2_MEM_R1_MASK 0x07ffffff  /* Mem sparse region 1 mask is 27 bits */
 
 /* GAMMA-SABLE is a SABLE with EV5-based CPUs */
 /* All LYNX machines, EV4 or EV5, use the GAMMA bias also */
@@ -85,7 +88,9 @@
 #define T2_DIR			(IDENT_ADDR + GAMMA_BIAS + 0x38e0004a0UL)
 #define T2_ICE			(IDENT_ADDR + GAMMA_BIAS + 0x38e0004c0UL)
 
+#ifndef T2_ONE_HAE_WINDOW
 #define T2_HAE_ADDRESS		T2_HAE_1
+#endif
 
 /*  T2 CSRs are in the non-cachable primary IO space from 3.8000.0000 to
  3.8fff.ffff
@@ -429,13 +434,15 @@ extern inline void t2_outl(u32 b, unsign
  *
  */
 
+#ifdef T2_ONE_HAE_WINDOW
+#define t2_set_hae
+#else
 #define t2_set_hae { \
-	msb = addr  >> 27; \
+	unsigned long msb = addr >> 27; \
 	addr &= T2_MEM_R1_MASK; \
 	set_hae(msb); \
 }
-
-extern raw_spinlock_t t2_hae_lock;
+#endif
 
 /*
  * NOTE: take T2_DENSE_MEM off in each readX/writeX routine, since
@@ -446,28 +453,22 @@ extern raw_spinlock_t t2_hae_lock;
 __EXTERN_INLINE u8 t2_readb(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long result, msb;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long result;
 
 	t2_set_hae;
 
 	result = *(vip) ((addr << 5) + T2_SPARSE_MEM + 0x00);
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 	return __kernel_extbl(result, addr & 3);
 }
 
 __EXTERN_INLINE u16 t2_readw(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long result, msb;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long result;
 
 	t2_set_hae;
 
 	result = *(vuip) ((addr << 5) + T2_SPARSE_MEM + 0x08);
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 	return __kernel_extwl(result, addr & 3);
 }
 
@@ -478,59 +479,47 @@ __EXTERN_INLINE u16 t2_readw(const volat
 __EXTERN_INLINE u32 t2_readl(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long result, msb;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long result;
 
 	t2_set_hae;
 
 	result = *(vuip) ((addr << 5) + T2_SPARSE_MEM + 0x18);
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 	return result & 0xffffffffUL;
 }
 
 __EXTERN_INLINE u64 t2_readq(const volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long r0, r1, work, msb;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long r0, r1, work;
 
 	t2_set_hae;
 
 	work = (addr << 5) + T2_SPARSE_MEM + 0x18;
 	r0 = *(vuip)(work);
 	r1 = *(vuip)(work + (4 << 5));
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 	return r1 << 32 | r0;
 }
 
 __EXTERN_INLINE void t2_writeb(u8 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long msb, w;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long w;
 
 	t2_set_hae;
 
 	w = __kernel_insbl(b, addr & 3);
 	*(vuip) ((addr << 5) + T2_SPARSE_MEM + 0x00) = w;
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 }
 
 __EXTERN_INLINE void t2_writew(u16 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long msb, w;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long w;
 
 	t2_set_hae;
 
 	w = __kernel_inswl(b, addr & 3);
 	*(vuip) ((addr << 5) + T2_SPARSE_MEM + 0x08) = w;
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 }
 
 /*
@@ -540,29 +529,22 @@ __EXTERN_INLINE void t2_writew(u16 b, vo
 __EXTERN_INLINE void t2_writel(u32 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long msb;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
 
 	t2_set_hae;
 
 	*(vuip) ((addr << 5) + T2_SPARSE_MEM + 0x18) = b;
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 }
 
 __EXTERN_INLINE void t2_writeq(u64 b, volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
-	unsigned long msb, work;
-	unsigned long flags;
-	raw_spin_lock_irqsave(&t2_hae_lock, flags);
+	unsigned long work;
 
 	t2_set_hae;
 
 	work = (addr << 5) + T2_SPARSE_MEM + 0x18;
 	*(vuip)work = b;
 	*(vuip)(work + (4 << 5)) = b >> 32;
-	raw_spin_unlock_irqrestore(&t2_hae_lock, flags);
 }
 
 __EXTERN_INLINE void __iomem *t2_ioportmap(unsigned long addr)
diff -puN arch/alpha/kernel/core_t2.c~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable arch/alpha/kernel/core_t2.c
--- a/arch/alpha/kernel/core_t2.c~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable
+++ a/arch/alpha/kernel/core_t2.c
@@ -74,8 +74,6 @@
 # define DBG(args)
 #endif
 
-DEFINE_RAW_SPINLOCK(t2_hae_lock);
-
 static volatile unsigned int t2_mcheck_any_expected;
 static volatile unsigned int t2_mcheck_last_taken;
 
@@ -406,6 +404,7 @@ void __init
 t2_init_arch(void)
 {
 	struct pci_controller *hose;
+	struct resource *hae_mem;
 	unsigned long temp;
 	unsigned int i;
 
@@ -433,7 +432,13 @@ t2_init_arch(void)
 	 */
 	pci_isa_hose = hose = alloc_pci_controller();
 	hose->io_space = &ioport_resource;
-	hose->mem_space = &iomem_resource;
+	hae_mem = alloc_resource();
+	hae_mem->start = 0;
+	hae_mem->end = T2_MEM_R1_MASK;
+	hae_mem->name = pci_hae0_name;
+	if (request_resource(&iomem_resource, hae_mem) < 0)
+		printk(KERN_ERR "Failed to request HAE_MEM\n");
+	hose->mem_space = hae_mem;
 	hose->index = 0;
 
 	hose->sparse_mem_base = T2_SPARSE_MEM - IDENT_ADDR;
diff -puN arch/alpha/kernel/machvec_impl.h~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable arch/alpha/kernel/machvec_impl.h
--- a/arch/alpha/kernel/machvec_impl.h~alpha-use-single-hae-window-on-t2-core-logic-gamma-sable
+++ a/arch/alpha/kernel/machvec_impl.h
@@ -25,6 +25,9 @@
 #ifdef MCPCIA_ONE_HAE_WINDOW
 #define MCPCIA_HAE_ADDRESS	(&alpha_mv.hae_cache)
 #endif
+#ifdef T2_ONE_HAE_WINDOW
+#define T2_HAE_ADDRESS		(&alpha_mv.hae_cache)
+#endif
 
 /* Only a few systems don't define IACK_SC, handling all interrupts through
    the SRM console.  But splitting out that one case from IO() below
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
alpha-enable-arch_dma_addr_t_64bit.patch
alpha-use-single-hae-window-on-t2-core-logic-gamma-sable.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
make-sure-nobodys-leaking-resources.patch

