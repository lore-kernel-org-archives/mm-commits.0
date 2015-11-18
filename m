From: akpm@linux-foundation.org
Subject: + ocfs2-fix-umask-ignored-issue.patch added to -mm tree
Date: Wed, 18 Nov 2015 14:11:39 -0800
Message-ID: <564cf79b.6Nc6JVKUJ9TWeqX/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbKRWLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 17:11:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix umask ignored issue
has been added to the -mm tree.  Its filename is
     ocfs2-fix-umask-ignored-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-umask-ignored-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-umask-ignored-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix umask ignored issue

New created file's mode is not masked with umask, and this makes umask not
work for ocfs2 volume.

Fixes: 702e5bc ("ocfs2: use generic posix ACL infrastructure")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-umask-ignored-issue fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-umask-ignored-issue
+++ a/fs/ocfs2/namei.c
@@ -372,6 +372,8 @@ static int ocfs2_mknod(struct inode *dir
 		mlog_errno(status);
 		goto leave;
 	}
+	/* update inode->i_mode after mask with "umask". */
+	inode->i_mode = mode;
 
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-fix-umask-ignored-issue.patch

