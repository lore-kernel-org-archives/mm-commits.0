From: akpm@linux-foundation.org
Subject: [patch 011/127] ocfs2: fix undefined struct variable in inode.h
Date: Fri, 07 Oct 2016 16:57:20 -0700
Message-ID: <57f83660.kUjmLxjeoXucA0PB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, zren@suse.com

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
