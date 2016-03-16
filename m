From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:53:17 -0700
Message-ID: <56e9b9ad.jUO7NjseMEitmuON%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return EINVAL when the lockres on migration target is in DROPPING_REF state
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: return EINVAL when the lockres on migration target is in DROPPING_REF state

If master migrate this lock resource to node when it happened to purge it,
a new lock resource will be created and inserted into hash list.  If then
master goes down, the lock resource being purged is recovered, so there
exist two lock resource with different owner.  So return error to master
if the lock resource is in DROPPING state, master will retry to migrate
this lock resource.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1403,12 +1403,24 @@ int dlm_mig_lockres_handler(struct o2net
 	 * and RECOVERY flag changed when it completes. */
 	hash = dlm_lockid_hash(mres->lockname, mres->lockname_len);
 	spin_lock(&dlm->spinlock);
-	res = __dlm_lookup_lockres(dlm, mres->lockname, mres->lockname_len,
+	res = __dlm_lookup_lockres_full(dlm, mres->lockname, mres->lockname_len,
 			hash);
 	if (res) {
 	 	/* this will get a ref on res */
 		/* mark it as recovering/migrating and hash it */
 		spin_lock(&res->spinlock);
+		if (res->state & DLM_LOCK_RES_DROPPING_REF) {
+			mlog(0, "%s: node is attempting to migrate "
+				"lockres %.*s, but marked as dropping "
+				" ref!\n", dlm->name,
+				mres->lockname_len, mres->lockname);
+			ret = -EINVAL;
+			spin_unlock(&res->spinlock);
+			spin_unlock(&dlm->spinlock);
+			dlm_lockres_put(res);
+			goto leave;
+		}
+
 		if (mres->flags & DLM_MRES_RECOVERY) {
 			res->state |= DLM_LOCK_RES_RECOVERING;
 		} else {
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

