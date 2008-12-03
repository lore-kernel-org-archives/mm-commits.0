From: akpm@linux-foundation.org
Subject: + ia64-implement-interrupt-enabling-rwlocks.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:13:29 -0800
Message-ID: <200812030013.mB30DTIb032356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327AbYLCAOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, a.p.zijlstra@chello.nl, linux-arch@vger.kernel.org, mingo@elte.hu, ptesarik@suse.cz, tony.luck@intel.com


The patch titled
     ia64: implement interrupt-enabling rwlocks
has been added to the -mm tree.  Its filename is
     ia64-implement-interrupt-enabling-rwlocks.patch

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
Subject: ia64: implement interrupt-enabling rwlocks
From: Robin Holt <holt@sgi.com>

Implement __raw_read_lock_flags and __raw_write_lock_flags for the ia64
architecture.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/spinlock.h |   80 ++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 17 deletions(-)

diff -puN arch/ia64/include/asm/spinlock.h~ia64-implement-interrupt-enabling-rwlocks arch/ia64/include/asm/spinlock.h
--- a/arch/ia64/include/asm/spinlock.h~ia64-implement-interrupt-enabling-rwlocks
+++ a/arch/ia64/include/asm/spinlock.h
@@ -120,6 +120,38 @@ do {											\
 #define __raw_read_can_lock(rw)		(*(volatile int *)(rw) >= 0)
 #define __raw_write_can_lock(rw)	(*(volatile int *)(rw) == 0)
 
+#ifdef ASM_SUPPORTED
+
+static __always_inline void
+__raw_read_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+{
+	__asm__ __volatile__ (
+		"tbit.nz p6, p0 = %1,%2\n"
+		"br.few 3f\n"
+		"1:\n"
+		"fetchadd4.rel r2 = [%0], -1;;\n"
+		"(p6) ssm psr.i\n"
+		"2:\n"
+		"hint @pause\n"
+		"ld4 r2 = [%0];;\n"
+		"cmp4.lt p7,p0 = r2, r0\n"
+		"(p7) br.cond.spnt.few 2b\n"
+		"(p6) rsm psr.i\n"
+		";;\n"
+		"3:\n"
+		"fetchadd4.acq r2 = [%0], 1;;\n"
+		"cmp4.lt p7,p0 = r2, r0\n"
+		"(p7) br.cond.spnt.few 1b\n"
+		: : "r"(lock), "r"(flags), "i"(IA64_PSR_I_BIT)
+		: "p6", "p7", "r2", "memory");
+}
+
+#define __raw_read_lock(lock) __raw_read_lock_flags(lock, 0)
+
+#else /* !ASM_SUPPORTED */
+
+#define __raw_read_lock_flags(rw, flags) __raw_read_lock(rw)
+
 #define __raw_read_lock(rw)								\
 do {											\
 	raw_rwlock_t *__read_lock_ptr = (rw);						\
@@ -131,6 +163,8 @@ do {											\
 	}										\
 } while (0)
 
+#endif /* !ASM_SUPPORTED */
+
 #define __raw_read_unlock(rw)					\
 do {								\
 	raw_rwlock_t *__read_lock_ptr = (rw);			\
@@ -138,20 +172,33 @@ do {								\
 } while (0)
 
 #ifdef ASM_SUPPORTED
-#define __raw_write_lock(rw)							\
-do {										\
- 	__asm__ __volatile__ (							\
-		"mov ar.ccv = r0\n"						\
-		"dep r29 = -1, r0, 31, 1;;\n"					\
-		"1:\n"								\
-		"ld4 r2 = [%0];;\n"						\
-		"cmp4.eq p0,p7 = r0,r2\n"					\
-		"(p7) br.cond.spnt.few 1b \n"					\
-		"cmpxchg4.acq r2 = [%0], r29, ar.ccv;;\n"			\
-		"cmp4.eq p0,p7 = r0, r2\n"					\
-		"(p7) br.cond.spnt.few 1b;;\n"					\
-		:: "r"(rw) : "ar.ccv", "p7", "r2", "r29", "memory");		\
-} while(0)
+
+static __always_inline void
+__raw_write_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+{
+	__asm__ __volatile__ (
+		"tbit.nz p6, p0 = %1, %2\n"
+		"mov ar.ccv = r0\n"
+		"dep r29 = -1, r0, 31, 1\n"
+		"br.few 3f;;\n"
+		"1:\n"
+		"(p6) ssm psr.i\n"
+		"2:\n"
+		"hint @pause\n"
+		"ld4 r2 = [%0];;\n"
+		"cmp4.eq p0,p7 = r0, r2\n"
+		"(p7) br.cond.spnt.few 2b\n"
+		"(p6) rsm psr.i\n"
+		";;\n"
+		"3:\n"
+		"cmpxchg4.acq r2 = [%0], r29, ar.ccv;;\n"
+		"cmp4.eq p0,p7 = r0, r2\n"
+		"(p7) br.cond.spnt.few 1b;;\n"
+		: : "r"(lock), "r"(flags), "i"(IA64_PSR_I_BIT)
+		: "ar.ccv", "p6", "p7", "r2", "r29", "memory");
+}
+
+#define __raw_write_lock(rw) __raw_write_lock_flags(rw, 0)
 
 #define __raw_write_trylock(rw)							\
 ({										\
@@ -174,6 +221,8 @@ static inline void __raw_write_unlock(ra
 
 #else /* !ASM_SUPPORTED */
 
+#define __raw_write_lock_flags(l, flags) __raw_write_lock(l)
+
 #define __raw_write_lock(l)								\
 ({											\
 	__u64 ia64_val, ia64_set_val = ia64_dep_mi(-1, 0, 31, 1);			\
@@ -213,9 +262,6 @@ static inline int __raw_read_trylock(raw
 	return (u32)ia64_cmpxchg4_acq((__u32 *)(x), new.word, old.word) == old.word;
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
