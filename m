From: akpm@linux-foundation.org
Subject: [merged] allow-rwlocks-to-re-enable-interrupts.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:48 -0700
Message-ID: <200904061938.n36JcmXo013553__25974.3830691606$1239050290$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbZDFUf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, a.p.zijlstra@chello.nl, linux-arch@vger.kernel.org, mingo@elte.hu, ptesarik@suse.cz, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Allow rwlocks to re-enable interrupts
has been removed from the -mm tree.  Its filename was
     allow-rwlocks-to-re-enable-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Allow rwlocks to re-enable interrupts
From: Robin Holt <holt@sgi.com>

Pass the original flags to rwlock arch-code, so that it can re-enable
interrupts if implemented for that architecture.

Initially, make __raw_read_lock_flags and __raw_write_lock_flags stubs
which just do the same thing as non-flags variants.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-arch@vger.kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/spinlock.h          |    3 +++
 arch/arm/include/asm/spinlock.h            |    3 +++
 arch/cris/include/arch-v32/arch/spinlock.h |    2 ++
 arch/ia64/include/asm/spinlock.h           |    3 +++
 arch/mips/include/asm/spinlock.h           |    2 ++
 arch/parisc/include/asm/spinlock.h         |    3 +++
 arch/powerpc/include/asm/spinlock.h        |    3 +++
 arch/s390/include/asm/spinlock.h           |    3 +++
 arch/sh/include/asm/spinlock.h             |    3 +++
 arch/sparc/include/asm/spinlock_32.h       |    2 ++
 arch/sparc/include/asm/spinlock_64.h       |    2 ++
 arch/x86/include/asm/spinlock.h            |    3 +++
 include/asm-m32r/spinlock.h                |    3 +++
 include/linux/spinlock.h                   |    6 ++++++
 kernel/spinlock.c                          |    6 ++++--
 15 files changed, 45 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/alpha/include/asm/spinlock.h
--- a/arch/alpha/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/alpha/include/asm/spinlock.h
@@ -166,6 +166,9 @@ static inline void __raw_write_unlock(ra
 	lock->lock = 0;
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN arch/arm/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/arm/include/asm/spinlock.h
--- a/arch/arm/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/arm/include/asm/spinlock.h
@@ -217,6 +217,9 @@ static inline int __raw_read_trylock(raw
 /* read_can_lock - would read_trylock() succeed? */
 #define __raw_read_can_lock(x)		((x)->lock < 0x80000000)
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN arch/cris/include/arch-v32/arch/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/cris/include/arch-v32/arch/spinlock.h
--- a/arch/cris/include/arch-v32/arch/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/cris/include/arch-v32/arch/spinlock.h
@@ -121,6 +121,8 @@ static  inline int __raw_write_trylock(r
 	return 1;
 }
 
+#define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
+#define _raw_write_lock_flags(lock, flags) _raw_write_lock(lock)
 
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
diff -puN arch/ia64/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/ia64/include/asm/spinlock.h
--- a/arch/ia64/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/ia64/include/asm/spinlock.h
@@ -213,6 +213,9 @@ static inline int __raw_read_trylock(raw
 	return (u32)ia64_cmpxchg4_acq((__u32 *)(x), new.word, old.word) == old.word;
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN arch/mips/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/mips/include/asm/spinlock.h
--- a/arch/mips/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/mips/include/asm/spinlock.h
@@ -480,6 +480,8 @@ static inline int __raw_write_trylock(ra
 	return ret;
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
diff -puN arch/parisc/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/parisc/include/asm/spinlock.h
--- a/arch/parisc/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/parisc/include/asm/spinlock.h
@@ -187,6 +187,9 @@ static __inline__ int __raw_write_can_lo
 	return !rw->counter;
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN arch/powerpc/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/powerpc/include/asm/spinlock.h
--- a/arch/powerpc/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/powerpc/include/asm/spinlock.h
@@ -287,6 +287,9 @@ static inline void __raw_write_unlock(ra
 	rw->lock = 0;
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	__spin_yield(lock)
 #define _raw_read_relax(lock)	__rw_yield(lock)
 #define _raw_write_relax(lock)	__rw_yield(lock)
diff -puN arch/s390/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/s390/include/asm/spinlock.h
--- a/arch/s390/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/s390/include/asm/spinlock.h
@@ -172,6 +172,9 @@ static inline int __raw_write_trylock(ra
 	return _raw_write_trylock_retry(rw);
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
diff -puN arch/sh/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/sh/include/asm/spinlock.h
--- a/arch/sh/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/sh/include/asm/spinlock.h
@@ -216,6 +216,9 @@ static inline int __raw_write_trylock(ra
 	return (oldval > (RW_LOCK_BIAS - 1));
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN arch/sparc/include/asm/spinlock_32.h~allow-rwlocks-to-re-enable-interrupts arch/sparc/include/asm/spinlock_32.h
--- a/arch/sparc/include/asm/spinlock_32.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/sparc/include/asm/spinlock_32.h
@@ -177,6 +177,8 @@ static inline int __read_trylock(raw_rwl
 #define __raw_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define __raw_read_lock_flags(rw, flags)   __raw_read_lock(rw)
+#define __raw_write_lock_flags(rw, flags)  __raw_write_lock(rw)
 
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
diff -puN arch/sparc/include/asm/spinlock_64.h~allow-rwlocks-to-re-enable-interrupts arch/sparc/include/asm/spinlock_64.h
--- a/arch/sparc/include/asm/spinlock_64.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/sparc/include/asm/spinlock_64.h
@@ -211,9 +211,11 @@ static int inline __write_trylock(raw_rw
 }
 
 #define __raw_read_lock(p)	__read_lock(p)
+#define __raw_read_lock_flags(p, f) __read_lock(p)
 #define __raw_read_trylock(p)	__read_trylock(p)
 #define __raw_read_unlock(p)	__read_unlock(p)
 #define __raw_write_lock(p)	__write_lock(p)
+#define __raw_write_lock_flags(p, f) __write_lock(p)
 #define __raw_write_unlock(p)	__write_unlock(p)
 #define __raw_write_trylock(p)	__write_trylock(p)
 
diff -puN arch/x86/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts arch/x86/include/asm/spinlock.h
--- a/arch/x86/include/asm/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/arch/x86/include/asm/spinlock.h
@@ -295,6 +295,9 @@ static inline void __raw_write_unlock(ra
 		     : "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN include/asm-m32r/spinlock.h~allow-rwlocks-to-re-enable-interrupts include/asm-m32r/spinlock.h
--- a/include/asm-m32r/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/include/asm-m32r/spinlock.h
@@ -316,6 +316,9 @@ static inline int __raw_write_trylock(ra
 	return 0;
 }
 
+#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
+#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+
 #define _raw_spin_relax(lock)	cpu_relax()
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
diff -puN include/linux/spinlock.h~allow-rwlocks-to-re-enable-interrupts include/linux/spinlock.h
--- a/include/linux/spinlock.h~allow-rwlocks-to-re-enable-interrupts
+++ a/include/linux/spinlock.h
@@ -153,9 +153,11 @@ do {								\
  extern int _raw_spin_trylock(spinlock_t *lock);
  extern void _raw_spin_unlock(spinlock_t *lock);
  extern void _raw_read_lock(rwlock_t *lock);
+#define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
  extern int _raw_read_trylock(rwlock_t *lock);
  extern void _raw_read_unlock(rwlock_t *lock);
  extern void _raw_write_lock(rwlock_t *lock);
+#define _raw_write_lock_flags(lock, flags) _raw_write_lock(lock)
  extern int _raw_write_trylock(rwlock_t *lock);
  extern void _raw_write_unlock(rwlock_t *lock);
 #else
@@ -165,9 +167,13 @@ do {								\
 # define _raw_spin_trylock(lock)	__raw_spin_trylock(&(lock)->raw_lock)
 # define _raw_spin_unlock(lock)		__raw_spin_unlock(&(lock)->raw_lock)
 # define _raw_read_lock(rwlock)		__raw_read_lock(&(rwlock)->raw_lock)
+# define _raw_read_lock_flags(lock, flags) \
+		__raw_read_lock_flags(&(lock)->raw_lock, *(flags))
 # define _raw_read_trylock(rwlock)	__raw_read_trylock(&(rwlock)->raw_lock)
 # define _raw_read_unlock(rwlock)	__raw_read_unlock(&(rwlock)->raw_lock)
 # define _raw_write_lock(rwlock)	__raw_write_lock(&(rwlock)->raw_lock)
+# define _raw_write_lock_flags(lock, flags) \
+		__raw_write_lock_flags(&(lock)->raw_lock, *(flags))
 # define _raw_write_trylock(rwlock)	__raw_write_trylock(&(rwlock)->raw_lock)
 # define _raw_write_unlock(rwlock)	__raw_write_unlock(&(rwlock)->raw_lock)
 #endif
diff -puN kernel/spinlock.c~allow-rwlocks-to-re-enable-interrupts kernel/spinlock.c
--- a/kernel/spinlock.c~allow-rwlocks-to-re-enable-interrupts
+++ a/kernel/spinlock.c
@@ -121,7 +121,8 @@ unsigned long __lockfunc _read_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
+			     _raw_read_lock_flags, &flags);
 	return flags;
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
@@ -151,7 +152,8 @@ unsigned long __lockfunc _write_lock_irq
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
+			     _raw_write_lock_flags, &flags);
 	return flags;
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

