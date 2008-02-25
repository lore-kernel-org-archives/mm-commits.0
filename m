From: akpm@linux-foundation.org
Subject: - fuse-fix-permission-checking.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:06 -0800
Message-ID: <200802250044.m1P0i6Lg006058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbYBYAo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fuse: fix permission checking
has been removed from the -mm tree.  Its filename was
     fuse-fix-permission-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix permission checking
From: Miklos Szeredi <mszeredi@suse.cz>

This is for 2.6.25 and 2.6.24.y, but NOT for 2.6.23.y.

I added a nasty local variable shadowing bug to fuse in 2.6.24, with the
result, that the 'default_permissions' mount option is basically ignored.

How did this happen?

 - old err declaration in inner scope
 - new err getting declared in outer scope
 - 'return err' from inner scope getting removed
 - old declaration not being noticed

-Wshadow would have saved us, but it doesn't seem practical for
the kernel :(

More testing would have also saved us :((

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fuse/dir.c~fuse-fix-permission-checking fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-fix-permission-checking
+++ a/fs/fuse/dir.c
@@ -906,7 +906,7 @@ static int fuse_permission(struct inode 
 	}
 
 	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
-		int err = generic_permission(inode, mask, NULL);
+		err = generic_permission(inode, mask, NULL);
 
 		/* If permission is denied, try to refresh file
 		   attributes.  This is also needed, because the root
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-create-proc-pid-mountinfo.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
