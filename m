Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA064C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiAWX6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46520 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiAWX6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45E3AB80DC7
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81A3C340E3;
        Sun, 23 Jan 2022 23:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982284;
        bh=kU9kPPiH46u1rDfVOmwy13KRtz1dKAosR1B3f0LGqDQ=;
        h=Date:From:To:Subject:From;
        b=p45Q4KhTrK5DIJn68RaCtO9fmx36y52iRmpOPYQyjYRSygbseujvWbkMa000Yq6ZO
         KcRCXx4/E88ld4gR578s2g7/NUIlx1N37KQr2ktoL6GV/Qxl1aFUyC3+jzZ/vdUrxI
         ABnxTfuKJkzYpXtA6Wg1nkwd9BtD9FuBiJc/c96k=
Date:   Sun, 23 Jan 2022 15:58:03 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        peterz@infradead.org, senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  [merged]
 locking-rwlocks-introduce-write_lock_nested.patch removed from -mm tree
Message-ID: <20220123235803.s8cUshbaK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking/rwlocks: introduce write_lock_nested
has been removed from the -mm tree.  Its filename was
     locking-rwlocks-introduce-write_lock_nested.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: locking/rwlocks: introduce write_lock_nested

In preparation for converting bit_spin_lock to rwlock in zsmalloc so that
multiple writers of zspages can run at the same time but those zspages are
supposed to be different zspage instance.  Thus, it's not deadlock.  This
patch adds write_lock_nested to support the case for LOCKDEP.

[minchan@kernel.org: fix write_lock_nested for RT]
  Link: https://lkml.kernel.org/r/YZfrMTAXV56HFWJY@google.com
[bigeasy@linutronix.de: fixup write_lock_nested() implementation]
  Link: https://lkml.kernel.org/r/20211123170134.y6xb7pmpgdn4m3bn@linutronix.de
Link: https://lkml.kernel.org/r/20211115185909.3949505-8-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwlock.h          |    6 ++++++
 include/linux/rwlock_api_smp.h  |    8 ++++++++
 include/linux/rwlock_rt.h       |   10 ++++++++++
 include/linux/spinlock_api_up.h |    1 +
 kernel/locking/spinlock.c       |   10 ++++++++++
 kernel/locking/spinlock_rt.c    |   12 ++++++++++++
 6 files changed, 47 insertions(+)

--- a/include/linux/rwlock_api_smp.h~locking-rwlocks-introduce-write_lock_nested
+++ a/include/linux/rwlock_api_smp.h
@@ -17,6 +17,7 @@
 
 void __lockfunc _raw_read_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_write_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_write_lock_nested(rwlock_t *lock, int subclass)	__acquires(lock);
 void __lockfunc _raw_read_lock_bh(rwlock_t *lock)	__acquires(lock);
 void __lockfunc _raw_write_lock_bh(rwlock_t *lock)	__acquires(lock);
 void __lockfunc _raw_read_lock_irq(rwlock_t *lock)	__acquires(lock);
@@ -209,6 +210,13 @@ static inline void __raw_write_lock(rwlo
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
+static inline void __raw_write_lock_nested(rwlock_t *lock, int subclass)
+{
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
+}
+
 #endif /* !CONFIG_GENERIC_LOCKBREAK || CONFIG_DEBUG_LOCK_ALLOC */
 
 static inline void __raw_write_unlock(rwlock_t *lock)
--- a/include/linux/rwlock.h~locking-rwlocks-introduce-write_lock_nested
+++ a/include/linux/rwlock.h
@@ -55,6 +55,12 @@ do {								\
 #define write_lock(lock)	_raw_write_lock(lock)
 #define read_lock(lock)		_raw_read_lock(lock)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define write_lock_nested(lock, subclass)	_raw_write_lock_nested(lock, subclass)
+#else
+#define write_lock_nested(lock, subclass)	_raw_write_lock(lock)
+#endif
+
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 
 #define read_lock_irqsave(lock, flags)			\
--- a/include/linux/rwlock_rt.h~locking-rwlocks-introduce-write_lock_nested
+++ a/include/linux/rwlock_rt.h
@@ -28,6 +28,7 @@ extern void rt_read_lock(rwlock_t *rwloc
 extern int rt_read_trylock(rwlock_t *rwlock);
 extern void rt_read_unlock(rwlock_t *rwlock);
 extern void rt_write_lock(rwlock_t *rwlock);
+extern void rt_write_lock_nested(rwlock_t *rwlock, int subclass);
 extern int rt_write_trylock(rwlock_t *rwlock);
 extern void rt_write_unlock(rwlock_t *rwlock);
 
@@ -83,6 +84,15 @@ static __always_inline void write_lock(r
 	rt_write_lock(rwlock);
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static __always_inline void write_lock_nested(rwlock_t *rwlock, int subclass)
+{
+	rt_write_lock_nested(rwlock, subclass);
+}
+#else
+#define write_lock_nested(lock, subclass)	rt_write_lock(((void)(subclass), (lock)))
+#endif
+
 static __always_inline void write_lock_bh(rwlock_t *rwlock)
 {
 	local_bh_disable();
--- a/include/linux/spinlock_api_up.h~locking-rwlocks-introduce-write_lock_nested
+++ a/include/linux/spinlock_api_up.h
@@ -59,6 +59,7 @@
 #define _raw_spin_lock_nested(lock, subclass)	__LOCK(lock)
 #define _raw_read_lock(lock)			__LOCK(lock)
 #define _raw_write_lock(lock)			__LOCK(lock)
+#define _raw_write_lock_nested(lock, subclass)	__LOCK(lock)
 #define _raw_spin_lock_bh(lock)			__LOCK_BH(lock)
 #define _raw_read_lock_bh(lock)			__LOCK_BH(lock)
 #define _raw_write_lock_bh(lock)		__LOCK_BH(lock)
--- a/kernel/locking/spinlock.c~locking-rwlocks-introduce-write_lock_nested
+++ a/kernel/locking/spinlock.c
@@ -300,6 +300,16 @@ void __lockfunc _raw_write_lock(rwlock_t
 	__raw_write_lock(lock);
 }
 EXPORT_SYMBOL(_raw_write_lock);
+
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
+#define __raw_write_lock_nested(lock, subclass)	__raw_write_lock(((void)(subclass), (lock)))
+#endif
+
+void __lockfunc _raw_write_lock_nested(rwlock_t *lock, int subclass)
+{
+	__raw_write_lock_nested(lock, subclass);
+}
+EXPORT_SYMBOL(_raw_write_lock_nested);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
--- a/kernel/locking/spinlock_rt.c~locking-rwlocks-introduce-write_lock_nested
+++ a/kernel/locking/spinlock_rt.c
@@ -239,6 +239,18 @@ void __sched rt_write_lock(rwlock_t *rwl
 }
 EXPORT_SYMBOL(rt_write_lock);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+void __sched rt_write_lock_nested(rwlock_t *rwlock, int subclass)
+{
+	rtlock_might_resched();
+	rwlock_acquire(&rwlock->dep_map, subclass, 0, _RET_IP_);
+	rwbase_write_lock(&rwlock->rwbase, TASK_RTLOCK_WAIT);
+	rcu_read_lock();
+	migrate_disable();
+}
+EXPORT_SYMBOL(rt_write_lock_nested);
+#endif
+
 void __sched rt_read_unlock(rwlock_t *rwlock)
 {
 	rwlock_release(&rwlock->dep_map, _RET_IP_);
_

Patches currently in -mm which might be from minchan@kernel.org are


