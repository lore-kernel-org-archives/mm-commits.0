From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:23:04 -0800
Message-ID: <58519c18.vJDx0VNeZ0CDdfZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756499AbcLNTXF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:23:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clean up useless BUG_ON default case in dlm_finalize_reco_handler()
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: clean up useless BUG_ON default case in dlm_finalize_reco_handler()

The value of 'stage' must be between 1 and 2, so the switch can't reach
the default case.

Link: http://lkml.kernel.org/r/57FB5EB2.7050002@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2966,8 +2966,6 @@ int dlm_finalize_reco_handler(struct o2n
 			spin_unlock(&dlm->spinlock);
 			dlm_kick_recovery_thread(dlm);
 			break;
-		default:
-			BUG();
 	}
 
 	mlog(0, "%s: recovery done, reco master was %u, dead now %u, master now %u\n",
_

Patches currently in -mm which might be from piaojun@huawei.com are


