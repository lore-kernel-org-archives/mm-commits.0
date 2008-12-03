From: akpm@linux-foundation.org
Subject: + factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:13:24 -0800
Message-ID: <200812030013.mB30DPAB032286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810AbYLCAOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:14:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, a.p.zijlstra@chello.nl, linux-arch@vger.kernel.org, mingo@elte.hu, ptesarik@suse.cz, tony.luck@intel.com


The patch titled
     Factor out #ifdefs from kernel/spinlock.c to LOCK_CONTENDED_FLAGS
has been added to the -mm tree.  Its filename is
     factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch

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
@@ -382,6 +382,23 @@ do {								\
 
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
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
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

mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

