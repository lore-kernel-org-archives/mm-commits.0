From: akpm@linux-foundation.org
Subject: + fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch added to -mm tree
Date: Thu, 09 Aug 2007 14:36:53 -0700
Message-ID: <200708092136.l79LarbI020750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbXHIVhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 17:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, npiggin@suse.de


The patch titled
     fix warnings in revoked_inode.c
has been added to the -mm tree.  Its filename is
     fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-f=
ix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: fix warnings in revoked_inode.c
=46rom: Miklos Szeredi <mszeredi@suse.cz>

=46ix following warnings introduced by
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch

fs/revoked_inode.c:381: warning: =E2=80=98revoked_write_begin=E2=80=99 =
defined but not used
fs/revoked_inode.c:388: warning: =E2=80=98revoked_write_end=E2=80=99 de=
fined but not used

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoked_inode.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff -puN fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-per=
form_write-aops-revoke-fix fs/revoked_inode.c
--- a/fs/revoked_inode.c~fs-introduce-write_begin-write_end-and-perform=
_write-aops-revoke-fix
+++ a/fs/revoked_inode.c
@@ -372,18 +372,6 @@ static int revoked_writepage(struct page
 	return -EIO;
 }
=20
-static int revoked_prepare_write(struct file *file, struct page *page,
-				 unsigned from, unsigned to)
-{
-	return -EIO;
-}
-
-static int revoked_commit_write(struct file *file, struct page *page,
-				unsigned from, unsigned to)
-{
-	return -EIO;
-}
-
 static int revoked_write_begin(struct file *file, struct address_space=
 *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -408,8 +396,8 @@ static ssize_t revoked_direct_IO(int rw,
 static const struct address_space_operations revoked_aops =3D {
         .readpage       =3D revoked_readpage,
         .writepage      =3D revoked_writepage,
-        .prepare_write  =3D revoked_prepare_write,
-        .commit_write   =3D revoked_commit_write,
+	.write_begin	=3D revoked_write_begin,
+	.write_end	=3D revoked_write_end,
         .direct_IO      =3D revoked_direct_IO,
 };
=20
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-convert-to-new-aops.patch
uml-remove-unnecessary-hostfs_getattr.patch
ext2-show-all-mount-options.patch
ext3-show-all-mount-options.patch
ext4-show-all-mount-options.patch
vfs-check-nanoseconds-in-utimensat.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
clean-out-unused-code-in-dentry-pruning.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patc=
h
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-a=
udit.patch
unprivileged-mounts-add-no-submounts-flag.patch
fuse-update-backing_dev_info-congestion-state.patch
fuse-fix-reserved-request-wake-up.patch
fuse-add-reference-counting-to-fuse_file.patch
fuse-truncate-on-spontaneous-size-change.patch
fuse-fix-page-invalidation.patch
fuse-set-i_nlink-to-sane-value-after-mount.patch
fuse-refresh-stale-attributes-in-fuse_permission.patch
fuse-fix-permission-checking-on-sticky-directories.patch
fuse-fix-permission-checking-on-sticky-directories-fix.patch
fuse-fix-permission-checking-on-sticky-directories-fix-setting-i_mode-b=
its.patch
fuse-cleanup-in-release.patch
fuse-no-abort-on-interrupt.patch
fuse-no-enoent-from-fuse-device-read.patch
fuse-clean-up-execute-permission-checking.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.pa=
tch
