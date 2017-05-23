From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-static-checker-warning.patch added to -mm tree
Date: Tue, 23 May 2017 15:30:48 -0700
Message-ID: <5924b818.ZOepC7BfDhgqufim%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968771AbdEWWat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 23 May 2017 18:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a static checker warning
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-static-checker-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-static-checker-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-static-checker-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: fix a static checker warning

Fix a static code checker warning:

fs/ocfs2/inode.c:179 ocfs2_iget()
warn: passing zero to 'ERR_PTR'

Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
Link: http://lkml.kernel.org/r/1495516634-1952-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-fix-a-static-checker-warning.patch
ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch

