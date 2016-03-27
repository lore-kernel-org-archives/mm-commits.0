From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch removed from -mm tree
Date: Sat, 26 Mar 2016 20:31:00 -0700
Message-ID: <56f753f4.QzLwa6FLI4peCGz1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0DbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:31:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: move lock to the tail of grant queue while doing in-place convert
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Acked-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
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
+	 * Move the lock to the tail because it may be the only lock which has
+	 * an invalid lvb.
+	 */
+	list_move_tail(&lock->list, &res->granted);
+
 	status = DLM_NORMAL;
 	*call_ast = 1;
 	goto unlock_exit;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are


