From: akpm@linux-foundation.org
Subject: + mntput-called-before-dput-in-afs.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:52:50 -0700
Message-ID: <200708311952.l7VJqov7023828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbXHaTxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@suse.de, dhowells@redhat.com, stable@kernel.org


The patch titled
     afs: mntput called before dput
has been added to the -mm tree.  Its filename is
     mntput-called-before-dput-in-afs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mntput-called-before-dput-in-afs.patch
faster-ext2_clear_inode.patch
revert-faster-ext2_clear_inode.patch
