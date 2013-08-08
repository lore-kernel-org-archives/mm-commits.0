From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch
 added to -mm tree
Date: Thu, 08 Aug 2013 14:56:44 -0700
Message-ID: <5204141c.MbwHuZoYEk2tdUap%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab3HHV4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 17:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wb@munzinger.de, viro@zeniv.linux.org.uk, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, dan.carpenter@oracle.com

Subject: + ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch added to -mm tree
To: dan.carpenter@oracle.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,viro@zeniv.linux.org.uk,wb@munzinger.de
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 14:56:44 -0700


The patch titled
     Subject: ocfs2: ocfs2: fix recent memory corruption bug
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-null-pointer-dereference-in-ocfs2_dir_foreach_blk_id-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
