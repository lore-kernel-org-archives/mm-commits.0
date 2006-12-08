From: akpm@osdl.org
Subject: - log2-provide-ilog2-fallbacks-for-powerpc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:41 -0800
Message-ID: <200612082005.kB8K5f1H002323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426329AbWLHUFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     LOG2: Provide ilog2() fallbacks for powerpc
has been removed from the -mm tree.  Its filename was
     log2-provide-ilog2-fallbacks-for-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: LOG2: Provide ilog2() fallbacks for powerpc
From: David Howells <dhowells@redhat.com>

Provide ilog2() fallbacks for powerpc for 32-bit numbers and 64-bit numbers on
ppc64.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/Kconfig          |    4 ++--
 include/asm-powerpc/bitops.h  |   21 ++++++++++++++++++++-
 include/asm-powerpc/page_32.h |   10 +---------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff -puN arch/powerpc/Kconfig~log2-provide-ilog2-fallbacks-for-powerpc arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~log2-provide-ilog2-fallbacks-for-powerpc
+++ a/arch/powerpc/Kconfig
@@ -43,11 +43,11 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config ARCH_HAS_ILOG2_U32
 	bool
-	default n
+	default y
 
 config ARCH_HAS_ILOG2_U64
 	bool
-	default n
+	default y if 64BIT
 
 config GENERIC_HWEIGHT
 	bool
diff -puN include/asm-powerpc/bitops.h~log2-provide-ilog2-fallbacks-for-powerpc include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~log2-provide-ilog2-fallbacks-for-powerpc
+++ a/include/asm-powerpc/bitops.h
@@ -190,7 +190,8 @@ static __inline__ void set_bits(unsigned
  * Return the zero-based bit position (LE, not IBM bit numbering) of
  * the most significant 1-bit in a double word.
  */
-static __inline__ int __ilog2(unsigned long x)
+static __inline__ __attribute__((const))
+int __ilog2(unsigned long x)
 {
 	int lz;
 
@@ -198,6 +199,24 @@ static __inline__ int __ilog2(unsigned l
 	return BITS_PER_LONG - 1 - lz;
 }
 
+static inline __attribute__((const))
+int __ilog2_u32(u32 n)
+{
+	int bit;
+	asm ("cntlzw %0,%1" : "=r" (bit) : "r" (n));
+	return 31 - bit;
+}
+
+#ifdef __powerpc64__
+static inline __attribute__((const))
+int __ilog2_u64(u32 n)
+{
+	int bit;
+	asm ("cntlzd %0,%1" : "=r" (bit) : "r" (n));
+	return 63 - bit;
+}
+#endif
+
 /*
  * Determines the bit position of the least significant 0 bit in the
  * specified double word. The returned bit position will be
diff -puN include/asm-powerpc/page_32.h~log2-provide-ilog2-fallbacks-for-powerpc include/asm-powerpc/page_32.h
--- a/include/asm-powerpc/page_32.h~log2-provide-ilog2-fallbacks-for-powerpc
+++ a/include/asm-powerpc/page_32.h
@@ -26,15 +26,7 @@ extern void clear_pages(void *page, int 
 static inline void clear_page(void *page) { clear_pages(page, 0); }
 extern void copy_page(void *to, void *from);
 
-/* Pure 2^n version of get_order */
-extern __inline__ int get_order(unsigned long size)
-{
-	int lz;
-
-	size = (size-1) >> PAGE_SHIFT;
-	asm ("cntlzw %0,%1" : "=r" (lz) : "r" (size));
-	return 32 - lz;
-}
+#include <asm-generic/page.h>
 
 #endif /* __ASSEMBLY__ */
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
log2-provide-ilog2-fallbacks-for-powerpc.patch
alsa-workqueue-fixes.patch
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
s390-workqueue-fixes.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
workqueue-tweaks.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch

