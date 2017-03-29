From: akpm@linux-foundation.org
Subject: + asm-generic-x86-wrap-atomic-operations-fix.patch added to -mm
 tree
Date: Wed, 29 Mar 2017 15:45:38 -0700
Message-ID: <58dc3912.wGWqGrsQDGAhWJeB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932172AbdC2Wpk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 18:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, arnd@arndb.de, aryabinin@virtuozzo.com, mark.rutland@arm.com, peterz@infradead.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: s/READ_ONCE_NOCHECK/READ_ONCE/ in arch_atomic[64]_read()
has been added to the -mm tree.  Its filename is
     asm-generic-x86-wrap-atomic-operations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asm-generic-x86-wrap-atomic-operations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asm-generic-x86-wrap-atomic-operations-fix.patch

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
Subject: x86: s/READ_ONCE_NOCHECK/READ_ONCE/ in arch_atomic[64]_read()

Two problems was reported with READ_ONCE_NOCHECK in arch_atomic_read:
1. Andrey Ryabinin reported significant binary size increase
(+400K of text). READ_ONCE_NOCHECK is intentionally compiled to
non-inlined function call, and I counted 640 copies of it in my vmlinux.
2. Arnd Bergmann reported a new splat of too large frame sizes.

A single inlined KASAN check is very cheap, a non-inlined function
call with KASAN/KCOV instrumentation can easily be more expensive.

Switch to READ_ONCE() in arch_atomic[64]_read().

Link: http://lkml.kernel.org/r/20170322125740.85337-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/atomic.h      |   15 ++++++---------
 arch/x86/include/asm/atomic64_64.h |    2 +-
 2 files changed, 7 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/atomic.h~asm-generic-x86-wrap-atomic-operations-fix arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~asm-generic-x86-wrap-atomic-operations-fix
+++ a/arch/x86/include/asm/atomic.h
@@ -24,10 +24,13 @@
 static __always_inline int arch_atomic_read(const atomic_t *v)
 {
 	/*
-	 * We use READ_ONCE_NOCHECK() because atomic_read() contains KASAN
-	 * instrumentation. Double instrumentation is unnecessary.
+	 * Note: READ_ONCE() here leads to double instrumentation as
+	 * both READ_ONCE() and atomic_read() contain instrumentation.
+	 * This is deliberate choice. READ_ONCE_NOCHECK() is compiled to a
+	 * non-inlined function call that considerably increases binary size
+	 * and stack usage under KASAN.
 	 */
-	return READ_ONCE_NOCHECK((v)->counter);
+	return READ_ONCE((v)->counter);
 }
 
 /**
@@ -39,12 +42,6 @@ static __always_inline int arch_atomic_r
  */
 static __always_inline void arch_atomic_set(atomic_t *v, int i)
 {
-	/*
-	 * We could use WRITE_ONCE_NOCHECK() if it exists, similar to
-	 * READ_ONCE_NOCHECK() in arch_atomic_read(). But there is no such
-	 * thing at the moment, and introducing it for this case does not
-	 * worth it.
-	 */
 	WRITE_ONCE(v->counter, i);
 }
 
diff -puN arch/x86/include/asm/atomic64_64.h~asm-generic-x86-wrap-atomic-operations-fix arch/x86/include/asm/atomic64_64.h
--- a/arch/x86/include/asm/atomic64_64.h~asm-generic-x86-wrap-atomic-operations-fix
+++ a/arch/x86/include/asm/atomic64_64.h
@@ -18,7 +18,7 @@
  */
 static inline long arch_atomic64_read(const atomic64_t *v)
 {
-	return READ_ONCE_NOCHECK((v)->counter);
+	return READ_ONCE((v)->counter);
 }
 
 /**
_

Patches currently in -mm which might be from dvyukov@google.com are

fault-inject-support-systematic-fault-injection.patch
kasan-allow-kasan_check_read-write-to-accept-pointers-to-volatiles.patch
asm-generic-x86-wrap-atomic-operations.patch
asm-generic-x86-wrap-atomic-operations-fix.patch
asm-generic-add-kasan-instrumentation-to-atomic-operations.patch
asm-generic-fix-compilation-failure-in-cmpxchg_double.patch
x86-remove-unused-atomic_inc_short.patch
x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

