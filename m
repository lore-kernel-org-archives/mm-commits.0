From: akpm@linux-foundation.org
Subject: + ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch added to -mm tree
Date: Tue, 25 Nov 2014 16:10:03 -0800
Message-ID: <54751a5b.ATkeazvgLGRc+mL+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKZAJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 19:09:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove bogus NULL check in ocfs2_move_extents()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch

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
Subject: ocfs2: remove bogus NULL check in ocfs2_move_extents()

"inode" isn't NULL here, and also we dereference it on the previous line
so static checkers get annoyed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/move_extents.c~ocfs2-remove-bogus-null-check-in-ocfs2_move_extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-remove-bogus-null-check-in-ocfs2_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -904,9 +904,6 @@ static int ocfs2_move_extents(struct ocf
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (!inode)
-		return -ENOENT;
