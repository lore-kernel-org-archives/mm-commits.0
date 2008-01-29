From: akpm@linux-foundation.org
Subject: + mount-options-fix-adfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:01 -0800
Message-ID: <200801292322.m0TNM1Pd009656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849AbYA2XWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, rmk+kernel@arm.linux.org.uk


The patch titled
     mount options: fix adfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-adfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
