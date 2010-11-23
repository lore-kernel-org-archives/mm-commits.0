From: akpm@linux-foundation.org
Subject: + reiserfs-fix-inode-mutex-reiserfs-lock-misordering.patch added to -mm tree
Date: Mon, 22 Nov 2010 16:14:16 -0800
Message-ID: <201011230014.oAN0EGtG017242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932512Ab0KWAOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 19:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, jack@suse.cz, jeffm@suse.com, markus.gapp@gmx.net, stable@kernel.org


The patch titled
     reiserfs: fix inode mutex - reiserfs lock misordering
has been added to the -mm tree.  Its filename is
     reiserfs-fix-inode-mutex-reiserfs-lock-misordering.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
reiserfs-fix-inode-mutex-reiserfs-lock-misordering.patch

