From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-undefined-struct-variable-in-inodeh.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:42:41 -0700
Message-ID: <57fc1961.6ewrLaOAxLPnCYxJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36601 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752279AbcJJWnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, zren@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix undefined struct variable in inode.h
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-undefined-struct-variable-in-inodeh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix undefined struct variable in inode.h

The extern struct variable ocfs2_inode_cache is not defined. It meant to
use ocfs2_inode_cachep defined in super.c, I think. Fortunately it is
not used anywhere now, so no impact actually. Clean it up to fix this
mistake.

Link: http://lkml.kernel.org/r/57E1E49D.8050503@huawei.com
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/inode.h~ocfs2-fix-undefined-struct-variable-in-inodeh fs/ocfs2/inode.h
--- a/fs/ocfs2/inode.h~ocfs2-fix-undefined-struct-variable-in-inodeh
+++ a/fs/ocfs2/inode.h
@@ -123,8 +123,6 @@ static inline struct ocfs2_inode_info *O
 #define INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags & OCFS2_INODE_JOURNAL)
 #define SET_INODE_JOURNAL(i) (OCFS2_I(i)->ip_flags |= OCFS2_INODE_JOURNAL)
 
-extern struct kmem_cache *ocfs2_inode_cache;
