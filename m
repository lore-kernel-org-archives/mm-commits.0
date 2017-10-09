From: akpm@linux-foundation.org
Subject: + pid-replace-pid-bitmap-implementation-with-idr-api.patch added
 to -mm tree
Date: Mon, 09 Oct 2017 16:17:57 -0700
Message-ID: <59dc03a5.Y717eLK8m7MT/+5y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754585AbdJIXR7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2017 19:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gs051095@gmail.com, ebiederm@xmission.com, hch@infradead.org, julia.lawall@lip6.fr, ktkhai@virtuozzo.com, mingo@kernel.org, oleg@redhat.com, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid: replace pid bitmap implementation with IDR API
has been added to the -mm tree.  Its filename is
     pid-replace-pid-bitmap-implementation-with-idr-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-replace-pid-bitmap-implementation-with-idr-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gargi Sharma <gs051095@gmail.com>
Subject: pid: replace pid bitmap implementation with IDR API

Patch series "Replacing PID bitmap implementation with IDR API", v4.

This series replaces kernel bitmap implementation of PID allocation with
IDR API.  These patches are written to simplify the kernel by replacing
custom code with calls to generic code.

The following are the stats for pid and pid_namespace object files before
and after the replacement.  There is a noteworthy change between the IDR
and bitmap implementation.

Before
text       data        bss        dec        hex    filename
   8447       3894         64      12405       3075    kernel/pid.o
After
text       data        bss        dec        hex    filename
   3397        304          0       3701        e75    kernel/pid.o

Before
 text       data        bss        dec        hex    filename
   5692       1842        192       7726       1e2e    kernel/pid_namespace.o
After
text       data        bss        dec        hex    filename
   2854        216         16       3086        c0e    kernel/pid_namespace.o

The following are the stats for ps, pstree and calling readdir on /proc
for 10,000 processes.

ps:
        With IDR API    With bitmap
real    0m1.479s        0m2.319s
user    0m0.070s        0m0.060s
sys     0m0.289s        0m0.516s

pstree:
        With IDR API    With bitmap
real    0m1.024s        0m1.794s
user    0m0.348s        0m0.612s
sys     0m0.184s        0m0.264s

proc:
        With IDR API    With bitmap
real    0m0.059s        0m0.074s
user    0m0.000s        0m0.004s
sys     0m0.016s        0m0.016s


This patch (of 2):

Replace the current bitmap implemetation for Process ID allocation. 
Functions that are no longer required, for example, free_pidmap(),
alloc_pidmap(), etc.  are removed.  The rest of the functions are modified
to use the IDR API.  The change was made to make the PID allocation less
complex by replacing custom code with calls to generic API.

Link: http://lkml.kernel.org/r/1507583624-22146-2-git-send-email-gs051095@gmail.com
Signed-off-by: Gargi Sharma <gs051095@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/sched.c |    2 
 fs/proc/loadavg.c                         |    2 
 include/linux/pid_namespace.h             |   14 -
 init/main.c                               |    2 
 kernel/pid.c                              |  197 +++-----------------
 kernel/pid_namespace.c                    |   42 +---
 6 files changed, 52 insertions(+), 207 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/sched.c~pid-replace-pid-bitmap-implementation-with-idr-api arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c~pid-replace-pid-bitmap-implementation-with-idr-api
+++ a/arch/powerpc/platforms/cell/spufs/sched.c
@@ -1093,7 +1093,7 @@ static int show_spu_loadavg(struct seq_f
 		LOAD_INT(c), LOAD_FRAC(c),
 		count_active_contexts(),
 		atomic_read(&nr_spu_contexts),
-		task_active_pid_ns(current)->last_pid);
+		idr_get_cursor(&task_active_pid_ns(current)->idr));
 	return 0;
 }
 
diff -puN fs/proc/loadavg.c~pid-replace-pid-bitmap-implementation-with-idr-api fs/proc/loadavg.c
--- a/fs/proc/loadavg.c~pid-replace-pid-bitmap-implementation-with-idr-api
+++ a/fs/proc/loadavg.c
@@ -23,7 +23,7 @@ static int loadavg_proc_show(struct seq_
 		LOAD_INT(avnrun[1]), LOAD_FRAC(avnrun[1]),
 		LOAD_INT(avnrun[2]), LOAD_FRAC(avnrun[2]),
 		nr_running(), nr_threads,
-		task_active_pid_ns(current)->last_pid);
+		idr_get_cursor(&task_active_pid_ns(current)->idr));
 	return 0;
 }
 
diff -puN include/linux/pid_namespace.h~pid-replace-pid-bitmap-implementation-with-idr-api include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-replace-pid-bitmap-implementation-with-idr-api
+++ a/include/linux/pid_namespace.h
@@ -9,15 +9,8 @@
 #include <linux/nsproxy.h>
 #include <linux/kref.h>
 #include <linux/ns_common.h>
+#include <linux/idr.h>
 
-struct pidmap {
-       atomic_t nr_free;
-       void *page;
-};
-
-#define BITS_PER_PAGE		(PAGE_SIZE * 8)
-#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
-#define PIDMAP_ENTRIES		((PID_MAX_LIMIT+BITS_PER_PAGE-1)/BITS_PER_PAGE)
 
 struct fs_pin;
 
@@ -29,9 +22,8 @@ enum { /* definitions for pid_namespace'
 
 struct pid_namespace {
 	struct kref kref;
-	struct pidmap pidmap[PIDMAP_ENTRIES];
+	struct idr idr;
 	struct rcu_head rcu;
-	int last_pid;
 	unsigned int nr_hashed;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
@@ -105,6 +97,6 @@ static inline int reboot_pid_ns(struct p
 
 extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
-void pidmap_init(void);
+void pid_idr_init(void);
 
 #endif /* _LINUX_PID_NS_H */
diff -puN init/main.c~pid-replace-pid-bitmap-implementation-with-idr-api init/main.c
--- a/init/main.c~pid-replace-pid-bitmap-implementation-with-idr-api
+++ a/init/main.c
@@ -670,7 +670,7 @@ asmlinkage __visible void __init start_k
 	if (late_time_init)
 		late_time_init();
 	calibrate_delay();
-	pidmap_init();
+	pid_idr_init();
 	anon_vma_init();
 	acpi_early_init();
 #ifdef CONFIG_X86
diff -puN kernel/pid.c~pid-replace-pid-bitmap-implementation-with-idr-api kernel/pid.c
--- a/kernel/pid.c~pid-replace-pid-bitmap-implementation-with-idr-api
+++ a/kernel/pid.c
@@ -39,6 +39,7 @@
 #include <linux/proc_ns.h>
 #include <linux/proc_fs.h>
 #include <linux/sched/task.h>
+#include <linux/idr.h>
 
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
@@ -53,14 +54,6 @@ int pid_max = PID_MAX_DEFAULT;
 int pid_max_min = RESERVED_PIDS + 1;
 int pid_max_max = PID_MAX_LIMIT;
 
-static inline int mk_pid(struct pid_namespace *pid_ns,
-		struct pidmap *map, int off)
-{
-	return (map - pid_ns->pidmap)*BITS_PER_PAGE + off;
-}
-
-#define find_next_offset(map, off)					\
-		find_next_zero_bit((map)->page, BITS_PER_PAGE, off)
 
 /*
  * PID-map pages start out as NULL, they get allocated upon
@@ -70,10 +63,7 @@ static inline int mk_pid(struct pid_name
  */
 struct pid_namespace init_pid_ns = {
 	.kref = KREF_INIT(2),
-	.pidmap = {
-		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
-	},
-	.last_pid = 0,
+	.idr = IDR_INIT,
 	.nr_hashed = PIDNS_HASH_ADDING,
 	.level = 0,
 	.child_reaper = &init_task,
@@ -101,138 +91,6 @@ EXPORT_SYMBOL_GPL(init_pid_ns);
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(pidmap_lock);
 
-static void free_pidmap(struct upid *upid)
-{
-	int nr = upid->nr;
-	struct pidmap *map = upid->ns->pidmap + nr / BITS_PER_PAGE;
-	int offset = nr & BITS_PER_PAGE_MASK;
-
-	clear_bit(offset, map->page);
-	atomic_inc(&map->nr_free);
-}
-
-/*
- * If we started walking pids at 'base', is 'a' seen before 'b'?
- */
-static int pid_before(int base, int a, int b)
-{
-	/*
-	 * This is the same as saying
-	 *
-	 * (a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
-	 * and that mapping orders 'a' and 'b' with respect to 'base'.
-	 */
-	return (unsigned)(a - base) < (unsigned)(b - base);
-}
-
-/*
- * We might be racing with someone else trying to set pid_ns->last_pid
- * at the pid allocation time (there's also a sysctl for this, but racing
- * with this one is OK, see comment in kernel/pid_namespace.c about it).
- * We want the winner to have the "later" value, because if the
- * "earlier" value prevails, then a pid may get reused immediately.
- *
- * Since pids rollover, it is not sufficient to just pick the bigger
- * value.  We have to consider where we started counting from.
- *
- * 'base' is the value of pid_ns->last_pid that we observed when
- * we started looking for a pid.
- *
- * 'pid' is the pid that we eventually found.
- */
-static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
-{
-	int prev;
-	int last_write = base;
-	do {
-		prev = last_write;
-		last_write = cmpxchg(&pid_ns->last_pid, prev, pid);
-	} while ((prev != last_write) && (pid_before(base, last_write, pid)));
-}
-
-static int alloc_pidmap(struct pid_namespace *pid_ns)
-{
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
-	struct pidmap *map;
-
-	pid = last + 1;
-	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
-	offset = pid & BITS_PER_PAGE_MASK;
-	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	/*
-	 * If last_pid points into the middle of the map->page we
-	 * want to scan this bitmap block twice, the second time
-	 * we start with offset == 0 (or RESERVED_PIDS).
-	 */
-	max_scan = DIV_ROUND_UP(pid_max, BITS_PER_PAGE) - !offset;
-	for (i = 0; i <= max_scan; ++i) {
-		if (unlikely(!map->page)) {
-			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irq(&pidmap_lock);
-			if (!map->page) {
-				map->page = page;
-				page = NULL;
-			}
-			spin_unlock_irq(&pidmap_lock);
-			kfree(page);
-			if (unlikely(!map->page))
-				return -ENOMEM;
-		}
-		if (likely(atomic_read(&map->nr_free))) {
-			for ( ; ; ) {
-				if (!test_and_set_bit(offset, map->page)) {
-					atomic_dec(&map->nr_free);
-					set_last_pid(pid_ns, last, pid);
-					return pid;
-				}
-				offset = find_next_offset(map, offset);
-				if (offset >= BITS_PER_PAGE)
-					break;
-				pid = mk_pid(pid_ns, map, offset);
-				if (pid >= pid_max)
-					break;
-			}
-		}
-		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
-			++map;
-			offset = 0;
-		} else {
-			map = &pid_ns->pidmap[0];
-			offset = RESERVED_PIDS;
-			if (unlikely(last == offset))
-				break;
-		}
-		pid = mk_pid(pid_ns, map, offset);
-	}
-	return -EAGAIN;
-}
-
-int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
-{
-	int offset;
-	struct pidmap *map, *end;
-
-	if (last >= PID_MAX_LIMIT)
-		return -1;
-
-	offset = (last + 1) & BITS_PER_PAGE_MASK;
-	map = &pid_ns->pidmap[(last + 1)/BITS_PER_PAGE];
-	end = &pid_ns->pidmap[PIDMAP_ENTRIES];
-	for (; map < end; map++, offset = 0) {
-		if (unlikely(!map->page))
-			continue;
-		offset = find_next_bit((map)->page, BITS_PER_PAGE, offset);
-		if (offset < BITS_PER_PAGE)
-			return mk_pid(pid_ns, map, offset);
-	}
-	return -1;
-}
-
 void put_pid(struct pid *pid)
 {
 	struct pid_namespace *ns;
@@ -284,12 +142,11 @@ void free_pid(struct pid *pid)
 			schedule_work(&ns->proc_work);
 			break;
 		}
+
+		idr_remove(&ns->idr, upid->nr);
 	}
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
-	for (i = 0; i <= pid->level; i++)
-		free_pidmap(pid->numbers + i);
-
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
@@ -308,8 +165,27 @@ struct pid *alloc_pid(struct pid_namespa
 
 	tmp = ns;
 	pid->level = ns->level;
+
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		int pid_min = 1;
+		idr_preload(GFP_KERNEL);
+		spin_lock_irq(&pidmap_lock);
+
+		/*
+		 * init really needs pid 1, but after reaching the maximum
+		 * wrap back to RESERVED_PIDS
+		 */
+		if (idr_get_cursor(&tmp->idr) > RESERVED_PIDS)
+			pid_min = RESERVED_PIDS;
+
+		/* Store a null pointer so find_pid_ns does not find             *
+		 * a partially initialized PID (see below).
+		 */
+		nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
+				      pid_max, GFP_ATOMIC);
+		spin_unlock_irq(&pidmap_lock);
+		idr_preload_end();
+
 		if (nr < 0) {
 			retval = nr;
 			goto out_free;
@@ -339,6 +215,8 @@ struct pid *alloc_pid(struct pid_namespa
 	for ( ; upid >= pid->numbers; --upid) {
 		hlist_add_head_rcu(&upid->pid_chain,
 				&pid_hash[pid_hashfn(upid->nr, upid->ns)]);
+		/* Make the PID visible to find_pid_ns. */
+		idr_replace(&upid->ns->idr, pid, upid->nr);
 		upid->ns->nr_hashed++;
 	}
 	spin_unlock_irq(&pidmap_lock);
@@ -350,8 +228,11 @@ out_unlock:
 	put_pid_ns(ns);
 
 out_free:
+	spin_lock_irq(&pidmap_lock);
 	while (++i <= ns->level)
-		free_pidmap(pid->numbers + i);
+		idr_remove(&ns->idr, (pid->numbers + i)->nr);
+
+	spin_unlock_irq(&pidmap_lock);
 
 	kmem_cache_free(ns->pid_cachep, pid);
 	return ERR_PTR(retval);
@@ -553,16 +434,7 @@ EXPORT_SYMBOL_GPL(task_active_pid_ns);
  */
 struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 {
-	struct pid *pid;
-
-	do {
-		pid = find_pid_ns(nr, ns);
-		if (pid)
-			break;
-		nr = next_pidmap(ns, nr);
-	} while (nr > 0);
-
-	return pid;
+	return idr_get_next(&ns->idr, &nr);
 }
 
 /*
@@ -578,7 +450,7 @@ void __init pidhash_init(void)
 					   0, 4096);
 }
 
-void __init pidmap_init(void)
+void __init pid_idr_init(void)
 {
 	/* Verify no one has done anything silly: */
 	BUILD_BUG_ON(PID_MAX_LIMIT >= PIDNS_HASH_ADDING);
@@ -590,10 +462,7 @@ void __init pidmap_init(void)
 				PIDS_PER_CPU_MIN * num_possible_cpus());
 	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
 
-	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	/* Reserve PID 0. We never call free_pidmap(0) */
-	set_bit(0, init_pid_ns.pidmap[0].page);
-	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
+	idr_init(&init_pid_ns.idr);
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
diff -puN kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid-replace-pid-bitmap-implementation-with-idr-api
+++ a/kernel/pid_namespace.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/sched/task.h>
 #include <linux/sched/signal.h>
+#include <linux/idr.h>
 
 struct pid_cache {
 	int nr_ids;
@@ -98,7 +99,6 @@ static struct pid_namespace *create_pid_
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
 	struct ucounts *ucounts;
-	int i;
 	int err;
 
 	err = -EINVAL;
@@ -117,17 +117,15 @@ static struct pid_namespace *create_pid_
 	if (ns == NULL)
 		goto out_dec;
 
-	ns->pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!ns->pidmap[0].page)
-		goto out_free;
+	idr_init(&ns->idr);
 
 	ns->pid_cachep = create_pid_cachep(level + 1);
 	if (ns->pid_cachep == NULL)
-		goto out_free_map;
+		goto out_free_idr;
 
 	err = ns_alloc_inum(&ns->ns);
 	if (err)
-		goto out_free_map;
+		goto out_free_idr;
 	ns->ns.ops = &pidns_operations;
 
 	kref_init(&ns->kref);
@@ -138,17 +136,10 @@ static struct pid_namespace *create_pid_
 	ns->nr_hashed = PIDNS_HASH_ADDING;
 	INIT_WORK(&ns->proc_work, proc_cleanup_work);
 
-	set_bit(0, ns->pidmap[0].page);
-	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
-
-	for (i = 1; i < PIDMAP_ENTRIES; i++)
-		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
-
 	return ns;
 
-out_free_map:
-	kfree(ns->pidmap[0].page);
-out_free:
+out_free_idr:
+	idr_destroy(&ns->idr);
 	kmem_cache_free(pid_ns_cachep, ns);
 out_dec:
 	dec_pid_namespaces(ucounts);
@@ -168,11 +159,9 @@ static void delayed_free_pidns(struct rc
 
 static void destroy_pid_namespace(struct pid_namespace *ns)
 {
-	int i;
-
 	ns_free_inum(&ns->ns);
-	for (i = 0; i < PIDMAP_ENTRIES; i++)
-		kfree(ns->pidmap[i].page);
+
+	idr_destroy(&ns->idr);
 	call_rcu(&ns->rcu, delayed_free_pidns);
 }
 
@@ -213,6 +202,7 @@ void zap_pid_ns_processes(struct pid_nam
 	int rc;
 	struct task_struct *task, *me = current;
 	int init_pids = thread_group_leader(me) ? 1 : 2;
+	struct pid *pid;
 
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
@@ -240,17 +230,11 @@ void zap_pid_ns_processes(struct pid_nam
 	 *
 	 */
 	read_lock(&tasklist_lock);
-	nr = next_pidmap(pid_ns, 1);
-	while (nr > 0) {
-		rcu_read_lock();
-
-		task = pid_task(find_vpid(nr), PIDTYPE_PID);
+	nr = 2;
+	idr_for_each_entry_continue(&pid_ns->idr, pid, nr) {
+		task = pid_task(pid, PIDTYPE_PID);
 		if (task && !__fatal_signal_pending(task))
 			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
-
-		rcu_read_unlock();
