From: akpm@linux-foundation.org
Subject: - fuse-fix-fuse_file_ops-sending.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:52 -0800
Message-ID: <200712010022.lB10MqhH031951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723AbXLAA1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix FUSE_FILE_OPS sending
has been removed from the -mm tree.  Its filename was
     fuse-fix-fuse_file_ops-sending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix FUSE_FILE_OPS sending
From: Miklos Szeredi <mszeredi@suse.cz>

FUSE_FILE_OPS is meant to signal that the kernel will send the open file to to
the userspace filesystem for operations on open files, so that sillyrenaming
unlinked files becomes unnecessary.

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

origin.patch
