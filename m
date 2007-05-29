From: akpm@linux-foundation.org
Subject: - fuse-generic_write_checks-for-direct_io.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:42 -0700
Message-ID: <200705291851.l4TIpfAl008355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757066AbXE2SwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: generic_write_checks() for direct_io
has been removed from the -mm tree.  Its filename was
     fuse-generic_write_checks-for-direct_io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: generic_write_checks() for direct_io
From: Miklos Szeredi <mszeredi@suse.cz>

This fixes O_APPEND in direct IO mode.  Also checks writes against file size
limits, notably rlimits.

Reported by Greg Bruno.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/fuse/file.c~fuse-generic_write_checks-for-direct_io fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-generic_write_checks-for-direct_io
+++ a/fs/fuse/file.c
@@ -610,7 +610,9 @@ static ssize_t fuse_direct_write(struct 
 	ssize_t res;
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
-	res = fuse_direct_io(file, buf, count, ppos, 1);
+	res = generic_write_checks(file, ppos, &count, 0);
+	if (!res)
+		res = fuse_direct_io(file, buf, count, ppos, 1);
 	mutex_unlock(&inode->i_mutex);
 	return res;
 }
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
