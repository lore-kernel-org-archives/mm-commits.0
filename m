From: akpm@linux-foundation.org
Subject: - alpha-correct-low-level-i-o-routines-for-sable-lynx.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:10 -0700
Message-ID: <200706011748.l51Hm9HN015181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761383AbXFARsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jay.estabrook@hp.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     ALPHA: correct low-level I/O routines for sable-lynx
has been removed from the -mm tree.  Its filename was
     alpha-correct-low-level-i-o-routines-for-sable-lynx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALPHA: correct low-level I/O routines for sable-lynx
From: Jay Estabrook <jay.estabrook@hp.com>

This code corrects the behavior of the t2_readX/t2_writeX routines,
and t2_ioreadNN/t2_iowriteNN routines.

The value T2_DENSE_MEM is now subtracted from the "xaddr" argument in
each of the readX/writeX routines, since those routines may be called
directly, rather than always through the ioreadNN/iowriteNN routines.

Examples of the direct calls, via the __raw_readX/writeX macros, are
the memcpy_fromio/toio, _memset_c_io, and scr_memcpyw routines.

Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/core_t2.h |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN include/asm-alpha/core_t2.h~alpha-correct-low-level-i-o-routines-for-sable-lynx include/asm-alpha/core_t2.h
--- a/include/asm-alpha/core_t2.h~alpha-correct-low-level-i-o-routines-for-sable-lynx
+++ a/include/asm-alpha/core_t2.h
@@ -437,9 +437,15 @@ static inline void t2_outl(u32 b, unsign
 
 static DEFINE_SPINLOCK(t2_hae_lock);
 
+/*
+ * NOTE: take T2_DENSE_MEM off in each readX/writeX routine, since
+ *       they may be called directly, rather than through the
+ *       ioreadNN/iowriteNN routines.
+ */
+
 __EXTERN_INLINE u8 t2_readb(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long result, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -453,7 +459,7 @@ __EXTERN_INLINE u8 t2_readb(const volati
 
 __EXTERN_INLINE u16 t2_readw(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long result, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -471,7 +477,7 @@ __EXTERN_INLINE u16 t2_readw(const volat
  */
 __EXTERN_INLINE u32 t2_readl(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long result, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -485,7 +491,7 @@ __EXTERN_INLINE u32 t2_readl(const volat
 
 __EXTERN_INLINE u64 t2_readq(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long r0, r1, work, msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -501,7 +507,7 @@ __EXTERN_INLINE u64 t2_readq(const volat
 
 __EXTERN_INLINE void t2_writeb(u8 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb, w;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -515,7 +521,7 @@ __EXTERN_INLINE void t2_writeb(u8 b, vol
 
 __EXTERN_INLINE void t2_writew(u16 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb, w;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -533,7 +539,7 @@ __EXTERN_INLINE void t2_writew(u16 b, vo
  */
 __EXTERN_INLINE void t2_writel(u32 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -546,7 +552,7 @@ __EXTERN_INLINE void t2_writel(u32 b, vo
 
 __EXTERN_INLINE void t2_writeq(u64 b, volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long) xaddr;
+	unsigned long addr = (unsigned long) xaddr - T2_DENSE_MEM;
 	unsigned long msb, work;
 	unsigned long flags;
 	spin_lock_irqsave(&t2_hae_lock, flags);
@@ -587,14 +593,14 @@ __EXTERN_INLINE int t2_is_mmio(const vol
 __EXTERN_INLINE unsigned int t2_ioread##NS(void __iomem *xaddr)		\
 {									\
 	if (t2_is_mmio(xaddr))						\
-		return t2_read##OS(xaddr - T2_DENSE_MEM);		\
+		return t2_read##OS(xaddr);				\
 	else								\
 		return t2_in##OS((unsigned long)xaddr - T2_IO);		\
 }									\
 __EXTERN_INLINE void t2_iowrite##NS(u##NS b, void __iomem *xaddr)	\
 {									\
 	if (t2_is_mmio(xaddr))						\
-		t2_write##OS(b, xaddr - T2_DENSE_MEM);			\
+		t2_write##OS(b, xaddr);					\
 	else								\
 		t2_out##OS(b, (unsigned long)xaddr - T2_IO);		\
 }
_

Patches currently in -mm which might be from jay.estabrook@hp.com are

origin.patch
