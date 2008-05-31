From: akpm@linux-foundation.org
Subject: + vfs-utimes-immutable-fix.patch added to -mm tree
Date: Fri, 30 May 2008 17:13:28 -0700
Message-ID: <200805310013.m4V0DS6P018634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601AbYEaAN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, drepper@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: utimes immutable fix
has been added to the -mm tree.  Its filename is
     vfs-utimes-immutable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: utimes immutable fix
From: Miklos Szeredi <mszeredi@suse.cz>

If updating file times to the current time and using a file
descriptor, then don't check for immutable inode, only if the file is
opened for write.  In this case immutability has been checked at open
time.  This is the same as how write() and ftruncate() are handled.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/utimes.c~vfs-utimes-immutable-fix fs/utimes.c
--- a/fs/utimes.c~vfs-utimes-immutable-fix
+++ a/fs/utimes.c
@@ -130,7 +130,7 @@ long do_utimes(int dfd, char __user *fil
 	if (!times || (nsec_special(times[0].tv_nsec) &&
 		       nsec_special(times[1].tv_nsec))) {
 		error = -EACCES;
-                if (IS_IMMUTABLE(inode))
+		if (!f && IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
 
 		if (!is_owner_or_cap(inode)) {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch
nfsd-clean-up-mnt_want_write-calls.patch
cgroup-dont-call-vfs_mkdir.patch
reiserfs-dont-call-vfs_rmdir.patch
reiserfs-dont-call-notify_change.patch
sysfs-dont-call-notify_change.patch
hpfs-dont-call-notify_change.patch
fat-dont-call-notify_change.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch

