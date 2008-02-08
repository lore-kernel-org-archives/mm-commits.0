From: akpm@linux-foundation.org
Subject: - mount-options-fix-hugetlbfs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:03 -0800
Message-ID: <200802082019.m18KJi8f011080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbYBHUoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:44:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, agl@us.ibm.com, david@gibson.dropbear.id.au, kenchen@google.com, pbadari@us.ibm.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     mount options: fix hugetlbfs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix hugetlbfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to hugetlbfs.

Use generic_show_options() and save the complete option string in
hugetlbfs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Ken Chen <kenchen@google.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/hugetlbfs/inode.c~mount-options-fix-hugetlbfs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mount-options-fix-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -734,6 +734,7 @@ static const struct super_operations hug
 	.delete_inode	= hugetlbfs_delete_inode,
 	.drop_inode	= hugetlbfs_drop_inode,
 	.put_super	= hugetlbfs_put_super,
+	.show_options	= generic_show_options,
 };
 
 static int
@@ -817,6 +818,8 @@ hugetlbfs_fill_super(struct super_block 
 	struct hugetlbfs_config config;
 	struct hugetlbfs_sb_info *sbinfo;
 
+	save_mount_options(sb, data);
+
 	config.nr_blocks = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
 	config.uid = current->fsuid;
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
