From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch added to -mm tree
Date: Tue, 26 Jan 2016 13:21:12 -0800
Message-ID: <56a7e348.v4/THKqkz8PWS+7Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcAZVVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:21:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return EINVAL when the lockres on migration target is in DROPPING_REF state
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Joseph Qi <joseph.qi@huawei.com>
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
ocfs2-dlm-add-deref_done-message.patch
ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch
ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch
ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch

