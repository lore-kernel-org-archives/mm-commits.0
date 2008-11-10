From: akpm@linux-foundation.org
Subject: - fat-fix-cleanup-dcache-handling-for-vfat.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:27 -0800
Message-ID: <200811102033.mAAKXR2N024493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbYKJUin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Fix/Cleanup dcache handling for vfat
has been removed from the -mm tree.  Its filename was
     fat-fix-cleanup-dcache-handling-for-vfat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Fix/Cleanup dcache handling for vfat
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

- Add comments for handling dcache of vfat.

- Separate case-sensitive case and case-insensitive to
  vfat_revalidate() and vfat_ci_revalidate().

  vfat_revalidate() doesn't need to drop case-insensitive negative
  dentry on creation path.

- Current code is missing to set ->d_revalidate to the negative dentry
  created by unlink/etc..

  This sets ->d_revalidate always, and returns 1 for positive
  dentry. Now, we don't need to change ->d_op dynamically anymore,
  so this just uses sb->s_root->d_op to set ->d_op.

- d_find_alias() may return DCACHE_DISCONNECTED dentry. It's not
  the interesting dentry there. This checks it.

- Add missing LOOKUP_PARENT check. We don't need to drop the valid
  negative dentry for (LOOKUP_CREATE | LOOKUP_PARENT) lookup.

- For consistent filename on creation path, this drops negative dentry
  if we can't see intent.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |  124 +++++++++++++++++++++++++++---------------
 1 file changed, 80 insertions(+), 44 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-fix-cleanup-dcache-handling-for-vfat fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-fix-cleanup-dcache-handling-for-vfat
+++ a/fs/fat/namei_vfat.c
@@ -24,27 +24,67 @@
 #include <linux/namei.h>
 #include "fat.h"
 
-static int vfat_revalidate(struct dentry *dentry, struct nameidata *nd)
+/*
+ * If new entry was created in the parent, it could create the 8.3
+ * alias (the shortname of logname).  So, the parent may have the
+ * negative-dentry which matches the created 8.3 alias.
+ *
+ * If it happened, the negative dentry isn't actually negative
+ * anymore.  So, drop it.
+ */
+static int vfat_revalidate_shortname(struct dentry *dentry)
 {
 	int ret = 1;
-
-	if (!dentry->d_inode &&
-	    nd && !(nd->flags & LOOKUP_CONTINUE) && (nd->flags & LOOKUP_CREATE))
-		/*
-		 * negative dentry is dropped, in order to make sure
-		 * to use the name which a user desires if this is
-		 * create path.
-		 */
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_time != dentry->d_parent->d_inode->i_version)
 		ret = 0;
-	else {
-		spin_lock(&dentry->d_lock);
-		if (dentry->d_time != dentry->d_parent->d_inode->i_version)
-			ret = 0;
-		spin_unlock(&dentry->d_lock);
-	}
+	spin_unlock(&dentry->d_lock);
 	return ret;
 }
 
+static int vfat_revalidate(struct dentry *dentry, struct nameidata *nd)
+{
+	/* This is not negative dentry. Always valid. */
+	if (dentry->d_inode)
+		return 1;
+	return vfat_revalidate_shortname(dentry);
+}
+
+static int vfat_revalidate_ci(struct dentry *dentry, struct nameidata *nd)
+{
+	/*
+	 * This is not negative dentry. Always valid.
+	 *
+	 * Note, rename() to existing directory entry will have ->d_inode,
+	 * and will use existing name which isn't specified name by user.
+	 *
+	 * We may be able to drop this positive dentry here. But dropping
+	 * positive dentry isn't good idea. So it's unsupported like
+	 * rename("filename", "FILENAME") for now.
+	 */
+	if (dentry->d_inode)
+		return 1;
+
+	/*
+	 * This may be nfsd (or something), anyway, we can't see the
+	 * intent of this. So, since this can be for creation, drop it.
+	 */
+	if (!nd)
+		return 0;
+
+	/*
+	 * Drop the negative dentry, in order to make sure to use the
+	 * case sensitive name which is specified by user if this is
+	 * for creation.
+	 */
+	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+		if (nd->flags & LOOKUP_CREATE)
+			return 0;
+	}
+
+	return vfat_revalidate_shortname(dentry);
+}
+
 /* returns the length of a struct qstr, ignoring trailing dots */
 static unsigned int vfat_striptail_len(struct qstr *qstr)
 {
@@ -126,25 +166,16 @@ static int vfat_cmp(struct dentry *dentr
 	return 1;
 }
 
-static struct dentry_operations vfat_dentry_ops[4] = {
-	{
-		.d_hash		= vfat_hashi,
-		.d_compare	= vfat_cmpi,
-	},
-	{
-		.d_revalidate	= vfat_revalidate,
-		.d_hash		= vfat_hashi,
-		.d_compare	= vfat_cmpi,
-	},
-	{
-		.d_hash		= vfat_hash,
-		.d_compare	= vfat_cmp,
-	},
-	{
-		.d_revalidate	= vfat_revalidate,
-		.d_hash		= vfat_hash,
-		.d_compare	= vfat_cmp,
-	}
+static struct dentry_operations vfat_ci_dentry_ops = {
+	.d_revalidate	= vfat_revalidate_ci,
+	.d_hash		= vfat_hashi,
+	.d_compare	= vfat_cmpi,
+};
+
+static struct dentry_operations vfat_dentry_ops = {
+	.d_revalidate	= vfat_revalidate,
+	.d_hash		= vfat_hash,
+	.d_compare	= vfat_cmp,
 };
 
 /* Characters that are undesirable in an MS-DOS file name */
@@ -685,29 +716,35 @@ static struct dentry *vfat_lookup(struct
 	struct fat_slot_info sinfo;
 	struct inode *inode;
 	struct dentry *alias;
-	int err, table;
+	int err;
 
 	lock_super(sb);
-	table = (MSDOS_SB(sb)->options.name_check == 's') ? 2 : 0;
-	dentry->d_op = &vfat_dentry_ops[table];
 
 	err = vfat_find(dir, &dentry->d_name, &sinfo);
 	if (err) {
 		if (err == -ENOENT) {
-			table++;
 			inode = NULL;
 			goto out;
 		}
 		goto error;
 	}
+
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		goto error;
 	}
+
 	alias = d_find_alias(inode);
-	if (alias) {
+	if (alias && !(alias->d_flags & DCACHE_DISCONNECTED)) {
+		/*
+		 * This inode has non DCACHE_DISCONNECTED dentry. This
+		 * means, the user did ->lookup() by an another name
+		 * (longname vs 8.3 alias of it) in past.
+		 *
+		 * Switch to new one for reason of locality if possible.
+		 */
 		if (d_invalidate(alias) == 0)
 			dput(alias);
 		else {
@@ -715,15 +752,14 @@ static struct dentry *vfat_lookup(struct
 			unlock_super(sb);
 			return alias;
 		}
-
 	}
 out:
 	unlock_super(sb);
-	dentry->d_op = &vfat_dentry_ops[table];
+	dentry->d_op = sb->s_root->d_op;
 	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	dentry = d_splice_alias(inode, dentry);
 	if (dentry) {
-		dentry->d_op = &vfat_dentry_ops[table];
+		dentry->d_op = sb->s_root->d_op;
 		dentry->d_time = dentry->d_parent->d_inode->i_version;
 	}
 	return dentry;
@@ -1022,9 +1058,9 @@ static int vfat_fill_super(struct super_
 		return res;
 
 	if (MSDOS_SB(sb)->options.name_check != 's')
-		sb->s_root->d_op = &vfat_dentry_ops[0];
+		sb->s_root->d_op = &vfat_ci_dentry_ops;
 	else
-		sb->s_root->d_op = &vfat_dentry_ops[2];
+		sb->s_root->d_op = &vfat_dentry_ops;
 
 	return 0;
 }
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

