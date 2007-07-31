From: akpm@linux-foundation.org
Subject: + ufs-implement-show_options.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:33:18 -0700
Message-ID: <200707310133.l6V1XIW1008619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758721AbXGaBdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dushistov@mail.ru, rdunlap@xenotime.net


The patch titled
     ufs: implement show_options
has been added to the -mm tree.  Its filename is
     ufs-implement-show_options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ufs: implement show_options
From: Evgeniy Dushistov <dushistov@mail.ru>

An implementation of show_options method for UFS.

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff -puN fs/ufs/super.c~ufs-implement-show_options fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-implement-show_options
+++ a/fs/ufs/super.c
@@ -88,6 +88,8 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/log2.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
 
 #include "swab.h"
 #include "util.h"
@@ -286,10 +288,21 @@ void ufs_warning (struct super_block * s
 }
 
 enum {
-	Opt_type_old, Opt_type_sunx86, Opt_type_sun, Opt_type_sunos, Opt_type_44bsd,
-	Opt_type_ufs2, Opt_type_hp, Opt_type_nextstepcd, Opt_type_nextstep,
-	Opt_type_openstep, Opt_onerror_panic, Opt_onerror_lock,
-	Opt_onerror_umount, Opt_onerror_repair, Opt_err
+       Opt_type_old = UFS_MOUNT_UFSTYPE_OLD,
+       Opt_type_sunx86 = UFS_MOUNT_UFSTYPE_SUNx86,
+       Opt_type_sun = UFS_MOUNT_UFSTYPE_SUN,
+       Opt_type_sunos = UFS_MOUNT_UFSTYPE_SUNOS,
+       Opt_type_44bsd = UFS_MOUNT_UFSTYPE_44BSD,
+       Opt_type_ufs2 = UFS_MOUNT_UFSTYPE_UFS2,
+       Opt_type_hp = UFS_MOUNT_UFSTYPE_HP,
+       Opt_type_nextstepcd = UFS_MOUNT_UFSTYPE_NEXTSTEP_CD,
+       Opt_type_nextstep = UFS_MOUNT_UFSTYPE_NEXTSTEP,
+       Opt_type_openstep = UFS_MOUNT_UFSTYPE_OPENSTEP,
+       Opt_onerror_panic = UFS_MOUNT_ONERROR_PANIC,
+       Opt_onerror_lock = UFS_MOUNT_ONERROR_LOCK,
+       Opt_onerror_umount = UFS_MOUNT_ONERROR_UMOUNT,
+       Opt_onerror_repair = UFS_MOUNT_ONERROR_REPAIR,
+       Opt_err
 };
 
 static match_table_t tokens = {
@@ -304,6 +317,7 @@ static match_table_t tokens = {
 	{Opt_type_nextstepcd, "ufstype=nextstep-cd"},
 	{Opt_type_nextstep, "ufstype=nextstep"},
 	{Opt_type_openstep, "ufstype=openstep"},
+/*end of possible ufs types */
 	{Opt_onerror_panic, "onerror=panic"},
 	{Opt_onerror_lock, "onerror=lock"},
 	{Opt_onerror_umount, "onerror=umount"},
@@ -1209,6 +1223,26 @@ static int ufs_remount (struct super_blo
 	return 0;
 }
 
+static int ufs_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	struct ufs_sb_info *sbi = UFS_SB(vfs->mnt_sb);
+	unsigned mval = sbi->s_mount_opt & UFS_MOUNT_UFSTYPE;
+	struct match_token *tp = tokens;
+
+	while (tp->token != Opt_onerror_panic && tp->token != mval)
+		++tp;
+	BUG_ON(tp->token == Opt_onerror_panic);
+	seq_printf(seq, ",%s", tp->pattern);
+
+	mval = sbi->s_mount_opt & UFS_MOUNT_ONERROR;
+	while (tp->token != Opt_err && tp->token != mval)
+		++tp;
+	BUG_ON(tp->token == Opt_err);
+	seq_printf(seq, ",%s", tp->pattern);
+
+	return 0;
+}
+
 static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -1301,6 +1335,7 @@ static const struct super_operations ufs
 	.write_super	= ufs_write_super,
 	.statfs		= ufs_statfs,
 	.remount_fs	= ufs_remount,
+	.show_options   = ufs_show_options,
 #ifdef CONFIG_QUOTA
 	.quota_read	= ufs_quota_read,
 	.quota_write	= ufs_quota_write,
_

Patches currently in -mm which might be from dushistov@mail.ru are

ufs-convert-to-new-aops.patch
add-in-sunos-41x-compatible-mode-for-ufs.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
ufs-implement-show_options.patch
