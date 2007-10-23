From: akpm@linux-foundation.org
Subject: - unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:48:13 -0700
Message-ID: <200710230648.l9N6mDW8004350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56162 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbXJWG52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID
has been removed from the -mm tree.  Its filename was
     unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID
From: Jeff Layton <jlayton@redhat.com>

Don't allow unionfs_setattr to trip the BUG() in notify_change. Clear
ATTR_MODE if the either ATTR_KILL_S*ID is set. This also allows the
lower filesystem to interpret these bits in its own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/unionfs/inode.c~unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid fs/unionfs/inode.c
--- a/fs/unionfs/inode.c~unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid
+++ a/fs/unionfs/inode.c
@@ -1048,6 +1048,13 @@ static int unionfs_setattr(struct dentry
 	bend = dbend(dentry);
 	inode = dentry->d_inode;
 
+	/*
+	 * mode change is for clearing setuid/setgid. Allow lower filesystem
+	 * to reinterpret it in its own way.
+	 */
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
 	     bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
git-unionfs.patch
