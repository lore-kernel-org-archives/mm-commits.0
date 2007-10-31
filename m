From: akpm@linux-foundation.org
Subject: - fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch removed from -mm tree
Date: Wed, 31 Oct 2007 15:40:47 -0700
Message-ID: <20071031224047.316A5432BF5@localhost>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:24370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432AbXJaWmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2007 18:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, clameter@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
has been removed from the -mm tree.  Its filename was
     fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Actually, on 386, cmpxchg and cmpxchg_local fall back on
cmpxchg_386_u8/16/32: it disables interruptions around non atomic
updates to mimic the cmpxchg behavior.

The comment:
/* Poor man's cmpxchg for 386. Unsuitable for SMP */

already present in cmpxchg_386_u32 tells much about how this cmpxchg
implementation should not be used in a SMP context. However, the cmpxchg_local
can perfectly use this fallback, since it only needs to be atomic wrt the local
cpu.

This patch adds a cmpxchg_486_u64 and uses it as a fallback for cmpxchg64
and cmpxchg64_local on 80386 and 80486.

Q:
but why is it called cmpxchg_486 when the other functions are called

A:
Because the standard cmpxchg is missing only on 386, but cmpxchg8b is
missing both on 386 and 486.

Citing Intel's Instruction set reference:

cmpxchg:
This instruction is not supported on Intel processors earlier than the
Intel486 processors.

cmpxchg8b:
This instruction encoding is not supported on Intel processors earlier
than the Pentium processors.

Q:
What's the reason to have cmpxchg64_local on 32 bit architectures?
Without that need all this would just be a few simple defines.

A:
cmpxchg64_local on 32 bits architectures takes unsigned long long
parameters, but cmpxchg_local only takes longs. Since we have cmpxchg8b
to execute a 8 byte cmpxchg atomically on pentium and +, it makes sense
to provide a flavor of cmpxchg and cmpxchg_local using this instruction.

Also, for 32 bits architectures lacking the 64 bits atomic cmpxchg, it
makes sense _not_ to define cmpxchg64 while cmpxchg could still be
available.

Moreover, the fallback for cmpxchg8b on i386 for 386 and 486 is a

However, cmpxchg64_local will be emulated by disabling interrupts on all
architectures where it is not supported atomically.

Therefore, we *could* turn cmpxchg64_local into a cmpxchg_local, but it
would make the 386/486 fallbacks ugly, make its design different from
cmpxchg/cmpxchg64 (which really depends on atomic operations and cannot
be emulated) and require the __cmpxchg_local to be expressed as a macro
rather than an inline function so the parameters would not be fixed to
unsigned long long in every case.

So I think cmpxchg64_local makes sense there, but I am open to
suggestions.

Q:
Are there any callers?

A:
I am actually using it in LTTng in my timestamping code. I use it to
work around CPUs with asynchronous TSCs. I need to update 64 bits
values atomically on this 32 bits architecture.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel.c  |   17 +++++
 include/asm-x86/cmpxchg_32.h |  100 ++++++++++++++++++++++-----------
 2 files changed, 85 insertions(+), 32 deletions(-)

diff -puN arch/x86/kernel/cpu/intel.c~fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486 arch/x86/kernel/cpu/intel.c
--- a/arch/x86/kernel/cpu/intel.c~fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486
+++ a/arch/x86/kernel/cpu/intel.c
@@ -342,5 +342,22 @@ unsigned long cmpxchg_386_u32(volatile v
 EXPORT_SYMBOL(cmpxchg_386_u32);
 #endif
 
+#ifndef CONFIG_X86_CMPXCHG64
+unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
+{
+	u64 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u64 *)ptr;
+	if (prev == old)
+		*(u64 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_486_u64);
+#endif
+
 // arch_initcall(intel_cpu_init);
 
diff -puN include/asm-x86/cmpxchg_32.h~fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486 include/asm-x86/cmpxchg_32.h
--- a/include/asm-x86/cmpxchg_32.h~fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486
+++ a/include/asm-x86/cmpxchg_32.h
@@ -116,6 +116,15 @@ static inline unsigned long __xchg(unsig
 					(unsigned long)(n),sizeof(*(ptr))))
 #endif
 
+#ifdef CONFIG_X86_CMPXCHG64
+#define cmpxchg64(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#define cmpxchg64_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#endif
+
 static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 				      unsigned long new, int size)
 {
@@ -203,6 +212,34 @@ static inline unsigned long __cmpxchg_lo
 	return old;
 }
 
+static inline unsigned long long __cmpxchg64(volatile void *ptr,
+			unsigned long long old, unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
+static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
+			unsigned long long old, unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__("cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
 #ifndef CONFIG_X86_CMPXCHG
 /*
  * Building a kernel capable running on 80386. It may be necessary to
@@ -252,38 +289,37 @@ static inline unsigned long cmpxchg_386(
 })
 #endif
 
-static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
-				      unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
+#ifndef CONFIG_X86_CMPXCHG64
+/*
+ * Building a kernel capable running on 80386 and 80486. It may be necessary
+ * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
+ */
 
-static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
-			unsigned long long old, unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__("cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
+extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
+
+#define cmpxchg64(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 4))				\
+		__ret = __cmpxchg64((ptr), (unsigned long long)(o),	\
+				(unsigned long long)(n));		\
+	else								\
+		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+				(unsigned long long)(n));		\
+	__ret;								\
+})
+#define cmpxchg64_local(ptr,o,n)					\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 4))				\
+		__ret = __cmpxchg64_local((ptr), (unsigned long long)(o), \
+				(unsigned long long)(n));		\
+	else								\
+		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+				(unsigned long long)(n));		\
+	__ret;								\
+})
+
+#endif
 
-#define cmpxchg64(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#define cmpxchg64_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
 #endif
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

local_t-documentation-update-2.patch
markers-fix-warnings.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
add-cmpxchg64-and-cmpxchg64_local-to-powerpc.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
add-cmpxchg_local-to-arm.patch
add-cmpxchg_local-to-avr32.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
add-cmpxchg_local-to-cris.patch
add-cmpxchg_local-to-frv.patch
add-cmpxchg_local-to-h8300.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
new-cmpxchg_local-optimized-for-up-case-for-m32r.patch
fix-m32r-__xchg.patch
m32r-build-fix-of-arch-m32r-kernel-smpbootc.patch
local_t-m32r-use-architecture-specific-cmpxchg_local.patch
add-cmpxchg_local-to-m86k.patch
add-cmpxchg_local-to-m68knommu.patch
add-cmpxchg_local-to-parisc.patch
add-cmpxchg_local-to-ppc.patch
add-cmpxchg_local-to-s390.patch
add-cmpxchg_local-to-sh-use-generic-cmpxchg-instead-of-cmpxchg_u32.patch
add-cmpxchg_local-to-sh64.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
add-cmpxchg_local-to-v850.patch
add-cmpxchg_local-to-xtensa.patch
