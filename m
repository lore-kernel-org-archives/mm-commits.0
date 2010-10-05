From: akpm@linux-foundation.org
Subject: + vfs-fix-infinite-loop-caused-by-clone_mnt-race.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:42:46 -0700
Message-ID: <201010051942.o95JgkF2015698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab0JETm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix infinite loop caused by clone_mnt race
has been added to the -mm tree.  Its filename is
     vfs-fix-infinite-loop-caused-by-clone_mnt-race.patch

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
Subject: vfs: fix infinite loop caused by clone_mnt race
From: Miklos Szeredi <mszeredi@suse.cz>

If clone_mnt() happens while mnt_make_readonly() is running, the cloned
mount might have MNT_WRITE_HOLD flag set, which results in
mnt_want_write() spinning forever on this mount.

Needs CAP_SYS_ADMIN to trigger deliberately and unlikely to happen
accidentally.  But if it does happen it can hang the machine.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~vfs-fix-infinite-loop-caused-by-clone_mnt-race fs/namespace.c
--- a/fs/namespace.c~vfs-fix-infinite-loop-caused-by-clone_mnt-race
+++ a/fs/namespace.c
@@ -595,7 +595,7 @@ static struct vfsmount *clone_mnt(struct
 				goto out_free;
 		}
 
-		mnt->mnt_flags = old->mnt_flags;
+		mnt->mnt_flags = old->mnt_flags & ~MNT_WRITE_HOLD;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
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

