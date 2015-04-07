From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch
 removed from -mm tree
Date: Tue, 07 Apr 2015 14:51:46 -0700
Message-ID: <55245172.m21n+WhFPOnbcyvE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbDGVvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2015 17:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

This patch was dropped because it was folded into ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3

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

In such a race case, invalid address access may occurs.
So we should delete list res->tracking before resA->refs decrease to 0.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3 fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -772,8 +772,19 @@ lookup:
 		dlm_lockres_grab_inflight_ref(dlm, tmpres);
 
 		spin_unlock(&tmpres->spinlock);
-		if (res)
+		if (res) {
+			spin_lock(&dlm->track_lock);
+			if (!list_empty(&res->tracking))
+				list_del_init(&res->tracking);
+			else {
+				mlog(ML_ERROR, "Resource %.*s not "
+						"on the Tracking list\n",
+						res->lockname.len,
+						res->lockname.name);
+			}
+			spin_unlock(&dlm->track_lock);
 			dlm_lockres_put(res);
+		}
 		res = tmpres;
 		goto leave;
 	}
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-use-actual-name-length-when-find-entry-in-ocfs2_orphan_del.patch
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

