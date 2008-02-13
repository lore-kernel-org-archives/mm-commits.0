From: akpm@linux-foundation.org
Subject: - fix-frv-cmpxchg_local.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:14:45 -0800
Message-ID: <200802132014.m1DKEjkL011248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760996AbYBMUPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: compudj@krystal.dyndns.org, bunk@kernel.org, dhowells@redhat.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Fix FRV cmpxchg_local
has been removed from the -mm tree.  Its filename was
     fix-frv-cmpxchg_local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix FRV cmpxchg_local
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

Fix the FRV cmpxchg_local by breaking the following header dependency loop :

linux/kernel.h -> linux/bitops.h -> asm-frv/bitops.h -> asm-frv/atomic.h
  -> asm-frv/system.h ->
  asm-generic/cmpxchg_local.h -> typecheck() defined in linux/kernel.h

and

linux/kernel.h -> linux/bitops.h -> asm-frv/bitops.h -> asm-frv/atomic.h ->
  asm-generic/cmpxchg_local.h -> typecheck() defined in linux/kernel.h

In order to fix this :
- Move the atomic_test_and_ *_mask inlines from asm-frv/atomic.h (why are they
  there at all anyway ? They are not touching atomic_t variables!) to
  asm-frv/bitops.h.

Also fix a build issue with cmpxchg : it does not cast to (unsigned long *)
like other architectures, to deal with it in the cmpxchg_local macro.

FRV builds fine with this patch.

Thanks to Adrian Bunk <bunk@kernel.org> for spotting this bug.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/atomic.h |   81 ------------------------------------
 include/asm-frv/bitops.h |   83 ++++++++++++++++++++++++++++++++++++-
 include/asm-frv/system.h |    3 -
 3 files changed, 83 insertions(+), 84 deletions(-)

diff -puN include/asm-frv/atomic.h~fix-frv-cmpxchg_local include/asm-frv/atomic.h
--- a/include/asm-frv/atomic.h~fix-frv-cmpxchg_local
+++ a/include/asm-frv/atomic.h
@@ -125,87 +125,6 @@ static inline void atomic_dec(atomic_t *
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
 #define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
 
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-static inline
-unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	and%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(~mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-static inline
-unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	or%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-static inline
-unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	xor%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-#else
-
-extern unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v);
-extern unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v);
-extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v);
-
-#endif
-
-#define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
-#define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
-
 /*****************************************************************************/
 /*
  * exchange value with memory
diff -puN include/asm-frv/bitops.h~fix-frv-cmpxchg_local include/asm-frv/bitops.h
--- a/include/asm-frv/bitops.h~fix-frv-cmpxchg_local
+++ a/include/asm-frv/bitops.h
@@ -16,8 +16,6 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
-#include <asm/atomic.h>
 
 #ifdef __KERNEL__
 
@@ -33,6 +31,87 @@
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+static inline
+unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	and%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(~mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+static inline
+unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	or%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+static inline
+unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	xor%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+#else
+
+extern unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v);
+extern unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v);
+extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v);
+
+#endif
+
+#define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
+#define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
+
 static inline int test_and_clear_bit(int nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
diff -puN include/asm-frv/system.h~fix-frv-cmpxchg_local include/asm-frv/system.h
--- a/include/asm-frv/system.h~fix-frv-cmpxchg_local
+++ a/include/asm-frv/system.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/linkage.h>
+#include <linux/kernel.h>
 
 struct thread_struct;
 
@@ -276,7 +277,7 @@ static inline unsigned long __cmpxchg_lo
 {
 	switch (size) {
 	case 4:
-		return cmpxchg(ptr, old, new);
+		return cmpxchg((unsigned long *)ptr, old, new);
 	default:
 		return __cmpxchg_local_generic(ptr, old, new, size);
 	}
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are
