From: akpm@linux-foundation.org
Subject: + bitops-make-asm-generic-bitops-findh-more-generic.patch added to -mm tree
Date: Tue, 05 Oct 2010 15:11:09 -0700
Message-ID: <201010052211.o95MB9YB023081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040Ab0JEWL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 18:11:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arnd@arndb.de, cmetcalf@tilera.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     bitops: make asm-generic/bitops/find.h more generic
has been added to the -mm tree.  Its filename is
     bitops-make-asm-generic-bitops-findh-more-generic.patch

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
Subject: bitops: make asm-generic/bitops/find.h more generic
From: Akinobu Mita <akinobu.mita@gmail.com>

asm-generic/bitops/find.h has the extern declarations of find_next_bit()
and find_next_zero_bit() and the macro definitions of find_first_bit() and
find_first_zero_bit().  It is only usable by the architectures which
enables CONFIG_GENERIC_FIND_NEXT_BIT and disables
CONFIG_GENERIC_FIND_FIRST_BIT.

x86 and tile enable both CONFIG_GENERIC_FIND_NEXT_BIT and
CONFIG_GENERIC_FIND_FIRST_BIT.  These architectures cannot include
asm-generic/bitops/find.h in their asm/bitops.h.  So ifdefed extern
declarations of find_first_bit and find_first_zero_bit() are put in
linux/bitops.h.

This makes asm-generic/bitops/find.h usable by these architectures and use
it.  Also this change is needed for the forthcoming duplicated extern
declarations cleanup.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/include/asm/bitops.h    |    1 +
 arch/x86/include/asm/bitops.h     |    2 ++
 include/asm-generic/bitops/find.h |   25 +++++++++++++++++++++++++
 include/linux/bitops.h            |   22 ----------------------
 4 files changed, 28 insertions(+), 22 deletions(-)

diff -puN arch/tile/include/asm/bitops.h~bitops-make-asm-generic-bitops-findh-more-generic arch/tile/include/asm/bitops.h
--- a/arch/tile/include/asm/bitops.h~bitops-make-asm-generic-bitops-findh-more-generic
+++ a/arch/tile/include/asm/bitops.h
@@ -120,6 +120,7 @@ static inline unsigned long __arch_hweig
 
 #include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
+#include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/minix.h>
diff -puN arch/x86/include/asm/bitops.h~bitops-make-asm-generic-bitops-findh-more-generic arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~bitops-make-asm-generic-bitops-findh-more-generic
+++ a/arch/x86/include/asm/bitops.h
@@ -440,6 +440,8 @@ static inline int fls(int x)
 
 #ifdef __KERNEL__
 
+#include <asm-generic/bitops/find.h>
+
 #include <asm-generic/bitops/sched.h>
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
diff -puN include/asm-generic/bitops/find.h~bitops-make-asm-generic-bitops-findh-more-generic include/asm-generic/bitops/find.h
--- a/include/asm-generic/bitops/find.h~bitops-make-asm-generic-bitops-findh-more-generic
+++ a/include/asm-generic/bitops/find.h
@@ -9,7 +9,32 @@ extern unsigned long find_next_zero_bit(
 		long size, unsigned long offset);
 #endif
 
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first set bit.
+ */
+extern unsigned long find_first_bit(const unsigned long *addr,
+				    unsigned long size);
+
+/**
+ * find_first_zero_bit - find the first cleared bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first cleared bit.
+ */
+extern unsigned long find_first_zero_bit(const unsigned long *addr,
+					 unsigned long size);
+#else /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
 #define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
 
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
 #endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
diff -puN include/linux/bitops.h~bitops-make-asm-generic-bitops-findh-more-generic include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-make-asm-generic-bitops-findh-more-generic
+++ a/include/linux/bitops.h
@@ -136,28 +136,6 @@ static inline unsigned long __ffs64(u64 
 }
 
 #ifdef __KERNEL__
-#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first set bit.
- */
-extern unsigned long find_first_bit(const unsigned long *addr,
-				    unsigned long size);
