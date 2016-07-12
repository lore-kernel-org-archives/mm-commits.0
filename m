From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch added to -mm tree
Date: Tue, 12 Jul 2016 13:50:47 -0700
Message-ID: <57855827.+ee7LxnBY3xaqrck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbcGLUus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 16:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: solve a BUG when deref failed in dlm_drop_lockres_ref
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: solve a BUG when deref failed in dlm_drop_lockres_ref

We found a BUG situation that lockres is migrated during deref described
below.  To solve the BUG, we could purge lockres directly when other node
says I did not have a ref.  Additionally, we'd better purge lockres if
master goes down, as no one will response deref done.

Node 1                  Node 2(old master)             Node3(new master)
dlm_purge_lockres
send deref to N2

                        leave domain
                        migrate lockres to N3
                                                       finish migration
                                                       send do assert
                                                       master to N1

receive do assert msg
form N3, but can not
find lockres because
DROPPING_REF is set,
so the owner is still
N2.

                        receive deref from N1
                        and response -EINVAL
                        because lockres is migrated

BUG when receive -EINVAL
in dlm_drop_lockres_ref

Fixes: 842b90b62461d ("ocfs2/dlm: return in progress if master can not clear the refmap bit right now")

Link: http://lkml.kernel.org/r/57845103.3070406@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jiufei Xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    9 ++++++---
 fs/ocfs2/dlm/dlmthread.c |   13 +++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2276,9 +2276,12 @@ int dlm_drop_lockres_ref(struct dlm_ctxt
 		mlog(ML_ERROR, "%s: res %.*s, DEREF to node %u got %d\n",
 		     dlm->name, namelen, lockname, res->owner, r);
 		dlm_print_one_lock_resource(res);
-		BUG();
-	}
-	return ret ? ret : r;
+		if (r == -ENOMEM)
+			BUG();
+	} else
+		ret = r;
+
+	return ret;
 }
 
 int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -175,6 +175,15 @@ static void dlm_purge_lockres(struct dlm
 	     res->lockname.len, res->lockname.name, master);
 
 	if (!master) {
+		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+			mlog(ML_NOTICE, "%s: res %.*s already in "
+				"DLM_LOCK_RES_DROPPING_REF state\n",
+				dlm->name, res->lockname.len,
+				res->lockname.name);
+			spin_unlock(&res->spinlock);
+			return;
+		}
+
 		res->state |= DLM_LOCK_RES_DROPPING_REF;
 		/* drop spinlock...  retake below */
 		spin_unlock(&res->spinlock);
@@ -203,8 +212,8 @@ static void dlm_purge_lockres(struct dlm
 		dlm->purge_count--;
 	}
 
-	if (!master && ret != 0) {
-		mlog(0, "%s: deref %.*s in progress or master goes down\n",
+	if (!master && ret == DLM_DEREF_RESPONSE_INPROG) {
+		mlog(0, "%s: deref %.*s in progress\n",
 			dlm->name, res->lockname.len, res->lockname.name);
 		spin_unlock(&res->spinlock);
 		return;
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch
ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch
ocfs2-dlm-continue-to-purge-recovery-lockres-when-recovery-master-goes-down.patch

