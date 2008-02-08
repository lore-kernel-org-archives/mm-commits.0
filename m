From: akpm@linux-foundation.org
Subject: - mount-options-fix-fat.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:52 -0800
Message-ID: <200802082019.m18KJXq3011068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934977AbYBHUfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:35:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     mount options: fix fat
has been removed from the -mm tree.  Its filename was
     mount-options-fix-fat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix fat
From: Miklos Szeredi <mszeredi@suse.cz>

Add flush option to /proc/mounts for msdos and vfat filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/fat/inode.c~mount-options-fix-fat fs/fat/inode.c
--- a/fs/fat/inode.c~mount-options-fix-fat
+++ a/fs/fat/inode.c
@@ -837,6 +837,8 @@ static int fat_show_options(struct seq_f
 		if (!opts->numtail)
 			seq_puts(m, ",nonumtail");
 	}
+	if (sbi->options.flush)
+		seq_puts(m, ",flush");
 
 	return 0;
 }
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
