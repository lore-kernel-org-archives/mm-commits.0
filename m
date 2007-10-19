From: akpm@linux-foundation.org
Subject: - ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:12 -0700
Message-ID: <200710190342.l9J3gCpR012882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966416AbXJSD5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, chris.mason@oracle.com, hch@lst.de, jeffm@suse.com, jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, neilb@suse.de, sfrench@us.ibm.com, trond.mykle


The patch titled
     ecryptfs: allow lower fs to interpret ATTR_KILL_S*ID
has been removed from the -mm tree.  Its filename was
     ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: allow lower fs to interpret ATTR_KILL_S*ID
From: Jeff Layton <jlayton@redhat.com>

Make sure ecryptfs doesn't trip the BUG() in notify_change.  This also allows
the lower filesystem to interpret ATTR_KILL_S*ID in its own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ecryptfs/inode.c~ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid
+++ a/fs/ecryptfs/inode.c
@@ -914,6 +914,14 @@ static int ecryptfs_setattr(struct dentr
 		if (rc < 0)
 			goto out;
 	}
+
+	/*
+	 * mode change is for clearing setuid/setgid bits. Allow lower fs
+	 * to interpret this in its own way.
+	 */
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	rc = notify_change(lower_dentry, ia);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
git-cifs.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
