From: akpm@osdl.org
Subject: - log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:38 -0800
Message-ID: <200612082005.kB8K5cNR002320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426325AbWLHUFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     LOG2: Alter get_order() so that it can make use of ilog2() on a constant
has been removed from the -mm tree.  Its filename was
     log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: LOG2: Alter get_order() so that it can make use of ilog2() on a constant
From: David Howells <dhowells@redhat.com>

Alter get_order() so that it can make use of ilog2() on a constant to produce
a constant value, retaining the ability for an arch to override it in the
non-const case.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/page.h |   38 +++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/page.h~log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant include/asm-generic/page.h
--- a/include/asm-generic/page.h~log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant
+++ a/include/asm-generic/page.h
@@ -4,21 +4,51 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#include <linux/compiler.h>
+#include <linux/log2.h>
 
-/* Pure 2^n version of get_order */
-static __inline__ __attribute_const__ int get_order(unsigned long size)
+/*
+ * non-const pure 2^n version of get_order
+ * - the arch may override these in asm/bitops.h if they can be implemented
+ *   more efficiently than using the arch log2 routines
+ * - we use the non-const log2() instead if the arch has defined one suitable
+ */
+#ifndef ARCH_HAS_GET_ORDER
+static inline __attribute__((const))
+int __get_order(unsigned long size, int page_shift)
 {
+#if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
+	int order = __ilog2_u32(size) - page_shift;
+	return order >= 0 ? order : 0;
+#elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)
+	int order = __ilog2_u64(size) - page_shift;
+	return order >= 0 ? order : 0;
+#else
 	int order;
 
-	size = (size - 1) >> (PAGE_SHIFT - 1);
+	size = (size - 1) >> (page_shift - 1);
 	order = -1;
 	do {
 		size >>= 1;
 		order++;
 	} while (size);
 	return order;
+#endif
 }
+#endif
+
+/**
+ * get_order - calculate log2(pages) to hold a block of the specified size
+ * @n - size
+ *
+ * calculate allocation order based on the current page size
+ * - this can be used to initialise global variables from constant data
+ */
+#define get_order(n)							\
+(									\
+	__builtin_constant_p(n) ?					\
+	((n < (1UL << PAGE_SHIFT)) ? 0 : ilog2(n) - PAGE_SHIFT) :	\
+	__get_order(n, PAGE_SHIFT)					\
+ )
 
 #endif	/* __ASSEMBLY__ */
 #endif	/* __KERNEL__ */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant.patch
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

