From: akpm@linux-foundation.org
Subject: + ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch added to -mm tree
Date: Mon, 03 Jun 2013 14:49:09 -0700
Message-ID: <51ad0f55.roka+2syt9euy3GB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3FCVtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 17:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: + ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch added to -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 14:49:09 -0700


The patch titled
     Subject: ocfs2: add missing dlm_put() in dlm_begin_reco_handler()
has been added to the -mm tree.  Its filename is
     ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch

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
Subject: ocfs2: add missing dlm_put() in dlm_begin_reco_handler()

dlm_begin_reco_handler() returns without putting dlm when dlm recovery
state is DLM_RECO_STATE_FINALIZE.

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2698,6 +2698,7 @@ int dlm_begin_reco_handler(struct o2net_
 		     dlm->name, br->node_idx, br->dead_node,
 		     dlm->reco.dead_node, dlm->reco.new_master);
 		spin_unlock(&dlm->spinlock);
+		dlm_put(dlm);
 		return -EAGAIN;
 	}
 	spin_unlock(&dlm->spinlock);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

linux-next.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch

