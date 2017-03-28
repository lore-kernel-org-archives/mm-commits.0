From: akpm@linux-foundation.org
Subject: + x86-remove-unused-atomic_inc_short.patch added to -mm tree
Date: Tue, 28 Mar 2017 16:45:08 -0700
Message-ID: <58daf584.rDksEubH3pFvUfG2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932242AbdC1XpK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:45:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, hpa@zytor.com, mark.rutland@arm.com, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: remove unused atomic_inc_short()
has been added to the -mm tree.  Its filename is
     x86-remove-unused-atomic_inc_short.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-remove-unused-atomic_inc_short.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-remove-unused-atomic_inc_short.patch

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
Subject: x86: remove unused atomic_inc_short()

It is completely unused and implemented only on x86.  Remove it.

Link: http://lkml.kernel.org/r/20170322174551.128143-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/lib/atomic_asm_32.S             |    3 +--
 arch/x86/include/asm/atomic.h             |   13 -------------
 include/asm-generic/atomic-instrumented.h |    6 ------
 3 files changed, 1 insertion(+), 21 deletions(-)

diff -puN arch/tile/lib/atomic_asm_32.S~x86-remove-unused-atomic_inc_short arch/tile/lib/atomic_asm_32.S
--- a/arch/tile/lib/atomic_asm_32.S~x86-remove-unused-atomic_inc_short
+++ a/arch/tile/lib/atomic_asm_32.S
@@ -24,8 +24,7 @@
  * has an opportunity to return -EFAULT to the user if needed.
  * The 64-bit routines just return a "long long" with the value,
  * since they are only used from kernel space and don't expect to fault.
- * Support for 16-bit ops is included in the framework but we don't provide
- * any (x86_64 has an atomic_inc_short(), so we might want to some day).
+ * Support for 16-bit ops is included in the framework but we don't provide any.
  *
  * Note that the caller is advised to issue a suitable L1 or L2
  * prefetch on the address being manipulated to avoid extra stalls.
diff -puN arch/x86/include/asm/atomic.h~x86-remove-unused-atomic_inc_short arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~x86-remove-unused-atomic_inc_short
+++ a/arch/x86/include/asm/atomic.h
@@ -257,19 +257,6 @@ static __always_inline int __arch_atomic
 	return c;
 }
 
-/**
- * arch_atomic_inc_short - increment of a short integer
- * @v: pointer to type int
- *
- * Atomically adds 1 to @v
- * Returns the new value of @u
- */
-static __always_inline short int arch_atomic_inc_short(short int *v)
-{
-	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
-	return *v;
-}
-
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
 #else
diff -puN include/asm-generic/atomic-instrumented.h~x86-remove-unused-atomic_inc_short include/asm-generic/atomic-instrumented.h
--- a/include/asm-generic/atomic-instrumented.h~x86-remove-unused-atomic_inc_short
+++ a/include/asm-generic/atomic-instrumented.h
@@ -89,12 +89,6 @@ static __always_inline bool atomic64_add
 	return arch_atomic64_add_unless(v, a, u);
 }
 
-static __always_inline short int atomic_inc_short(short int *v)
-{
-	kasan_check_write(v, sizeof(*v));
-	return arch_atomic_inc_short(v);
-}
