From: akpm@linux-foundation.org
Subject: + ipc-optimize-semget-shmget-msgget-for-lots-of-keys.patch added
 to -mm tree
Date: Tue, 15 Aug 2017 14:49:48 -0700
Message-ID: <59936c7c.onWAfWdI9mr1ER3+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46212 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdHOVtu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 17:49:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guillaume.knispel@supersonicimagine.com, adobriyan@gmail.com, avagin@openvz.org, bigeasy@linutronix.de, dave@stgolabs.net, ebiederm@xmission.com, keescook@chromium.org, manfred@colorfullife.com, marc.pardo@supersonicimagine.com, mingo@kernel.org, peterz@infradead.org, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: optimize semget/shmget/msgget for lots of keys
has been added to the -mm tree.  Its filename is
     ipc-optimize-semget-shmget-msgget-for-lots-of-keys.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-optimize-semget-shmget-msgget-for-lots-of-keys.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-optimize-semget-shmget-msgget-for-lots-of-keys.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guillaume Knispel <guillaume.knispel@supersonicimagine.com>
Subject: ipc: optimize semget/shmget/msgget for lots of keys

ipc_findkey() used to scan all objects to look for the wanted key.  This
is slow when using a high number of keys.  This change adds an rhashtable
of kern_ipc_perm objects in ipc_ids, so that one lookup cease to be O(n).

This change gives a 865% improvement of benchmark reaim.jobs_per_min on a
56 threads Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz with 256G memory [1]

Other (more micro) benchmark results, by the author: On an i5 laptop, the
following loop executed right after a reboot took, without and with this
change:

    for (int i = 0, k=0x424242; i < KEYS; ++i)
        semget(k++, 1, IPC_CREAT | 0600);

                 total       total          max single  max single
   KEYS        without        with        call without   call with

      1            3.5         4.9   µs            3.5         4.9
     10            7.6         8.6   µs            3.7         4.7
     32           16.2        15.9   µs            4.3         5.3
    100           72.9        41.8   µs            3.7         4.7
   1000        5,630.0       502.0   µs             *           *
  10000    1,340,000.0     7,240.0   µs             *           *
  31900   17,600,000.0    22,200.0   µs             *           *

 *: unreliable measure: high variance

The duration for a lookup-only usage was obtained by the same loop once
the keys are present:

                 total       total          max single  max single
   KEYS        without        with        call without   call with

      1            2.1         2.5   µs            2.1         2.5
     10            4.5         4.8   µs            2.2         2.3
     32           13.0        10.8   µs            2.3         2.8
    100           82.9        25.1   µs             *          2.3
   1000        5,780.0       217.0   µs             *           *
  10000    1,470,000.0     2,520.0   µs             *           *
  31900   17,400,000.0     7,810.0   µs             *           *

Finally, executing each semget() in a new process gave, when still
summing only the durations of these syscalls:

creation:
                 total       total
   KEYS        without        with

      1            3.7         5.0   µs
     10           32.9        36.7   µs
     32          125.0       109.0   µs
    100          523.0       353.0   µs
   1000       20,300.0     3,280.0   µs
  10000    2,470,000.0    46,700.0   µs
  31900   27,800,000.0   219,000.0   µs

lookup-only:
                 total       total
   KEYS        without        with

      1            2.5         2.7   µs
     10           25.4        24.4   µs
     32          106.0        72.6   µs
    100          591.0       352.0   µs
   1000       22,400.0     2,250.0   µs
  10000    2,510,000.0    25,700.0   µs
  31900   28,200,000.0   115,000.0   µs

[1] http://lkml.kernel.org/r/20170814060507.GE23258@yexl-desktop

Link: http://lkml.kernel.org/r/20170815194954.ck32ta2z35yuzpwp@debix
Signed-off-by: Guillaume Knispel <guillaume.knispel@supersonicimagine.com>
Reviewed-by: Marc Pardo <marc.pardo@supersonicimagine.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Guillaume Knispel <guillaume.knispel@supersonicimagine.com>
Cc: Marc Pardo <marc.pardo@supersonicimagine.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc.h           |    3 
 include/linux/ipc_namespace.h |    3 
 ipc/msg.c                     |   10 +--
 ipc/namespace.c               |   20 +++++-
 ipc/sem.c                     |   11 ++-
 ipc/shm.c                     |   12 ++-
 ipc/util.c                    |  100 ++++++++++++++++++++++++--------
 ipc/util.h                    |   21 +++---
 8 files changed, 130 insertions(+), 50 deletions(-)

diff -puN include/linux/ipc.h~ipc-optimize-semget-shmget-msgget-for-lots-of-keys include/linux/ipc.h
--- a/include/linux/ipc.h~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/include/linux/ipc.h
@@ -3,6 +3,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/uidgid.h>
+#include <linux/rhashtable.h>
 #include <uapi/linux/ipc.h>
 #include <linux/refcount.h>
 
@@ -22,6 +23,8 @@ struct kern_ipc_perm {
 	unsigned long	seq;
 	void		*security;
 
+	struct rhash_head khtnode;
+
 	struct rcu_head rcu;
 	refcount_t refcount;
 } ____cacheline_aligned_in_smp __randomize_layout;
diff -puN include/linux/ipc_namespace.h~ipc-optimize-semget-shmget-msgget-for-lots-of-keys include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/include/linux/ipc_namespace.h
@@ -8,15 +8,18 @@
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
 #include <linux/refcount.h>
+#include <linux/rhashtable.h>
 
 struct user_namespace;
 
 struct ipc_ids {
 	int in_use;
 	unsigned short seq;
+	bool tables_initialized;
 	struct rw_semaphore rwsem;
 	struct idr ipcs_idr;
 	int next_id;
+	struct rhashtable key_ht;
 };
 
 struct ipc_namespace {
diff -puN ipc/msg.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys ipc/msg.c
--- a/ipc/msg.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/ipc/msg.c
@@ -1011,7 +1011,7 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, stru
 }
 
 
-void msg_init_ns(struct ipc_namespace *ns)
+int msg_init_ns(struct ipc_namespace *ns)
 {
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
@@ -1019,7 +1019,7 @@ void msg_init_ns(struct ipc_namespace *n
 
 	atomic_set(&ns->msg_bytes, 0);
 	atomic_set(&ns->msg_hdrs, 0);
-	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
+	return ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -1027,6 +1027,7 @@ void msg_exit_ns(struct ipc_namespace *n
 {
 	free_ipcs(ns, &msg_ids(ns), freeque);
 	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
+	rhashtable_destroy(&ns->ids[IPC_MSG_IDS].key_ht);
 }
 #endif
 
@@ -1058,11 +1059,12 @@ static int sysvipc_msg_proc_show(struct
 }
 #endif
 
-void __init msg_init(void)
+int __init msg_init(void)
 {
-	msg_init_ns(&init_ipc_ns);
+	const int err = msg_init_ns(&init_ipc_ns);
 
 	ipc_init_proc_interface("sysvipc/msg",
 				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
+	return err;
 }
diff -puN ipc/namespace.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys ipc/namespace.c
--- a/ipc/namespace.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/ipc/namespace.c
@@ -54,16 +54,28 @@ static struct ipc_namespace *create_ipc_
 	ns->user_ns = get_user_ns(user_ns);
 	ns->ucounts = ucounts;
 
-	err = mq_init_ns(ns);
+	err = sem_init_ns(ns);
 	if (err)
 		goto fail_put;
+	err = msg_init_ns(ns);
+	if (err)
+		goto fail_destroy_sem;
+	err = shm_init_ns(ns);
+	if (err)
+		goto fail_destroy_msg;
 
-	sem_init_ns(ns);
-	msg_init_ns(ns);
-	shm_init_ns(ns);
+	err = mq_init_ns(ns);
+	if (err)
+		goto fail_destroy_shm;
 
 	return ns;
 
+fail_destroy_shm:
+	shm_exit_ns(ns);
+fail_destroy_msg:
+	msg_exit_ns(ns);
+fail_destroy_sem:
+	sem_exit_ns(ns);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
diff -puN ipc/sem.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys ipc/sem.c
--- a/ipc/sem.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/ipc/sem.c
@@ -183,14 +183,14 @@ static int sysvipc_sem_proc_show(struct
 #define sc_semopm	sem_ctls[2]
 #define sc_semmni	sem_ctls[3]
 
-void sem_init_ns(struct ipc_namespace *ns)
+int sem_init_ns(struct ipc_namespace *ns)
 {
 	ns->sc_semmsl = SEMMSL;
 	ns->sc_semmns = SEMMNS;
 	ns->sc_semopm = SEMOPM;
 	ns->sc_semmni = SEMMNI;
 	ns->used_sems = 0;
-	ipc_init_ids(&ns->ids[IPC_SEM_IDS]);
+	return ipc_init_ids(&ns->ids[IPC_SEM_IDS]);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -198,15 +198,18 @@ void sem_exit_ns(struct ipc_namespace *n
 {
 	free_ipcs(ns, &sem_ids(ns), freeary);
 	idr_destroy(&ns->ids[IPC_SEM_IDS].ipcs_idr);
+	rhashtable_destroy(&ns->ids[IPC_SEM_IDS].key_ht);
 }
 #endif
 
-void __init sem_init(void)
+int __init sem_init(void)
 {
-	sem_init_ns(&init_ipc_ns);
+	const int err = sem_init_ns(&init_ipc_ns);
+
 	ipc_init_proc_interface("sysvipc/sem",
 				"       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime\n",
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
+	return err;
 }
 
 /**
diff -puN ipc/shm.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys ipc/shm.c
--- a/ipc/shm.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/ipc/shm.c
@@ -72,14 +72,14 @@ static void shm_destroy(struct ipc_names
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
 
-void shm_init_ns(struct ipc_namespace *ns)
+int shm_init_ns(struct ipc_namespace *ns)
 {
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_rmid_forced = 0;
 	ns->shm_tot = 0;
-	ipc_init_ids(&shm_ids(ns));
+	return ipc_init_ids(&shm_ids(ns));
 }
 
 /*
@@ -95,7 +95,7 @@ static void do_shm_rmid(struct ipc_names
 	if (shp->shm_nattch) {
 		shp->shm_perm.mode |= SHM_DEST;
 		/* Do not find it any more */
-		shp->shm_perm.key = IPC_PRIVATE;
+		ipc_set_key_private(&shm_ids(ns), &shp->shm_perm);
 		shm_unlock(shp);
 	} else
 		shm_destroy(ns, shp);
@@ -106,13 +106,15 @@ void shm_exit_ns(struct ipc_namespace *n
 {
 	free_ipcs(ns, &shm_ids(ns), do_shm_rmid);
 	idr_destroy(&ns->ids[IPC_SHM_IDS].ipcs_idr);
+	rhashtable_destroy(&ns->ids[IPC_SHM_IDS].key_ht);
 }
 #endif
 
 static int __init ipc_ns_init(void)
 {
-	shm_init_ns(&init_ipc_ns);
-	return 0;
+	const int err = shm_init_ns(&init_ipc_ns);
+	WARN(err, "ipc: sysv shm_init_ns failed: %d\n", err);
+	return err;
 }
 
 pure_initcall(ipc_ns_init);
diff -puN ipc/util.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys ipc/util.c
--- a/ipc/util.c~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/ipc/util.c
@@ -83,27 +83,46 @@ struct ipc_proc_iface {
  */
 static int __init ipc_init(void)
 {
-	sem_init();
-	msg_init();
+	int err_sem, err_msg;
+
+	err_sem = sem_init();
+	WARN(err_sem, "ipc: sysv sem_init failed: %d\n", err_sem);
+	err_msg = msg_init();
+	WARN(err_msg, "ipc: sysv msg_init failed: %d\n", err_msg);
 	shm_init();
-	return 0;
+
+	return err_msg ? err_msg : err_sem;
 }
 device_initcall(ipc_init);
 
+static const struct rhashtable_params ipc_kht_params = {
+	.head_offset		= offsetof(struct kern_ipc_perm, khtnode),
+	.key_offset		= offsetof(struct kern_ipc_perm, key),
+	.key_len		= FIELD_SIZEOF(struct kern_ipc_perm, key),
+	.locks_mul		= 1,
+	.automatic_shrinking	= true,
+};
+
 /**
  * ipc_init_ids	- initialise ipc identifiers
  * @ids: ipc identifier set
  *
  * Set up the sequence range to use for the ipc identifier range (limited
- * below IPCMNI) then initialise the ids idr.
+ * below IPCMNI) then initialise the keys hashtable and ids idr.
  */
-void ipc_init_ids(struct ipc_ids *ids)
+int ipc_init_ids(struct ipc_ids *ids)
 {
+	int err;
 	ids->in_use = 0;
 	ids->seq = 0;
 	ids->next_id = -1;
 	init_rwsem(&ids->rwsem);
+	err = rhashtable_init(&ids->key_ht, &ipc_kht_params);
+	if (err)
+		return err;
 	idr_init(&ids->ipcs_idr);
+	ids->tables_initialized = true;
+	return 0;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -147,28 +166,20 @@ void __init ipc_init_proc_interface(cons
  * Returns the locked pointer to the ipc structure if found or NULL
  * otherwise. If key is found ipc points to the owning ipc structure
  *
- * Called with ipc_ids.rwsem held.
+ * Called with writer ipc_ids.rwsem held.
  */
 static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 {
-	struct kern_ipc_perm *ipc;
-	int next_id;
-	int total;
+	struct kern_ipc_perm *ipcp = NULL;
 
-	for (total = 0, next_id = 0; total < ids->in_use; next_id++) {
-		ipc = idr_find(&ids->ipcs_idr, next_id);
-
-		if (ipc == NULL)
-			continue;
-
-		if (ipc->key != key) {
-			total++;
-			continue;
-		}
+	if (likely(ids->tables_initialized))
+		ipcp = rhashtable_lookup_fast(&ids->key_ht, &key,
+					      ipc_kht_params);
 
+	if (ipcp) {
 		rcu_read_lock();
-		ipc_lock_object(ipc);
-		return ipc;
+		ipc_lock_object(ipcp);
+		return ipcp;
 	}
 
 	return NULL;
@@ -221,13 +232,13 @@ int ipc_addid(struct ipc_ids *ids, struc
 {
 	kuid_t euid;
 	kgid_t egid;
-	int id;
+	int id, err;
 	int next_id = ids->next_id;
 
 	if (size > IPCMNI)
 		size = IPCMNI;
 
-	if (ids->in_use >= size)
+	if (!ids->tables_initialized || ids->in_use >= size)
 		return -ENOSPC;
 
 	idr_preload(GFP_KERNEL);
@@ -246,6 +257,15 @@ int ipc_addid(struct ipc_ids *ids, struc
 		       (next_id < 0) ? 0 : ipcid_to_idx(next_id), 0,
 		       GFP_NOWAIT);
 	idr_preload_end();
+
+	if (id >= 0 && new->key != IPC_PRIVATE) {
+		err = rhashtable_insert_fast(&ids->key_ht, &new->khtnode,
+					     ipc_kht_params);
+		if (err < 0) {
+			idr_remove(&ids->ipcs_idr, id);
+			id = err;
+		}
+	}
 	if (id < 0) {
 		spin_unlock(&new->lock);
 		rcu_read_unlock();
@@ -377,6 +397,20 @@ static int ipcget_public(struct ipc_name
 	return err;
 }
 
+/**
+ * ipc_kht_remove - remove an ipc from the key hashtable
+ * @ids: ipc identifier set
+ * @ipcp: ipc perm structure containing the key to remove
+ *
+ * ipc_ids.rwsem (as a writer) and the spinlock for this ID are held
+ * before this function is called, and remain locked on the exit.
+ */
+static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
+{
+	if (ipcp->key != IPC_PRIVATE)
+		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
+				       ipc_kht_params);
+}
 
 /**
  * ipc_rmid - remove an ipc identifier
@@ -391,10 +425,25 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	int lid = ipcid_to_idx(ipcp->id);
 
 	idr_remove(&ids->ipcs_idr, lid);
+	ipc_kht_remove(ids, ipcp);
 	ids->in_use--;
 	ipcp->deleted = true;
 }
 
+/**
+ * ipc_set_key_private - switch the key of an existing ipc to IPC_PRIVATE
+ * @ids: ipc identifier set
+ * @ipcp: ipc perm structure containing the key to modify
+ *
+ * ipc_ids.rwsem (as a writer) and the spinlock for this ID are held
+ * before this function is called, and remain locked on the exit.
+ */
+void ipc_set_key_private(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
+{
+	ipc_kht_remove(ids, ipcp);
+	ipcp->key = IPC_PRIVATE;
+}
+
 int ipc_rcu_getref(struct kern_ipc_perm *ptr)
 {
 	return refcount_inc_not_zero(&ptr->refcount);
@@ -485,7 +534,7 @@ void ipc64_perm_to_ipc_perm(struct ipc64
 }
 
 /**
- * ipc_obtain_object
+ * ipc_obtain_object_idr
  * @ids: ipc identifier set
  * @id: ipc id to look for
  *
@@ -499,6 +548,9 @@ struct kern_ipc_perm *ipc_obtain_object_
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
 
+	if (unlikely(!ids->tables_initialized))
+		return ERR_PTR(-EINVAL);
+
 	out = idr_find(&ids->ipcs_idr, lid);
 	if (!out)
 		return ERR_PTR(-EINVAL);
diff -puN ipc/util.h~ipc-optimize-semget-shmget-msgget-for-lots-of-keys ipc/util.h
--- a/ipc/util.h~ipc-optimize-semget-shmget-msgget-for-lots-of-keys
+++ a/ipc/util.h
@@ -15,8 +15,8 @@
 
 #define SEQ_MULTIPLIER	(IPCMNI)
 
-void sem_init(void);
-void msg_init(void);
+int sem_init(void);
+int msg_init(void);
 void shm_init(void);
 
 struct ipc_namespace;
@@ -30,17 +30,17 @@ static inline void mq_put_mnt(struct ipc
 #endif
 
 #ifdef CONFIG_SYSVIPC
-void sem_init_ns(struct ipc_namespace *ns);
-void msg_init_ns(struct ipc_namespace *ns);
-void shm_init_ns(struct ipc_namespace *ns);
+int sem_init_ns(struct ipc_namespace *ns);
+int msg_init_ns(struct ipc_namespace *ns);
+int shm_init_ns(struct ipc_namespace *ns);
 
 void sem_exit_ns(struct ipc_namespace *ns);
 void msg_exit_ns(struct ipc_namespace *ns);
 void shm_exit_ns(struct ipc_namespace *ns);
 #else
-static inline void sem_init_ns(struct ipc_namespace *ns) { }
-static inline void msg_init_ns(struct ipc_namespace *ns) { }
-static inline void shm_init_ns(struct ipc_namespace *ns) { }
+static inline int sem_init_ns(struct ipc_namespace *ns) { return 0; }
+static inline int msg_init_ns(struct ipc_namespace *ns) { return 0; }
+static inline int shm_init_ns(struct ipc_namespace *ns) { return 0; }
 
 static inline void sem_exit_ns(struct ipc_namespace *ns) { }
 static inline void msg_exit_ns(struct ipc_namespace *ns) { }
@@ -79,7 +79,7 @@ struct ipc_ops {
 struct seq_file;
 struct ipc_ids;
 
-void ipc_init_ids(struct ipc_ids *);
+int ipc_init_ids(struct ipc_ids *);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
@@ -104,6 +104,9 @@ int ipc_get_maxid(struct ipc_ids *);
 /* must be called with both locks acquired. */
 void ipc_rmid(struct ipc_ids *, struct kern_ipc_perm *);
 
+/* must be called with both locks acquired. */
+void ipc_set_key_private(struct ipc_ids *, struct kern_ipc_perm *);
+
 /* must be called with ipcp locked */
 int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flg);
 
_

Patches currently in -mm which might be from guillaume.knispel@supersonicimagine.com are

ipc-optimize-semget-shmget-msgget-for-lots-of-keys.patch

