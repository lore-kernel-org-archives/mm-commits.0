From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-umask-ignored-issue.patch removed from -mm
 tree
Date: Mon, 23 Nov 2015 12:15:24 -0800
Message-ID: <565373dc.yRx+jQFtFW2lObY3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbbKWUPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix umask ignored issue
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-umask-ignored-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


