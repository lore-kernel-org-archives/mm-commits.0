From: akpm@linux-foundation.org
Subject: [merged] factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:45 -0700
Message-ID: <200904061938.n36Jcjhp013524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbZDFUdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, a.p.zijlstra@chello.nl, linux-arch@vger.kernel.org, mingo@elte.hu, ptesarik@suse.cz, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Factor out #ifdefs from kernel/spinlock.c to LOCK_CONTENDED_FLAGS
has been removed from the -mm tree.  Its filename was
     factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Factor out #ifdefs from kernel/spinlock.c to LOCK_CONTENDED_FLAGS
From: Robin Holt <holt@sgi.com>

SGI has observed that on large systems, interrupts are not serviced for a
long period of time when waiting for a rwlock.  The following patch series
re-enables irqs while waiting for the lock, resembling the code which is
already there for spinlocks.

I only made the ia64 version, because the patch adds some overhead to the
fast path.  I assume there is currently no demand to have this for other
architectures, because the systems are not so large.  Of course, the
possibility to implement raw_{read|write}_lock_flags for any architecture
is still there.


This patch:

The new macro LOCK_CONTENDED_FLAGS expands to the correct implementation
depending on the config options, so that IRQ's are re-enabled when
possible, but they remain disabled if CONFIG_LOCKDEP is set.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |   17 +++++++++++++++++
 kernel/spinlock.c       |   12 ++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff -puN include/linux/lockdep.h~factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags include/linux/lockdep.h
--- a/include/linux/lockdep.h~factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags
+++ a/include/linux/lockdep.h
@@ -364,6 +364,23 @@ do {								\
 
 #endif /* CONFIG_LOCK_STAT */
 
+#ifdef CONFIG_LOCKDEP
+
+/*
+ * On lockdep we dont want the hand-coded irq-enable of
+ * _raw_*_lock_flags() code, because lockdep assumes
+ * that interrupts are not re-enabled during lock-acquire:
+ */
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
+	LOCK_CONTENDED((_lock), (try), (lock))
+
+#else /* CONFIG_LOCKDEP */
+
+#define LOCK_CONTENDED_FLAGS(_lock, try, lock, lockfl, flags) \
+	lockfl((_lock), (flags))
+
+#endif /* CONFIG_LOCKDEP */
+
 #ifdef CONFIG_GENERIC_HARDIRQS
 extern void early_init_irq_lock_class(void);
 #else
diff -puN kernel/spinlock.c~factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags kernel/spinlock.c
--- a/kernel/spinlock.c~factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags
+++ a/kernel/spinlock.c
@@ -299,16 +299,8 @@ unsigned long __lockfunc _spin_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
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
+	LOCK_CONTENDED_FLAGS(lock, _raw_spin_trylock, _raw_spin_lock,
+				_raw_spin_lock_flags, &flags);
 	return flags;
 }
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

