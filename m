From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:12 -0700
Message-ID: <533f0844.kypqsWmT49bhhQz1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaDDTaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.de, jlbec@evilplan.org, jack@suse.cz

Subject: [merged] ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.de,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:12 -0700


The patch titled
     Subject: ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later
has been removed from the -mm tree.  Its filename was
     ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later

Move dquot_initalize() call in ocfs2_delete_inode() after the moment we
verify inode is actually a sane one to delete.  We certainly don't want to
initialize quota for system inodes etc.  This also avoids calling into
quota code from downconvert thread.

Add more details into the comment why bailing out from
ocfs2_delete_inode() when we are in downconvert thread is OK.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/inode.c~ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later fs/ocfs2/inode.c
--- a/fs/ocfs2/inode.c~ocfs2-move-dquot_initialize-in-ocfs2_delete_inode-somewhat-later
+++ a/fs/ocfs2/inode.c
@@ -831,11 +831,13 @@ static int ocfs2_inode_is_valid_to_delet
 		goto bail;
 	}
 
-	/* If we're coming from downconvert_thread we can't go into our own
-	 * voting [hello, deadlock city!], so unforuntately we just
-	 * have to skip deleting this guy. That's OK though because
-	 * the node who's doing the actual deleting should handle it
-	 * anyway. */
+	/*
+	 * If we're coming from downconvert_thread we can't go into our own
+	 * voting [hello, deadlock city!] so we cannot delete the inode. But
+	 * since we dropped last inode ref when downconverting dentry lock,
+	 * we cannot have the file open and thus the node doing unlink will
+	 * take care of deleting the inode.
+	 */
 	if (current == osb->dc_task)
 		goto bail;
 
@@ -981,8 +983,6 @@ static void ocfs2_delete_inode(struct in
 	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno)
 		goto bail;
 
-	dquot_initialize(inode);
