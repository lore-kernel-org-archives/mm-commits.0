From: akpm@linux-foundation.org
Subject: [failures] shm-fix-a-race-between-shm_exit-and-shm_init.patch removed from -mm tree
Date: Wed, 03 Aug 2011 12:34:20 -0700
Message-ID: <201108031934.p73JYKMj008540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab1HCTe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 15:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, manuel.lauss@googlemail.com, marc.zyngier@arm.com, maz@misterjones.org, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     shm: fix a race between shm_exit() and shm_init()
has been removed from the -mm tree.  Its filename was
     shm-fix-a-race-between-shm_exit-and-shm_init.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shm: fix a race between shm_exit() and shm_init()
From: Vasiliy Kulikov <segoon@openwall.com>

On thread exit shm_exit_ns() is called, it uses shm_ids(ns).rw_mutex.  It
is initialized in shm_init(), but it is not called yet at the moment of
kernel threads exit.  Some kernel threads are created in
do_pre_smp_initcalls(), and shm_init() is called in do_initcalls().

Static initialization of shm_ids(init_ipc_ns).rw_mutex fixes the race.

It fixes a kernel oops:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
[<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015da08>] (exit_shm+0x28/0x48)
[<c015da08>] (exit_shm+0x28/0x48) from [<c002e550>] (do_exit+0x59c/0x750)
[<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>] (____call_usermodehelper+0x13c/0x154)
[<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>] (kernel_thread_exit+0x0/0x8)
Code: 1afffffa e597c00c e58d0000 e587d00c (e58cd000)

Reported-by: Manuel Lauss <manuel.lauss@googlemail.com>
Reported-by: Richard Weinberger <richard@nod.at>
Reported-by: Marc Zyngier <maz@misterjones.org>
Tested-by: Manuel Lauss <manuel.lauss@googlemail.com>
Tested-by: Richard Weinberger <richard@nod.at>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    6 ++++++
 ipc/shm.c     |   11 ++++++++++-
 ipc/util.c    |   30 +++++++++++++++++-------------
 ipc/util.h    |    1 +
 4 files changed, 34 insertions(+), 14 deletions(-)

diff -puN ipc/msgutil.c~shm-fix-a-race-between-shm_exit-and-shm_init ipc/msgutil.c
--- a/ipc/msgutil.c~shm-fix-a-race-between-shm_exit-and-shm_init
+++ a/ipc/msgutil.c
@@ -20,6 +20,9 @@
 
 DEFINE_SPINLOCK(mq_lock);
 
+#define INIT_IPC_SHM_IDS(name) \
+	{ .rw_mutex = __RWSEM_INITIALIZER(name.rw_mutex), }
+
 /*
  * The next 2 defines are here bc this is the only file
  * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
@@ -27,6 +30,9 @@ DEFINE_SPINLOCK(mq_lock);
  */
 struct ipc_namespace init_ipc_ns = {
 	.count		= ATOMIC_INIT(1),
+	.ids	= {
+		[IPC_SHM_IDS] = INIT_IPC_SHM_IDS(init_ipc_ns.ids[IPC_SHM_IDS]),
+	},
 #ifdef CONFIG_POSIX_MQUEUE
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
diff -puN ipc/shm.c~shm-fix-a-race-between-shm_exit-and-shm_init ipc/shm.c
--- a/ipc/shm.c~shm-fix-a-race-between-shm_exit-and-shm_init
+++ a/ipc/shm.c
@@ -76,7 +76,16 @@ void shm_init_ns(struct ipc_namespace *n
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_rmid_forced = 0;
 	ns->shm_tot = 0;
-	ipc_init_ids(&shm_ids(ns));
+
+	/*
+	 * For init_ipc_ns shm_ids().rw_mutex is statically initialized
+	 * as kernel threads should be able to use it in do_exit() before
+	 * shm_init(), which is called on do_initcall()
+	 */
+	if (ns == &init_ipc_ns)
+		__ipc_init_ids(&shm_ids(ns));
+	else
+		ipc_init_ids(&shm_ids(ns));
 }
 
 /*
diff -puN ipc/util.c~shm-fix-a-race-between-shm_exit-and-shm_init ipc/util.c
--- a/ipc/util.c~shm-fix-a-race-between-shm_exit-and-shm_init
+++ a/ipc/util.c
@@ -108,31 +108,35 @@ static int __init ipc_init(void)
 }
 __initcall(ipc_init);
 
-/**
- *	ipc_init_ids		-	initialise IPC identifiers
- *	@ids: Identifier set
- *
- *	Set up the sequence range to use for the ipc identifier range (limited
- *	below IPCMNI) then initialise the ids idr.
- */
- 
-void ipc_init_ids(struct ipc_ids *ids)
+void __ipc_init_ids(struct ipc_ids *ids)
 {
-	init_rwsem(&ids->rw_mutex);
-
 	ids->in_use = 0;
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
 		if (seq_limit > USHRT_MAX)
 			ids->seq_max = USHRT_MAX;
-		 else
-		 	ids->seq_max = seq_limit;
+		else
+			ids->seq_max = seq_limit;
 	}
 
 	idr_init(&ids->ipcs_idr);
 }
 
+/**
+ *	ipc_init_ids		-	initialise IPC identifiers
+ *	@ids: Identifier set
+ *
+ *	Set up the sequence range to use for the ipc identifier range (limited
+ *	below IPCMNI) then initialise the ids idr.
+ */
+
+void ipc_init_ids(struct ipc_ids *ids)
+{
+	init_rwsem(&ids->rw_mutex);
+	__ipc_init_ids(ids);
+}
+
 #ifdef CONFIG_PROC_FS
 static const struct file_operations sysvipc_proc_fops;
 /**
diff -puN ipc/util.h~shm-fix-a-race-between-shm_exit-and-shm_init ipc/util.h
--- a/ipc/util.h~shm-fix-a-race-between-shm_exit-and-shm_init
+++ a/ipc/util.h
@@ -80,6 +80,7 @@ struct seq_file;
 struct ipc_ids;
 
 void ipc_init_ids(struct ipc_ids *);
+void __ipc_init_ids(struct ipc_ids *ids);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
taskstats-add_del_listener-shouldnt-use-the-wrong-node.patch
taskstats-add_del_listener-should-ignore-valid-listeners.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

