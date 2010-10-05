From: akpm@linux-foundation.org
Subject: + vfs-fix-per-mount-read-write.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:42:50 -0700
Message-ID: <201010051942.o95Jgo51015704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755979Ab0JETnC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:43:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix per mount read-write
has been added to the -mm tree.  Its filename is
     vfs-fix-per-mount-read-write.patch

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
Subject: vfs: fix per mount read-write
From: Miklos Szeredi <mszeredi@suse.cz>

Don't allow remounting the vfsmount read-write if the superblock is
read-only.  Return -EROFS in this case.

Rename __mnt_unmake_readonly() to mnt_make_writable() to match
mnt_make_readonly().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/namespace.c~vfs-fix-per-mount-read-write fs/namespace.c
--- a/fs/namespace.c~vfs-fix-per-mount-read-write
+++ a/fs/namespace.c
@@ -399,11 +399,18 @@ static int mnt_make_readonly(struct vfsm
 	return ret;
 }
 
-static void __mnt_unmake_readonly(struct vfsmount *mnt)
+static int mnt_make_writable(struct vfsmount *mnt)
 {
+	int err = 0;
+
 	br_write_lock(vfsmount_lock);
-	mnt->mnt_flags &= ~MNT_READONLY;
+	if (mnt->mnt_sb->s_flags & MS_RDONLY)
+		err = -EROFS;
+	else
+		mnt->mnt_flags &= ~MNT_READONLY;
 	br_write_unlock(vfsmount_lock);
+
+	return err;
 }
 
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
@@ -1600,7 +1607,7 @@ static int change_mount_flags(struct vfs
 	if (readonly_request)
 		error = mnt_make_readonly(mnt);
 	else
-		__mnt_unmake_readonly(mnt);
+		error = mnt_make_writable(mnt);
 	return error;
 }
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
vfs-fix-infinite-loop-caused-by-clone_mnt-race.patch
vfs-ignore-error-on-forced-remount.patch
vfs-fix-per-mount-read-write.patch
vfs-add-sb_force_remount_readonly-helper.patch
vfs-allow-mnt_want_write-to-sleep.patch
vfs-allow-mnt_want_write-to-sleep-fix.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch
vfs-mark-mounts-read-only-on-forced-remount.patch
fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch
fuse-use-release_pages.patch

