From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch added to -mm tree
Date: Wed, 19 Oct 2016 13:03:13 -0700
Message-ID: <5807d181.wvP34WFvDD4ALnrj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761351AbcJSUDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 16:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: clean up useless BUG_ON default case in dlm_finalize_reco_handler()
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/dlm: clean up useless BUG_ON default case in dlm_finalize_reco_handler()

The value of 'stage' must be between 1 and 2, so the switch can't reach
the default case.

Link: http://lkml.kernel.org/r/57FB5EB2.7050002@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
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

ocfs2-dlm-clean-up-useless-bug_on-default-case-in-dlm_finalize_reco_handler.patch

