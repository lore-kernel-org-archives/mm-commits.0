From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
 added to -mm tree
Date: Tue, 28 Apr 2015 13:33:54 -0700
Message-ID: <553feeb2.WS83qwuhQDD3dX3R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbbD1Udz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 16:33:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix race between purge and get lock resource
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: fix race between purge and get lock resource

There is a race between purge and get lock resource, which will lead to
ast unfinished and system hung.  The case is described below:

mkdir                                  dlm_thread
-----------------------------------------------------------------------
o2cb_dlm_lock                        |
-> dlmlock                           |
  -> dlm_get_lock_resource           |
    -> __dlm_lookup_lockres_full     |
      -> spin_unlock(&dlm->spinlock) |
                                     | dlm_run_purge_list
                                     | -> dlm_purge_lockres
                                     |   -> dlm_drop_lockres_ref
                                     |   -> spin_lock(&dlm->spinlock)
                                     |   -> spin_lock(&res->spinlock)
                                     |   -> ~DLM_LOCK_RES_DROPPING_REF
                                     |   -> spin_unlock(&res->spinlock)
                                     |   -> spin_unlock(&dlm->spinlock)
      -> spin_lock(&tmpres->spinlock)|
      DLM_LOCK_RES_DROPPING_REF cleared |
      -> spin_unlock(&tmpres->spinlock) |
      return the purged lockres         |

So after this, once ast comes, it will ingore the ast because the lockres
cannot be found anymore.  Thus the OCFS2_LOCK_BUSY won't be cleared and
corresponding thread hangs.

The &dlm->spinlock was held when checking DLM_LOCK_RES_DROPPING_REF at the
very begining.  And commit 7b791d6856 ("ocfs2/dlm: Fix race during lockres
mastery") moved it up because of the possible wait.  So take the
&dlm->spinlock and introduce a new wait function to fix the race.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    2 ++
 fs/ocfs2/dlm/dlmmaster.c |   13 +++++++++----
 fs/ocfs2/dlm/dlmthread.c |   23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -1014,6 +1014,8 @@ void dlm_move_lockres_to_recovery_list(s
 
 /* will exit holding res->spinlock, but may drop in function */
 void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags);
+void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res, int flags);
 
 /* will exit holding res->spinlock, but may drop in function */
 static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -755,13 +755,16 @@ lookup:
 	spin_lock(&dlm->spinlock);
 	tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
 	if (tmpres) {
-		spin_unlock(&dlm->spinlock);
 		spin_lock(&tmpres->spinlock);
 		/* Wait on the thread that is mastering the resource */
 		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
-			__dlm_wait_on_lockres(tmpres);
+			__dlm_wait_on_lockres_flags_new(dlm, tmpres,
+					(DLM_LOCK_RES_IN_PROGRESS|
+					DLM_LOCK_RES_RECOVERING|
+					DLM_LOCK_RES_MIGRATING));
 			BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
 			spin_unlock(&tmpres->spinlock);
+			spin_unlock(&dlm->spinlock);
 			dlm_lockres_put(tmpres);
 			tmpres = NULL;
 			goto lookup;
@@ -770,9 +773,10 @@ lookup:
 		/* Wait on the resource purge to complete before continuing */
 		if (tmpres->state & DLM_LOCK_RES_DROPPING_REF) {
 			BUG_ON(tmpres->owner == dlm->node_num);
-			__dlm_wait_on_lockres_flags(tmpres,
-						    DLM_LOCK_RES_DROPPING_REF);
+			__dlm_wait_on_lockres_flags_new(dlm, tmpres,
+				DLM_LOCK_RES_DROPPING_REF);
 			spin_unlock(&tmpres->spinlock);
+			spin_unlock(&dlm->spinlock);
 			dlm_lockres_put(tmpres);
 			tmpres = NULL;
 			goto lookup;
@@ -782,6 +786,7 @@ lookup:
 		dlm_lockres_grab_inflight_ref(dlm, tmpres);
 
 		spin_unlock(&tmpres->spinlock);
+		spin_unlock(&dlm->spinlock);
 		if (res)
 			dlm_lockres_put(res);
 		res = tmpres;
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -77,6 +77,29 @@ repeat:
 	__set_current_state(TASK_RUNNING);
 }
 
+void __dlm_wait_on_lockres_flags_new(struct dlm_ctxt *dlm,
+		struct dlm_lock_resource *res, int flags)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	assert_spin_locked(&dlm->spinlock);
+	assert_spin_locked(&res->spinlock);
+
+	add_wait_queue(&res->wq, &wait);
+repeat:
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	if (res->state & flags) {
+		spin_unlock(&res->spinlock);
+		spin_unlock(&dlm->spinlock);
+		schedule();
+		spin_lock(&dlm->spinlock);
+		spin_lock(&res->spinlock);
+		goto repeat;
+	}
+	remove_wait_queue(&res->wq, &wait);
+	__set_current_state(TASK_RUNNING);
+}
+
 int __dlm_lockres_has_locks(struct dlm_lock_resource *res)
 {
 	if (list_empty(&res->granted) &&
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

