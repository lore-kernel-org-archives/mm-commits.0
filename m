From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:39 -0700
Message-ID: <55ef22bf.7TJbO5bwLn04RZUW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: avoid access invalid address when read o2dlm debug messages
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yiwen Jiang <jiangyiwen@huawei.com>
Subject: ocfs2: avoid access invalid address when read o2dlm debug messages

The following case will lead to a lockres is freed but is still in use.

cat /sys/kernel/debug/o2dlm/locking_state	dlm_thread
lockres_seq_start
    -> lock dlm->track_lock
    -> get resA
                                                resA->refs decrease to 0,
                                                call dlm_lockres_release,
                                                and wait for "cat" unlock.
Although resA->refs is already set to 0,
increase resA->refs, and then unlock
                                                lock dlm->track_lock
                                                    -> list_del_init()
                                                    -> unlock
                                                    -> free resA

In such a race case, invalid address access may occurs.  So we should
delete list res->tracking before resA->refs decrease to 0.


Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   22 +++++++++++-----------
 fs/ocfs2/dlm/dlmthread.c |   10 ++++++++++
 2 files changed, 21 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -498,16 +498,6 @@ static void dlm_lockres_release(struct k
 	mlog(0, "destroying lockres %.*s\n", res->lockname.len,
 	     res->lockname.name);
 
-	spin_lock(&dlm->track_lock);
-	if (!list_empty(&res->tracking))
-		list_del_init(&res->tracking);
-	else {
-		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
-		     res->lockname.len, res->lockname.name);
-		dlm_print_one_lock_resource(res);
-	}
-	spin_unlock(&dlm->track_lock);
-
 	atomic_dec(&dlm->res_cur_count);
 
 	if (!hlist_unhashed(&res->hash_node) ||
@@ -795,8 +785,18 @@ lookup:
 		dlm_lockres_grab_inflight_ref(dlm, tmpres);
 
 		spin_unlock(&tmpres->spinlock);
-		if (res)
+		if (res) {
+			spin_lock(&dlm->track_lock);
+			if (!list_empty(&res->tracking))
+				list_del_init(&res->tracking);
+			else
+				mlog(ML_ERROR, "Resource %.*s not "
+						"on the Tracking list\n",
+						res->lockname.len,
+						res->lockname.name);
+			spin_unlock(&dlm->track_lock);
 			dlm_lockres_put(res);
+		}
 		res = tmpres;
 		goto leave;
 	}
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -211,6 +211,16 @@ static void dlm_purge_lockres(struct dlm
 
 	__dlm_unhash_lockres(dlm, res);
 
+	spin_lock(&dlm->track_lock);
+	if (!list_empty(&res->tracking))
+		list_del_init(&res->tracking);
+	else {
+		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
+				res->lockname.len, res->lockname.name);
+		__dlm_print_one_lock_resource(res);
+	}
+	spin_unlock(&dlm->track_lock);
+
 	/* lockres is not in the hash now.  drop the flag and wake up
 	 * any processes waiting in dlm_get_lock_resource. */
 	if (!master) {
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are


