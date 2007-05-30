From: akpm@linux-foundation.org
Subject: + alpha-cleanup-in-bitopsh.patch added to -mm tree
Date: Wed, 30 May 2007 11:27:36 -0700
Message-ID: <200705301827.l4UIRa9E001658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbXE3S2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 14:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru


The patch titled
     alpha: cleanup in bitops.h
has been added to the -mm tree.  Its filename is
     alpha-cleanup-in-bitopsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: cleanup in bitops.h
From: Richard Henderson <rth@twiddle.net>

Remove 2 functions private to the alpha implemetation, in favor of similar
functions in <linux/log2.h>.

Provide a more efficient version of the fls64 function for pre-ev67 alphas.

Signed-off-by: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    3 +
 arch/alpha/kernel/setup.c     |    3 +
 arch/alpha/lib/Makefile       |    3 +
 arch/alpha/lib/fls.c          |   38 ++++++++++++++++++++++++
 include/asm-alpha/bitops.h    |   50 ++++++++++++++++++--------------
 5 files changed, 73 insertions(+), 24 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-cleanup-in-bitopsh arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-cleanup-in-bitopsh
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
+#include <linux/log2.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -53,7 +54,7 @@ size_for_memory(unsigned long max)
 {
 	unsigned long mem = max_low_pfn << PAGE_SHIFT;
 	if (mem < max)
-		max = 1UL << ceil_log2(mem);
+		max = roundup_pow_of_two(mem);
 	return max;
 }
 
diff -puN arch/alpha/kernel/setup.c~alpha-cleanup-in-bitopsh arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~alpha-cleanup-in-bitopsh
+++ a/arch/alpha/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <linux/notifier.h>
 #include <asm/setup.h>
 #include <asm/io.h>
+#include <linux/log2.h>
 
 extern struct atomic_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
@@ -1303,7 +1304,7 @@ external_cache_probe(int minsize, int wi
 	long size = minsize, maxsize = MAX_BCACHE_SIZE * 2;
 
 	if (maxsize > (max_low_pfn + 1) << PAGE_SHIFT)
-		maxsize = 1 << (floor_log2(max_low_pfn + 1) + PAGE_SHIFT);
+		maxsize = 1 << (ilog2(max_low_pfn + 1) + PAGE_SHIFT);
 
 	/* Get the first block cached. */
 	read_mem_block(__va(0), stride, size);
diff -puN arch/alpha/lib/Makefile~alpha-cleanup-in-bitopsh arch/alpha/lib/Makefile
--- a/arch/alpha/lib/Makefile~alpha-cleanup-in-bitopsh
+++ a/arch/alpha/lib/Makefile
@@ -37,7 +37,8 @@ lib-y =	__divqu.o __remqu.o __divlu.o __
 	$(ev6-y)clear_page.o \
 	$(ev6-y)copy_page.o \
 	fpreg.o \
-	callback_srm.o srm_puts.o srm_printk.o
+	callback_srm.o srm_puts.o srm_printk.o \
+	fls.o
 
 lib-$(CONFIG_SMP) += dec_and_lock.o
 
diff -puN /dev/null arch/alpha/lib/fls.c
--- /dev/null
+++ a/arch/alpha/lib/fls.c
@@ -0,0 +1,38 @@
+/*
+ * arch/alpha/lib/fls.c
+ */
+
+#include <linux/module.h>
+#include <asm/bitops.h>
+
+/* This is fls(x)-1, except zero is held to zero.  This allows most
+   efficent input into extbl, plus it allows easy handling of fls(0)=0.  */
+
+const unsigned char __flsm1_tab[256] =
+{
+  0,
+  0,
+  1, 1,
+  2, 2, 2, 2,
+  3, 3, 3, 3, 3, 3, 3, 3,
+  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
+
+  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
+  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
+
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+};
+
+EXPORT_SYMBOL(__flsm1_tab);
diff -puN include/asm-alpha/bitops.h~alpha-cleanup-in-bitopsh include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-cleanup-in-bitopsh
+++ a/include/asm-alpha/bitops.h
@@ -313,32 +313,29 @@ static inline int ffs(int word)
  * fls: find last bit set.
  */
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
-static inline int fls(int word)
+static inline int fls64(unsigned long word)
 {
-	return 64 - __kernel_ctlz(word & 0xffffffff);
+	return 64 - __kernel_ctlz(word);
 }
 #else
-#include <asm-generic/bitops/fls.h>
-#endif
-#include <asm-generic/bitops/fls64.h>
+extern const unsigned char __flsm1_tab[256];
 
-/* Compute powers of two for the given integer.  */
-static inline long floor_log2(unsigned long word)
+static inline int fls64(unsigned long x)
 {
-#if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
-	return 63 - __kernel_ctlz(word);
-#else
-	long bit;
-	for (bit = -1; word ; bit++)
-		word >>= 1;
-	return bit;
-#endif
+	unsigned long t, a, r;
+
+	t = __kernel_cmpbge (x, 0x0101010101010101);
+	a = __flsm1_tab[t];
+	t = __kernel_extbl (x, a);
+	r = a*8 + __flsm1_tab[t] + (x != 0);
+
+	return r;
 }
+#endif
 
-static inline long ceil_log2(unsigned long word)
+static inline int fls(int x)
 {
-	long bit = floor_log2(word);
-	return bit + (word > (1UL << bit));
+	return fls64((unsigned int) x);
 }
 
 /*
@@ -353,9 +350,20 @@ static inline unsigned long hweight64(un
 	return __kernel_ctpop(w);
 }
 
-#define hweight32(x)	(unsigned int) hweight64((x) & 0xfffffffful)
-#define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
-#define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
+static inline unsigned int hweight32(unsigned int w)
+{
+	return hweight64(w);
+}
+
+static inline unsigned int hweight16(unsigned int w)
+{
+	return hweight64(w & 0xffff);
+}
+
+static inline unsigned int hweight8(unsigned int w)
+{
+	return hweight64(w & 0xff);
+}
 #else
 #include <asm-generic/bitops/hweight.h>
 #endif
_

Patches currently in -mm which might be from rth@twiddle.net are

alpha-support-graphics-on-non-zero-pci-domains.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
alpha-correct-low-level-i-o-routines-for-sable-lynx.patch
alpha-misc-fixes.patch
alpha-cleanup-in-bitopsh.patch
alpha-support-new-syscalls.patch
