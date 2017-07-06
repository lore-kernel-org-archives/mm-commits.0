From: akpm@linux-foundation.org
Subject: [patch 015/108] ocfs2: fix a static checker warning
Date: Thu, 06 Jul 2017 15:36:07 -0700
Message-ID: <20170706223607.yCAAqxKf2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbdGFWgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, zren@suse.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: fix a static checker warning

Fix a static code checker warning:

fs/ocfs2/inode.c:179 ocfs2_iget()
warn: passing zero to 'ERR_PTR'

Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
Link: http://lkml.kernel.org/r/1495516634-1952-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Reviewed-by: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/inode.c~ocfs2-fix-a-static-checker-warning fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-fix-a-static-checker-warning
+++ a/fs/ocfs2/inode.c
@@ -136,7 +136,7 @@ struct inode *ocfs2_ilookup(struct super
 struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 			 int sysfile_type)
 {
-	int rc = 0;
+	int rc = -ESTALE;
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
 	struct ocfs2_find_inode_args args;
_
