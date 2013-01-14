From: akpm@linux-foundation.org
Subject: [merged] lockdep-rwsem-provide-down_write_nest_lock.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:41 -0800
Message-ID: <20130114203842.2861B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55634 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab3ANUip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:45 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so293810lbc.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, a.p.zijlstra@chello.nl, mel@csn.ul.ie, mingo@kernel.org, riel@redhat.com, sedat.dilek@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep, rwsem: provide down_write_nest_lock()
has been removed from the -mm tree.  Its filename was
     lockdep-rwsem-provide-down_write_nest_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: lockdep, rwsem: provide down_write_nest_lock()

down_write_nest_lock() provides means to annotate locking scenario where
an outer lock is guaranteed to serialize the order nested locks are being
acquired.

This is analogoue to already existing mutex_lock_nest_lock() and
spin_lock_nest_lock().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mel@csn.ul.ie>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    3 +++
 include/linux/rwsem.h   |    9 +++++++++
 kernel/rwsem.c          |   10 ++++++++++
 3 files changed, 22 insertions(+)

diff -puN include/linux/lockdep.h~lockdep-rwsem-provide-down_write_nest_lock include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-rwsem-provide-down_write_nest_lock
+++ a/include/linux/lockdep.h
@@ -524,14 +524,17 @@ static inline void print_irqtrace_events
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
 #  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 #  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
 # else
 #  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
 #  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
 # endif
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
 # define rwsem_acquire(l, s, t, i)		do { } while (0)
+# define rwsem_acquire_nest(l, s, t, n, i)	do { } while (0)
 # define rwsem_acquire_read(l, s, t, i)		do { } while (0)
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
diff -puN include/linux/rwsem.h~lockdep-rwsem-provide-down_write_nest_lock include/linux/rwsem.h
--- a/include/linux/rwsem.h~lockdep-rwsem-provide-down_write_nest_lock
+++ a/include/linux/rwsem.h
@@ -125,8 +125,17 @@ extern void downgrade_write(struct rw_se
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
+extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock);
+
+# define down_write_nest_lock(sem, nest_lock)			\
+do {								\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
+	_down_write_nest_lock(sem, &(nest_lock)->dep_map);	\
+} while (0);
+
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
+# define down_write_nest_lock(sem, nest_lock)	down_read(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 #endif
 
diff -puN kernel/rwsem.c~lockdep-rwsem-provide-down_write_nest_lock kernel/rwsem.c
--- a/kernel/rwsem.c~lockdep-rwsem-provide-down_write_nest_lock
+++ a/kernel/rwsem.c
@@ -116,6 +116,16 @@ void down_read_nested(struct rw_semaphor
 
 EXPORT_SYMBOL(down_read_nested);
 
+void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
+{
+	might_sleep();
+	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+}
+
+EXPORT_SYMBOL(_down_write_nest_lock);
+
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch

