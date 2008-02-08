From: akpm@linux-foundation.org
Subject: - mount-options-fix-spufs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:11 -0800
Message-ID: <200802082019.m18KJqgF011092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933546AbYBHUlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:41:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, arnd@arndb.de, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     mount options: fix spufs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-spufs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix spufs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to spufs.

Use generic_show_options() and save the complete option string in
spufs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/powerpc/platforms/cell/spufs/inode.c~mount-options-fix-spufs arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~mount-options-fix-spufs
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -755,8 +755,11 @@ spufs_fill_super(struct super_block *sb,
 		.statfs = simple_statfs,
 		.delete_inode = spufs_delete_inode,
 		.drop_inode = generic_delete_inode,
+		.show_options = generic_show_options,
 	};
 
+	save_mount_options(sb, data);
+
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
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
