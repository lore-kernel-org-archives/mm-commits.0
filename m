From: akpm@linux-foundation.org
Subject: [patch 74/94] pid: remove pidhash
Date: Fri, 17 Nov 2017 15:30:34 -0800
Message-ID: <20171117233034.gzUJkD8_K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966959AbdKQXag (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:30:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, gs051095@gmail.com, hch@infradead.org, julia.lawall@lip6.fr, ktkhai@virtuozzo.com, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, pasha.tatashin@oracle.com, riel@redhat.com, tony.luck@intel.com, torvalds@linux-foundation.org

From: Gargi Sharma <gs051095@gmail.com>
Subject: pid: remove pidhash

pidhash is no longer required as all the information can be looked up from
idr tree.  nr_hashed represented the number of pids that had been hashed. 
Since, nr_hashed and PIDNS_HASH_ADDING are no longer relevant, it has been
renamed to pid_allocated and PIDNS_ADDING respectively.

[gs051095@gmail.com: v6]
  Link: http://lkml.kernel.org/r/1507760379-21662-3-git-send-email-gs051095@gmail.com
Link: http://lkml.kernel.org/r/1507583624-22146-3-git-send-email-gs051095@gmail.com
Signed-off-by: Gargi Sharma <gs051095@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Tested-by: Tony Luck <tony.luck@intel.com>	[ia64]
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/asm-offsets.c |    4 +-
 include/linux/init_task.h      |    1 
 include/linux/pid.h            |    2 -
 include/linux/pid_namespace.h  |    4 +-
 init/main.c                    |    1 
 kernel/fork.c                  |    2 -
 kernel/pid.c                   |   48 ++++++-------------------------
 kernel/pid_namespace.c         |    6 +--
 8 files changed, 18 insertions(+), 50 deletions(-)

diff -puN arch/ia64/kernel/asm-offsets.c~pid-remove-pidhash arch/ia64/kernel/asm-offsets.c
--- a/arch/ia64/kernel/asm-offsets.c~pid-remove-pidhash
+++ a/arch/ia64/kernel/asm-offsets.c
@@ -31,8 +31,8 @@ void foo(void)
 	DEFINE(SIGFRAME_SIZE, sizeof (struct sigframe));
 	DEFINE(UNW_FRAME_INFO_SIZE, sizeof (struct unw_frame_info));
 
-	BUILD_BUG_ON(sizeof(struct upid) != 32);
-	DEFINE(IA64_UPID_SHIFT, 5);
+	BUILD_BUG_ON(sizeof(struct upid) != 16);
+	DEFINE(IA64_UPID_SHIFT, 4);
 
 	BLANK();
 
diff -puN include/linux/init_task.h~pid-remove-pidhash include/linux/init_task.h
--- a/include/linux/init_task.h~pid-remove-pidhash
+++ a/include/linux/init_task.h
@@ -105,7 +105,6 @@ extern struct group_info init_groups;
 	.numbers	= { {						\
 		.nr		= 0,					\
 		.ns		= &init_pid_ns,				\
-		.pid_chain	= { .next = NULL, .pprev = NULL },	\
 	}, }								\
 }
 
diff -puN include/linux/pid.h~pid-remove-pidhash include/linux/pid.h
--- a/include/linux/pid.h~pid-remove-pidhash
+++ a/include/linux/pid.h
@@ -51,10 +51,8 @@ enum pid_type
  */
 
 struct upid {
-	/* Try to keep pid_chain in the same cacheline as nr for find_vpid */
 	int nr;
 	struct pid_namespace *ns;
-	struct hlist_node pid_chain;
 };
 
 struct pid
diff -puN include/linux/pid_namespace.h~pid-remove-pidhash include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-remove-pidhash
+++ a/include/linux/pid_namespace.h
@@ -25,7 +25,7 @@ struct pid_namespace {
 	struct kref kref;
 	struct idr idr;
 	struct rcu_head rcu;
-	unsigned int nr_hashed;
+	unsigned int pid_allocated;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
 	unsigned int level;
@@ -49,7 +49,7 @@ struct pid_namespace {
 
 extern struct pid_namespace init_pid_ns;
 
-#define PIDNS_HASH_ADDING (1U << 31)
+#define PIDNS_ADDING (1U << 31)
 
 #ifdef CONFIG_PID_NS
 static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
diff -puN init/main.c~pid-remove-pidhash init/main.c
--- a/init/main.c~pid-remove-pidhash
+++ a/init/main.c
@@ -562,7 +562,6 @@ asmlinkage __visible void __init start_k
 	 * kmem_cache_init()
 	 */
 	setup_log_buf(0);
-	pidhash_init();
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
diff -puN kernel/fork.c~pid-remove-pidhash kernel/fork.c
--- a/kernel/fork.c~pid-remove-pidhash
+++ a/kernel/fork.c
@@ -1871,7 +1871,7 @@ static __latent_entropy struct task_stru
 		retval = -ERESTARTNOINTR;
 		goto bad_fork_cancel_cgroup;
 	}
-	if (unlikely(!(ns_of_pid(pid)->nr_hashed & PIDNS_HASH_ADDING))) {
+	if (unlikely(!(ns_of_pid(pid)->pid_allocated & PIDNS_ADDING))) {
 		retval = -ENOMEM;
 		goto bad_fork_cancel_cgroup;
 	}
diff -puN kernel/pid.c~pid-remove-pidhash kernel/pid.c
--- a/kernel/pid.c~pid-remove-pidhash
+++ a/kernel/pid.c
@@ -41,10 +41,6 @@
 #include <linux/sched/task.h>
 #include <linux/idr.h>
 
-#define pid_hashfn(nr, ns)	\
-	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
-static struct hlist_head *pid_hash;
-static unsigned int pidhash_shift = 4;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
 int pid_max = PID_MAX_DEFAULT;
@@ -54,7 +50,6 @@ int pid_max = PID_MAX_DEFAULT;
 int pid_max_min = RESERVED_PIDS + 1;
 int pid_max_max = PID_MAX_LIMIT;
 
-
 /*
  * PID-map pages start out as NULL, they get allocated upon
  * first use and are never deallocated. This way a low pid_max
@@ -64,7 +59,7 @@ int pid_max_max = PID_MAX_LIMIT;
 struct pid_namespace init_pid_ns = {
 	.kref = KREF_INIT(2),
 	.idr = IDR_INIT,
-	.nr_hashed = PIDNS_HASH_ADDING,
+	.pid_allocated = PIDNS_ADDING,
 	.level = 0,
 	.child_reaper = &init_task,
 	.user_ns = &init_user_ns,
@@ -123,8 +118,7 @@ void free_pid(struct pid *pid)
 	for (i = 0; i <= pid->level; i++) {
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
-		hlist_del_rcu(&upid->pid_chain);
-		switch (--ns->nr_hashed) {
+		switch (--ns->pid_allocated) {
 		case 2:
 		case 1:
 			/* When all that is left in the pid namespace
@@ -133,10 +127,10 @@ void free_pid(struct pid *pid)
 			 */
 			wake_up_process(ns->child_reaper);
 			break;
-		case PIDNS_HASH_ADDING:
+		case PIDNS_ADDING:
 			/* Handle a fork failure of the first process */
 			WARN_ON(ns->child_reaper);
-			ns->nr_hashed = 0;
+			ns->pid_allocated = 0;
 			/* fall through */
 		case 0:
 			schedule_work(&ns->proc_work);
@@ -212,14 +206,12 @@ struct pid *alloc_pid(struct pid_namespa
 
 	upid = pid->numbers + ns->level;
 	spin_lock_irq(&pidmap_lock);
-	if (!(ns->nr_hashed & PIDNS_HASH_ADDING))
+	if (!(ns->pid_allocated & PIDNS_ADDING))
 		goto out_unlock;
 	for ( ; upid >= pid->numbers; --upid) {
-		hlist_add_head_rcu(&upid->pid_chain,
-				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
 		/* Make the PID visible to find_pid_ns. */
 		idr_replace(&upid->ns->idr, pid, upid->nr);
-		upid->ns->nr_hashed++;
+		upid->ns->pid_allocated++;
 	}
 	spin_unlock_irq(&pidmap_lock);
 
@@ -243,21 +235,13 @@ out_free:
 void disable_pid_allocation(struct pid_namespace *ns)
 {
 	spin_lock_irq(&pidmap_lock);
-	ns->nr_hashed &= ~PIDNS_HASH_ADDING;
+	ns->pid_allocated &= ~PIDNS_ADDING;
 	spin_unlock_irq(&pidmap_lock);
 }
 
 struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
 {
-	struct upid *pnr;
-
-	hlist_for_each_entry_rcu(pnr,
-			&pid_hash[pid_hashfn(nr, ns)], pid_chain)
-		if (pnr->nr == nr && pnr->ns == ns)
-			return container_of(pnr, struct pid,
-					numbers[ns->level]);
-
-	return NULL;
+	return idr_find(&ns->idr, nr);
 }
 EXPORT_SYMBOL_GPL(find_pid_ns);
 
@@ -413,6 +397,7 @@ pid_t __task_pid_nr_ns(struct task_struc
 		if (type != PIDTYPE_PID) {
 			if (type == __PIDTYPE_TGID)
 				type = PIDTYPE_PID;
+
 			task = task->group_leader;
 		}
 		nr = pid_nr_ns(rcu_dereference(task->pids[type].pid), ns);
@@ -439,23 +424,10 @@ struct pid *find_ge_pid(int nr, struct p
 	return idr_get_next(&ns->idr, &nr);
 }
 
-/*
- * The pid hash table is scaled according to the amount of memory in the
- * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
- * more.
- */
-void __init pidhash_init(void)
-{
-	pid_hash = alloc_large_system_hash("PID", sizeof(*pid_hash), 0, 18,
-					   HASH_EARLY | HASH_SMALL | HASH_ZERO,
-					   &pidhash_shift, NULL,
-					   0, 4096);
-}
-
 void __init pid_idr_init(void)
 {
 	/* Verify no one has done anything silly: */
-	BUILD_BUG_ON(PID_MAX_LIMIT >= PIDNS_HASH_ADDING);
+	BUILD_BUG_ON(PID_MAX_LIMIT >= PIDNS_ADDING);
 
 	/* bump default and minimum pid_max based on number of cpus */
 	pid_max = min(pid_max_max, max_t(int, pid_max,
diff -puN kernel/pid_namespace.c~pid-remove-pidhash kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid-remove-pidhash
+++ a/kernel/pid_namespace.c
@@ -133,7 +133,7 @@ static struct pid_namespace *create_pid_
 	ns->parent = get_pid_ns(parent_pid_ns);
 	ns->user_ns = get_user_ns(user_ns);
 	ns->ucounts = ucounts;
-	ns->nr_hashed = PIDNS_HASH_ADDING;
+	ns->pid_allocated = PIDNS_ADDING;
 	INIT_WORK(&ns->proc_work, proc_cleanup_work);
 
 	return ns;
@@ -254,7 +254,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 * sys_wait4() above can't reap the EXIT_DEAD children but we do not
 	 * really care, we could reparent them to the global init. We could
 	 * exit and reap ->child_reaper even if it is not the last thread in
-	 * this pid_ns, free_pid(nr_hashed == 0) calls proc_cleanup_work(),
+	 * this pid_ns, free_pid(pid_allocated == 0) calls proc_cleanup_work(),
 	 * pid_ns can not go away until proc_kill_sb() drops the reference.
 	 *
 	 * But this ns can also have other tasks injected by setns()+fork().
@@ -268,7 +268,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 */
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (pid_ns->nr_hashed == init_pids)
+		if (pid_ns->pid_allocated == init_pids)
 			break;
 		schedule();
 	}
_
