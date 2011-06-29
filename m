From: akpm@linux-foundation.org
Subject: + ipc-introduce-shm_rmid_forced-sysctl.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:14:55 -0700
Message-ID: <201106292214.p5TMEtHg015372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133Ab1F2WPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, serge.hallyn@canonical.com, tj@kernel.org


The patch titled
     ipc: introduce shm_rmid_forced sysctl
has been added to the -mm tree.  Its filename is
     ipc-introduce-shm_rmid_forced-sysctl.patch

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
Subject: ipc: introduce shm_rmid_forced sysctl
From: Vasiliy Kulikov <segoon@openwall.com>

Add support for the shm_rmid_forced sysctl.  If set to 1, all
shared memory objects in current ipc namespace will be automatically
forced to use IPC_RMID.

The POSIX way of handling shmem allows one to create shm objects and call
shmdt(), leaving shm object associated with no process, thus consuming
memory not counted via rlimits.

With shm_rmid_forced=1 the shared memory object is counted at least for
one process, so OOM killer may effectively kill the fat process holding
the shared memory.

It obviously breaks POSIX - some programs relying on the feature would
stop working.  So set shm_rmid_forced=1 only if you're sure nobody uses
"orphaned" memory.  Use shm_rmid_forced=0 by default for compatability
reasons.

The feature was previously impemented in -ow as a configure option.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   22 +++++++
 include/linux/ipc_namespace.h   |    3 +
 include/linux/shm.h             |    5 +
 ipc/ipc_sysctl.c                |   33 +++++++++++
 ipc/shm.c                       |   87 ++++++++++++++++++++++++++++--
 kernel/exit.c                   |    1 
 6 files changed, 147 insertions(+), 4 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~ipc-introduce-shm_rmid_forced-sysctl Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~ipc-introduce-shm_rmid_forced-sysctl
+++ a/Documentation/sysctl/kernel.txt
@@ -62,6 +62,7 @@ show up in /proc/sys/kernel:
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
+- shm_rmid_forced
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - tainted
@@ -475,6 +476,27 @@ kernel.  This value defaults to SHMMAX.
 
 ==============================================================
 
+shm_rmid_forced:
+
+Linux lets you set resource limits, including on how much memory one
+process can consume, via setrlimit(2).  Unfortunately, shared memory
+segments are allowed to exist without association with any process, and
+thus might not be counted against any resource limits.  If enabled,
+shared memory segments are automatically destroyed when their attach
+count becomes zero after a detach or a process termination.  It will
+also destroy segments that were created, but never attached to, on exit
+from the process.  The only use left for IPC_RMID is to immediately
+destroy an unattached segment.  Of course, this breaks the way things are
+defined, so some applications might stop working.  Note that this
+feature will do you no good unless you also configure your resource
+limits (in particular, RLIMIT_AS and RLIMIT_NPROC).  Most systems don't
+need this.
+
+Note that if you change this from 0 to 1, already created segments
+without users and with a dead originative process will be destroyed.
+
+==============================================================
+
 softlockup_thresh:
 
 This value can be used to lower the softlockup tolerance threshold.  The
diff -puN include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-introduce-shm_rmid_forced-sysctl
+++ a/include/linux/ipc_namespace.h
@@ -44,6 +44,7 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
+	int		shm_rmid_forced;
 
 	struct notifier_block ipcns_nb;
 
@@ -72,6 +73,7 @@ extern int register_ipcns_notifier(struc
 extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern void unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);
+extern void shm_destroy_orphaned(struct ipc_namespace *ns);
 #else /* CONFIG_SYSVIPC */
 static inline int register_ipcns_notifier(struct ipc_namespace *ns)
 { return 0; }
@@ -79,6 +81,7 @@ static inline int cond_register_ipcns_no
 { return 0; }
 static inline void unregister_ipcns_notifier(struct ipc_namespace *ns) { }
 static inline int ipcns_notify(unsigned long l) { return 0; }
+static inline void shm_destroy_orphaned(struct ipc_namespace *ns) {}
 #endif /* CONFIG_SYSVIPC */
 
 #ifdef CONFIG_POSIX_MQUEUE
diff -puN include/linux/shm.h~ipc-introduce-shm_rmid_forced-sysctl include/linux/shm.h
--- a/include/linux/shm.h~ipc-introduce-shm_rmid_forced-sysctl
+++ a/include/linux/shm.h
@@ -106,6 +106,7 @@ struct shmid_kernel /* private to the ke
 #ifdef CONFIG_SYSVIPC
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
 extern int is_file_shm_hugepages(struct file *file);
+extern void exit_shm(struct task_struct *task);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
 				int shmflg, unsigned long *addr)
@@ -116,6 +117,10 @@ static inline int is_file_shm_hugepages(
 {
 	return 0;
 }
+static inline void exit_shm(struct task_struct *task)
+{
+	return 0;
+}
 #endif
 
 #endif /* __KERNEL__ */
diff -puN ipc/ipc_sysctl.c~ipc-introduce-shm_rmid_forced-sysctl ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-introduce-shm_rmid_forced-sysctl
+++ a/ipc/ipc_sysctl.c
@@ -37,6 +37,28 @@ static int proc_ipc_dointvec(ctl_table *
 	return proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
 }
 
+static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table ipc_table;
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+
+	return proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
+}
+
+static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+	int err = proc_ipc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+	if (ns->shm_rmid_forced)
+		shm_destroy_orphaned(ns);
+	return err;
+}
+
 static int proc_ipc_callback_dointvec(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -125,6 +147,8 @@ static int proc_ipcauto_dointvec_minmax(
 #else
 #define proc_ipc_doulongvec_minmax NULL
 #define proc_ipc_dointvec	   NULL
+#define proc_ipc_dointvec_minmax   NULL
+#define proc_ipc_dointvec_minmax_orphans   NULL
 #define proc_ipc_callback_dointvec NULL
 #define proc_ipcauto_dointvec_minmax NULL
 #endif
@@ -155,6 +179,15 @@ static struct ctl_table ipc_kern_table[]
 		.proc_handler	= proc_ipc_dointvec,
 	},
 	{
+		.procname	= "shm_rmid_forced",
+		.data		= &init_ipc_ns.shm_rmid_forced,
+		.maxlen		= sizeof(init_ipc_ns.shm_rmid_forced),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec_minmax_orphans,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "msgmax",
 		.data		= &init_ipc_ns.msg_ctlmax,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
diff -puN ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl ipc/shm.c
--- a/ipc/shm.c~ipc-introduce-shm_rmid_forced-sysctl
+++ a/ipc/shm.c
@@ -74,6 +74,7 @@ void shm_init_ns(struct ipc_namespace *n
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
+	ns->shm_rmid_forced = 0;
 	ns->shm_tot = 0;
 	ipc_init_ids(&shm_ids(ns));
 }
@@ -186,6 +187,13 @@ static void shm_destroy(struct ipc_names
 	ipc_rcu_putref(shp);
 }
 
+static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
+{
+	return (shp->shm_nattch == 0) &&
+	       (ns->shm_rmid_forced ||
+		(shp->shm_perm.mode & SHM_DEST));
+}
+
 /*
  * remove the attach descriptor vma.
  * free memory for segment if it is marked destroyed.
@@ -206,11 +214,83 @@ static void shm_close(struct vm_area_str
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
-	if(shp->shm_nattch == 0 &&
-	   shp->shm_perm.mode & SHM_DEST)
+	if (shm_may_destroy(ns, shp))
+		shm_destroy(ns, shp);
+	else
+		shm_unlock(shp);
+	up_write(&shm_ids(ns).rw_mutex);
+}
+
+static int shm_try_destroy_current(int id, void *p, void *data)
+{
+	struct ipc_namespace *ns = data;
+	struct shmid_kernel *shp = shm_lock(ns, id);
+
+	if (IS_ERR(shp))
+		return 0;
+
+	if (shp->shm_cprid != task_tgid_vnr(current)) {
+		shm_unlock(shp);
+		return 0;
+	}
+
+	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
+	return 0;
+}
+
+static int shm_try_destroy_orphaned(int id, void *p, void *data)
+{
+	struct ipc_namespace *ns = data;
+	struct shmid_kernel *shp = shm_lock(ns, id);
+	struct task_struct *task;
+
+	if (IS_ERR(shp))
+		return 0;
+
+	/*
+	 * We want to destroy segments without users and with already
+	 * exit'ed originating process.
+	 *
+	 * XXX: the originating process may exist in another pid namespace.
+	 */
+	task = find_task_by_vpid(shp->shm_cprid);
+	if (task != NULL) {
+		shm_unlock(shp);
+		return 0;
+	}
+
+	if (shm_may_destroy(ns, shp))
+		shm_destroy(ns, shp);
+	else
+		shm_unlock(shp);
+	return 0;
+}
+
+void shm_destroy_orphaned(struct ipc_namespace *ns)
+{
+	down_write(&shm_ids(ns).rw_mutex);
+	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+	up_write(&shm_ids(ns).rw_mutex);
+}
+
+
+void exit_shm(struct task_struct *task)
+{
+	struct nsproxy *nsp = task->nsproxy;
+	struct ipc_namespace *ns;
+
+	if (!nsp)
+		return;
+	ns = nsp->ipc_ns;
+	if (!ns || !ns->shm_rmid_forced)
+		return;
+
+	/* Destroy all already created segments, but not mapped yet */
+	down_write(&shm_ids(ns).rw_mutex);
+	idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_current, ns);
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
@@ -950,8 +1030,7 @@ out_nattch:
 	shp = shm_lock(ns, shmid);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
-	if(shp->shm_nattch == 0 &&
-	   shp->shm_perm.mode & SHM_DEST)
+	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
 	else
 		shm_unlock(shp);
diff -puN kernel/exit.c~ipc-introduce-shm_rmid_forced-sysctl kernel/exit.c
--- a/kernel/exit.c~ipc-introduce-shm_rmid_forced-sysctl
+++ a/kernel/exit.c
@@ -984,6 +984,7 @@ NORET_TYPE void do_exit(long code)
 	trace_sched_process_exit(tsk);
 
 	exit_sem(tsk);
+	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
 	check_stack_usage();
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

