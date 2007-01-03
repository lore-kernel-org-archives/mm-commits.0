From: akpm@osdl.org
Subject: + spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:12:45 -0800
Message-ID: <200701032112.l03LCjDs031375@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50556 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXACVNH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:13:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, ak@suse.de, md@google.com, mingo@elte.hu, pravin.shelar@calsoftinc.com, shai@scalex86.org


The patch titled
     spin_lock_irq: Enable interrupts while spinning: preparatory patch
has been added to the -mm tree.  Its filename is
     spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spin_lock_irq: Enable interrupts while spinning: preparatory patch
From: Ravikiran G Thirumalai <kiran@scalex86.org>

There seems to be no good reason for spin_lock_irq to disable interrupts
while spinning.  Zwane Mwaikambo had an implementation couple of years ago,
and the only objection seemed to be concerns about buggy code using
spin_lock_irq whilst interrupts disabled http://lkml.org/lkml/2004/5/26/87
That shouldn't be a concern anymore.  Besides, spin_lock_irqsave now
enables interrupts while spinning.

As to the motivation, on a Sun x4600 8 socket 16 core x86_64 NUMA box, we
notice softlockups and quite a few lost timer ticks under extreme memory
pressure.  The reason turned out to be that zone->lru_lock tends to get
heavily contended, and NUMA nodes try to grab the locks using
spin_lock_irq.  Instrumentation showed us that interrupt hold offs can last
for a few seconds, and even the main timer interrupts get held off for long
-- which is not good.  Enabling interrupts for spinlocks while spinning
made the machine responsive and the softlockups/lost ticks went away.

Although the scenario above was an extreme condition (very high memory
pressure), I guess it still makes sense to enable interrupts while spinning
for a lock.

The following patches do just that.  The first patch is preparatory in
nature and the second one changes the x86_64 implementation of
spin_lock_irq.  Patch passed overnight runs of kernbench and dbench on 4
way x86_64 smp.



Preparatory patch to enable interrupts while spinning with spinlock irqs.
Any arch which needs this feature just has to implement __raw_spin_lock_irq

Signed-off by: Pravin B. Shelar <pravin.shelar@calsoftinc.com>
Signed-off by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off by: Shai Fultheim <shai@scalex86.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Michael Davidson <md@google.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-alpha/spinlock.h         |    1 +
 include/asm-arm/spinlock.h           |    1 +
 include/asm-cris/arch-v32/spinlock.h |    2 +-
 include/asm-i386/spinlock.h          |    1 +
 include/asm-ia64/spinlock.h          |    3 ++-
 include/asm-m32r/spinlock.h          |    1 +
 include/asm-mips/spinlock.h          |    1 +
 include/asm-parisc/spinlock.h        |    1 +
 include/asm-powerpc/spinlock.h       |    2 ++
 include/asm-ppc/spinlock.h           |    1 +
 include/asm-s390/spinlock.h          |    1 +
 include/asm-sh/spinlock.h            |    1 +
 include/asm-sparc/spinlock.h         |    1 +
 include/asm-sparc64/spinlock.h       |    2 ++
 include/asm-x86_64/spinlock.h        |    1 +
 include/linux/spinlock.h             |    2 ++
 kernel/spinlock.c                    |    6 +++++-
 17 files changed, 25 insertions(+), 3 deletions(-)

diff -puN include/asm-alpha/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-alpha/spinlock.h
--- a/include/asm-alpha/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-alpha/spinlock.h
@@ -13,6 +13,7 @@
  */
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #define __raw_spin_is_locked(x)	((x)->lock != 0)
 #define __raw_spin_unlock_wait(x) \
 		do { cpu_relax(); } while ((x)->lock)
diff -puN include/asm-arm/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-arm/spinlock.h
--- a/include/asm-arm/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-arm/spinlock.h
@@ -22,6 +22,7 @@
 	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock, flags) __raw_spin_lock(lock)
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
diff -puN include/asm-cris/arch-v32/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-cris/arch-v32/spinlock.h
--- a/include/asm-cris/arch-v32/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-cris/arch-v32/spinlock.h
@@ -36,7 +36,7 @@ static inline void _raw_spin_lock_flags 
 {
   _raw_spin_lock(lock);
 }
-
+#define __raw_spin_lock_irq(lock) _raw_spin_lock(lock)
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
diff -puN include/asm-i386/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-i386/spinlock.h
--- a/include/asm-i386/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-i386/spinlock.h
@@ -82,6 +82,7 @@ static inline void __raw_spin_lock_flags
 	 	  CLI_STI_INPUT_ARGS
 		: "memory" CLI_STI_CLOBBERS);
 }
+# define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
diff -puN include/asm-ia64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-ia64/spinlock.h
--- a/include/asm-ia64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-ia64/spinlock.h
@@ -87,7 +87,7 @@ __raw_spin_lock_flags (raw_spinlock_t *l
 }
 
 #define __raw_spin_lock(lock) __raw_spin_lock_flags(lock, 0)
-
+# define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 /* Unlock by doing an ordered store and releasing the cacheline with nta */
 static inline void __raw_spin_unlock(raw_spinlock_t *x) {
 	barrier();
@@ -96,6 +96,7 @@ static inline void __raw_spin_unlock(raw
 
 #else /* !ASM_SUPPORTED */
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+# define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 # define __raw_spin_lock(x)								\
 do {											\
 	__u32 *ia64_spinlock_ptr = (__u32 *) (x);					\
diff -puN include/asm-m32r/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-m32r/spinlock.h
--- a/include/asm-m32r/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-m32r/spinlock.h
@@ -26,6 +26,7 @@
 
 #define __raw_spin_is_locked(x)		(*(volatile int *)(&(x)->slock) <= 0)
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #define __raw_spin_unlock_wait(x) \
 		do { cpu_relax(); } while (__raw_spin_is_locked(x))
 
diff -puN include/asm-mips/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-mips/spinlock.h
--- a/include/asm-mips/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-mips/spinlock.h
@@ -18,6 +18,7 @@
 
 #define __raw_spin_is_locked(x)       ((x)->lock != 0)
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #define __raw_spin_unlock_wait(x) \
 	do { cpu_relax(); } while ((x)->lock)
 
diff -puN include/asm-parisc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-parisc/spinlock.h
--- a/include/asm-parisc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-parisc/spinlock.h
@@ -12,6 +12,7 @@ static inline int __raw_spin_is_locked(r
 }
 
 #define __raw_spin_lock(lock) __raw_spin_lock_flags(lock, 0)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #define __raw_spin_unlock_wait(x) \
 		do { cpu_relax(); } while (__raw_spin_is_locked(x))
 
diff -puN include/asm-powerpc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-powerpc/spinlock.h
--- a/include/asm-powerpc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-powerpc/spinlock.h
@@ -138,6 +138,8 @@ static void __inline__ __raw_spin_lock_f
 	}
 }
 
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
+
 static __inline__ void __raw_spin_unlock(raw_spinlock_t *lock)
 {
 	SYNC_IO;
diff -puN include/asm-ppc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-ppc/spinlock.h
--- a/include/asm-ppc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-ppc/spinlock.h
@@ -13,6 +13,7 @@
 #define __raw_spin_unlock_wait(lock) \
 	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
diff -puN include/asm-s390/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-s390/spinlock.h
--- a/include/asm-s390/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-s390/spinlock.h
@@ -54,6 +54,7 @@ _raw_compare_and_swap(volatile unsigned 
 
 #define __raw_spin_is_locked(x) ((x)->owner_cpu != 0)
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #define __raw_spin_unlock_wait(lock) \
 	do { while (__raw_spin_is_locked(lock)) \
 		 _raw_spin_relax(lock); } while (0)
diff -puN include/asm-sh/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-sh/spinlock.h
--- a/include/asm-sh/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-sh/spinlock.h
@@ -18,6 +18,7 @@
 
 #define __raw_spin_is_locked(x)	((x)->lock != 0)
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #define __raw_spin_unlock_wait(x) \
 	do { cpu_relax(); } while (__raw_spin_is_locked(x))
 
diff -puN include/asm-sparc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-sparc/spinlock.h
--- a/include/asm-sparc/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-sparc/spinlock.h
@@ -179,6 +179,7 @@ static inline int __read_trylock(raw_rwl
 #define __raw_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
diff -puN include/asm-sparc64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-sparc64/spinlock.h
--- a/include/asm-sparc64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-sparc64/spinlock.h
@@ -103,6 +103,8 @@ static inline void __raw_spin_lock_flags
 	: "memory");
 }
 
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
+
 /* Multi-reader locks, these are much saner than the 32-bit Sparc ones... */
 
 static void inline __read_lock(raw_rwlock_t *lock)
diff -puN include/asm-x86_64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/asm-x86_64/spinlock.h
--- a/include/asm-x86_64/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/asm-x86_64/spinlock.h
@@ -63,6 +63,7 @@ static inline void __raw_spin_lock_flags
 		"5:\n\t"
 		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
 }
+#define __raw_spin_lock_irq(lock) __raw_spin_lock(lock)
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
diff -puN include/linux/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch include/linux/spinlock.h
--- a/include/linux/spinlock.h~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/include/linux/spinlock.h
@@ -138,6 +138,7 @@ do {								\
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void _raw_spin_lock(spinlock_t *lock);
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
+#define _raw_spin_lock_irq(lock) _raw_spin_lock(lock)
  extern int _raw_spin_trylock(spinlock_t *lock);
  extern void _raw_spin_unlock(spinlock_t *lock);
  extern void _raw_read_lock(rwlock_t *lock);
@@ -148,6 +149,7 @@ do {								\
  extern void _raw_write_unlock(rwlock_t *lock);
 #else
 # define _raw_spin_lock(lock)		__raw_spin_lock(&(lock)->raw_lock)
+# define _raw_spin_lock_irq(lock) 	__raw_spin_lock_irq(&(lock)->raw_lock)
 # define _raw_spin_lock_flags(lock, flags) \
 		__raw_spin_lock_flags(&(lock)->raw_lock, *(flags))
 # define _raw_spin_trylock(lock)	__raw_spin_trylock(&(lock)->raw_lock)
diff -puN kernel/spinlock.c~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch kernel/spinlock.c
--- a/kernel/spinlock.c~spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch
+++ a/kernel/spinlock.c
@@ -102,7 +102,11 @@ void __lockfunc _spin_lock_irq(spinlock_
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+#ifdef CONFIG_PROVE_LOCKING
+        _raw_spin_lock(lock);
+#else
+        _raw_spin_lock_irq(lock);
+#endif
 }
 EXPORT_SYMBOL(_spin_lock_irq);
 
_

Patches currently in -mm which might be from kiran@scalex86.org are

x86-fix-dev_to_node-for-x86-and-x86_64.patch
mm-set-hashdist_default-to-1-for-x86_64-numa.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
slab-leaks3-default-y.patch
