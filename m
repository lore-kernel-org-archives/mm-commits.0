From: akpm@linux-foundation.org
Subject: - x86-bitops_32h-style-cleanups.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:33 -0800
Message-ID: <200711192316.lAJNGX3p001778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbXKSX2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: bitops_32.h style cleanups
has been removed from the -mm tree.  Its filename was
     x86-bitops_32h-style-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: bitops_32.h style cleanups
From: Randy Dunlap <randy.dunlap@oracle.com>

Coding style cleanups in x86/bitops_32.h:

- drop space in "* addr"
- whitespace & indentation fixes
- spello fixes

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/bitops_32.h |   48 +++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff -puN include/asm-x86/bitops_32.h~x86-bitops_32h-style-cleanups include/asm-x86/bitops_32.h
--- a/include/asm-x86/bitops_32.h~x86-bitops_32h-style-cleanups
+++ a/include/asm-x86/bitops_32.h
@@ -37,7 +37,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile unsigned long * addr)
+static inline void set_bit(int nr, volatile unsigned long *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
@@ -54,7 +54,7 @@ static inline void set_bit(int nr, volat
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __set_bit(int nr, volatile unsigned long * addr)
+static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
 	__asm__(
 		"btsl %1,%0"
@@ -72,7 +72,7 @@ static inline void __set_bit(int nr, vol
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long * addr)
+static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
@@ -94,7 +94,7 @@ static inline void clear_bit_unlock(unsi
 	clear_bit(nr, addr);
 }
 
-static inline void __clear_bit(int nr, volatile unsigned long * addr)
+static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
 	__asm__ __volatile__(
 		"btrl %1,%0"
@@ -132,7 +132,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static inline void __change_bit(int nr, volatile unsigned long * addr)
+static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
 	__asm__ __volatile__(
 		"btcl %1,%0"
@@ -150,7 +150,7 @@ static inline void __change_bit(int nr, 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void change_bit(int nr, volatile unsigned long * addr)
+static inline void change_bit(int nr, volatile unsigned long *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
@@ -167,7 +167,7 @@ static inline void change_bit(int nr, vo
  * It may be reordered on other architectures than x86.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -199,7 +199,7 @@ static inline int test_and_set_bit_lock(
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
+static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -219,7 +219,7 @@ static inline int __test_and_set_bit(int
  * It can be reorderdered on other architectures other than x86.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
+static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -270,7 +270,7 @@ static inline int __test_and_change_bit(
  * This operation is atomic and cannot be reordered.  
  * It also implies a memory barrier.
  */
-static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
+static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -287,7 +287,7 @@ static inline int test_and_change_bit(in
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static int test_bit(int nr, const volatile void * addr);
+static int test_bit(int nr, const volatile void *addr);
 #endif
 
 static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
@@ -295,7 +295,7 @@ static __always_inline int constant_test
 	return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
 }
 
-static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
+static inline int variable_test_bit(int nr, const volatile unsigned long *addr)
 {
 	int oldbit;
 
@@ -306,10 +306,10 @@ static inline int variable_test_bit(int 
 	return oldbit;
 }
 
-#define test_bit(nr,addr) \
-(__builtin_constant_p(nr) ? \
- constant_test_bit((nr),(addr)) : \
- variable_test_bit((nr),(addr)))
+#define test_bit(nr, addr) \
+	(__builtin_constant_p(nr) ? \
+		constant_test_bit((nr), (addr)) : \
+		variable_test_bit((nr), (addr)))
 
 #undef ADDR
 
@@ -318,7 +318,7 @@ static inline int variable_test_bit(int 
  * @addr: The address to start the search at
  * @size: The maximum size to search
  *
- * Returns the bit-number of the first zero bit, not the number of the byte
+ * Returns the bit number of the first zero bit, not the number of the byte
  * containing a bit.
  */
 static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
@@ -348,7 +348,7 @@ static inline int find_first_zero_bit(co
 /**
  * find_next_zero_bit - find the first zero bit in a memory region
  * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
+ * @offset: The bit number to start searching at
  * @size: The maximum size to search
  */
 int find_next_zero_bit(const unsigned long *addr, int size, int offset);
@@ -372,7 +372,7 @@ static inline unsigned long __ffs(unsign
  * @addr: The address to start the search at
  * @size: The maximum size to search
  *
- * Returns the bit-number of the first set bit, not the number of the byte
+ * Returns the bit number of the first set bit, not the number of the byte
  * containing a bit.
  */
 static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
@@ -391,7 +391,7 @@ static inline unsigned find_first_bit(co
 /**
  * find_next_bit - find the first set bit in a memory region
  * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
+ * @offset: The bit number to start searching at
  * @size: The maximum size to search
  */
 int find_next_bit(const unsigned long *addr, int size, int offset);
@@ -460,10 +460,10 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
-#define ext2_set_bit_atomic(lock,nr,addr) \
-        test_and_set_bit((nr),(unsigned long*)addr)
-#define ext2_clear_bit_atomic(lock,nr, addr) \
-	        test_and_clear_bit((nr),(unsigned long*)addr)
+#define ext2_set_bit_atomic(lock, nr, addr) \
+		test_and_set_bit((nr), (unsigned long *)addr)
+#define ext2_clear_bit_atomic(lock, nr, addr) \
+		test_and_clear_bit((nr), (unsigned long *)addr)
 
 #include <asm-generic/bitops/minix.h>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
git-scsi-misc.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
