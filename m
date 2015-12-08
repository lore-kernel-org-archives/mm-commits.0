From: akpm@linux-foundation.org
Subject: + ocfs2-fix-sgid-not-inherited-issue.patch added to -mm tree
Date: Tue, 08 Dec 2015 13:21:47 -0800
Message-ID: <566749eb.vXB3eC33AccugUWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbbLHVVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 16:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix SGID not inherited issue
has been added to the -mm tree.  Its filename is
     ocfs2-fix-sgid-not-inherited-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-sgid-not-inherited-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-sgid-not-inherited-issue.patch

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
Subject: ocfs2: fix SGID not inherited issue

commit 8f1eb48758aa ("ocfs2: fix umask ignored issue") introduced an
issue, SGID of sub dir was not inherited from its parents dir.  It is
because SGID is set into "inode->i_mode" in ocfs2_get_init_inode(), but is
overwritten by "mode" which don't have SGID set later.

Fixes: 8f1eb48758aa ("ocfs2: fix umask ignored issue")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-sgid-not-inherited-issue fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-sgid-not-inherited-issue
+++ a/fs/ocfs2/namei.c
@@ -367,13 +367,11 @@ static int ocfs2_mknod(struct inode *dir
 		goto leave;
 	}
 
-	status = posix_acl_create(dir, &mode, &default_acl, &acl);
+	status = posix_acl_create(dir, &inode->i_mode, &default_acl, &acl);
 	if (status) {
 		mlog_errno(status);
 		goto leave;
 	}
-	/* update inode->i_mode after mask with "umask". */
-	inode->i_mode = mode;
 
 	handle = ocfs2_start_trans(osb, ocfs2_mknod_credits(osb->sb,
 							    S_ISDIR(mode),
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-dlm-fix-deadlock-due-to-nested-lock.patch
ocfs2-fix-sgid-not-inherited-issue.patch
o2hb-increase-unsteady-iterations.patch

