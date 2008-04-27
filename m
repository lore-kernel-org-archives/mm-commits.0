From: akpm@linux-foundation.org
Subject: - introduce-a-generic-__fls-implementation.patch removed from -mm tree
Date: Sun, 27 Apr 2008 11:36:41 -0700
Message-ID: <200804271836.m3RIafZT019362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759528AbYD0Sje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heukelum@mailshack.com, benh@kernel.crashing.org, davem@davemloft.net, grundler@parisc-linux.org, heiko.carstens@de.ibm.com, heukelum@fastmail.fm, ink@jurassic.park.msu.ru, kyle@mcmar


The patch titled
     Introduce a generic __fls implementation
has been removed from the -mm tree.  Its filename was
     introduce-a-generic-__fls-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Introduce a generic __fls implementation
From: Alexander van Heukelum <heukelum@mailshack.com>

This series of patches:

[1/3] adds __fls.h to asm-generic
[2/3] modifies asm-*/bitops.h for 64-bit archs to implement __fls
[3/3] modifies asm-generic/fls64.h to make use of __fls

I have compiled i386 and x86_64, and they generate the same code as before the
change.  These patches make one tiny bit of the x86-unification a tiny bit
cleaner.



This patch:

Add a generic __fls implementation in the same spirit as the generic __ffs
one.  It finds the last (most significant) set bit in the given long value.

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

 include/asm-generic/bitops/__fls.h |   43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN /dev/null include/asm-generic/bitops/__fls.h
--- /dev/null
+++ a/include/asm-generic/bitops/__fls.h
@@ -0,0 +1,43 @@
+#ifndef _ASM_GENERIC_BITOPS___FLS_H_
+#define _ASM_GENERIC_BITOPS___FLS_H_
+
+#include <asm/types.h>
+
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	int num = BITS_PER_LONG - 1;
+
+#if BITS_PER_LONG == 64
+	if (!(word & (~0ul << 32))) {
+		num -= 32;
+		word <<= 32;
+	}
+#endif
+	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
+		num -= 16;
+		word <<= 16;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-8)))) {
+		num -= 8;
+		word <<= 8;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-4)))) {
+		num -= 4;
+		word <<= 4;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-2)))) {
+		num -= 2;
+		word <<= 2;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-1))))
+		num -= 1;
+	return num;
+}
+
+#endif /* _ASM_GENERIC_BITOPS___FLS_H_ */
_

Patches currently in -mm which might be from heukelum@mailshack.com are

origin.patch

