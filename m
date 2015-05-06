From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch removed from
 -mm tree
Date: Wed, 06 May 2015 11:58:34 -0700
Message-ID: <554a645a.Wii1S5u2Os8PdNoj%akpm__26513.4933325045$1430938732$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbEFS6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dlm: fix race between purge and get lock resource
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-race-between-purge-and-get-lock-resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

