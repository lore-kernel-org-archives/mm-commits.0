From: akpm@linux-foundation.org
Subject: + mips-lock-bitops.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:37:31 -0700
Message-ID: <200708311837.l7VIbVGs021079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965879AbXHaSho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, ralf@linux-mips.org


The patch titled
     mips: lock bitops
has been added to the -mm tree.  Its filename is
     mips-lock-bitops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: lock bitops
From: Nick Piggin <npiggin@suse.de>

mips can avoid one mb when acquiring a lock with test_and_set_bit_lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/bitops.h |   97 +++++++++++++++++++++++++++++++++++-
 1 files changed, 96 insertions(+), 1 deletion(-)

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

remove-zero_page.patch
mm-use-lockless-radix-tree-probe.patch
mm-improve-find_lock_page.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
fs-fix-nobh-error-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
introduce-write_begin-write_end-aops-fix2.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
implement-simple-fs-aops-fix.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext2-convert-to-new-aops-fix.patch
ext2-convert-to-new-aops-fix2.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext3-convert-to-new-aops-fix-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix-fix.patch
xfs-convert-to-new-aops.patch
gfs2-convert-to-new-aops-fix.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-convert-to-new-aops-fix2.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
ufs-convert-to-new-aops-fix2.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops-fix2.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
minix-convert-to-new-aops-fix2.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
make-swappiness-safer-to-use.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
