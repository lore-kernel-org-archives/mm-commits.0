From: akpm@linux-foundation.org
Subject: - mips-lock-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:25 -0700
Message-ID: <200710190345.l9J3jPAv013218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934331AbXJSDzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: lock bitops
has been removed from the -mm tree.  Its filename was
     mips-lock-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: lock bitops
From: Nick Piggin <npiggin@suse.de>

mips can avoid one mb when acquiring a lock with test_and_set_bit_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/bitops.h |   97 +++++++++++++++++++++++++++++++++++-
 1 file changed, 96 insertions(+), 1 deletion(-)

diff -puN include/asm-mips/bitops.h~mips-lock-bitops include/asm-mips/bitops.h
--- a/include/asm-mips/bitops.h~mips-lock-bitops
+++ a/include/asm-mips/bitops.h
@@ -172,6 +172,20 @@ static inline void clear_bit(unsigned lo
 }
 
 /*
+ * clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock.
+ */
+static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+	smp_mb__before_clear_bit();
+	clear_bit(nr, addr);
+}
+
+/*
  * change_bit - Toggle a bit in memory
  * @nr: Bit to change
  * @addr: Address to start counting from
@@ -297,6 +311,73 @@ static inline int test_and_set_bit(unsig
 }
 
 /*
+ * test_and_set_bit_lock - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and implies acquire ordering semantics
+ * after the memory operation.
+ */
+static inline int test_and_set_bit_lock(unsigned long nr,
+	volatile unsigned long *addr)
+{
+	unsigned short bit = nr & SZLONG_MASK;
+	unsigned long res;
+
+	if (cpu_has_llsc && R10000_LLSC_WAR) {
+		unsigned long *m = ((unsigned long *) addr) + (nr >> SZLONG_LOG);
+		unsigned long temp;
+
+		__asm__ __volatile__(
+		"	.set	mips3					\n"
+		"1:	" __LL "%0, %1		# test_and_set_bit	\n"
+		"	or	%2, %0, %3				\n"
+		"	" __SC	"%2, %1					\n"
+		"	beqzl	%2, 1b					\n"
+		"	and	%2, %0, %3				\n"
+		"	.set	mips0					\n"
+		: "=&r" (temp), "=m" (*m), "=&r" (res)
+		: "r" (1UL << bit), "m" (*m)
+		: "memory");
+	} else if (cpu_has_llsc) {
+		unsigned long *m = ((unsigned long *) addr) + (nr >> SZLONG_LOG);
+		unsigned long temp;
+
+		__asm__ __volatile__(
+		"	.set	push					\n"
+		"	.set	noreorder				\n"
+		"	.set	mips3					\n"
+		"1:	" __LL "%0, %1		# test_and_set_bit	\n"
+		"	or	%2, %0, %3				\n"
+		"	" __SC	"%2, %1					\n"
+		"	beqz	%2, 2f					\n"
+		"	 and	%2, %0, %3				\n"
+		"	.subsection 2					\n"
+		"2:	b	1b					\n"
+		"	 nop						\n"
+		"	.previous					\n"
+		"	.set	pop					\n"
+		: "=&r" (temp), "=m" (*m), "=&r" (res)
+		: "r" (1UL << bit), "m" (*m)
+		: "memory");
+	} else {
+		volatile unsigned long *a = addr;
+		unsigned long mask;
+		unsigned long flags;
+
+		a += nr >> SZLONG_LOG;
+		mask = 1UL << bit;
+		raw_local_irq_save(flags);
+		res = (mask & *a);
+		*a |= mask;
+		raw_local_irq_restore(flags);
+	}
+
+	smp_llsc_mb();
+
+	return res != 0;
+}
+/*
  * test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear
  * @addr: Address to count from
@@ -459,6 +540,21 @@ static inline int test_and_change_bit(un
 #include <asm-generic/bitops/non-atomic.h>
 
 /*
+ * __clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * __clear_bit() is non-atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock if no other CPUs can concurrently
+ * modify other bits in the word.
+ */
+static inline void __clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+	smp_mb();
+	__clear_bit(nr, addr);
+}
+
+/*
  * Return the bit position (0..63) of the most significant 1 bit in a word
  * Returns -1 if no 1 bit exists
  */
@@ -562,7 +658,6 @@ static inline int ffs(int word)
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
-#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch
