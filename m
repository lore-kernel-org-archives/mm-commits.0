From: akpm@linux-foundation.org
Subject: + fuse-fix-fuse_file_ops-sending.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:22:29 -0700
Message-ID: <200710250322.l9P3MTZ7029301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519AbXJYDXG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:23:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix FUSE_FILE_OPS sending
has been added to the -mm tree.  Its filename is
     fuse-fix-fuse_file_ops-sending.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse: fix FUSE_FILE_OPS sending
From: Miklos Szeredi <mszeredi@suse.cz>

FUSE_FILE_OPS is meant to signal, that the kernel will send the open
file to to the userspace filesystem for operations on open files, so
that sillyrenaming unlinked files becomes unnecessary.

However this needs VFS changes, which won't make it into 2.6.24.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/fuse/inode.c~fuse-fix-fuse_file_ops-sending fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-fuse_file_ops-sending
+++ a/fs/fuse/inode.c
@@ -562,8 +562,7 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS |
-		FUSE_ATOMIC_O_TRUNC;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

fuse-fuse_file_alloc-fix-null-dereferences.patch
fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
