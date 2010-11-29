From: akpm@linux-foundation.org
Subject: [merged] reiserfs-fix-inode-mutex-reiserfs-lock-misordering.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:30 -0800
Message-ID: <201011291951.oATJpxfj007342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742Ab0K2Tws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:52:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, jack@suse.cz, jeffm@suse.com, markus.gapp@gmx.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix inode mutex - reiserfs lock misordering
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-inode-mutex-reiserfs-lock-misordering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix inode mutex - reiserfs lock misordering
From: Frederic Weisbecker <fweisbec@gmail.com>

reiserfs_unpack() locks the inode mutex with reiserfs_mutex_lock_safe() to
protect against reiserfs lock dependency.  However this protection
requires to have the reiserfs lock to be locked.

This is the case if reiserfs_unpack() is called by reiserfs_ioctl but not
from reiserfs_quota_on() when it tries to unpack tails of quota files.

Fix the ordering of the two locks in reiserfs_unpack() to
fix this issue.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Markus Gapp <markus.gapp@gmx.net>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: <stable@kernel.org>		[2.6.36.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/ioctl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/ioctl.c~reiserfs-fix-inode-mutex-reiserfs-lock-misordering fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~reiserfs-fix-inode-mutex-reiserfs-lock-misordering
+++ a/fs/reiserfs/ioctl.c
@@ -183,12 +183,11 @@ int reiserfs_unpack(struct inode *inode,
 		return 0;
 	}
 
-	/* we need to make sure nobody is changing the file size beneath
-	 ** us
-	 */
-	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
 	depth = reiserfs_write_lock_once(inode->i_sb);
 
+	/* we need to make sure nobody is changing the file size beneath us */
+	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
+
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
 	if (write_from == 0) {
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch

