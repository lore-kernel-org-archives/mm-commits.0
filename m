From: akpm@linux-foundation.org
Subject: - mount-options-fix-udf.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:17 -0800
Message-ID: <200802082019.m18KJwCF011101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762443AbYBHUlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, gorcunov@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     mount options: fix udf
has been removed from the -mm tree.  Its filename was
     mount-options-fix-udf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix udf
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to udf.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c  |   74 +++++++++++++++++++++++++++++++++++++++++++---
 fs/udf/udf_sb.h |    2 +
 2 files changed, 72 insertions(+), 4 deletions(-)

diff -puN fs/udf/super.c~mount-options-fix-udf fs/udf/super.c
--- a/fs/udf/super.c~mount-options-fix-udf
+++ a/fs/udf/super.c
@@ -53,6 +53,8 @@
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
 #include <linux/errno.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
 #include <asm/byteorder.h>
 
 #include <linux/udf_fs.h>
@@ -71,6 +73,8 @@
 #define VDS_POS_TERMINATING_DESC	6
 #define VDS_POS_LENGTH			7
 
+#define UDF_DEFAULT_BLOCKSIZE 2048
+
 static char error_buf[1024];
 
 /* These are the "meat" - everything else is stuffing */
@@ -95,6 +99,7 @@ static void udf_open_lvid(struct super_b
 static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
+static int udf_show_options(struct seq_file *, struct vfsmount *);
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
@@ -181,6 +186,7 @@ static const struct super_operations udf
 	.write_super	= udf_write_super,
 	.statfs		= udf_statfs,
 	.remount_fs	= udf_remount_fs,
+	.show_options	= udf_show_options,
 };
 
 struct udf_options {
@@ -247,6 +253,61 @@ static int udf_sb_alloc_partition_maps(s
 	return 0;
 }
 
+static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
+{
+	struct super_block *sb = mnt->mnt_sb;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT))
+		seq_puts(seq, ",nostrict");
+	if (sb->s_blocksize != UDF_DEFAULT_BLOCKSIZE)
+		seq_printf(seq, ",bs=%lu", sb->s_blocksize);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
+		seq_puts(seq, ",unhide");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNDELETE))
+		seq_puts(seq, ",undelete");
+	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_USE_AD_IN_ICB))
+		seq_puts(seq, ",noadinicb");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_USE_SHORT_AD))
+		seq_puts(seq, ",shortad");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UID_FORGET))
+		seq_puts(seq, ",uid=forget");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UID_IGNORE))
+		seq_puts(seq, ",uid=ignore");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_GID_FORGET))
+		seq_puts(seq, ",gid=forget");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_GID_IGNORE))
+		seq_puts(seq, ",gid=ignore");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UID_SET))
+		seq_printf(seq, ",uid=%u", sbi->s_uid);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_GID_SET))
+		seq_printf(seq, ",gid=%u", sbi->s_gid);
+	if (sbi->s_umask != 0)
+		seq_printf(seq, ",umask=%o", sbi->s_umask);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_SESSION_SET))
+		seq_printf(seq, ",session=%u", sbi->s_session);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_LASTBLOCK_SET))
+		seq_printf(seq, ",lastblock=%u", sbi->s_last_block);
+	/*
+	 * s_anchor[2] could be zeroed out in case there is no anchor
+	 * in the specified block, but then the "anchor=N" option
+	 * originally given by the user wasn't effective, so it's OK
+	 * if we don't show it.
+	 */
+	if (sbi->s_anchor[2] != 0)
+		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
+	/*
+	 * volume, partition, fileset and rootdir seem to be ignored
+	 * currently
+	 */
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
+		seq_puts(seq, ",utf8");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP) && sbi->s_nls_map)
+		seq_printf(seq, ",iocharset=%s", sbi->s_nls_map->charset);
+
+	return 0;
+}
+
 /*
  * udf_parse_options
  *
@@ -339,13 +400,14 @@ static match_table_t tokens = {
 	{Opt_err,	NULL}
 };
 
-static int udf_parse_options(char *options, struct udf_options *uopt)
+static int udf_parse_options(char *options, struct udf_options *uopt,
+			     bool remount)
 {
 	char *p;
 	int option;
 
 	uopt->novrs = 0;
-	uopt->blocksize = 2048;
+	uopt->blocksize = UDF_DEFAULT_BLOCKSIZE;
 	uopt->partition = 0xFFFF;
 	uopt->session = 0xFFFFFFFF;
 	uopt->lastblock = 0;
@@ -415,11 +477,15 @@ static int udf_parse_options(char *optio
 			if (match_int(args, &option))
 				return 0;
 			uopt->session = option;
+			if (!remount)
+				uopt->flags |= (1 << UDF_FLAG_SESSION_SET);
 			break;
 		case Opt_lastblock:
 			if (match_int(args, &option))
 				return 0;
 			uopt->lastblock = option;
+			if (!remount)
+				uopt->flags |= (1 << UDF_FLAG_LASTBLOCK_SET);
 			break;
 		case Opt_anchor:
 			if (match_int(args, &option))
@@ -497,7 +563,7 @@ static int udf_remount_fs(struct super_b
 	uopt.gid   = sbi->s_gid;
 	uopt.umask = sbi->s_umask;
 
-	if (!udf_parse_options(options, &uopt))
+	if (!udf_parse_options(options, &uopt, true))
 		return -EINVAL;
 
 	sbi->s_flags = uopt.flags;
@@ -1679,7 +1745,7 @@ static int udf_fill_super(struct super_b
 
 	mutex_init(&sbi->s_alloc_mutex);
 
-	if (!udf_parse_options((char *)options, &uopt))
+	if (!udf_parse_options((char *)options, &uopt, false))
 		goto error_out;
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
diff -puN fs/udf/udf_sb.h~mount-options-fix-udf fs/udf/udf_sb.h
--- a/fs/udf/udf_sb.h~mount-options-fix-udf
+++ a/fs/udf/udf_sb.h
@@ -26,6 +26,8 @@
 #define UDF_FLAG_GID_IGNORE     14
 #define UDF_FLAG_UID_SET	15
 #define UDF_FLAG_GID_SET	16
+#define UDF_FLAG_SESSION_SET	17
+#define UDF_FLAG_LASTBLOCK_SET	18
 
 #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
 #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002
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
