From: akpm@linux-foundation.org
Subject: - introduce-write_trylock_irqsave.patch removed from -mm tree
Date: Thu, 10 May 2007 16:57:16 -0700
Message-ID: <200705102357.l4ANvGPu001810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009AbXEJX5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 19:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sripathik@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Introduce write_trylock_irqsave
has been removed from the -mm tree.  Its filename was
     introduce-write_trylock_irqsave.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Introduce write_trylock_irqsave
From: Sripathi Kodi <sripathik@in.ibm.com>

I am trying to fix the BUG I mentioned here:
http://lkml.org/lkml/2007/04/20/41. I noticed that an elegant way to solve
this problem is to have a write_trylock_irqsave helper function. Since we
don't have this now, the code in ptrace_attach  implements it using
local_irq_disable and write_trylock. I wish to add write_trylock_irqsave to
mainline kernel and then fix the -rt specific problem using this.

The patch below adds write_trylock_irqsave function.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h         |    2 ++
 include/linux/spinlock_api_smp.h |    1 +
 include/linux/spinlock_api_up.h  |    2 ++
 kernel/spinlock.c                |   14 ++++++++++++++
 4 files changed, 19 insertions(+)

diff -puN include/linux/spinlock.h~introduce-write_trylock_irqsave include/linux/spinlock.h
--- a/include/linux/spinlock.h~introduce-write_trylock_irqsave
+++ a/include/linux/spinlock.h
@@ -171,6 +171,8 @@ do {								\
 #define spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
 #define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
 #define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
+#define write_trylock_irqsave(lock, flags) \
+		__cond_lock(lock, _write_trylock_irqsave(lock, flags))
 
 #define spin_lock(lock)			_spin_lock(lock)
 
diff -puN include/linux/spinlock_api_smp.h~introduce-write_trylock_irqsave include/linux/spinlock_api_smp.h
--- a/include/linux/spinlock_api_smp.h~introduce-write_trylock_irqsave
+++ a/include/linux/spinlock_api_smp.h
@@ -41,6 +41,7 @@ unsigned long __lockfunc _write_lock_irq
 int __lockfunc _spin_trylock(spinlock_t *lock);
 int __lockfunc _read_trylock(rwlock_t *lock);
 int __lockfunc _write_trylock(rwlock_t *lock);
+int __lockfunc _write_trylock_irqsave(rwlock_t *lock, unsigned long flags);
 int __lockfunc _spin_trylock_bh(spinlock_t *lock);
 void __lockfunc _spin_unlock(spinlock_t *lock)		__releases(lock);
 void __lockfunc _read_unlock(rwlock_t *lock)		__releases(lock);
diff -puN include/linux/spinlock_api_up.h~introduce-write_trylock_irqsave include/linux/spinlock_api_up.h
--- a/include/linux/spinlock_api_up.h~introduce-write_trylock_irqsave
+++ a/include/linux/spinlock_api_up.h
@@ -64,6 +64,8 @@
 #define _spin_trylock(lock)			({ __LOCK(lock); 1; })
 #define _read_trylock(lock)			({ __LOCK(lock); 1; })
 #define _write_trylock(lock)			({ __LOCK(lock); 1; })
+#define _write_trylock_irqsave(lock, flags) \
+				({ __LOCK_IRQSAVE(lock, flags); 1; })
 #define _spin_trylock_bh(lock)			({ __LOCK_BH(lock); 1; })
 #define _spin_unlock(lock)			__UNLOCK(lock)
 #define _read_unlock(lock)			__UNLOCK(lock)
diff -puN kernel/spinlock.c~introduce-write_trylock_irqsave kernel/spinlock.c
--- a/kernel/spinlock.c~introduce-write_trylock_irqsave
+++ a/kernel/spinlock.c
@@ -60,6 +60,20 @@ int __lockfunc _write_trylock(rwlock_t *
 }
 EXPORT_SYMBOL(_write_trylock);
 
+int __lockfunc _write_trylock_irqsave(rwlock_t *lock, unsigned long flags)
+{
+	int ret;
+
+	local_irq_save(flags);
+	ret = _write_trylock(lock);
+	if (ret)
+		return ret;
+
+	local_irq_restore(flags);
+	return 0;
+}
+EXPORT_SYMBOL(_write_trylock_irqsave);
+
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
_

Patches currently in -mm which might be from sripathik@in.ibm.com are

introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
