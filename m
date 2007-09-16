From: akpm@linux-foundation.org
Subject: - mntput-called-before-dput-in-afs.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:36 -0700
Message-ID: <200709160925.l8G9PaS6009115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbXIPJ0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruen@suse.de, dhowells@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     afs: mntput called before dput
has been removed from the -mm tree.  Its filename was
     mntput-called-before-dput-in-afs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: afs: mntput called before dput
From: Andreas Gruenbacher <agruen@suse.de>

dput must be called before mntput here.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-By: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/mntpt.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/mntpt.c~mntput-called-before-dput-in-afs fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~mntput-called-before-dput-in-afs
+++ a/fs/afs/mntpt.c
@@ -235,8 +235,8 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		mntput(nd->mnt);
 		dput(nd->dentry);
+		mntput(nd->mnt);
 		nd->mnt = newmnt;
 		nd->dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
_

Patches currently in -mm which might be from agruen@suse.de are

origin.patch
faster-ext2_clear_inode.patch
revert-faster-ext2_clear_inode.patch
