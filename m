From: akpm@linux-foundation.org
Subject: +
 ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch
 added to -mm tree
Date: Tue, 13 Sep 2016 14:20:19 -0700
Message-ID: <57d86d93.ILWyVsLud2RE+PMI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34963 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbcIMVUU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 17:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, zren@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix memory leak in dlm_migrate_request_handler()
has been added to the -mm tree.  Its filename is
     ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: fix memory leak in dlm_migrate_request_handler()

In the dlm_migrate_request_handler(), when `ret' is --EEXIST, the mle
should be freed, otherwise the memory will be leaked.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
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

ocfs2-free-the-mle-while-the-res-had-one-to-avoid-mle-memory-leak.patch

