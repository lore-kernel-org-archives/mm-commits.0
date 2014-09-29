From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-do-not-get-resource-spinlock-if-lockres-is-new.patch removed from -mm tree
Date: Mon, 29 Sep 2014 13:22:25 -0700
Message-ID: <5429bf81.d05dre4VPHB9lqEG%akpm__37634.1821429834$1412022196$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaI2UWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 16:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, guozhonghua@h3c.com, jlbec@evilplan.org, mfasheh@suse.com, stable@vger.kernel.org, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: do not get resource spinlock if lockres is new
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-do-not-get-resource-spinlock-if-lockres-is-new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: do not get resource spinlock if lockres is new

There is a deadlock case which reported by Guozhonghua:
https://oss.oracle.com/pipermail/ocfs2-devel/2014-September/010079.html

This case is caused by &res->spinlock and &dlm->master_lock
misordering in different threads.

It was introduced by commit 8d400b81cc83 ("ocfs2/dlm: Clean up refmap
helpers").  Since lockres is new, it doesn't not require the
&res->spinlock.  So remove it.

Fixes: 8d400b81cc83 ("ocfs2/dlm: Clean up refmap helpers")
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
Reported-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-get-resource-spinlock-if-lockres-is-new fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-do-not-get-resource-spinlock-if-lockres-is-new
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -655,12 +655,9 @@ void dlm_lockres_clear_refmap_bit(struct
 	clear_bit(bit, res->refmap);
 }
 
-
-void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+static void __dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res)
 {
-	assert_spin_locked(&res->spinlock);
-
 	res->inflight_locks++;
 
 	mlog(0, "%s: res %.*s, inflight++: now %u, %ps()\n", dlm->name,
@@ -668,6 +665,13 @@ void dlm_lockres_grab_inflight_ref(struc
 	     __builtin_return_address(0));
 }
 
+void dlm_lockres_grab_inflight_ref(struct dlm_ctxt *dlm,
+				   struct dlm_lock_resource *res)
+{
+	assert_spin_locked(&res->spinlock);
+	__dlm_lockres_grab_inflight_ref(dlm, res);
+}
+
 void dlm_lockres_drop_inflight_ref(struct dlm_ctxt *dlm,
 				   struct dlm_lock_resource *res)
 {
@@ -894,10 +898,8 @@ lookup:
 	/* finally add the lockres to its hash bucket */
 	__dlm_insert_lockres(dlm, res);
 
-	/* Grab inflight ref to pin the resource */
-	spin_lock(&res->spinlock);
-	dlm_lockres_grab_inflight_ref(dlm, res);
-	spin_unlock(&res->spinlock);
+	/* since this lockres is new it doesn't not require the spinlock */
+	__dlm_lockres_grab_inflight_ref(dlm, res);
 
 	/* get an extra ref on the mle in case this is a BLOCK
 	 * if so, the creator of the BLOCK may try to put the last
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-should-put-mle-when-goto-kill-in-dlm_assert_master_handler.patch
ocfs2-dlm-refactor-error-handling-in-dlm_alloc_ctxt.patch
ocfs2-fix-shift-left-operations-overflow.patch
ocfs2-call-o2quo_exit-if-malloc-failed-in-o2net_init.patch
ocfs2-dlm-fix-race-between-dispatched_work-and-dlm_lockres_grab_inflight_worker.patch
ocfs2-fix-deadlock-between-o2hb-thread-and-o2net_wq.patch

