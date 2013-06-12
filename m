From: akpm@linux-foundation.org
Subject: +
 ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid.patch
 added to -mm tree
Date: Wed, 12 Jun 2013 15:48:30 -0700
Message-ID: <51b8fabe.F8OTgHHkWYVM/Pym%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab3FLWsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jun 2013 18:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, fengguang.wu@intel.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,fengguang.wu@intel.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 12 Jun 2013 15:48:30 -0700


The patch titled
     Subject: ipc: restore rcu locking in ipc_addid
has been added to the -mm tree.  Its filename is
     ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: restore rcu locking in ipc_addid

Fengguang reported the following trinity triggered issue:

[   51.524946]
[   51.525983] ===============================
[   51.532875] [ INFO: suspicious RCU usage. ]
[   51.535385] 3.10.0-rc4-next-20130606 #6 Not tainted
[   51.538304] -------------------------------
[   51.540937] /c/kernel-tests/src/stable/include/linux/rcupdate.h:471 Illegal context switch in RCU read-side critical section!
[   51.548110]
[   51.548110] other info that might help us debug this:
[   51.548110]
[   51.553055]
[   51.553055] rcu_scheduler_active = 1, debug_locks = 1
[   51.557199] 2 locks held by trinity/1107:
[   51.560168]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e15ee>] ipcget+0x38/0x2b3
[   51.566465]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e7698>] newseg+0x19d/0x3fd
[   51.572413]
[   51.572413] stack backtrace:
[   51.574761] CPU: 0 PID: 1107 Comm: trinity Not tainted 3.10.0-rc4-next-20130606 #6
[   51.579331] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   51.583068]  0000000000000001 ffff880004a07d88 ffffffff817b1f5c ffff880004a07db8
[   51.592119]  ffffffff810f2f1d ffffffff81b78569 00000000000001a8 0000000000000000
[   51.596726]  0000000000000000 ffff880004a07de8 ffffffff810ded5e ffff880004a07fd8
[   51.605189] Call Trace:
[   51.606409]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[   51.609632]  [<ffffffff810f2f1d>] lockdep_rcu_suspicious+0xeb/0xf4
[   51.612905]  [<ffffffff810ded5e>] __might_sleep+0x59/0x1dc
[   51.618614]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[   51.621939]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[   51.624373]  [<ffffffff811e771c>] newseg+0x221/0x3fd
[   51.626596]  [<ffffffff811e7698>] ? newseg+0x19d/0x3fd
[   51.630177]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[   51.633174]  [<ffffffff817bc094>] ? retint_swapgs+0x13/0x1b
[   51.636356]  [<ffffffff811e7a5a>] SyS_shmget+0x59/0x5d
[   51.639576]  [<ffffffff811e74fb>] ? shm_try_destroy_orphaned+0xbf/0xbf
[   51.643673]  [<ffffffff811e6ce5>] ? shm_get_unmapped_area+0x20/0x20
[   51.647321]  [<ffffffff811e6cf0>] ? shm_security+0xb/0xb
[   51.650831]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b

The issue was caused because we were allocating memory in GFP_KERNEL
context after calling rcu_read_lock.  This patch restores the
rcu_read_lock call into ipc_addid() and thus maintains the original
behavior.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    2 --
 ipc/sem.c  |    2 --
 ipc/shm.c  |    2 --
 ipc/util.c |    3 ++-
 4 files changed, 2 insertions(+), 7 deletions(-)

diff -puN ipc/msg.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid ipc/msg.c
--- a/ipc/msg.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid
+++ a/ipc/msg.c
@@ -200,10 +200,8 @@ static int newque(struct ipc_namespace *
 	}
 
 	/* ipc_addid() locks msq upon success. */
-	rcu_read_lock();
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
-		rcu_read_unlock();
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
 		return id;
diff -puN ipc/sem.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid ipc/sem.c
--- a/ipc/sem.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid
+++ a/ipc/sem.c
@@ -407,10 +407,8 @@ static int newary(struct ipc_namespace *
 		return retval;
 	}
 
-	rcu_read_lock();
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
-		rcu_read_unlock();
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
 		return id;
diff -puN ipc/shm.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid ipc/shm.c
--- a/ipc/shm.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid
+++ a/ipc/shm.c
@@ -521,11 +521,9 @@ static int newseg(struct ipc_namespace *
 	if (IS_ERR(file))
 		goto no_file;
 
-	rcu_read_lock();
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
 		error = id;
-		rcu_read_unlock();
 		goto no_id;
 	}
 
diff -puN ipc/util.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid ipc/util.c
--- a/ipc/util.c~ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid
+++ a/ipc/util.c
@@ -246,7 +246,7 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and a negative err-code is returned.
  *
- *	Called with RCU read lock and writer ipc_ids.rw_mutex held.
+ *	Called with writer ipc_ids.rw_mutex held.
  */
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
@@ -265,6 +265,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
+	rcu_read_lock();
 	spin_lock(&new->lock);
 
 	id = idr_alloc(&ids->ipcs_idr, new,
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
softirq-use-_ret_ip_.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipc-remove-unused-functions.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
ipc-semc-cacheline-align-the-semaphore-structures.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch
ipc-semc-always-use-only-one-queue-for-alter-operations.patch
ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch
ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch

