From: akpm@linux-foundation.org
Subject: + atomic-implement-generic-atomic_dec_if_positive.patch added to -mm tree
Date: Thu, 13 Sep 2012 12:35:45 -0700
Message-ID: <20120913193546.32AA720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:49252 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563Ab2IMTfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2012 15:35:50 -0400
Received: by lagw12 with SMTP id w12so213033lag.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 12:35:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, benh@kernel.crashing.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, monstr@monstr.eu, riel@redhat.com, sfr@canb.auug.org.au, shli@fusionio.com, tglx@linutronix.de


The patch titled
     Subject: atomic: implement generic atomic_dec_if_positive()
has been added to the -mm tree.  Its filename is
     atomic-implement-generic-atomic_dec_if_positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: atomic: implement generic atomic_dec_if_positive()

The x86 implementation of atomic_dec_if_positive is quite generic, so make
it available to all architectures.

This is needed for "swap: add a simple detector for inappropriate swapin
readahead".

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

 arch/microblaze/include/asm/atomic.h |    3 ++-
 arch/powerpc/include/asm/atomic.h    |    3 ++-
 arch/x86/include/asm/atomic.h        |   24 ------------------------
 include/linux/atomic.h               |   25 +++++++++++++++++++++++++
 4 files changed, 29 insertions(+), 26 deletions(-)

diff -puN arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive arch/microblaze/include/asm/atomic.h
--- a/arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive
+++ a/arch/microblaze/include/asm/atomic.h
@@ -9,7 +9,7 @@
  * Atomically test *v and decrement if it is greater than 0.
  * The function returns the old value of *v minus 1.
  */
-static inline int atomic_dec_if_positive(atomic_t *v)
+static inline int __atomic_dec_if_positive(atomic_t *v)
 {
 	unsigned long flags;
 	int res;
@@ -22,5 +22,6 @@ static inline int atomic_dec_if_positive
 
 	return res;
 }
+#define atomic_dec_if_positive __atomic_dec_if_positive
 
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff -puN arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive
+++ a/arch/powerpc/include/asm/atomic.h
@@ -247,7 +247,7 @@ static __inline__ int atomic_inc_not_zer
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
  */
-static __inline__ int atomic_dec_if_positive(atomic_t *v)
+static __inline__ int __atomic_dec_if_positive(atomic_t *v)
 {
 	int t;
 
@@ -268,6 +268,7 @@ static __inline__ int atomic_dec_if_posi
 
 	return t;
 }
+#define atomic_dec_if_positive __atomic_dec_if_positive
 
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

linux-next.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
atomic-implement-generic-atomic_dec_if_positive.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch

