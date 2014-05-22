From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch added to -mm tree
Date: Thu, 22 May 2014 12:07:51 -0700
Message-ID: <537e4b07.JoHRQQoZGbaI7HO7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaEVTHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 15:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 12:07:51 -0700


The patch titled
     Subject: ocfs2/dlm: do not purge lockres that is queued for assert master
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: do not purge lockres that is queued for assert master

When workqueue is delayed, it may occur that a lockres is purged while it
is still queued for master assert.  it may trigger BUG() as follows.

N1                                         N2
dlm_get_lockres()
->dlm_do_master_requery
                                  is the master of lockres,
                                  so queue assert_master work

                                  dlm_thread() start running
                                  and purge the lockres

                                  dlm_assert_master_worker()
                                  send assert master message
                                  to other nodes
receiving the assert_master
message, set master to N2

dlmlock_remote() send create_lock message to N2, but receive DLM_IVLOCKID,
if it is RECOVERY lockres, it triggers the BUG().

Another BUG() is triggered when N3 become the new master and send
assert_master to N1, N1 will trigger the BUG() because owner doesn't
match.  So we should not purge lockres when it is queued for assert
master.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h   |    4 +++
 fs/ocfs2/dlm/dlmmaster.c   |   43 ++++++++++++++++++++++++++++++++++-
 fs/ocfs2/dlm/dlmrecovery.c |    3 +-
 fs/ocfs2/dlm/dlmthread.c   |   11 +++++---
 4 files changed, 55 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -332,6 +332,7 @@ struct dlm_lock_resource
 	u16 state;
 	char lvb[DLM_LVB_LEN];
 	unsigned int inflight_locks;
+	unsigned int inflight_assert_workers;
 	unsigned long refmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 };
 
@@ -911,6 +912,9 @@ void dlm_lockres_drop_inflight_ref(struc
 void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res);
 
+void __dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res);
+
 void dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void dlm_queue_bast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
 void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock);
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -581,6 +581,7 @@ static void dlm_init_lockres(struct dlm_
 	atomic_set(&res->asts_reserved, 0);
 	res->migration_pending = 0;
 	res->inflight_locks = 0;
+	res->inflight_assert_workers = 0;
 
 	res->dlm = dlm;
 
@@ -683,6 +684,43 @@ void dlm_lockres_drop_inflight_ref(struc
 	wake_up(&res->wq);
 }
 
+void __dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	res->inflight_assert_workers++;
+	mlog(0, "%s:%.*s: inflight assert worker++: now %u\n",
+			dlm->name, res->lockname.len, res->lockname.name,
+			res->inflight_assert_workers);
+}
+
+void dlm_lockres_grab_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	spin_lock(&res->spinlock);
+	__dlm_lockres_grab_inflight_worker(dlm, res);
+	spin_unlock(&res->spinlock);
+}
+
+void __dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	BUG_ON(res->inflight_assert_workers == 0);
+	res->inflight_assert_workers--;
+	mlog(0, "%s:%.*s: inflight assert worker--: now %u\n",
+			dlm->name, res->lockname.len, res->lockname.name,
+			res->inflight_assert_workers);
+}
+
+void dlm_lockres_drop_inflight_worker(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res)
+{
+	spin_lock(&res->spinlock);
+	__dlm_lockres_drop_inflight_worker(dlm, res);
+	spin_unlock(&res->spinlock);
+}
+
 /*
  * lookup a lock resource by name.
  * may already exist in the hashtable.
@@ -1603,7 +1641,8 @@ send_response:
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
 			dlm_lockres_put(res);
-		}
+		} else
+			dlm_lockres_grab_inflight_worker(dlm, res);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
@@ -2118,6 +2157,8 @@ static void dlm_assert_master_worker(str
 	dlm_lockres_release_ast(dlm, res);
 
 put:
+	dlm_lockres_drop_inflight_worker(dlm, res);
+
 	dlm_lockres_put(res);
 
 	mlog(0, "finished with dlm_assert_master_worker\n");
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1708,7 +1708,8 @@ int dlm_master_requery_handler(struct o2
 				mlog_errno(-ENOMEM);
 				/* retry!? */
 				BUG();
-			}
+			} else
+				__dlm_lockres_grab_inflight_worker(dlm, res);
 		} else /* put.. incase we are not the master */
 			dlm_lockres_put(res);
 		spin_unlock(&res->spinlock);
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -259,11 +259,14 @@ static void dlm_run_purge_list(struct dl
 		 * refs on it. */
 		unused = __dlm_lockres_unused(lockres);
 		if (!unused ||
-		    (lockres->state & DLM_LOCK_RES_MIGRATING)) {
+		    (lockres->state & DLM_LOCK_RES_MIGRATING) ||
+		    (lockres->inflight_assert_workers != 0)) {
 			mlog(0, "%s: res %.*s is in use or being remastered, "
-			     "used %d, state %d\n", dlm->name,
-			     lockres->lockname.len, lockres->lockname.name,
-			     !unused, lockres->state);
+			     "used %d, state %d, assert master workers %u\n",
+			     dlm->name, lockres->lockname.len,
+			     lockres->lockname.name,
+			     !unused, lockres->state,
+			     lockres->inflight_assert_workers);
 			list_move_tail(&dlm->purge_list, &lockres->purge);
 			spin_unlock(&lockres->spinlock);
 			continue;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-fix-possible-convertion-deadlock.patch
ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch
ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

