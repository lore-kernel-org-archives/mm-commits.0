From: akpm@linux-foundation.org
Subject: [merged] x86-mark-complex-bitopsh-inlines-as-__always_inline.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:03:55 -0800
Message-ID: <200901261903.n0QJ3tk3029304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051AbZAZTE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:04:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, hugh@veritas.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: mark complex bitops.h inlines as __always_inline
has been removed from the -mm tree.  Its filename was
     x86-mark-complex-bitopsh-inlines-as-__always_inline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: mark complex bitops.h inlines as __always_inline
From: Andi Kleen <andi@firstfloor.org>

Hugh Dickins noticed that older gcc versions when the kernel is built for
code size didn't inline some of the bitops.

Mark all complex x86 bitops that have more than a single asm statement or
two as always inline to avoid this problem.

Probably should be done for other architectures too.

Ingo then found a better fix that only requires a single line change, but
it unfortunately only works on gcc 4.3.

But unfortunately on older gccs the original patch still makes a large
difference with CONFIG_OPTIMIZE_INLINING.

e.g.  with gcc 4.1 and defconfig like build:

6116998 1138540  883788 8139326  7c323e vmlinux-oi-with-patch
6137043 1138540  883788 8159371  7c808b vmlinux-optimize-inlining

~20k difference.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/bitops.h      |   14 ++++++++++----
 include/asm-generic/bitops/__ffs.h |    2 +-
 include/asm-generic/bitops/__fls.h |    2 +-
 include/asm-generic/bitops/fls.h   |    2 +-
 include/asm-generic/bitops/fls64.h |    4 ++--
 5 files changed, 15 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/bitops.h~x86-mark-complex-bitopsh-inlines-as-__always_inline arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~x86-mark-complex-bitopsh-inlines-as-__always_inline
+++ a/arch/x86/include/asm/bitops.h
@@ -3,6 +3,9 @@
 
 /*
  * Copyright 1992, Linus Torvalds.
+ *
+ * Note: inlines with more than a single statement should be marked
+ * __always_inline to avoid problems with older gcc's inlining heuristics.
  */
 
 #ifndef _LINUX_BITOPS_H
@@ -53,7 +56,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
+static __always_inline void
+set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -90,7 +94,8 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static __always_inline void
+clear_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -204,7 +209,8 @@ static inline int test_and_set_bit(int n
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static __always_inline int
+test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -300,7 +306,7 @@ static inline int test_and_change_bit(in
 	return oldbit;
 }
 
-static inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
diff -puN include/asm-generic/bitops/__ffs.h~x86-mark-complex-bitopsh-inlines-as-__always_inline include/asm-generic/bitops/__ffs.h
--- a/include/asm-generic/bitops/__ffs.h~x86-mark-complex-bitopsh-inlines-as-__always_inline
+++ a/include/asm-generic/bitops/__ffs.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static inline unsigned long __ffs(unsigned long word)
+static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
diff -puN include/asm-generic/bitops/__fls.h~x86-mark-complex-bitopsh-inlines-as-__always_inline include/asm-generic/bitops/__fls.h
--- a/include/asm-generic/bitops/__fls.h~x86-mark-complex-bitopsh-inlines-as-__always_inline
+++ a/include/asm-generic/bitops/__fls.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no set bit exists, so code should check against 0 first.
  */
-static inline unsigned long __fls(unsigned long word)
+static __always_inline unsigned long __fls(unsigned long word)
 {
 	int num = BITS_PER_LONG - 1;
 
diff -puN include/asm-generic/bitops/fls.h~x86-mark-complex-bitopsh-inlines-as-__always_inline include/asm-generic/bitops/fls.h
--- a/include/asm-generic/bitops/fls.h~x86-mark-complex-bitopsh-inlines-as-__always_inline
+++ a/include/asm-generic/bitops/fls.h
@@ -9,7 +9,7 @@
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
 
-static inline int fls(int x)
+static __always_inline int fls(int x)
 {
 	int r = 32;
 
diff -puN include/asm-generic/bitops/fls64.h~x86-mark-complex-bitopsh-inlines-as-__always_inline include/asm-generic/bitops/fls64.h
--- a/include/asm-generic/bitops/fls64.h~x86-mark-complex-bitopsh-inlines-as-__always_inline
+++ a/include/asm-generic/bitops/fls64.h
@@ -15,7 +15,7 @@
  * at position 64.
  */
 #if BITS_PER_LONG == 32
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
 	if (h)
@@ -23,7 +23,7 @@ static inline int fls64(__u64 x)
 	return fls(x);
 }
 #elif BITS_PER_LONG == 64
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	if (x == 0)
 		return 0;
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
x86-simplify-highmem-related-kconfig-entries.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch

