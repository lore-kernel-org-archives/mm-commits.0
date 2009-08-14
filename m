From: akpm@linux-foundation.org
Subject: [to-be-updated] spinlock-allow-inlined-spinlocks.patch removed from -mm tree
Date: Fri, 14 Aug 2009 16:33:01 -0700
Message-ID: <200908142333.n7ENX1Zp025033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757259AbZHNXdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 19:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     spinlock: allow inlined spinlocks
has been removed from the -mm tree.  Its filename was
     spinlock-allow-inlined-spinlocks.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spinlock: allow inlined spinlocks
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add new config option SPINLOCK_INLINE and some defines which depend on it
in order to generate inlined spinlock code instead of out-of-line code.

Avoiding function calls for spinlocks gives 1%-5% less cpu usage on
network benchmarks on s390.

Architectures must select HAVE_SPINLOCK_INLINE_SUPPORT to enable this
config option.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock_api_smp.h |   35 +++++++++++++++++++++++++++++
 kernel/spinlock.c                |    4 +++
 lib/Kconfig.debug                |   14 +++++++++++
 3 files changed, 53 insertions(+)

diff -puN include/linux/spinlock_api_smp.h~spinlock-allow-inlined-spinlocks include/linux/spinlock_api_smp.h
--- a/include/linux/spinlock_api_smp.h~spinlock-allow-inlined-spinlocks
+++ a/include/linux/spinlock_api_smp.h
@@ -19,6 +19,8 @@ int in_lock_functions(unsigned long addr
 
 #define assert_spin_locked(x)	BUG_ON(!spin_is_locked(x))
 
+#ifndef CONFIG_SPINLOCK_INLINE
+
 void __lockfunc _spin_lock(spinlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 							__acquires(lock);
@@ -60,6 +62,39 @@ void __lockfunc _read_unlock_irqrestore(
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+#else /* CONFIG_HAVE_SPINLOCK_INLINE_SUPPORT */
+
+#define _spin_trylock(lock)	  __spin_trylock(lock)
+#define _read_trylock(lock)	  __read_trylock(lock)
+#define _write_trylock(lock)	  __write_trylock(lock)
+#define _read_lock(lock)	  __read_lock(lock)
+#define _spin_lock_irqsave(lock)  __spin_lock_irqsave(lock)
+#define _spin_lock_irq(lock)	  __spin_lock_irq(lock)
+#define _spin_lock_bh(lock)	  __spin_lock_bh(lock)
+#define _read_lock_irqsave(lock)  __read_lock_irqsave(lock)
+#define _read_lock_irq(lock)	  __read_lock_irq(lock)
+#define _read_lock_bh(lock)	  __read_lock_bh(lock)
+#define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
+#define _write_lock_irq(lock)	  __write_lock_irq(lock)
+#define _write_lock_bh(lock)	  __write_lock_bh(lock)
+#define _spin_lock(lock)	  __spin_lock(lock)
+#define _write_lock(lock)	  __write_lock(lock)
+#define _spin_unlock(lock)	  __spin_unlock(lock)
+#define _write_unlock(lock)	  __write_unlock(lock)
+#define _read_unlock(lock)	  __read_unlock(lock)
+#define _spin_unlock_irq(lock)	  __spin_unlock_irq(lock)
+#define _spin_unlock_bh(lock)	  __spin_unlock_bh(lock)
+#define _read_unlock_irq(lock)	  __read_unlock_irq(lock)
+#define _read_unlock_bh(lock)	  __read_unlock_bh(lock)
+#define _write_unlock_irq(lock)	  __write_unlock_irq(lock)
+#define _write_unlock_bh(lock)	  __write_unlock_bh(lock)
+#define _spin_trylock_bh(lock)	  __spin_trylock_bh(lock)
+#define _spin_unlock_irqrestore(lock, flags)  __spin_unlock_irqrestore(lock, flags)
+#define _read_unlock_irqrestore(lock, flags)  __read_unlock_irqrestore(lock, flags)
+#define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
+
+#endif /* CONFIG_HAVE_SPINLOCK_INLINE_SUPPORT */
+
 static inline int __spin_trylock(spinlock_t *lock)
 {
 	preempt_disable();
diff -puN kernel/spinlock.c~spinlock-allow-inlined-spinlocks kernel/spinlock.c
--- a/kernel/spinlock.c~spinlock-allow-inlined-spinlocks
+++ a/kernel/spinlock.c
@@ -21,6 +21,8 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
+#ifndef CONFIG_SPINLOCK_INLINE
+
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
 	return __spin_trylock(lock);
@@ -320,6 +322,8 @@ int __lockfunc _spin_trylock_bh(spinlock
 }
 EXPORT_SYMBOL(_spin_trylock_bh);
 
+#endif /* CONFIG_HAVE_SPINLOCK_INLINE_SUPPORT */
+
 notrace int in_lock_functions(unsigned long addr)
 {
 	/* Linker adds these: start and end of __lockfunc functions */
diff -puN lib/Kconfig.debug~spinlock-allow-inlined-spinlocks lib/Kconfig.debug
--- a/lib/Kconfig.debug~spinlock-allow-inlined-spinlocks
+++ a/lib/Kconfig.debug
@@ -922,6 +922,20 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config HAVE_SPINLOCK_INLINE_SUPPORT
+	bool
+
+config SPINLOCK_INLINE
+	bool "Inline spinlock code"
+	depends on HAVE_SPINLOCK_INLINE_SUPPORT
+	depends on !DEBUG_SPINLOCK
+	depends on SMP && !PREEMPT
+	help
+	  Select this option if you want to have inlined spinlock code instead
+	  of an out of line implementation.
+	  This will generate a larger kernel image. On some architectures this
+	  increases performance.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
spinlock-move-spinlock-function-bodies-to-header-file.patch
spinlock-allow-inlined-spinlocks.patch
spinlock-allow-inlined-spinlocks-on-s390.patch

