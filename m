From: akpm@linux-foundation.org
Subject: [to-be-updated] spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch removed from -mm tree
Date: Fri, 24 Jul 2009 14:57:15 -0700
Message-ID: <200907242157.n6OLvFKr004018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568AbZGXV57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 17:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kilroyd@googlemail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     spinlocks: check spinlock_t/rwlock_t argument type on non-SMP builds
has been removed from the -mm tree.  Its filename was
     spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch

This patch was dropped because an updated version will be merged

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

Add typechecking on the first argument of these macro functions. Note
that since the typecheck now references the variable, the explicit read
is redundant and can be removed.

This change causes compiler warnings in net/ipv4/route.c, as this passes
NULL as the first argument in the UP configuration. Simply cast this.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock_api_up.h |  100 +++++++++++++++---------------
 net/ipv4/route.c                |    2 
 2 files changed, 51 insertions(+), 51 deletions(-)

diff -puN include/linux/spinlock_api_up.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds include/linux/spinlock_api_up.h
--- a/include/linux/spinlock_api_up.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds
+++ a/include/linux/spinlock_api_up.h
@@ -24,58 +24,58 @@
  * flags straight, to suppress compiler warnings of unused lock
  * variables, and to add the proper checker annotations:
  */
-#define __LOCK(lock) \
-  do { preempt_disable(); __acquire(lock); (void)(lock); } while (0)
+#define __LOCK(type, lock) \
+  do { typecheck(type*, lock); preempt_disable(); __acquire(lock); } while (0)
 
-#define __LOCK_BH(lock) \
-  do { local_bh_disable(); __LOCK(lock); } while (0)
+#define __LOCK_BH(type, lock) \
+  do { local_bh_disable(); __LOCK(type, lock); } while (0)
 
-#define __LOCK_IRQ(lock) \
-  do { local_irq_disable(); __LOCK(lock); } while (0)
+#define __LOCK_IRQ(type, lock) \
+  do { local_irq_disable(); __LOCK(type, lock); } while (0)
 
-#define __LOCK_IRQSAVE(lock, flags) \
-  do { local_irq_save(flags); __LOCK(lock); } while (0)
-
-#define __UNLOCK(lock) \
-  do { preempt_enable(); __release(lock); (void)(lock); } while (0)
-
-#define __UNLOCK_BH(lock) \
-  do { preempt_enable_no_resched(); local_bh_enable(); __release(lock); (void)(lock); } while (0)
-
-#define __UNLOCK_IRQ(lock) \
-  do { local_irq_enable(); __UNLOCK(lock); } while (0)
-
-#define __UNLOCK_IRQRESTORE(lock, flags) \
-  do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
-
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
+#define __LOCK_IRQSAVE(type, lock, flags) \
+  do { local_irq_save(flags); __LOCK(type, lock); } while (0)
+
+#define __UNLOCK(type, lock) \
+  do { typecheck(type*, lock); preempt_enable(); __release(lock); } while (0)
+
+#define __UNLOCK_BH(type, lock) \
+  do { typecheck(type*, lock); preempt_enable_no_resched(); local_bh_enable(); __release(lock); } while (0)
+
+#define __UNLOCK_IRQ(type, lock) \
+  do { local_irq_enable(); __UNLOCK(type, lock); } while (0)
+
+#define __UNLOCK_IRQRESTORE(type, lock, flags) \
+  do { local_irq_restore(flags); __UNLOCK(type, lock); } while (0)
+
+#define _spin_lock(lock)			__LOCK(spinlock_t, lock)
+#define _spin_lock_nested(lock, subclass)	__LOCK(spinlock_t, lock)
+#define _read_lock(lock)			__LOCK(rwlock_t, lock)
+#define _write_lock(lock)			__LOCK(rwlock_t, lock)
+#define _spin_lock_bh(lock)			__LOCK_BH(spinlock_t, lock)
+#define _read_lock_bh(lock)			__LOCK_BH(rwlock_t, lock)
+#define _write_lock_bh(lock)			__LOCK_BH(rwlock_t, lock)
+#define _spin_lock_irq(lock)			__LOCK_IRQ(spinlock_t, lock)
+#define _read_lock_irq(lock)			__LOCK_IRQ(rwlock_t, lock)
+#define _write_lock_irq(lock)			__LOCK_IRQ(rwlock_t, lock)
+#define _spin_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(spinlock_t, lock, flags)
+#define _read_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(rwlock_t, lock, flags)
+#define _write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(rwlock_t, lock, flags)
+#define _spin_trylock(lock)			({ __LOCK(spinlock_t, lock); 1; })
+#define _read_trylock(lock)			({ __LOCK(rwlock_t, lock); 1; })
+#define _write_trylock(lock)			({ __LOCK(rwlock_t, lock); 1; })
+#define _spin_trylock_bh(lock)			({ __LOCK_BH(spinlock_t, lock); 1; })
+#define _spin_unlock(lock)			__UNLOCK(spinlock_t, lock)
+#define _read_unlock(lock)			__UNLOCK(rwlock_t, lock)
+#define _write_unlock(lock)			__UNLOCK(rwlock_t, lock)
+#define _spin_unlock_bh(lock)			__UNLOCK_BH(spinlock_t, lock)
+#define _write_unlock_bh(lock)			__UNLOCK_BH(rwlock_t, lock)
+#define _read_unlock_bh(lock)			__UNLOCK_BH(rwlock_t, lock)
+#define _spin_unlock_irq(lock)			__UNLOCK_IRQ(spinlock_t, lock)
+#define _read_unlock_irq(lock)			__UNLOCK_IRQ(rwlock_t, lock)
+#define _write_unlock_irq(lock)			__UNLOCK_IRQ(rwlock_t, lock)
+#define _spin_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(spinlock_t, lock, flags)
+#define _read_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(rwlock_t, lock, flags)
+#define _write_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(rwlock_t, lock, flags)
 
 #endif /* __LINUX_SPINLOCK_API_UP_H */
diff -puN net/ipv4/route.c~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds net/ipv4/route.c
--- a/net/ipv4/route.c~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds
+++ a/net/ipv4/route.c
@@ -242,7 +242,7 @@ static __init void rt_hash_lock_init(voi
 		spin_lock_init(&rt_hash_locks[i]);
 }
 #else
-# define rt_hash_lock_addr(slot) NULL
+# define rt_hash_lock_addr(slot) ((spinlock_t *) NULL)
 
 static inline void rt_hash_lock_init(void)
 {
_

Patches currently in -mm which might be from kilroyd@googlemail.com are

linux-next.patch
spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds.patch

