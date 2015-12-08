From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 13:16:52 -0800
Message-ID: <566748c4.Ho1xYcfBrYkaJm5o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbLHVQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 16:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: fix a race between purge and migratio
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch

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
Subject: ocfs2/dlm: fix a race between purge and migratio

We found a race between purge and migration when doing code review.  Node
A put lockres to purgelist before receiving the migrate message from node
B which is the master.  dlm_mig_lockres_handler finds the lockres and
releases the dlm spinlock.  Then dlm_thread on node A can purge the
lockres.  dlm_mig_lockres_handler then gets the lockres spinlock and sends
assert master message to tell other nodes that node A is the master now
even lockres is purged.  If node C set the master to node A, and another
node D master the lockres because no node respond he is the master.  That
will make node C crash when node D send assert master to node C.  So check
if lockres gets unhashed in dlm_mig_lockres_handler to fix this race.

Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-a-race-between-purge-and-migratio fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-fix-a-race-between-purge-and-migratio
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1400,11 +1400,33 @@ int dlm_mig_lockres_handler(struct o2net
 	/* lookup the lock to see if we have a secondary queue for this
 	 * already...  just add the locks in and this will have its owner
 	 * and RECOVERY flag changed when it completes. */
+way_up_top:
 	res = dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len);
 	if (res) {
 	 	/* this will get a ref on res */
 		/* mark it as recovering/migrating and hash it */
 		spin_lock(&res->spinlock);
+
+		/*
+		 * Right after dlm spinlock was released, dlm_thread could have
+		 * purged the lockres. Check if lockres got unhashed. If so
+		 * start over.
+		 */
+		if (hlist_unhashed(&res->hash_node)) {
+			spin_unlock(&res->spinlock);
+			dlm_lockres_put(res);
+			goto way_up_top;
+		}
+
+		/* Wait on the resource purge to complete before continuing */
+		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+			__dlm_wait_on_lockres_flags(res,
+					DLM_LOCK_RES_DROPPING_REF);
+			spin_unlock(&res->spinlock);
+			dlm_lockres_put(res);
+			goto way_up_top;
+		}
+
 		if (mres->flags & DLM_MRES_RECOVERY) {
 			res->state |= DLM_LOCK_RES_RECOVERING;
 		} else {
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-fix-a-race-between-purge-and-migratio.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch

