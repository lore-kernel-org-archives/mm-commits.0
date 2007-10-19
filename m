From: akpm@linux-foundation.org
Subject: - alpha-lock-bitops.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:45:19 -0700
Message-ID: <200710190345.l9J3jJF6013207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966479AbXJSDzx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, bunk@kernel.org, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: lock bitops
has been removed from the -mm tree.  Its filename was
     alpha-lock-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alpha: lock bitops
From: Nick Piggin <npiggin@suse.de>

Alpha can avoid one mb when acquiring a lock with test_and_set_bit_lock.

[bunk@kernel.org: alpha bitops.h must #include <asm/barrier.h>]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h |   43 ++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff -puN include/asm-alpha/bitops.h~alpha-lock-bitops include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-lock-bitops
+++ a/include/asm-alpha/bitops.h
@@ -2,6 +2,7 @@
 #define _ALPHA_BITOPS_H
 
 #include <asm/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * Copyright 1994, Linus Torvalds.
@@ -69,6 +70,13 @@ clear_bit(unsigned long nr, volatile voi
 	:"Ir" (1UL << (nr & 31)), "m" (*m));
 }
 
+static inline void
+clear_bit_unlock(unsigned long nr, volatile void * addr)
+{
+	smp_mb();
+	clear_bit(nr, addr);
+}
+
 /*
  * WARNING: non atomic version.
  */
@@ -81,6 +89,13 @@ __clear_bit(unsigned long nr, volatile v
 }
 
 static inline void
+__clear_bit_unlock(unsigned long nr, volatile void * addr)
+{
+	smp_mb();
+	__clear_bit(nr, addr);
+}
+
+static inline void
 change_bit(unsigned long nr, volatile void * addr)
 {
 	unsigned long temp;
@@ -139,6 +154,33 @@ test_and_set_bit(unsigned long nr, volat
 	return oldbit != 0;
 }
 
+static inline int
+test_and_set_bit_lock(unsigned long nr, volatile void *addr)
+{
+	unsigned long oldbit;
+	unsigned long temp;
+	int *m = ((int *) addr) + (nr >> 5);
+
+	__asm__ __volatile__(
+	"1:	ldl_l %0,%4\n"
+	"	and %0,%3,%2\n"
+	"	bne %2,2f\n"
+	"	xor %0,%3,%0\n"
+	"	stl_c %0,%1\n"
+	"	beq %0,3f\n"
+	"2:\n"
+#ifdef CONFIG_SMP
+	"	mb\n"
+#endif
+	".subsection 2\n"
+	"3:	br 1b\n"
+	".previous"
+	:"=&r" (temp), "=m" (*m), "=&r" (oldbit)
+	:"Ir" (1UL << (nr & 31)), "m" (*m) : "memory");
+
+	return oldbit != 0;
+}
+
 /*
  * WARNING: non atomic version.
  */
@@ -376,7 +418,6 @@ static inline unsigned int hweight8(unsi
 #else
 #include <asm-generic/bitops/hweight.h>
 #endif
-#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
reiser4-fix-for-new-aops-patches.patch
