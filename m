From: akpm@linux-foundation.org
Subject: + spinlock-move-spinlock-function-bodies-to-header-file.patch added to -mm tree
Date: Wed, 12 Aug 2009 14:42:35 -0700
Message-ID: <200908122142.n7CLgaDY023331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbZHLVm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 17:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     spinlock: move spinlock function bodies to header file
has been added to the -mm tree.  Its filename is
     spinlock-move-spinlock-function-bodies-to-header-file.patch

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
Subject: spinlock: move spinlock function bodies to header file
From: Heiko Carstens <heiko.carstens@de.ibm.com>

This patch set allows to have inlined spinlocks again.

The rationale behind this is that function calls on at least s390 are
expensive.

If one considers that server kernels are usually compiled with
!CONFIG_PREEMPT a simple spin_lock is just a compare and swap loop.  The
extra overhead for a function call is significant.  With inlined spinlocks
overall cpu usage gets reduced by 1%-5% on s390.  These numbers were taken
with some network benchmarks.  However I expect any workload that calls
frequently into the kernel and which grabs a few locks to perform better.

The implementation is straight forward: move the function bodies of the
locking functions to static inline functions and place them in a header
file.

Dependent on CONFIG_SPINLOCK_INLINE generate out-of-line or inlined
locking functions.



This patch:

Move spinlock function bodies to header file by creating a static inline
version of each variant.

Use the inline version on the out-of-line code.  This shouldn't make any
difference besides that the spinlock code can now be used to generate
inlined spinlock code.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h         |   18 -
 include/linux/spinlock_api_smp.h |  263 +++++++++++++++++++++++++++++
 kernel/spinlock.c                |  174 +++----------------
 3 files changed, 300 insertions(+), 155 deletions(-)

diff -puN include/linux/spinlock.h~spinlock-move-spinlock-function-bodies-to-header-file include/linux/spinlock.h
--- a/include/linux/spinlock.h~spinlock-move-spinlock-function-bodies-to-header-file
+++ a/include/linux/spinlock.h
@@ -143,15 +143,6 @@ static inline void smp_mb__after_lock(vo
  */
 #define spin_unlock_wait(lock)	__raw_spin_unlock_wait(&(lock)->raw_lock)
 
-/*
- * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-# include <linux/spinlock_api_smp.h>
-#else
-# include <linux/spinlock_api_up.h>
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void _raw_spin_lock(spinlock_t *lock);
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
@@ -380,4 +371,13 @@ extern int _atomic_dec_and_lock(atomic_t
  */
 #define spin_can_lock(lock)	(!spin_is_locked(lock))
 
+/*
+ * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+# include <linux/spinlock_api_smp.h>
+#else
+# include <linux/spinlock_api_up.h>
+#endif
+
 #endif /* __LINUX_SPINLOCK_H */
diff -puN include/linux/spinlock_api_smp.h~spinlock-move-spinlock-function-bodies-to-header-file include/linux/spinlock_api_smp.h
--- a/include/linux/spinlock_api_smp.h~spinlock-move-spinlock-function-bodies-to-header-file
+++ a/include/linux/spinlock_api_smp.h
@@ -60,4 +60,267 @@ void __lockfunc _read_unlock_irqrestore(
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+static inline int __spin_trylock(spinlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_spin_trylock(lock)) {
+		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __read_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_read_trylock(lock)) {
+		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __write_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_write_trylock(lock)) {
+		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+/*
+ * If lockdep is enabled then we use the non-preemption spin-ops
+ * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
+ * not re-enabled during lock-acquire (which the preempt-spin-ops do):
+ */
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+
+static inline void __read_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __spin_lock_irqsave(spinlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	/*
+	 * On lockdep we dont want the hand-coded irq-enable of
+	 * _raw_spin_lock_flags() code, because lockdep assumes
+	 * that interrupts are not re-enabled during lock-acquire:
+	 */
+#ifdef CONFIG_LOCKDEP
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+#else
+	_raw_spin_lock_flags(lock, &flags);
+#endif
+	return flags;
+}
+
+static inline void __spin_lock_irq(spinlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline void __spin_lock_bh(spinlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
+			     _raw_read_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __read_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline void __read_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
+			     _raw_write_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __write_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __write_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __spin_lock(spinlock_t *lock)
+{
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline void __write_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+#endif /* CONFIG_PREEMPT */
+
+static inline void __spin_unlock(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __write_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __read_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __spin_unlock_irqrestore(spinlock_t *lock,
+					    unsigned long flags)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __spin_unlock_irq(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __spin_unlock_bh(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __read_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __read_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __write_unlock_irqrestore(rwlock_t *lock,
+					     unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __write_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __write_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline int __spin_trylock_bh(spinlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	if (_raw_spin_trylock(lock)) {
+		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	return 0;
+}
+
 #endif /* __LINUX_SPINLOCK_API_SMP_H */
diff -puN kernel/spinlock.c~spinlock-move-spinlock-function-bodies-to-header-file kernel/spinlock.c
--- a/kernel/spinlock.c~spinlock-move-spinlock-function-bodies-to-header-file
+++ a/kernel/spinlock.c
@@ -23,40 +23,19 @@
 
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-	
-	preempt_enable();
-	return 0;
+	return __spin_trylock(lock);
 }
 EXPORT_SYMBOL(_spin_trylock);
 
 int __lockfunc _read_trylock(rwlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_read_trylock(lock)) {
-		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable();
-	return 0;
+	return __read_trylock(lock);
 }
 EXPORT_SYMBOL(_read_trylock);
 
 int __lockfunc _write_trylock(rwlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_write_trylock(lock)) {
-		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable();
-	return 0;
+	return __write_trylock(lock);
 }
 EXPORT_SYMBOL(_write_trylock);
 
@@ -69,129 +48,74 @@ EXPORT_SYMBOL(_write_trylock);
 
 void __lockfunc _read_lock(rwlock_t *lock)
 {
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock(lock);
 }
 EXPORT_SYMBOL(_read_lock);
 
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	/*
-	 * On lockdep we dont want the hand-coded irq-enable of
-	 * _raw_spin_lock_flags() code, because lockdep assumes
-	 * that interrupts are not re-enabled during lock-acquire:
-	 */
-#ifdef CONFIG_LOCKDEP
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
-#else
-	_raw_spin_lock_flags(lock, &flags);
-#endif
-	return flags;
+	return __spin_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irqsave);
 
 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
 
 void __lockfunc _spin_lock_bh(spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
 
 unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
-			     _raw_read_lock_flags, &flags);
-	return flags;
+	return __read_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
 
 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock_irq(lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
 
 void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock_bh(lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
 
 unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
-			     _raw_write_lock_flags, &flags);
-	return flags;
+	return __write_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
 
 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock_irq(lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
 
 void __lockfunc _write_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock_bh(lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
 
 void __lockfunc _spin_lock(spinlock_t *lock)
 {
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock(lock);
 }
-
 EXPORT_SYMBOL(_spin_lock);
 
 void __lockfunc _write_lock(rwlock_t *lock)
 {
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock(lock);
 }
-
 EXPORT_SYMBOL(_write_lock);
 
 #else /* CONFIG_PREEMPT: */
@@ -320,121 +244,79 @@ EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	preempt_enable();
+	__spin_unlock(lock);
 }
 EXPORT_SYMBOL(_spin_unlock);
 
 void __lockfunc _write_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable();
+	__write_unlock(lock);
 }
 EXPORT_SYMBOL(_write_unlock);
 
 void __lockfunc _read_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable();
+	__read_unlock(lock);
 }
 EXPORT_SYMBOL(_read_unlock);
 
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
 
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__spin_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_irq);
 
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__spin_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_bh);
 
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__read_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_read_unlock_irqrestore);
 
 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__read_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_read_unlock_irq);
 
 void __lockfunc _read_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__read_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_read_unlock_bh);
 
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__write_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_write_unlock_irqrestore);
 
 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__write_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_write_unlock_irq);
 
 void __lockfunc _write_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__write_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_write_unlock_bh);
 
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
