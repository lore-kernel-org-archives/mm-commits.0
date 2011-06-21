From: akpm@linux-foundation.org
Subject: + atomic-cleanup-asm-generic-atomich-inclusion.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:57:32 -0700
Message-ID: <201106212257.p5LMvWVE029766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756879Ab1FUW5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: asharma@fb.com, davem@davemloft.net, eric.dumazet@gmail.com, mingo@elte.hu, vapier@gentoo.org


The patch titled
     atomic: cleanup asm-generic atomic*.h inclusion
has been added to the -mm tree.  Its filename is
     atomic-cleanup-asm-generic-atomich-inclusion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic: cleanup asm-generic atomic*.h inclusion
From: Arun Sharma <asharma@fb.com>

After changing all consumers of atomics to include
<linux/atomic.h>, we ran into some compile time errors
due to this dependency chain:

linux/atomic.h
  -> asm/atomic.h
    -> asm-generic/atomic-long.h

where atomic-long.h could use funcs defined later in
linux/atomic.h without a prototype. This patches moves
the code that includes asm-generic/atomic*.h to
linux/atomic.h.

Archs that need <asm-generic/atomic64.h> need to select
CONFIG_GENERIC_ATOMIC64 from now on (some of them used
to include it unconditionally).

Compile tested on i386 and x86_64 with allnoconfig.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h    |    1 -
 arch/arm/include/asm/atomic.h      |    5 +----
 arch/avr32/include/asm/atomic.h    |    2 --
 arch/blackfin/include/asm/atomic.h |    3 ---
 arch/cris/include/asm/atomic.h     |    1 -
 arch/frv/include/asm/atomic.h      |    1 -
 arch/h8300/include/asm/atomic.h    |    1 -
 arch/ia64/include/asm/atomic.h     |    1 -
 arch/m32r/include/asm/atomic.h     |    1 -
 arch/m68k/include/asm/atomic.h     |    2 --
 arch/mips/include/asm/atomic.h     |    6 ------
 arch/mn10300/include/asm/atomic.h  |    2 --
 arch/parisc/include/asm/atomic.h   |    5 -----
 arch/powerpc/include/asm/atomic.h  |    4 ----
 arch/s390/include/asm/atomic.h     |    2 --
 arch/sh/include/asm/atomic.h       |    3 ---
 arch/sparc/include/asm/atomic_32.h |    1 -
 arch/sparc/include/asm/atomic_64.h |    1 -
 arch/tile/include/asm/atomic.h     |    5 -----
 arch/x86/include/asm/atomic.h      |    1 -
 arch/xtensa/include/asm/atomic.h   |    1 -
 include/asm-generic/atomic.h       |    2 --
 include/linux/atomic.h             |    4 ++++
 23 files changed, 5 insertions(+), 50 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/alpha/include/asm/atomic.h
@@ -255,5 +255,4 @@ static __inline__ int atomic64_add_unles
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ALPHA_ATOMIC_H */
diff -puN arch/arm/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/arm/include/asm/atomic.h
--- a/arch/arm/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/arm/include/asm/atomic.h
@@ -459,9 +459,6 @@ static inline int atomic64_add_unless(at
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
 
-#else /* !CONFIG_GENERIC_ATOMIC64 */
-#include <asm-generic/atomic64.h>
-#endif
-#include <asm-generic/atomic-long.h>
+#endif /* !CONFIG_GENERIC_ATOMIC64 */
 #endif
 #endif
diff -puN arch/avr32/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/avr32/include/asm/atomic.h
--- a/arch/avr32/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/avr32/include/asm/atomic.h
@@ -188,6 +188,4 @@ static inline int atomic_sub_if_positive
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /*  __ASM_AVR32_ATOMIC_H */
diff -puN arch/blackfin/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/blackfin/include/asm/atomic.h
@@ -116,10 +116,7 @@ static inline int atomic_test_mask(int m
 #define atomic_sub_and_test(i,v) (atomic_sub_return((i), (v)) == 0)
 #define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
 
-#include <asm-generic/atomic-long.h>
 
 #endif
 
-#include <asm-generic/atomic64.h>
-
 #endif
diff -puN arch/cris/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/cris/include/asm/atomic.h
--- a/arch/cris/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/cris/include/asm/atomic.h
@@ -157,5 +157,4 @@ static inline int __atomic_add_unless(at
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc()     barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif
diff -puN arch/frv/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/frv/include/asm/atomic.h
--- a/arch/frv/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/frv/include/asm/atomic.h
@@ -257,5 +257,4 @@ static __inline__ int __atomic_add_unles
 }
 
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ASM_ATOMIC_H */
diff -puN arch/h8300/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/h8300/include/asm/atomic.h
--- a/arch/h8300/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/h8300/include/asm/atomic.h
@@ -145,5 +145,4 @@ static __inline__ void atomic_set_mask(u
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc() barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* __ARCH_H8300_ATOMIC __ */
diff -puN arch/ia64/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/ia64/include/asm/atomic.h
@@ -215,5 +215,4 @@ atomic64_add_negative (__s64 i, atomic64
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ASM_IA64_ATOMIC_H */
diff -puN arch/m32r/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/m32r/include/asm/atomic.h
--- a/arch/m32r/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/m32r/include/asm/atomic.h
@@ -313,5 +313,4 @@ static __inline__ void atomic_set_mask(u
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif	/* _ASM_M32R_ATOMIC_H */
diff -puN arch/m68k/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/m68k/include/asm/atomic.h
--- a/arch/m68k/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/m68k/include/asm/atomic.h
@@ -205,6 +205,4 @@ static __inline__ int __atomic_add_unles
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-#include <asm-generic/atomic64.h>
 #endif /* __ARCH_M68K_ATOMIC __ */
diff -puN arch/mips/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/mips/include/asm/atomic.h
--- a/arch/mips/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/mips/include/asm/atomic.h
@@ -765,10 +765,6 @@ static __inline__ int atomic64_add_unles
  */
 #define atomic64_add_negative(i, v) (atomic64_add_return(i, (v)) < 0)
 
-#else /* !CONFIG_64BIT */
-
-#include <asm-generic/atomic64.h>
-
 #endif /* CONFIG_64BIT */
 
 /*
@@ -780,6 +776,4 @@ static __inline__ int atomic64_add_unles
 #define smp_mb__before_atomic_inc()	smp_mb__before_llsc()
 #define smp_mb__after_atomic_inc()	smp_llsc_mb()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* _ASM_ATOMIC_H */
diff -puN arch/mn10300/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/mn10300/include/asm/atomic.h
--- a/arch/mn10300/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/mn10300/include/asm/atomic.h
@@ -343,8 +343,6 @@ static inline void atomic_set_mask(unsig
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* __KERNEL__ */
 #endif /* CONFIG_SMP */
 #endif /* _ASM_ATOMIC_H */
diff -puN arch/parisc/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/parisc/include/asm/atomic.h
--- a/arch/parisc/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/parisc/include/asm/atomic.h
@@ -335,12 +335,7 @@ static __inline__ int atomic64_add_unles
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
-#else /* CONFIG_64BIT */
-
-#include <asm-generic/atomic64.h>
-
 #endif /* !CONFIG_64BIT */
 
-#include <asm-generic/atomic-long.h>
 
 #endif /* _ASM_PARISC_ATOMIC_H_ */
diff -puN arch/powerpc/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/powerpc/include/asm/atomic.h
@@ -469,11 +469,7 @@ static __inline__ int atomic64_add_unles
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
-#else  /* __powerpc64__ */
-#include <asm-generic/atomic64.h>
-
 #endif /* __powerpc64__ */
 
-#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_ATOMIC_H_ */
diff -puN arch/s390/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/s390/include/asm/atomic.h
--- a/arch/s390/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/s390/include/asm/atomic.h
@@ -331,6 +331,4 @@ static inline long long atomic64_dec_if_
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic-long.h>
-
 #endif /* __ARCH_S390_ATOMIC__  */
diff -puN arch/sh/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/sh/include/asm/atomic.h
--- a/arch/sh/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/sh/include/asm/atomic.h
@@ -67,7 +67,4 @@ static inline int __atomic_add_unless(at
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic-long.h>
-#include <asm-generic/atomic64.h>
-
 #endif /* __ASM_SH_ATOMIC_H */
diff -puN arch/sparc/include/asm/atomic_32.h~atomic-cleanup-asm-generic-atomich-inclusion arch/sparc/include/asm/atomic_32.h
--- a/arch/sparc/include/asm/atomic_32.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/sparc/include/asm/atomic_32.h
@@ -160,5 +160,4 @@ static inline int __atomic24_sub(int i, 
 
 #endif /* !(__KERNEL__) */
 
-#include <asm-generic/atomic-long.h>
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
diff -puN arch/sparc/include/asm/atomic_64.h~atomic-cleanup-asm-generic-atomich-inclusion arch/sparc/include/asm/atomic_64.h
--- a/arch/sparc/include/asm/atomic_64.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/sparc/include/asm/atomic_64.h
@@ -113,5 +113,4 @@ static inline long atomic64_add_unless(a
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
diff -puN arch/tile/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/tile/include/asm/atomic.h
--- a/arch/tile/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/tile/include/asm/atomic.h
@@ -177,9 +177,4 @@ extern unsigned long __cmpxchg_called_wi
 #include <asm/atomic_64.h>
 #endif
 
-/* Provide the appropriate atomic_long_t definitions. */
-#ifndef __ASSEMBLY__
-#include <asm-generic/atomic-long.h>
-#endif
-
 #endif /* _ASM_TILE_ATOMIC_H */
diff -puN arch/x86/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/x86/include/asm/atomic.h
@@ -318,5 +318,4 @@ static inline void atomic_or_long(unsign
 # include "atomic64_64.h"
 #endif
 
-#include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_H */
diff -puN arch/xtensa/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion arch/xtensa/include/asm/atomic.h
--- a/arch/xtensa/include/asm/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/arch/xtensa/include/asm/atomic.h
@@ -291,7 +291,6 @@ static inline void atomic_set_mask(unsig
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 
 #endif /* _XTENSA_ATOMIC_H */
diff -puN include/asm-generic/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomic-cleanup-asm-generic-atomich-inclusion
+++ a/include/asm-generic/atomic.h
@@ -154,7 +154,5 @@ static inline void atomic_clear_mask(uns
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic-long.h>
