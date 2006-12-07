From: akpm@osdl.org
Subject: - lockdep-name-some-old-style-locks.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:23 -0800
Message-ID: <200612072304.kB7N4N9I030041@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52068 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163838AbWLGXEb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: name some old style locks
has been removed from the -mm tree.  Its filename was
     lockdep-name-some-old-style-locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: name some old style locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Name some of the remaning 'old_style_spin_init' locks

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/traps.c       |    2 +-
 include/asm-i386/rwsem.h       |    4 ++--
 include/linux/init_task.h      |    2 +-
 include/linux/mutex.h          |    2 +-
 include/linux/rtmutex.h        |    2 +-
 include/linux/rwsem-spinlock.h |    3 ++-
 include/linux/sunrpc/sched.h   |    4 ++--
 kernel/acct.c                  |    3 ++-
 kernel/irq/handle.c            |    2 +-
 net/sunrpc/svcauth.c           |    3 ++-
 security/keys/process_keys.c   |    2 +-
 11 files changed, 16 insertions(+), 13 deletions(-)

diff -puN arch/i386/kernel/traps.c~lockdep-name-some-old-style-locks arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~lockdep-name-some-old-style-locks
+++ a/arch/i386/kernel/traps.c
@@ -452,7 +452,7 @@ void die(const char * str, struct pt_reg
 		u32 lock_owner;
 		int lock_owner_depth;
 	} die = {
-		.lock =			SPIN_LOCK_UNLOCKED,
+		.lock =			__SPIN_LOCK_UNLOCKED(die.lock),
 		.lock_owner =		-1,
 		.lock_owner_depth =	0
 	};
diff -puN include/asm-i386/rwsem.h~lockdep-name-some-old-style-locks include/asm-i386/rwsem.h
--- a/include/asm-i386/rwsem.h~lockdep-name-some-old-style-locks
+++ a/include/asm-i386/rwsem.h
@@ -75,8 +75,8 @@ struct rw_semaphore {
 
 
 #define __RWSEM_INITIALIZER(name) \
-{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, LIST_HEAD_INIT((name).wait_list) \
-	__RWSEM_DEP_MAP_INIT(name) }
+{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED((name).wait_lock), \
+  LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
diff -puN include/linux/init_task.h~lockdep-name-some-old-style-locks include/linux/init_task.h
--- a/include/linux/init_task.h~lockdep-name-some-old-style-locks
+++ a/include/linux/init_task.h
@@ -73,7 +73,7 @@
 extern struct nsproxy init_nsproxy;
 #define INIT_NSPROXY(nsproxy) {						\
 	.count		= ATOMIC_INIT(1),				\
-	.nslock		= SPIN_LOCK_UNLOCKED,				\
+	.nslock		= __SPIN_LOCK_UNLOCKED(nsproxy.nslock),		\
 	.uts_ns		= &init_uts_ns,					\
 	.namespace	= NULL,						\
 	INIT_IPC_NS(ipc_ns)						\
diff -puN include/linux/mutex.h~lockdep-name-some-old-style-locks include/linux/mutex.h
--- a/include/linux/mutex.h~lockdep-name-some-old-style-locks
+++ a/include/linux/mutex.h
@@ -94,7 +94,7 @@ do {							\
 
 #define __MUTEX_INITIALIZER(lockname) \
 		{ .count = ATOMIC_INIT(1) \
-		, .wait_lock = SPIN_LOCK_UNLOCKED \
+		, .wait_lock = __SPIN_LOCK_UNLOCKED(lockname.wait_lock) \
 		, .wait_list = LIST_HEAD_INIT(lockname.wait_list) \
 		__DEBUG_MUTEX_INITIALIZER(lockname) \
 		__DEP_MAP_MUTEX_INITIALIZER(lockname) }
diff -puN include/linux/rtmutex.h~lockdep-name-some-old-style-locks include/linux/rtmutex.h
--- a/include/linux/rtmutex.h~lockdep-name-some-old-style-locks
+++ a/include/linux/rtmutex.h
@@ -63,7 +63,7 @@ struct hrtimer_sleeper;
 #endif
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
-	{ .wait_lock = SPIN_LOCK_UNLOCKED \
+	{ .wait_lock = __SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
 	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list, mutexname.wait_lock) \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
diff -puN include/linux/rwsem-spinlock.h~lockdep-name-some-old-style-locks include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~lockdep-name-some-old-style-locks
+++ a/include/linux/rwsem-spinlock.h
@@ -44,7 +44,8 @@ struct rw_semaphore {
 #endif
 
 #define __RWSEM_INITIALIZER(name) \
-{ 0, SPIN_LOCK_UNLOCKED, LIST_HEAD_INIT((name).wait_list) __RWSEM_DEP_MAP_INIT(name) }
+{ 0, __SPIN_LOCK_UNLOCKED(name.wait_lock), LIST_HEAD_INIT((name).wait_list) \
+  __RWSEM_DEP_MAP_INIT(name) }
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
diff -puN include/linux/sunrpc/sched.h~lockdep-name-some-old-style-locks include/linux/sunrpc/sched.h
--- a/include/linux/sunrpc/sched.h~lockdep-name-some-old-style-locks
+++ a/include/linux/sunrpc/sched.h
@@ -222,7 +222,7 @@ struct rpc_wait_queue {
 
 #ifndef RPC_DEBUG
 # define RPC_WAITQ_INIT(var,qname) { \
-		.lock = SPIN_LOCK_UNLOCKED, \
+		.lock = __SPIN_LOCK_UNLOCKED(var.lock), \
 		.tasks = { \
 			[0] = LIST_HEAD_INIT(var.tasks[0]), \
 			[1] = LIST_HEAD_INIT(var.tasks[1]), \
@@ -231,7 +231,7 @@ struct rpc_wait_queue {
 	}
 #else
 # define RPC_WAITQ_INIT(var,qname) { \
-		.lock = SPIN_LOCK_UNLOCKED, \
+		.lock = __SPIN_LOCK_UNLOCKED(var.lock), \
 		.tasks = { \
 			[0] = LIST_HEAD_INIT(var.tasks[0]), \
 			[1] = LIST_HEAD_INIT(var.tasks[1]), \
diff -puN kernel/acct.c~lockdep-name-some-old-style-locks kernel/acct.c
--- a/kernel/acct.c~lockdep-name-some-old-style-locks
+++ a/kernel/acct.c
@@ -89,7 +89,8 @@ struct acct_glbs {
 	struct timer_list	timer;
 };
 
-static struct acct_glbs acct_globals __cacheline_aligned = {SPIN_LOCK_UNLOCKED};
+static struct acct_glbs acct_globals __cacheline_aligned =
+	{__SPIN_LOCK_UNLOCKED(acct_globals.lock)};
 
 /*
  * Called whenever the timer says to check the free space.
diff -puN kernel/irq/handle.c~lockdep-name-some-old-style-locks kernel/irq/handle.c
--- a/kernel/irq/handle.c~lockdep-name-some-old-style-locks
+++ a/kernel/irq/handle.c
@@ -54,7 +54,7 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 		.chip = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
-		.lock = SPIN_LOCK_UNLOCKED,
+		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
 #ifdef CONFIG_SMP
 		.affinity = CPU_MASK_ALL
 #endif
diff -puN net/sunrpc/svcauth.c~lockdep-name-some-old-style-locks net/sunrpc/svcauth.c
--- a/net/sunrpc/svcauth.c~lockdep-name-some-old-style-locks
+++ a/net/sunrpc/svcauth.c
@@ -119,7 +119,8 @@ EXPORT_SYMBOL(svc_auth_unregister);
 #define	DN_HASHMASK	(DN_HASHMAX-1)
 
 static struct hlist_head	auth_domain_table[DN_HASHMAX];
-static spinlock_t	auth_domain_lock = SPIN_LOCK_UNLOCKED;
+static spinlock_t	auth_domain_lock =
+	__SPIN_LOCK_UNLOCKED(auth_domain_lock);
 
 void auth_domain_put(struct auth_domain *dom)
 {
diff -puN security/keys/process_keys.c~lockdep-name-some-old-style-locks security/keys/process_keys.c
--- a/security/keys/process_keys.c~lockdep-name-some-old-style-locks
+++ a/security/keys/process_keys.c
@@ -27,7 +27,7 @@ static DEFINE_MUTEX(key_session_mutex);
 struct key_user root_key_user = {
 	.usage		= ATOMIC_INIT(3),
 	.consq		= LIST_HEAD_INIT(root_key_user.consq),
-	.lock		= SPIN_LOCK_UNLOCKED,
+	.lock		= __SPIN_LOCK_UNLOCKED(root_key_user.lock),
 	.nkeys		= ATOMIC_INIT(2),
 	.nikeys		= ATOMIC_INIT(2),
 	.uid		= 0,
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

