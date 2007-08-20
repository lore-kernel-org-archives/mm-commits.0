From: akpm@linux-foundation.org
Subject: + define-first-set-of-bit-macros.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:34 -0700
Message-ID: <200708202042.l7KKgYXD022241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49590 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761626AbXHTUnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     define first set of BIT* macros
has been added to the -mm tree.  Its filename is
     define-first-set-of-bit-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: define first set of BIT* macros
From: Jiri Slaby <jirislaby@gmail.com>

define first set of BIT* macros

- move BITOP_MASK and BITOP_WORD from asm-generic/bitops/atomic.h to
  include/linux/bitops.h and rename it to BIT_MASK and BIT_WORD
- move BITS_TO_LONGS and BITS_PER_BYTE to bitops.h too and allow easily
  define another BITS_TO_something (e.g. in event.c) by BITS_TO_TYPE macro
Remaining (and common) BIT macro will be defined after all occurences and
conflicts will be sorted out in the patches.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/atomic.h     |   27 +++++++++-----------
 include/asm-generic/bitops/non-atomic.h |   29 +++++++++-------------
 include/linux/bitops.h                  |    8 ++++++
 include/linux/types.h                   |    3 --
 4 files changed, 33 insertions(+), 34 deletions(-)

diff -puN include/asm-generic/bitops/atomic.h~define-first-set-of-bit-macros include/asm-generic/bitops/atomic.h
--- a/include/asm-generic/bitops/atomic.h~define-first-set-of-bit-macros
+++ a/include/asm-generic/bitops/atomic.h
@@ -3,9 +3,6 @@
 
 #include <asm/types.h>
 
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
 #include <asm/cache.h>		/* we use L1_CACHE_BYTES */
@@ -66,8 +63,8 @@ extern raw_spinlock_t __atomic_hash[ATOM
  */
 static inline void set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long flags;
 
 	_atomic_spin_lock_irqsave(p, flags);
@@ -87,8 +84,8 @@ static inline void set_bit(int nr, volat
  */
 static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long flags;
 
 	_atomic_spin_lock_irqsave(p, flags);
@@ -108,8 +105,8 @@ static inline void clear_bit(int nr, vol
  */
 static inline void change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long flags;
 
 	_atomic_spin_lock_irqsave(p, flags);
@@ -128,8 +125,8 @@ static inline void change_bit(int nr, vo
  */
 static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;
 
@@ -152,8 +149,8 @@ static inline int test_and_set_bit(int n
  */
 static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;
 
@@ -175,8 +172,8 @@ static inline int test_and_clear_bit(int
  */
 static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old;
 	unsigned long flags;
 
diff -puN include/asm-generic/bitops/non-atomic.h~define-first-set-of-bit-macros include/asm-generic/bitops/non-atomic.h
--- a/include/asm-generic/bitops/non-atomic.h~define-first-set-of-bit-macros
+++ a/include/asm-generic/bitops/non-atomic.h
@@ -3,9 +3,6 @@
 
 #include <asm/types.h>
 
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
 /**
  * __set_bit - Set a bit in memory
  * @nr: the bit to set
@@ -17,16 +14,16 @@
  */
 static inline void __set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p  |= mask;
 }
 
 static inline void __clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p &= ~mask;
 }
@@ -42,8 +39,8 @@ static inline void __clear_bit(int nr, v
  */
 static inline void __change_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 
 	*p ^= mask;
 }
@@ -59,8 +56,8 @@ static inline void __change_bit(int nr, 
  */
 static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old | mask;
@@ -78,8 +75,8 @@ static inline int __test_and_set_bit(int
  */
 static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old & ~mask;
@@ -90,8 +87,8 @@ static inline int __test_and_clear_bit(i
 static inline int __test_and_change_bit(int nr,
 					    volatile unsigned long *addr)
 {
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
 	unsigned long old = *p;
 
 	*p = old ^ mask;
@@ -105,7 +102,7 @@ static inline int __test_and_change_bit(
  */
 static inline int test_bit(int nr, const volatile unsigned long *addr)
 {
-	return 1UL & (addr[BITOP_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
 
 #endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
diff -puN include/linux/bitops.h~define-first-set-of-bit-macros include/linux/bitops.h
--- a/include/linux/bitops.h~define-first-set-of-bit-macros
+++ a/include/linux/bitops.h
@@ -2,6 +2,14 @@
 #define _LINUX_BITOPS_H
 #include <asm/types.h>
 
+#ifdef	__KERNEL__
+#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
+#define BITS_TO_TYPE(nr, t)	(((nr)+(t)-1)/(t))
+#define BITS_TO_LONGS(nr)	BITS_TO_TYPE(nr, BITS_PER_LONG)
+#define BITS_PER_BYTE		8
+#endif
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
diff -puN include/linux/types.h~define-first-set-of-bit-macros include/linux/types.h
--- a/include/linux/types.h~define-first-set-of-bit-macros
+++ a/include/linux/types.h
@@ -3,12 +3,9 @@
 
 #ifdef	__KERNEL__
 
-#define BITS_TO_LONGS(bits) \
-	(((bits)+BITS_PER_LONG-1)/BITS_PER_LONG)
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
 
-#define BITS_PER_BYTE 8
 #endif
 
 #include <linux/posix_types.h>
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
