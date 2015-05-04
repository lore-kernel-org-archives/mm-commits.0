From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch
 added to -mm tree
Date: Mon, 04 May 2015 14:12:03 -0700
Message-ID: <5547e0a3.uBQmv68bvsBKvcka%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbbEDVME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 17:12:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dlm: fix race between purge and get lock resource
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
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: dlm: fix race between purge and get lock resource

There is a race window in dlm_get_lock_resource(), which may return a lock
resource which has been purged.  This will cause the process to hang
forever in dlmlock() as the ast msg can't be handled due to its lock
resource not existing.

dlm_get_lock_resource {
	...
	spin_lock(&dlm->spinlock);
	tmpres = __dlm_lookup_lockres_full(dlm, lockid, namelen, hash);
	if (tmpres) {
		spin_unlock(&dlm->spinlock);
		>>>>>>>> race window, dlm_run_purge_list() may run and purge
				 the lock resource
		spin_lock(&tmpres->spinlock);
		...
		spin_unlock(&tmpres->spinlock);
	}
}

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-fix-race-between-purge-and-get-lock-resource
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -757,6 +757,19 @@ lookup:
 	if (tmpres) {
 		spin_unlock(&dlm->spinlock);
 		spin_lock(&tmpres->spinlock);
+
+		/*
+		 * Right after dlm spinlock was released, dlm_thread could have
+		 * purged the lockres. Check if lockres got unhashed. If so
+		 * start over.
+		 */
+		if (hlist_unhashed(&tmpres->hash_node)) {
+			spin_unlock(&tmpres->spinlock);
+			dlm_lockres_put(tmpres);
+			tmpres = NULL;
+			goto lookup;
+		}
+
 		/* Wait on the thread that is mastering the resource */
 		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
 			__dlm_wait_on_lockres(tmpres);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch

