From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch added to -mm tree
Date: Wed, 27 Jan 2016 12:07:29 -0800
Message-ID: <56a92381.+XxDJUiCAFxSipJB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965614AbcA0UHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:07:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: move lock to the tail of grant queue while doing in-place convert
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

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
Subject: ocfs2/dlm: move lock to the tail of grant queue while doing in-place convert

We have found a bug when two nodes doing umount one after another.

1) Node 1 migrate a lockres that has 3 locks in grant queue such as
   N2(PR)<->N3(NL)<->N4(PR) to N2.  After migration, lvb of the lock
   N3(NL) and N4(PR) are empty on node 2 because migration target do not
   copy lvb to these two lock.

2) Node 3 want to convert to PR, it can be granted in
   __dlmconvert_master(), and the order of these locks is unchanged.  The
   lvb of the lock N3(PR) on node 2 is copyed from lockres in function
   dlm_update_lvb() while the lvb of lock N4(PR) is still empty.

3) Node 2 want to leave domain, it will migrate this lockres to node 3.
   Then node 2 will trigger the BUG in dlm_prepare_lvb_for_migration()
   when adding the lock N4(PR) to mres with the following message because
   the lvb of mres is already copied from lock N3(PR), but the lvb of lock
   N4(PR) is empty.

"Mismatched lvb in lock cookie=%u:%llu, name=%.*s, node=%u"

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -212,6 +212,12 @@ grant:
 	if (lock->lksb->flags & DLM_LKSB_PUT_LVB)
 		memcpy(res->lvb, lock->lksb->lvb, DLM_LVB_LEN);
 
+	/*
+	 * move the lock to tail because it may be the only lock who has
+	 * a invalid lvb.
+	 */
+	list_move_tail(&lock->list, &res->granted);
+
 	status = DLM_NORMAL;
 	*call_ast = 1;
 	goto unlock_exit;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-add-deref_done-message.patch
ocfs2-dlm-return-in-progress-if-master-can-not-clear-the-refmap-bit-right-now.patch
ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch
ocfs2-dlm-return-einval-when-the-lockres-on-migration-target-is-in-dropping_ref-state.patch
ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

