Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD0DC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F081763215
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349497AbhKOVga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353002AbhKOVKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:10:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9BE61B44;
        Mon, 15 Nov 2021 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010412;
        bh=aqXHAkLLJWcFd4xwV+k9oyjaAWWeoijJ1lnsPZ9f2fI=;
        h=Date:From:To:Subject:From;
        b=DwCX66UIR+e0RfyqfiGKOmCLD7fnSNck5NJCCEnkKAJ+eudYo//7u33z+tdS6Tlc3
         z9eY01EzTCH1fwEBTgiZyO/6KsRAscj47eh2Oqvijh6g0Ft7XkYOekof7+WWWw3RoO
         E6yvfrIZYqcG7qkHbe1b+QDDtBEeR0ElSt4Bulew=
Date:   Mon, 15 Nov 2021 13:06:51 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + locking-rwlocks-introduce-write_lock_nested.patch added
 to -mm tree
Message-ID: <20211115210651.3xbf7AvMt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: locking/rwlocks: introduce write_lock_nested
has been added to the -mm tree.  Its filename is
     locking-rwlocks-introduce-write_lock_nested.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/locking-rwlocks-introduce-write_lock_nested.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/locking-rwlocks-introduce-write_lock_nested.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: locking/rwlocks: introduce write_lock_nested

In preparation for converting bit_spin_lock to rwlock in zsmalloc so that
multiple writers of zspages can run at the same time but those zspages are
supposed to be different zspage instance.  Thus, it's not deadlock.  This
patch adds write_lock_nested to support the case for LOCKDEP.

Link: https://lkml.kernel.org/r/20211115185909.3949505-8-minchan@kernel.org
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwlock.h          |    6 ++++++
 include/linux/rwlock_api_smp.h  |    9 +++++++++
 include/linux/rwlock_rt.h       |    6 ++++++
 include/linux/spinlock_api_up.h |    1 +
 kernel/locking/spinlock.c       |    6 ++++++
 kernel/locking/spinlock_rt.c    |   12 ++++++++++++
 6 files changed, 40 insertions(+)

--- a/include/linux/rwlock_api_smp.h~locking-rwlocks-introduce-write_lock_nested
+++ a/include/linux/rwlock_api_smp.h
@@ -17,6 +17,7 @@
 
 void __lockfunc _raw_read_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_write_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_write_lock_nested(rwlock_t *lock, int subclass)	__acquires(lock);
 void __lockfunc _raw_read_lock_bh(rwlock_t *lock)	__acquires(lock);
 void __lockfunc _raw_write_lock_bh(rwlock_t *lock)	__acquires(lock);
 void __lockfunc _raw_read_lock_irq(rwlock_t *lock)	__acquires(lock);
@@ -46,6 +47,7 @@ _raw_write_unlock_irqrestore(rwlock_t *l
 
 #ifdef CONFIG_INLINE_WRITE_LOCK
 #define _raw_write_lock(lock) __raw_write_lock(lock)
+#define _raw_write_lock_nested(lock, subclass) __raw_write_lock_nested(lock, subclass)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_BH
@@ -209,6 +211,13 @@ static inline void __raw_write_lock(rwlo
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
 
@@ -83,6 +84,11 @@ static __always_inline void write_lock(r
 	rt_write_lock(rwlock);
 }
 
+static __always_inline void write_lock_nested(rwlock_t *rwlock, int subclass)
+{
+	rt_write_lock_nested(rwlock, subclass);
+}
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
@@ -300,6 +300,12 @@ void __lockfunc _raw_write_lock(rwlock_t
 	__raw_write_lock(lock);
 }
 EXPORT_SYMBOL(_raw_write_lock);
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
+	___might_sleep(__FILE__, __LINE__, 0);
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

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

