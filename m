From: akpm@linux-foundation.org
Subject: - use-__fls-for-fls64-on-64-bit-archs.patch removed from -mm tree
Date: Sun, 27 Apr 2008 11:36:52 -0700
Message-ID: <200804271836.m3RIaqfw019368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758107AbYD0Sje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heukelum@mailshack.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, heukelum@fastmail.fm, ink@jurassic.park.msu.ru, kyle@mcmar


The patch titled
     Use __fls for fls64 on 64-bit archs
has been removed from the -mm tree.  Its filename was
     use-__fls-for-fls64-on-64-bit-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use __fls for fls64 on 64-bit archs
From: Alexander van Heukelum <heukelum@mailshack.com>

Use __fls for fls64 on 64-bit archs.  The implementation for 64-bit archs is
moved from x86_64 to asm-generic.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/fls64.h |   22 ++++++++++++++++++++++
 include/asm-x86/bitops_64.h        |   15 ++-------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff -puN include/asm-generic/bitops/fls64.h~use-__fls-for-fls64-on-64-bit-archs include/asm-generic/bitops/fls64.h
--- a/include/asm-generic/bitops/fls64.h~use-__fls-for-fls64-on-64-bit-archs
+++ a/include/asm-generic/bitops/fls64.h
@@ -3,6 +3,18 @@
 
 #include <asm/types.h>
 
+/**
+ * fls64 - find last set bit in a 64-bit word
+ * @x: the word to search
+ *
+ * This is defined in a similar way as the libc and compiler builtin
+ * ffsll, but returns the position of the most significant set bit.
+ *
+ * fls64(value) returns 0 if value is 0 or the position of the last
+ * set bit if value is nonzero. The last (most significant) bit is
+ * at position 64.
+ */
+#if BITS_PER_LONG == 32
 static inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
@@ -10,5 +22,15 @@ static inline int fls64(__u64 x)
 		return fls(h) + 32;
 	return fls(x);
 }
+#elif BITS_PER_LONG == 64
+static inline int fls64(__u64 x)
+{
+	if (x == 0)
+		return 0;
+	return __fls(x) + 1;
+}
+#else
+#error BITS_PER_LONG not 32 or 64
+#endif
 
 #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
diff -puN include/asm-x86/bitops_64.h~use-__fls-for-fls64-on-64-bit-archs include/asm-x86/bitops_64.h
--- a/include/asm-x86/bitops_64.h~use-__fls-for-fls64-on-64-bit-archs
+++ a/include/asm-x86/bitops_64.h
@@ -112,19 +112,6 @@ static inline int ffs(int x)
 }
 
 /**
- * fls64 - find last bit set in 64 bit word
- * @x: the word to search
- *
- * This is defined the same way as fls.
- */
-static inline int fls64(__u64 x)
-{
-	if (x == 0)
-		return 0;
-	return __fls(x) + 1;
-}
