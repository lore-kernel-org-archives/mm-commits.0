From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch added to
 -mm tree
Date: Tue, 26 Jan 2016 13:21:10 -0800
Message-ID: <56a7e346.4+XZLJQPntDgo1Fk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcAZVVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 16:21:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clear DROPPING_REF flag when the master goes down
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down.patch

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
Subject: ocfs2/dlm: clear DROPPING_REF flag when the master goes down

If the master goes down after return in-progress for deref message.  The
lock resource on non-master node can not be purged.  Clear the
DROPPING_REF flag and recovery it.

Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clear-dropping_ref-flag-when-the-master-goes-down
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2374,14 +2374,16 @@ static void dlm_do_local_recovery_cleanu
 			dlm_revalidate_lvb(dlm, res, dead_node);
 			if (res->owner == dead_node) {
 				if (res->state & DLM_LOCK_RES_DROPPING_REF) {
-					mlog(ML_NOTICE, "%s: res %.*s, Skip "
-					     "recovery as it is being freed\n",
-					     dlm->name, res->lockname.len,
-					     res->lockname.name);
-				} else
-					dlm_move_lockres_to_recovery_list(dlm,
-									  res);
