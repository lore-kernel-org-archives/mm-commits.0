From: akpm@linux-foundation.org
Subject: + separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:56:38 -0700
Message-ID: <200808222056.m7MKucHA016131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbYHVU5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, linux-arch@vger.kernel.org


The patch titled
     Separate atomic_t declaration from asm/atomic.h into asm/atomic_def.h
has been added to the -mm tree.  Its filename is
     separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Separate atomic_t declaration from asm/atomic.h into asm/atomic_def.h
From: Huang Ying <ying.huang@intel.com>

asm/atomic.h contains both declaration and implementation of atomic_t.  So
there are some implementation related files included in asm/atomic.h.  And
atomic_t is a typedef.  Combination of above makes it impossible to use
atomic_t in files included by atomic.h.  Such as atomic_t can not be used
in linux/kernel.h on i386, because it is included by asm/atomic.h.

It is reasonable to separate declaration from implementation.  So a new
file atomic_def.h is added for every architecture to accommodate the
declaration of atomic_t.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h     |   10 +---------
 arch/arm/include/asm/atomic.h       |    3 +--
 arch/avr32/include/asm/atomic.h     |    2 +-
 arch/h8300/include/asm/atomic.h     |    3 ++-
 arch/ia64/include/asm/atomic.h      |    8 +-------
 arch/m68knommu/include/asm/atomic.h |    2 +-
 arch/powerpc/include/asm/atomic.h   |    2 +-
 arch/s390/include/asm/atomic.h      |    4 +---
 include/asm-alpha/atomic_def.h      |   13 +++++++++++++
 include/asm-arm/atomic_def.h        |    6 ++++++
 include/asm-avr32/atomic_def.h      |    6 ++++++
 include/asm-blackfin/atomic.h       |    4 +---
 include/asm-blackfin/atomic_def.h   |    8 ++++++++
 include/asm-cris/atomic.h           |    3 +--
 include/asm-cris/atomic_def.h       |    6 ++++++
 include/asm-frv/atomic.h            |    5 +----
 include/asm-frv/atomic_def.h        |    8 ++++++++
 include/asm-h8300/atomic_def.h      |    6 ++++++
 include/asm-ia64/atomic_def.h       |   11 +++++++++++
 include/asm-m32r/atomic.h           |    8 +-------
 include/asm-m32r/atomic_def.h       |   11 +++++++++++
 include/asm-m68k/atomic.h           |    2 +-
 include/asm-m68k/atomic_def.h       |    6 ++++++
 include/asm-m68knommu/atomic_def.h  |    6 ++++++
 include/asm-mips/atomic.h           |    3 +--
 include/asm-mips/atomic_def.h       |    6 ++++++
 include/asm-mn10300/atomic.h        |   11 ++---------
 include/asm-mn10300/atomic_def.h    |   13 +++++++++++++
 include/asm-powerpc/atomic_def.h    |    6 ++++++
 include/asm-s390/atomic_def.h       |    8 ++++++++
 include/asm-um/atomic_def.h         |    6 ++++++
 include/asm-x86/atomic_32.h         |   10 +---------
 include/asm-x86/atomic_64.h         |   10 +---------
 include/asm-x86/atomic_def.h        |   13 +++++++++++++
 include/asm-xtensa/atomic.h         |    3 +--
 include/asm-xtensa/atomic_def.h     |    6 ++++++
 36 files changed, 165 insertions(+), 73 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/alpha/include/asm/atomic.h
@@ -3,6 +3,7 @@
 
 #include <asm/barrier.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -12,15 +13,6 @@
  * than regular operations.
  */
 
-
-/*
- * Counter is volatile to make sure gcc doesn't try to be clever
- * and move things around on us. We need to use _exactly_ the address
- * the user gave us, not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile long counter; } atomic64_t;
-
 #define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
 #define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
 
diff -puN arch/arm/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/arm/include/asm/atomic.h
--- a/arch/arm/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/arm/include/asm/atomic.h
@@ -13,8 +13,7 @@
 
 #include <linux/compiler.h>
 #include <asm/system.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff -puN arch/avr32/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/avr32/include/asm/atomic.h
--- a/arch/avr32/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/avr32/include/asm/atomic.h
@@ -15,8 +15,8 @@
 #define __ASM_AVR32_ATOMIC_H
 
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
-typedef struct { volatile int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/h8300/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/h8300/include/asm/atomic.h
--- a/arch/h8300/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/h8300/include/asm/atomic.h
@@ -1,12 +1,13 @@
 #ifndef __ARCH_H8300_ATOMIC__
 #define __ARCH_H8300_ATOMIC__
 
+#include <asm/atomic_def.h>
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/ia64/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/ia64/include/asm/atomic.h
@@ -16,13 +16,7 @@
 
 #include <asm/intrinsics.h>
 #include <asm/system.h>
-
-/*
- * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
- */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
+#include <asm/atomic_def.h>
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
diff -puN arch/m68knommu/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/m68knommu/include/asm/atomic.h
--- a/arch/m68knommu/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/m68knommu/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_M68KNOMMU_ATOMIC__
 
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -12,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN arch/powerpc/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/powerpc/include/asm/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
 
-typedef struct { int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>
diff -puN arch/s390/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh arch/s390/include/asm/atomic.h
--- a/arch/s390/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/arch/s390/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_S390_ATOMIC__
 
 #include <linux/compiler.h>
+#include <asm/atomic_def.h>
 
 /*
  *  include/asm-s390/atomic.h
@@ -23,9 +24,6 @@
  * S390 uses 'Compare And Swap' for atomicity in SMP enviroment
  */
 
-typedef struct {
-	int counter;
-} __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #ifdef __KERNEL__
diff -puN /dev/null include/asm-alpha/atomic_def.h
--- /dev/null
+++ a/include/asm-alpha/atomic_def.h
@@ -0,0 +1,13 @@
+#ifndef _ALPHA_ATOMIC_DEF_H
+#define _ALPHA_ATOMIC_DEF_H
+
+
+/*
+ * Counter is volatile to make sure gcc doesn't try to be clever
+ * and move things around on us. We need to use _exactly_ the address
+ * the user gave us, not some alias that contains the same information.
+ */
+typedef struct { volatile int counter; } atomic_t;
+typedef struct { volatile long counter; } atomic64_t;
+
+#endif
diff -puN /dev/null include/asm-arm/atomic_def.h
--- /dev/null
+++ a/include/asm-arm/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_ARM_ATOMIC_DEF_H
+#define __ASM_ARM_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN /dev/null include/asm-avr32/atomic_def.h
--- /dev/null
+++ a/include/asm-avr32/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_AVR32_ATOMIC_DEF_H
+#define __ASM_AVR32_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN include/asm-blackfin/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-blackfin/atomic.h
--- a/include/asm-blackfin/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-blackfin/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_BLACKFIN_ATOMIC__
 
 #include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,9 +14,6 @@
  * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
 
-typedef struct {
-	int counter;
-} atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN /dev/null include/asm-blackfin/atomic_def.h
--- /dev/null
+++ a/include/asm-blackfin/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_BLACKFIN_ATOMIC_DEF__
+#define __ARCH_BLACKFIN_ATOMIC_DEF__
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
diff -puN include/asm-cris/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-cris/atomic.h
--- a/include/asm-cris/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-cris/atomic.h
@@ -7,14 +7,13 @@
 
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v) ((v)->counter)
diff -puN /dev/null include/asm-cris/atomic_def.h
--- /dev/null
+++ a/include/asm-cris/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_CRIS_ATOMIC_DEF__
+#define __ASM_CRIS_ATOMIC_DEF__
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN include/asm-frv/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-frv/atomic.h
--- a/include/asm-frv/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-frv/atomic.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <asm/spr-regs.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -35,10 +36,6 @@
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
diff -puN /dev/null include/asm-frv/atomic_def.h
--- /dev/null
+++ a/include/asm-frv/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
diff -puN /dev/null include/asm-h8300/atomic_def.h
--- /dev/null
+++ a/include/asm-h8300/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_H8300_ATOMIC_DEF__
+#define __ARCH_H8300_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN /dev/null include/asm-ia64/atomic_def.h
--- /dev/null
+++ a/include/asm-ia64/atomic_def.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_IA64_ATOMIC_DEF_H
+#define _ASM_IA64_ATOMIC_DEF_H
+
+/*
+ * On IA-64, counter must always be volatile to ensure that that the
+ * memory accesses are ordered.
+ */
+typedef struct { volatile __s32 counter; } atomic_t;
+typedef struct { volatile __s64 counter; } atomic64_t;
+
+#endif
diff -puN include/asm-m32r/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-m32r/atomic.h
--- a/include/asm-m32r/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-m32r/atomic.h
@@ -11,19 +11,13 @@
 
 #include <asm/assembler.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff -puN /dev/null include/asm-m32r/atomic_def.h
--- /dev/null
+++ a/include/asm-m32r/atomic_def.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_M32R_ATOMIC_DEF_H
+#define _ASM_M32R_ATOMIC_DEF_H
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN include/asm-m68k/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-m68k/atomic.h
--- a/include/asm-m68k/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-m68k/atomic.h
@@ -3,6 +3,7 @@
 
 
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,7 +14,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
diff -puN /dev/null include/asm-m68k/atomic_def.h
--- /dev/null
+++ a/include/asm-m68k/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68K_ATOMIC_DEF__
+#define __ARCH_M68K_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN /dev/null include/asm-m68knommu/atomic_def.h
--- /dev/null
+++ a/include/asm-m68knommu/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68KNOMMU_ATOMIC_DEF__
+#define __ARCH_M68KNOMMU_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN include/asm-mips/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-mips/atomic.h
--- a/include/asm-mips/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-mips/atomic.h
@@ -19,8 +19,7 @@
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/system.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #define ATOMIC_INIT(i)    { (i) }
 
diff -puN /dev/null include/asm-mips/atomic_def.h
--- /dev/null
+++ a/include/asm-mips/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN include/asm-mn10300/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-mn10300/atomic.h
--- a/include/asm-mn10300/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-mn10300/atomic.h
@@ -11,6 +11,8 @@
 #ifndef _ASM_ATOMIC_H
 #define _ASM_ATOMIC_H
 
+#include <asm/atomic_def.h>
+
 #ifdef CONFIG_SMP
 #error not SMP safe
 #endif
@@ -20,15 +22,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int	counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
diff -puN /dev/null include/asm-mn10300/atomic_def.h
--- /dev/null
+++ a/include/asm-mn10300/atomic_def.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct {
+	int	counter;
+} atomic_t;
+
+#endif
diff -puN /dev/null include/asm-powerpc/atomic_def.h
--- /dev/null
+++ a/include/asm-powerpc/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_POWERPC_ATOMIC_DEF_H_
+#define _ASM_POWERPC_ATOMIC_DEF_H_
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN /dev/null include/asm-s390/atomic_def.h
--- /dev/null
+++ a/include/asm-s390/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_S390_ATOMIC_DEF__
+#define __ARCH_S390_ATOMIC_DEF__
+
+typedef struct {
+	int counter;
+} __attribute__ ((aligned (4))) atomic_t;
+
+#endif
diff -puN /dev/null include/asm-um/atomic_def.h
--- /dev/null
+++ a/include/asm-um/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __UM_ATOMIC_DEF_H
+#define __UM_ATOMIC_DEF_H
+
+#include "asm/arch/atomic_def.h"
+
+#endif
diff -puN include/asm-x86/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-x86/atomic_32.h
--- a/include/asm-x86/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-x86/atomic_32.h
@@ -4,21 +4,13 @@
 #include <linux/compiler.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff -puN include/asm-x86/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-x86/atomic_64.h
--- a/include/asm-x86/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-x86/atomic_64.h
@@ -3,6 +3,7 @@
 
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/atomic_def.h>
 
 /* atomic_t should be 32 bit signed type */
 
@@ -11,15 +12,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
diff -puN /dev/null include/asm-x86/atomic_def.h
--- /dev/null
+++ a/include/asm-x86/atomic_def.h
@@ -0,0 +1,13 @@
+#ifndef __ARCH_X86_ATOMIC_DEF__
+#define __ARCH_X86_ATOMIC_DEF__
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
diff -puN include/asm-xtensa/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh include/asm-xtensa/atomic.h
--- a/include/asm-xtensa/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh
+++ a/include/asm-xtensa/atomic.h
@@ -14,8 +14,7 @@
 #define _XTENSA_ATOMIC_H
 
 #include <linux/stringify.h>
