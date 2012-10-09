From: akpm@linux-foundation.org
Subject: [merged] atomic-implement-generic-atomic_dec_if_positive.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:53 -0700
Message-ID: <20121009181153.D68B7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42688 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2JISLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574279yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, benh@kernel.crashing.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, monstr@monstr.eu, riel@redhat.com, sfr@canb.auug.org.au, shli@fusionio.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: atomic: implement generic atomic_dec_if_positive()
has been removed from the -mm tree.  Its filename was
     atomic-implement-generic-atomic_dec_if_positive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: atomic: implement generic atomic_dec_if_positive()

The x86 implementation of atomic_dec_if_positive is quite generic, so make
it available to all architectures.

This is needed for "swap: add a simple detector for inappropriate swapin
readahead".

[akpm@linux-foundation.org: do the "#define foo foo" trick in the conventional manner]
Signed-off-by: Shaohua Li <shli@fusionio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/atomic.h |    1 +
 arch/powerpc/include/asm/atomic.h    |    1 +
 arch/x86/include/asm/atomic.h        |   24 ------------------------
 include/linux/atomic.h               |   25 +++++++++++++++++++++++++
 4 files changed, 27 insertions(+), 24 deletions(-)

diff -puN arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive arch/microblaze/include/asm/atomic.h
--- a/arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive
+++ a/arch/microblaze/include/asm/atomic.h
@@ -22,5 +22,6 @@ static inline int atomic_dec_if_positive
 
 	return res;
 }
+#define atomic_dec_if_positive atomic_dec_if_positive
 
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff -puN arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive
+++ a/arch/powerpc/include/asm/atomic.h
@@ -268,6 +268,7 @@ static __inline__ int atomic_dec_if_posi
 
 	return t;
 }
+#define atomic_dec_if_positive atomic_dec_if_positive
 
 #define smp_mb__before_atomic_dec()     smp_mb()
 #define smp_mb__after_atomic_dec()      smp_mb()
diff -puN arch/x86/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive
+++ a/arch/x86/include/asm/atomic.h
@@ -240,30 +240,6 @@ static inline int __atomic_add_unless(at
 	return c;
 }
 
-
-/*
- * atomic_dec_if_positive - decrement by 1 if old value positive
- * @v: pointer of type atomic_t
- *
- * The function returns the old value of *v minus 1, even if
- * the atomic variable, v, was not decremented.
- */
-static inline int atomic_dec_if_positive(atomic_t *v)
-{
-	int c, old, dec;
-	c = atomic_read(v);
-	for (;;) {
-		dec = c - 1;
-		if (unlikely(dec < 0))
-			break;
-		old = atomic_cmpxchg((v), c, dec);
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return dec;
-}
-
 /**
  * atomic_inc_short - increment of a short integer
  * @v: pointer to type int
diff -puN include/linux/atomic.h~atomic-implement-generic-atomic_dec_if_positive include/linux/atomic.h
--- a/include/linux/atomic.h~atomic-implement-generic-atomic_dec_if_positive
+++ a/include/linux/atomic.h
@@ -86,6 +86,31 @@ static inline int atomic_dec_unless_posi
 }
 #endif
 
+/*
+ * atomic_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+#ifndef atomic_dec_if_positive
+static inline int atomic_dec_if_positive(atomic_t *v)
+{
+	int c, old, dec;
+	c = atomic_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+#endif
+
 #ifndef CONFIG_ARCH_HAS_ATOMIC_OR
 static inline void atomic_or(int i, atomic_t *v)
 {
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

