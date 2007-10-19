From: akpm@linux-foundation.org
Subject: - reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:18 -0700
Message-ID: <200710190342.l9J3gIl1012888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966249AbXJSD5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, chris.mason@oracle.com, hch@lst.de, jeffm@suse.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: turn of ATTR_KILL_S*ID at beginning of reiserfs_setattr
has been removed from the -mm tree.  Its filename was
     reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: turn of ATTR_KILL_S*ID at beginning of reiserfs_setattr
From: Jeff Layton <jlayton@redhat.com>

reiserfs_setattr can call notify_change recursively using the same
iattr struct. This could cause it to trip the BUG() in notify_change.
Fix reiserfs to clear those bits near the beginning of the function.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/inode.c~reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr
+++ a/fs/reiserfs/inode.c
@@ -3061,7 +3061,11 @@ int reiserfs_setattr(struct dentry *dent
 {
 	struct inode *inode = dentry->d_inode;
 	int error;
-	unsigned int ia_valid = attr->ia_valid;
+	unsigned int ia_valid;
+
+	/* must be turned off for recursive notify_change calls */
+	ia_valid = attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
+
 	reiserfs_write_lock(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
git-cifs.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
