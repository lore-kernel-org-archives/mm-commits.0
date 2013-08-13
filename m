From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch
 removed from -mm tree
Date: Tue, 13 Aug 2013 15:57:50 -0700
Message-ID: <520ab9ee.SO46EqpMeprQGdhV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab3HMW5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Aug 2013 18:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wb@munzinger.de, viro@zeniv.linux.org.uk, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, dan.carpenter@oracle.com

Subject: [folded-merged] ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch removed from -mm tree
To: dan.carpenter@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,viro@zeniv.linux.org.uk,wb@munzinger.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 13 Aug 2013 15:57:50 -0700


The patch titled
     Subject: ocfs2: ocfs2: fix recent memory corruption bug
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch

This patch was dropped because it was folded into ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: ocfs2: fix recent memory corruption bug

The pointer math in 6fdf3af1d2 "ocfs2: fix null pointer dereference in
ocfs2_dir_foreach_blk_id()" isn't correct so it will zero out the wrong
memory.  In fact, the memset isn't needed because the initializer will set
all these values to zero.

This patch also removes the "ctx.pos = 0" initialization because that
will be zeroed automatically as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jie Liu <jeff.liu@oracle.com>
Cc: David Weber <wb@munzinger.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix
+++ a/fs/ocfs2/dir.c
@@ -2154,12 +2154,8 @@ int ocfs2_empty_dir(struct inode *inode)
 	int ret;
 	struct ocfs2_empty_dir_priv priv = {
 		.ctx.actor = ocfs2_empty_dir_filldir,
-		.ctx.pos = 0,
 	};
 
-	memset(&priv + sizeof(struct dir_context), 0,
-	       sizeof(priv) - sizeof(struct dir_context));
