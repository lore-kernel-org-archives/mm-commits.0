From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:22:27 -0700
Message-ID: <57fe8d73.ub0qo901nXVPqqkP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755899AbcJLTXl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, zren@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix memory leak in dlm_migrate_request_handler()
has been removed from the -mm tree.  Its filename was
     ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: fix memory leak in dlm_migrate_request_handler()

In the dlm_migrate_request_handler(), when `ret' is -EEXIST, the mle
should be freed, otherwise the memory will be leaked.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Reviewed-by: Mark Fasheh <mfasheh@versity.com>
Cc: Eric Ren <zren@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -3188,6 +3188,9 @@ int dlm_migrate_request_handler(struct o
 				    migrate->new_master,
 				    migrate->master);
 
+	if (ret < 0)
+		kmem_cache_free(dlm_mle_cache, mle);
+
 	spin_unlock(&dlm->master_lock);
 unlock:
 	spin_unlock(&dlm->spinlock);
_

Patches currently in -mm which might be from guozhonghua@h3c.com are


