From: akpm@linux-foundation.org
Subject: - lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:46 -0700
Message-ID: <200707192003.l6JK3koZ019887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761827AbXGSU1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, jbaron@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockstat: hook into spinlock_t, rwlock_t, rwsem and mutex
has been removed from the -mm tree.  Its filename was
     lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockstat: hook into spinlock_t, rwlock_t, rwsem and mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Call the new lockstat tracking functions from the various lock primitives.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/mutex.c    |    8 ++++++++
 kernel/rwsem.c    |    8 ++++----
 kernel/spinlock.c |   28 ++++++++++++++--------------
 3 files changed, 26 insertions(+), 18 deletions(-)

diff -puN kernel/mutex.c~lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex kernel/mutex.c
--- a/kernel/mutex.c~lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex
+++ a/kernel/mutex.c
@@ -139,6 +139,12 @@ __mutex_lock_common(struct mutex *lock, 
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
+	old_val = atomic_xchg(&lock->count, -1);
+	if (old_val == 1)
+		goto done;
+
+	lock_contended(&lock->dep_map, _RET_IP_);
+
 	for (;;) {
 		/*
 		 * Lets try to take the lock again - this is needed even if
@@ -174,6 +180,8 @@ __mutex_lock_common(struct mutex *lock, 
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
+	lock_acquired(&lock->dep_map);
+done:
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));
diff -puN kernel/rwsem.c~lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex kernel/rwsem.c
--- a/kernel/rwsem.c~lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex
+++ a/kernel/rwsem.c
@@ -20,7 +20,7 @@ void down_read(struct rw_semaphore *sem)
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
-	__down_read(sem);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
 
 EXPORT_SYMBOL(down_read);
@@ -47,7 +47,7 @@ void down_write(struct rw_semaphore *sem
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
-	__down_write(sem);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -111,7 +111,7 @@ void down_read_nested(struct rw_semaphor
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	__down_read(sem);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
 
 EXPORT_SYMBOL(down_read_nested);
@@ -130,7 +130,7 @@ void down_write_nested(struct rw_semapho
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	__down_write_nested(sem, subclass);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
 
 EXPORT_SYMBOL(down_write_nested);
diff -puN kernel/spinlock.c~lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex kernel/spinlock.c
--- a/kernel/spinlock.c~lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex
+++ a/kernel/spinlock.c
@@ -72,7 +72,7 @@ void __lockfunc _read_lock(rwlock_t *loc
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock);
 
@@ -89,7 +89,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_LOCKDEP
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
 #endif
@@ -102,7 +102,7 @@ void __lockfunc _spin_lock_irq(spinlock_
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
 
@@ -111,7 +111,7 @@ void __lockfunc _spin_lock_bh(spinlock_t
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
 
@@ -122,7 +122,7 @@ unsigned long __lockfunc _read_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 	return flags;
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
@@ -132,7 +132,7 @@ void __lockfunc _read_lock_irq(rwlock_t 
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
 
@@ -141,7 +141,7 @@ void __lockfunc _read_lock_bh(rwlock_t *
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
 
@@ -152,7 +152,7 @@ unsigned long __lockfunc _write_lock_irq
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 	return flags;
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
@@ -162,7 +162,7 @@ void __lockfunc _write_lock_irq(rwlock_t
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
 
@@ -171,7 +171,7 @@ void __lockfunc _write_lock_bh(rwlock_t 
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
 
@@ -179,7 +179,7 @@ void __lockfunc _spin_lock(spinlock_t *l
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
 EXPORT_SYMBOL(_spin_lock);
@@ -188,7 +188,7 @@ void __lockfunc _write_lock(rwlock_t *lo
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 
 EXPORT_SYMBOL(_write_lock);
@@ -289,7 +289,7 @@ void __lockfunc _spin_lock_nested(spinlo
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
 EXPORT_SYMBOL(_spin_lock_nested);
@@ -306,7 +306,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_LOCKDEP
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
 #endif
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
