From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-unlock-lockres-spinlock-before-dlm_lockres_put.patch removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:50 -0700
Message-ID: <5633c8b2.aNvjGTO9rrjyTN3z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbbJ3Tou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: unlock lockres spinlock before dlm_lockres_put
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-unlock-lockres-spinlock-before-dlm_lockres_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: unlock lockres spinlock before dlm_lockres_put

dlm_lockres_put will call dlm_lockres_release if it is the last reference,
and then it may call dlm_print_one_lock_resource and take lockres
spinlock.

So unlock lockres spinlock before dlm_lockres_put to avoid deadlock.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c   |    3 ++-
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-unlock-lockres-spinlock-before-dlm_lockres_put fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-unlock-lockres-spinlock-before-dlm_lockres_put
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -1658,12 +1658,13 @@ send_response:
 		if (ret < 0) {
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
+			spin_unlock(&res->spinlock);
 			dlm_lockres_put(res);
 		} else {
 			dispatched = 1;
 			__dlm_lockres_grab_inflight_worker(dlm, res);
+			spin_unlock(&res->spinlock);
 		}
-		spin_unlock(&res->spinlock);
 	} else {
 		if (res)
 			dlm_lockres_put(res);
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-unlock-lockres-spinlock-before-dlm_lockres_put fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-unlock-lockres-spinlock-before-dlm_lockres_put
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1723,8 +1723,8 @@ int dlm_master_requery_handler(struct o2
 			} else {
 				dispatched = 1;
 				__dlm_lockres_grab_inflight_worker(dlm, res);
+				spin_unlock(&res->spinlock);
 			}
-			spin_unlock(&res->spinlock);
 		} else {
 			/* put.. incase we are not the master */
 			spin_unlock(&res->spinlock);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-improve-performance-for-localalloc.patch
ocfs2-do-not-include-dio-entry-in-case-of-orphan-scan.patch
ocfs2-only-take-lock-if-dio-entry-when-recover-orphans.patch
ocfs2-fix-race-between-mount-and-delete-node-cluster.patch
ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

