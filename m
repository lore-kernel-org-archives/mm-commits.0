From: akpm@linux-foundation.org
Subject: - mount-options-fix-ext2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:50 -0800
Message-ID: <200802082019.m18KJVMi011065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40449 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762006AbYBHUfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:35:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: fix ext2
has been removed from the -mm tree.  Its filename was
     mount-options-fix-ext2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix ext2
From: Miklos Szeredi <mszeredi@suse.cz>

Add noreservation option to /proc/mounts for ext2 filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ext2/super.c~mount-options-fix-ext2 fs/ext2/super.c
--- a/fs/ext2/super.c~mount-options-fix-ext2
+++ a/fs/ext2/super.c
@@ -285,6 +285,9 @@ static int ext2_show_options(struct seq_
 		seq_puts(seq, ",xip");
 #endif
 
+	if (!test_opt(sb, RESERVATION))
+		seq_puts(seq, ",noreservation");
+
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
