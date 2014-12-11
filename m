From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 10:55:29 -0800
Message-ID: <5489e8a1.S4VJOXcR/+uRhixY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450AbaLKSz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove bogus NULL check in ocfs2_move_extents()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
