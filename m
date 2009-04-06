From: akpm@linux-foundation.org
Subject: [merged] fs-reiserfs-return-f_fsid-for-statfs2-v3.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:36 -0700
Message-ID: <200904061938.n36Jcafp013457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbZDFTlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: coly.li@suse.de, jeffm@suse.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiserfs: return f_fsid for statfs(2)
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-return-f_fsid-for-statfs2-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/reiserfs: return f_fsid for statfs(2)
From: Coly Li <coly.li@suse.de>

Make reiserfs3 return f_fsid info for statfs(2).  By Andreas' suggestion,
this patch populates a persistent f_fsid between boots/mounts with help of
on-disk uuid record.

Randy Dunlap reported a compiling error from v2 patch like:
    fs/built-in.o: In function `reiserfs_statfs':
    super.c:(.text+0x7332b): undefined reference to `crc32_le'
    super.c:(.text+0x7333f): undefined reference to `crc32_le'
Also he provided helpful solution to fix this error. The modification of v3
patch is based on Randy's suggestion, add 'select CRC32' in fs/reiserfs/Kconfig.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/Kconfig |    1 +
 fs/reiserfs/super.c |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN fs/reiserfs/Kconfig~fs-reiserfs-return-f_fsid-for-statfs2-v3 fs/reiserfs/Kconfig
--- a/fs/reiserfs/Kconfig~fs-reiserfs-return-f_fsid-for-statfs2-v3
+++ a/fs/reiserfs/Kconfig
@@ -1,5 +1,6 @@
 config REISERFS_FS
 	tristate "Reiserfs support"
+	select CRC32
 	help
 	  Stores not just filenames but the files themselves in a balanced
 	  tree.  Uses journalling.
diff -puN fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2-v3 fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~fs-reiserfs-return-f_fsid-for-statfs2-v3
+++ a/fs/reiserfs/super.c
@@ -27,6 +27,7 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/crc32.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -1904,6 +1905,10 @@ static int reiserfs_statfs(struct dentry
 	buf->f_bsize = dentry->d_sb->s_blocksize;
 	/* changed to accommodate gcc folks. */
 	buf->f_type = REISERFS_SUPER_MAGIC;
+	buf->f_fsid.val[0] = (u32)crc32_le(0, rs->s_uuid, sizeof(rs->s_uuid)/2);
+	buf->f_fsid.val[1] = (u32)crc32_le(0, rs->s_uuid + sizeof(rs->s_uuid)/2,
+				sizeof(rs->s_uuid)/2);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from coly.li@suse.de are

origin.patch
fs-romfs-return-f_fsid-for-statfs2.patch

