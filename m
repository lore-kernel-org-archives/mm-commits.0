From: akpm@linux-foundation.org
Subject: + ocfs2-fix-uninitialized-variable-access.patch added to -mm tree
Date: Tue, 06 Jan 2015 16:10:10 -0800
Message-ID: <54ac7962.9FG2ubxlgfl7yADy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbAGAKL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:10:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix uninitialized variable access
has been added to the -mm tree.  Its filename is
     ocfs2-fix-uninitialized-variable-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-uninitialized-variable-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-uninitialized-variable-access.patch

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
Subject: ocfs2: fix uninitialized variable access

Variable "why" is not yet initialized at line 615, fix it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-uninitialized-variable-access fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-uninitialized-variable-access
+++ a/fs/ocfs2/file.c
@@ -569,7 +569,7 @@ static int __ocfs2_extend_allocation(str
 	handle_t *handle = NULL;
 	struct ocfs2_alloc_context *data_ac = NULL;
 	struct ocfs2_alloc_context *meta_ac = NULL;
-	enum ocfs2_alloc_restarted why;
+	enum ocfs2_alloc_restarted why = RESTART_NONE;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_tree et;
 	int did_quota = 0;
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-fix-uninitialized-variable-access.patch
ocfs2-fix-wrong-comment.patch

