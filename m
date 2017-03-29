From: akpm@linux-foundation.org
Subject: + x86-asm-generic-add-kasan-instrumentation-to-bitops.patch added to -mm tree
Date: Wed, 29 Mar 2017 15:28:02 -0700
Message-ID: <58dc34f2.23Yvg9iS2kukbiht%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbdC2W2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 18:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, mark.rutland@arm.com, mingo@redhat.com, peterz@infradead.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, asm-generic: add KASAN instrumentation to bitops
has been added to the -mm tree.  Its filename is
     x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-asm-generic-add-kasan-instrumentation-to-bitops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: x86, asm-generic: add KASAN instrumentation to bitops

Instrument bitops similarly to atomicops.
See the following patches for details:
asm-generic, x86: wrap atomic operations
asm-generic: add KASAN instrumentation to atomic operations

Link: http://lkml.kernel.org/r/20170322150915.138175-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/bitops.h             |   95 ++++++++++----------
 include/asm-generic/bitops-instrumented.h |   53 +++++++++++
 2 files changed, 103 insertions(+), 45 deletions(-)

diff -puN arch/x86/include/asm/bitops.h~x86-asm-generic-add-kasan-instrumentation-to-bitops arch/x86/include/asm/bitops.h
--- a/arch/x86/include/asm/bitops.h~x86-asm-generic-add-kasan-instrumentation-to-bitops
+++ a/arch/x86/include/asm/bitops.h
@@ -54,11 +54,11 @@
 #define CONST_MASK(nr)			(1 << ((nr) & 7))
 
 /**
- * set_bit - Atomically set a bit in memory
+ * arch_set_bit - Atomically set a bit in memory
  * @nr: the bit to set
  * @addr: the address to start counting from
  *
- * This function is atomic and may not be reordered.  See __set_bit()
+ * This function is atomic and may not be reordered.  See arch___set_bit()
  * if you do not require the atomic guarantees.
  *
  * Note: there are no guarantees that this function will not be reordered
@@ -69,7 +69,7 @@
  * restricted to acting on a single-word quantity.
  */
 static __always_inline void
-set_bit(long nr, volatile unsigned long *addr)
+arch_set_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -83,31 +83,32 @@ set_bit(long nr, volatile unsigned long
 }
 
 /**
- * __set_bit - Set a bit in memory
+ * arch___set_bit - Set a bit in memory
  * @nr: the bit to set
  * @addr: the address to start counting from
  *
- * Unlike set_bit(), this function is non-atomic and may be reordered.
+ * Unlike arch_set_bit(), this function is non-atomic and may be reordered.
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static __always_inline void __set_bit(long nr, volatile unsigned long *addr)
+static __always_inline void
+arch___set_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
 /**
- * clear_bit - Clears a bit in memory
+ * arch_clear_bit - Clears a bit in memory
  * @nr: Bit to clear
  * @addr: Address to start counting from
  *
- * clear_bit() is atomic and may not be reordered.  However, it does
+ * arch_clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
  * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __always_inline void
-clear_bit(long nr, volatile unsigned long *addr)
+arch_clear_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -121,25 +122,25 @@ clear_bit(long nr, volatile unsigned lon
 }
 
 /*
- * clear_bit_unlock - Clears a bit in memory
+ * arch_clear_bit_unlock - Clears a bit in memory
  * @nr: Bit to clear
  * @addr: Address to start counting from
  *
- * clear_bit() is atomic and implies release semantics before the memory
- * operation. It can be used for an unlock.
+ * arch_clear_bit_unlock() is atomic and implies release semantics before the
+ * memory operation. It can be used for an unlock.
  */
-static __always_inline void clear_bit_unlock(long nr, volatile unsigned long *addr)
+static __always_inline void arch_clear_bit_unlock(long nr, volatile unsigned long *addr)
 {
 	barrier();
-	clear_bit(nr, addr);
+	arch_clear_bit(nr, addr);
 }
 
-static __always_inline void __clear_bit(long nr, volatile unsigned long *addr)
+static __always_inline void arch___clear_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
 }
 
-static __always_inline bool clear_bit_unlock_is_negative_byte(long nr, volatile unsigned long *addr)
+static __always_inline bool arch_clear_bit_unlock_is_negative_byte(long nr, volatile unsigned long *addr)
 {
 	bool negative;
 	asm volatile(LOCK_PREFIX "andb %2,%1\n\t"
@@ -153,47 +154,49 @@ static __always_inline bool clear_bit_un
 #define clear_bit_unlock_is_negative_byte clear_bit_unlock_is_negative_byte
 
 /*
- * __clear_bit_unlock - Clears a bit in memory
+ * arch___clear_bit_unlock - Clears a bit in memory
  * @nr: Bit to clear
  * @addr: Address to start counting from
  *
- * __clear_bit() is non-atomic and implies release semantics before the memory
- * operation. It can be used for an unlock if no other CPUs can concurrently
- * modify other bits in the word.
+ * arch___clear_bit_unlock() is non-atomic and implies release semantics before
+ * the memory operation. It can be used for an unlock if no other CPUs can
+ * concurrently modify other bits in the word.
  *
  * No memory barrier is required here, because x86 cannot reorder stores past
  * older loads. Same principle as spin_unlock.
  */
-static __always_inline void __clear_bit_unlock(long nr, volatile unsigned long *addr)
+static __always_inline void arch___clear_bit_unlock(long nr, volatile unsigned long *addr)
 {
 	barrier();
-	__clear_bit(nr, addr);
+	arch___clear_bit(nr, addr);
 }
 
 /**
- * __change_bit - Toggle a bit in memory
+ * arch___change_bit - Toggle a bit in memory
  * @nr: the bit to change
  * @addr: the address to start counting from
  *
- * Unlike change_bit(), this function is non-atomic and may be reordered.
+ * Unlike arch_change_bit(), this function is non-atomic and may be reordered.
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static __always_inline void __change_bit(long nr, volatile unsigned long *addr)
+static __always_inline void
+arch___change_bit(long nr, volatile unsigned long *addr)
 {
 	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
 }
 
 /**
- * change_bit - Toggle a bit in memory
+ * arch_change_bit - Toggle a bit in memory
  * @nr: Bit to change
  * @addr: Address to start counting from
  *
- * change_bit() is atomic and may not be reordered.
+ * arch_change_bit() is atomic and may not be reordered.
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static __always_inline void change_bit(long nr, volatile unsigned long *addr)
+static __always_inline void
+arch_change_bit(long nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "xorb %1,%0"
@@ -207,33 +210,33 @@ static __always_inline void change_bit(l
 }
 
 /**
- * test_and_set_bit - Set a bit and return its old value
+ * arch_test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static __always_inline bool test_and_set_bit(long nr, volatile unsigned long *addr)
+static __always_inline bool arch_test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, "Ir", nr, "%0", c);
 }
 
 /**
- * test_and_set_bit_lock - Set a bit and return its old value for lock
+ * arch_test_and_set_bit_lock - Set a bit and return its old value for lock
  * @nr: Bit to set
  * @addr: Address to count from
  *
- * This is the same as test_and_set_bit on x86.
+ * This is the same as arch_test_and_set_bit on x86.
  */
 static __always_inline bool
-test_and_set_bit_lock(long nr, volatile unsigned long *addr)
+arch_test_and_set_bit_lock(long nr, volatile unsigned long *addr)
 {
-	return test_and_set_bit(nr, addr);
+	return arch_test_and_set_bit(nr, addr);
 }
 
 /**
- * __test_and_set_bit - Set a bit and return its old value
+ * arch___test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
  *
@@ -241,7 +244,7 @@ test_and_set_bit_lock(long nr, volatile
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static __always_inline bool __test_and_set_bit(long nr, volatile unsigned long *addr)
+static __always_inline bool arch___test_and_set_bit(long nr, volatile unsigned long *addr)
 {
 	bool oldbit;
 
@@ -253,20 +256,20 @@ static __always_inline bool __test_and_s
 }
 
 /**
- * test_and_clear_bit - Clear a bit and return its old value
+ * arch_test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static __always_inline bool test_and_clear_bit(long nr, volatile unsigned long *addr)
+static __always_inline bool arch_test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, "Ir", nr, "%0", c);
 }
 
 /**
- * __test_and_clear_bit - Clear a bit and return its old value
+ * arch___test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear
  * @addr: Address to count from
  *
@@ -281,7 +284,7 @@ static __always_inline bool test_and_cle
  * accessed from a hypervisor on the same CPU if running in a VM: don't change
  * this without also updating arch/x86/kernel/kvm.c
  */
-static __always_inline bool __test_and_clear_bit(long nr, volatile unsigned long *addr)
+static __always_inline bool arch___test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
 	bool oldbit;
 
@@ -293,7 +296,7 @@ static __always_inline bool __test_and_c
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static __always_inline bool __test_and_change_bit(long nr, volatile unsigned long *addr)
+static __always_inline bool arch___test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	bool oldbit;
 
@@ -306,14 +309,14 @@ static __always_inline bool __test_and_c
 }
 
 /**
- * test_and_change_bit - Change a bit and return its old value
+ * arch_test_and_change_bit - Change a bit and return its old value
  * @nr: Bit to change
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static __always_inline bool test_and_change_bit(long nr, volatile unsigned long *addr)
+static __always_inline bool arch_test_and_change_bit(long nr, volatile unsigned long *addr)
 {
 	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, "Ir", nr, "%0", c);
 }
@@ -342,10 +345,10 @@ static __always_inline bool variable_tes
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static bool test_bit(int nr, const volatile unsigned long *addr);
+static bool arch_test_bit(int nr, const volatile unsigned long *addr);
 #endif
 
-#define test_bit(nr, addr)			\
+#define arch_test_bit(nr, addr)			\
 	(__builtin_constant_p((nr))		\
 	 ? constant_test_bit((nr), (addr))	\
 	 : variable_test_bit((nr), (addr)))
@@ -506,6 +509,8 @@ static __always_inline int fls64(__u64 x
 #include <asm-generic/bitops/fls64.h>
 #endif
 
+#include <asm-generic/bitops-instrumented.h>
+
 #include <asm-generic/bitops/find.h>
 
 #include <asm-generic/bitops/sched.h>
diff -puN /dev/null include/asm-generic/bitops-instrumented.h
--- /dev/null
+++ a/include/asm-generic/bitops-instrumented.h
@@ -0,0 +1,53 @@
+/* See atomic-instrumented.h for explanation. */
+#ifndef _LINUX_BITOPS_INSTRUMENTED_H
+#define _LINUX_BITOPS_INSTRUMENTED_H
+
+#include <linux/kasan-checks.h>
+
+#define ADDR(nr, addr) ((void *)(addr) + ((nr) >> 3))
+
+#define INSTR_VOID(func)						\
+static __always_inline void func(long nr, volatile unsigned long *addr)	\
+{									\
+	kasan_check_write(ADDR(nr, addr), 1);				\
+	arch_##func(nr, addr);						\
+}
+
+#define INSTR_BOOL(func)						\
+static __always_inline bool func(long nr, volatile unsigned long *addr)	\
+{									\
+	kasan_check_write(ADDR(nr, addr), 1);				\
+	return arch_##func(nr, addr);					\
+}
+
+INSTR_VOID(set_bit);
+INSTR_VOID(__set_bit);
+INSTR_VOID(clear_bit);
+INSTR_VOID(__clear_bit);
+INSTR_VOID(clear_bit_unlock);
+INSTR_VOID(__clear_bit_unlock);
+INSTR_VOID(change_bit);
+INSTR_VOID(__change_bit);
+
+INSTR_BOOL(test_and_set_bit);
+INSTR_BOOL(test_and_set_bit_lock);
+INSTR_BOOL(__test_and_set_bit);
+INSTR_BOOL(test_and_clear_bit);
+INSTR_BOOL(__test_and_clear_bit);
+INSTR_BOOL(test_and_change_bit);
+INSTR_BOOL(__test_and_change_bit);
+#ifdef clear_bit_unlock_is_negative_byte
+INSTR_BOOL(clear_bit_unlock_is_negative_byte);
+#endif
+
+static bool test_bit(int nr, const volatile unsigned long *addr)
+{
+	kasan_check_read(ADDR(nr, addr), 1);
+	return arch_test_bit(nr, addr);
+}
+
+#undef ADDR
+#undef INSTR_VOID
+#undef INSTR_BOOL
+
+#endif /* _LINUX_BITOPS_INSTRUMENTED_H */
_

Patches currently in -mm which might be from dvyukov@google.com are

fault-inject-support-systematic-fault-injection.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch
asm-generic-fix-compilation-failure-in-cmpxchg_double.patch
x86-remove-unused-atomic_inc_short.patch
x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

