From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:23:06 -0700
Message-ID: <51db119a.maSo+5+6yAcZzEkV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, xuejiufei@huawei.com

Subject: [merged] ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch removed from -mm tree
To: xuejiufei@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:06 -0700


The patch titled
     Subject: ocfs2: add missing dlm_put() in dlm_begin_reco_handler()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: add missing dlm_put() in dlm_begin_reco_handler()

dlm_begin_reco_handler() returns without putting dlm when dlm recovery
state is DLM_RECO_STATE_FINALIZE.

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2692,6 +2692,7 @@ int dlm_begin_reco_handler(struct o2net_
 		     dlm->name, br->node_idx, br->dead_node,
 		     dlm->reco.dead_node, dlm->reco.new_master);
 		spin_unlock(&dlm->spinlock);
+		dlm_put(dlm);
 		return -EAGAIN;
 	}
 	spin_unlock(&dlm->spinlock);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
linux-next.patch

