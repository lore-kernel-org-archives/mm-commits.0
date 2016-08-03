From: akpm@linux-foundation.org
Subject: [merged] sysv-ipc-fix-security-layer-leaking.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:11:21 -0700
Message-ID: <57a233c9.MgrMDgChKqd4VA5n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dbueso@suse.de, manfred@colorfullife.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sysv, ipc: fix security-layer leaking
has been removed from the -mm tree.  Its filename was
     sysv-ipc-fix-security-layer-leaking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: sysv, ipc: fix security-layer leaking

53dad6d3a8e5 ("ipc: fix race with LSMs") updated ipc_rcu_putref() to
receive rcu freeing function but used generic ipc_rcu_free() instead of
msg_rcu_free() which does security cleaning.

Running LTP msgsnd06 with kmemleak gives the following:

cat /sys/kernel/debug/kmemleak

unreferenced object 0xffff88003c0a11f8 (size 8):
  comm "msgsnd06", pid 1645, jiffies 4294672526 (age 6.549s)
  hex dump (first 8 bytes):
    1b 00 00 00 01 00 00 00                          ........
  backtrace:
    [<ffffffff818e2c43>] kmemleak_alloc+0x23/0x40
    [<ffffffff81177f31>] kmem_cache_alloc_trace+0xe1/0x180
    [<ffffffff812d42af>] selinux_msg_queue_alloc_security+0x3f/0xd0
    [<ffffffff812cc6be>] security_msg_queue_alloc+0x2e/0x40
    [<ffffffff812b94ee>] newque+0x4e/0x150
    [<ffffffff812b8cb9>] ipcget+0x159/0x1b0
    [<ffffffff812b98d9>] SyS_msgget+0x39/0x40
    [<ffffffff818e7bdb>] entry_SYSCALL_64_fastpath+0x13/0x8f
    [<ffffffffffffffff>] 0xffffffffffffffff

Manfred Spraul suggested to fix sem.c as well and
Davidlohr Bueso to only use ipc_rcu_free in case of security
allocation failure in newary()

Fixes: 53dad6d3a8e ("ipc: fix race with LSMs")
Link: http://lkml.kernel.org/r/1470083552-22966-1-git-send-email-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 ipc/sem.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN ipc/msg.c~sysv-ipc-fix-security-layer-leaking ipc/msg.c
--- a/ipc/msg.c~sysv-ipc-fix-security-layer-leaking
+++ a/ipc/msg.c
@@ -680,7 +680,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		rcu_read_lock();
 		ipc_lock_object(&msq->q_perm);
 
-		ipc_rcu_putref(msq, ipc_rcu_free);
+		ipc_rcu_putref(msq, msg_rcu_free);
 		/* raced with RMID? */
 		if (!ipc_valid_object(&msq->q_perm)) {
 			err = -EIDRM;
diff -puN ipc/sem.c~sysv-ipc-fix-security-layer-leaking ipc/sem.c
--- a/ipc/sem.c~sysv-ipc-fix-security-layer-leaking
+++ a/ipc/sem.c
@@ -438,7 +438,7 @@ static inline struct sem_array *sem_obta
 static inline void sem_lock_and_putref(struct sem_array *sma)
 {
 	sem_lock(sma, NULL, -1);
-	ipc_rcu_putref(sma, ipc_rcu_free);
+	ipc_rcu_putref(sma, sem_rcu_free);
 }
 
 static inline void sem_rmid(struct ipc_namespace *ns, struct sem_array *s)
@@ -1381,7 +1381,7 @@ static int semctl_main(struct ipc_namesp
 			rcu_read_unlock();
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if (sem_io == NULL) {
-				ipc_rcu_putref(sma, ipc_rcu_free);
+				ipc_rcu_putref(sma, sem_rcu_free);
 				return -ENOMEM;
 			}
 
@@ -1415,20 +1415,20 @@ static int semctl_main(struct ipc_namesp
 		if (nsems > SEMMSL_FAST) {
 			sem_io = ipc_alloc(sizeof(ushort)*nsems);
 			if (sem_io == NULL) {
-				ipc_rcu_putref(sma, ipc_rcu_free);
+				ipc_rcu_putref(sma, sem_rcu_free);
 				return -ENOMEM;
 			}
 		}
 
 		if (copy_from_user(sem_io, p, nsems*sizeof(ushort))) {
-			ipc_rcu_putref(sma, ipc_rcu_free);
+			ipc_rcu_putref(sma, sem_rcu_free);
 			err = -EFAULT;
 			goto out_free;
 		}
 
 		for (i = 0; i < nsems; i++) {
 			if (sem_io[i] > SEMVMX) {
-				ipc_rcu_putref(sma, ipc_rcu_free);
+				ipc_rcu_putref(sma, sem_rcu_free);
 				err = -ERANGE;
 				goto out_free;
 			}
@@ -1720,7 +1720,7 @@ static struct sem_undo *find_alloc_undo(
 	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
-		ipc_rcu_putref(sma, ipc_rcu_free);
+		ipc_rcu_putref(sma, sem_rcu_free);
 		return ERR_PTR(-ENOMEM);
 	}
 
_

Patches currently in -mm which might be from fabf@skynet.be are


