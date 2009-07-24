From: akpm@linux-foundation.org
Subject: + spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:00:37 -0700
Message-ID: <200907242200.n6OM0bGi009459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbZGXWBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kilroyd@googlemail.com, mingo@elte.hu


The patch titled
     spinlocks: check spinlock_t/rwlock_t argument type on non-SMP builds
has been added to the -mm tree.  Its filename is
     spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch

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
Subject: spinlocks: check spinlock_t/rwlock_t argument type on non-SMP builds
From: David Kilroy <kilroyd@googlemail.com>

When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy to get
the first argument to the spinlock/rwlock functions wrong.  This is
because the parameter is not actually used in this configuration.

Typically you will only find out it's wrong
 * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
 * after you've submitted your beautiful patch series.

The first means a long wait, and the latter is a bit late.

Change the intermediate macros into inline functions.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h        |    6 -
 include/linux/spinlock_api_up.h |  118 ++++++++++++++++++++++--------
 2 files changed, 92 insertions(+), 32 deletions(-)

diff -puN include/linux/spinlock.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds include/linux/spinlock.h
--- a/include/linux/spinlock.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds
+++ a/include/linux/spinlock.h
@@ -249,17 +249,17 @@ static inline void smp_mb__after_lock(vo
 #define spin_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_spin_lock_irqsave(lock, flags);	\
+		_spin_lock_irqsave(lock, &flags);	\
 	} while (0)
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_read_lock_irqsave(lock, flags);	\
+		_read_lock_irqsave(lock, &flags);	\
 	} while (0)
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_write_lock_irqsave(lock, flags);	\
+		_write_lock_irqsave(lock, &flags);	\
 	} while (0)
 #define spin_lock_irqsave_nested(lock, flags, subclass)	\
 	spin_lock_irqsave(lock, flags)
diff -puN include/linux/spinlock_api_up.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds include/linux/spinlock_api_up.h
--- a/include/linux/spinlock_api_up.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds
+++ a/include/linux/spinlock_api_up.h
@@ -48,34 +48,94 @@
 #define __UNLOCK_IRQRESTORE(lock, flags) \
   do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
 
-#define _spin_lock(lock)			__LOCK(lock)
-#define _spin_lock_nested(lock, subclass)	__LOCK(lock)
-#define _read_lock(lock)			__LOCK(lock)
-#define _write_lock(lock)			__LOCK(lock)
-#define _spin_lock_bh(lock)			__LOCK_BH(lock)
-#define _read_lock_bh(lock)			__LOCK_BH(lock)
-#define _write_lock_bh(lock)			__LOCK_BH(lock)
-#define _spin_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _read_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _write_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _spin_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(lock, flags)
-#define _read_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(lock, flags)
-#define _write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
-#define _spin_trylock(lock)			({ __LOCK(lock); 1; })
-#define _read_trylock(lock)			({ __LOCK(lock); 1; })
-#define _write_trylock(lock)			({ __LOCK(lock); 1; })
-#define _spin_trylock_bh(lock)			({ __LOCK_BH(lock); 1; })
-#define _spin_unlock(lock)			__UNLOCK(lock)
-#define _read_unlock(lock)			__UNLOCK(lock)
-#define _write_unlock(lock)			__UNLOCK(lock)
-#define _spin_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _write_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _read_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _spin_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _read_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _write_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _spin_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
-#define _read_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
-#define _write_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
+static inline void _spin_lock(spinlock_t *lock)
+{ __LOCK(lock); }
+
+static inline void _spin_lock_nested(spinlock_t *lock, int subclass)
+{ __LOCK(lock); }
+
+static inline void _read_lock(rwlock_t *lock)
+{ __LOCK(lock); }
+
+static inline void _write_lock(rwlock_t *lock)
+{ __LOCK(lock); }
+
+static inline void _spin_lock_bh(spinlock_t *lock)
+{ __LOCK_BH(lock); }
+
+static inline void _read_lock_bh(rwlock_t *lock)
+{ __LOCK_BH(lock); }
+
+static inline void _write_lock_bh(rwlock_t *lock)
+{ __LOCK_BH(lock); }
+
+static inline void _spin_lock_irq(spinlock_t *lock)
+{ __LOCK_IRQ(lock); }
+
+static inline void _read_lock_irq(rwlock_t *lock)
+{ __LOCK_IRQ(lock); }
+
+static inline void _write_lock_irq(rwlock_t *lock)
+{ __LOCK_IRQ(lock); }
+
+static inline void _spin_lock_irqsave(spinlock_t *lock, unsigned long *flags)
+{ __LOCK_IRQSAVE(lock, *flags); }
+
+static inline void _read_lock_irqsave(rwlock_t *lock, unsigned long *flags)
+{ __LOCK_IRQSAVE(lock, *flags); }
+
+static inline void _write_lock_irqsave(rwlock_t *lock, unsigned long *flags)
+{ __LOCK_IRQSAVE(lock, *flags); }
+
+static inline int _spin_trylock(spinlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline int _read_trylock(rwlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline int _write_trylock(rwlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline int _spin_trylock_bh(spinlock_t *lock)
+{ __LOCK(lock); return 1; }
+
+static inline void _spin_unlock(spinlock_t *lock)
+{ __UNLOCK(lock); }
+
+static inline void _read_unlock(rwlock_t *lock)
+{ __UNLOCK(lock); }
+
+static inline void _write_unlock(rwlock_t *lock)
+{ __UNLOCK(lock); }
+
+static inline void _spin_unlock_bh(spinlock_t *lock)
+{ __UNLOCK_BH(lock); }
+
+static inline void _read_unlock_bh(rwlock_t *lock)
+{ __UNLOCK_BH(lock); }
+
+static inline void _write_unlock_bh(rwlock_t *lock)
+{ __UNLOCK_BH(lock); }
+
+static inline void _spin_unlock_irq(spinlock_t *lock)
+{ __UNLOCK_IRQ(lock); }
+
+static inline void _read_unlock_irq(rwlock_t *lock)
+{ __UNLOCK_IRQ(lock); }
+
+static inline void _write_unlock_irq(rwlock_t *lock)
+{ __UNLOCK_IRQ(lock); }
+
+static inline void _spin_unlock_irqrestore(spinlock_t *lock,
+					   unsigned long flags)
+{ __UNLOCK_IRQRESTORE(lock, flags); }
+
+static inline void _read_unlock_irqrestore(rwlock_t *lock,
+					   unsigned long flags)
+{ __UNLOCK_IRQRESTORE(lock, flags); }
+
+static inline void _write_unlock_irqrestore(rwlock_t *lock,
+					    unsigned long flags)
+{ __UNLOCK_IRQRESTORE(lock, flags); }
 
 #endif /* __LINUX_SPINLOCK_API_UP_H */
_

Patches currently in -mm which might be from kilroyd@googlemail.com are

linux-next.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch

