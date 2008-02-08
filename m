From: akpm@linux-foundation.org
Subject: - mount-options-fix-adfs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:32 -0800
Message-ID: <200802082019.m18KJDgJ011029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934867AbYBHUkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mount options: fix adfs
has been removed from the -mm tree.  Its filename was
     mount-options-fix-adfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix adfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to adfs.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/super.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff -puN fs/adfs/super.c~mount-options-fix-adfs fs/adfs/super.c
--- a/fs/adfs/super.c~mount-options-fix-adfs
+++ a/fs/adfs/super.c
@@ -20,6 +20,8 @@
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/bitops.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -30,6 +32,9 @@
 #include "dir_f.h"
 #include "dir_fplus.h"
 
+#define ADFS_DEFAULT_OWNER_MASK S_IRWXU
+#define ADFS_DEFAULT_OTHER_MASK (S_IRWXG | S_IRWXO)
+
 void __adfs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 {
 	char error_buf[128];
@@ -134,6 +139,22 @@ static void adfs_put_super(struct super_
 	sb->s_fs_info = NULL;
 }
 
+static int adfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
+{
+	struct adfs_sb_info *asb = ADFS_SB(mnt->mnt_sb);
+
+	if (asb->s_uid != 0)
+		seq_printf(seq, ",uid=%u", asb->s_uid);
+	if (asb->s_gid != 0)
+		seq_printf(seq, ",gid=%u", asb->s_gid);
+	if (asb->s_owner_mask != ADFS_DEFAULT_OWNER_MASK)
+		seq_printf(seq, ",ownmask=%o", asb->s_owner_mask);
+	if (asb->s_other_mask != ADFS_DEFAULT_OTHER_MASK)
+		seq_printf(seq, ",othmask=%o", asb->s_other_mask);
+
+	return 0;
+}
+
 enum {Opt_uid, Opt_gid, Opt_ownmask, Opt_othmask, Opt_err};
 
 static match_table_t tokens = {
@@ -259,6 +280,7 @@ static const struct super_operations adf
 	.put_super	= adfs_put_super,
 	.statfs		= adfs_statfs,
 	.remount_fs	= adfs_remount,
+	.show_options	= adfs_show_options,
 };
 
 static struct adfs_discmap *adfs_read_map(struct super_block *sb, struct adfs_discrecord *dr)
@@ -344,8 +366,8 @@ static int adfs_fill_super(struct super_
 	/* set default options */
 	asb->s_uid = 0;
 	asb->s_gid = 0;
-	asb->s_owner_mask = S_IRWXU;
-	asb->s_other_mask = S_IRWXG | S_IRWXO;
+	asb->s_owner_mask = ADFS_DEFAULT_OWNER_MASK;
+	asb->s_other_mask = ADFS_DEFAULT_OTHER_MASK;
 
 	if (parse_options(sb, data))
 		goto error;
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
