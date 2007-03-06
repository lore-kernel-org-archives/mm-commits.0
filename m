From: akpm@linux-foundation.org
Subject: - inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:59:40 -0800
Message-ID: <200703060159.l261xeYs008619@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965638AbXCFB7o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     inode_diet: Replace inode.u.generic_ip with inode.i_private
has been removed from the -mm tree.  Its filename was
     inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: inode_diet: Replace inode.u.generic_ip with inode.i_private
From: "Theodore Ts'o" <tytso@mit.edu>

The filesystem or device-specific pointer in the inode is inside a union,
which is pretty pointless given that all 30+ users of this field have been
using the void pointer.  Get rid of the union and rename it to i_private, with
a comment to explain who is allowed to use the void pointer.  This is just a
cleanup, but it allows us to reuse the union 'u' for something something where
the union will actually be used.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/inode.h                   |    2 +-
 fs/reiser4/plugin/file/symlink.c     |   14 +++++++-------
 fs/reiser4/plugin/inode_ops.c        |    6 +++---
 fs/reiser4/plugin/item/static_stat.c |   18 +++++++++---------
 4 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/reiser4/inode.h~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4 fs/reiser4/inode.h
--- a/fs/reiser4/inode.h~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4
+++ a/fs/reiser4/inode.h
@@ -41,7 +41,7 @@ typedef enum {
 	REISER4_IMMUTABLE = 2,
 	/* inode was read from storage */
 	REISER4_LOADED = 3,
-	/* this bit is set for symlinks. inode->u.generic_ip points to target
+	/* this bit is set for symlinks. inode->i_private points to target
 	   name of symlink. */
 	REISER4_GENERIC_PTR_USED = 4,
 	/* set if size of stat-data item for this inode is known. If this is
diff -puN fs/reiser4/plugin/file/symlink.c~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4 fs/reiser4/plugin/file/symlink.c
--- a/fs/reiser4/plugin/file/symlink.c~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4
+++ a/fs/reiser4/plugin/file/symlink.c
@@ -42,8 +42,8 @@ int create_symlink(struct inode *symlink
 	 */
 	reiser4_inode_data(symlink)->extmask |= (1 << SYMLINK_STAT);
 
-	assert("vs-838", symlink->u.generic_ip == NULL);
-	symlink->u.generic_ip = (void *)data->name;
+	assert("vs-838", symlink->i_private == NULL);
+	symlink->i_private = (void *)data->name;
 
 	assert("vs-843", symlink->i_size == 0);
 	INODE_SET_FIELD(symlink, i_size, strlen(data->name));
@@ -51,14 +51,14 @@ int create_symlink(struct inode *symlink
 	/* insert stat data appended with data->name */
 	result = inode_file_plugin(symlink)->write_sd_by_inode(symlink);
 	if (result) {
-		/* FIXME-VS: Make sure that symlink->u.generic_ip is not attached
+		/* FIXME-VS: Make sure that symlink->i_private is not attached
 		   to kmalloced data */
 		INODE_SET_FIELD(symlink, i_size, 0);
 	} else {
-		assert("vs-849", symlink->u.generic_ip
+		assert("vs-849", symlink->i_private
 		       && inode_get_flag(symlink, REISER4_GENERIC_PTR_USED));
 		assert("vs-850",
-		       !memcmp((char *)symlink->u.generic_ip, data->name,
+		       !memcmp((char *)symlink->i_private, data->name,
 			       (size_t) symlink->i_size + 1));
 	}
 	return result;
@@ -76,8 +76,8 @@ void destroy_inode_symlink(struct inode 
 	assert("edward-801", inode_get_flag(inode, REISER4_GENERIC_PTR_USED));
 	assert("vs-839", S_ISLNK(inode->i_mode));
 
-	kfree(inode->u.generic_ip);
-	inode->u.generic_ip = NULL;
+	kfree(inode->i_private);
+	inode->i_private = NULL;
 	inode_clr_flag(inode, REISER4_GENERIC_PTR_USED);
 }
 
diff -puN fs/reiser4/plugin/inode_ops.c~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4 fs/reiser4/plugin/inode_ops.c
--- a/fs/reiser4/plugin/inode_ops.c~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4
+++ a/fs/reiser4/plugin/inode_ops.c
@@ -389,16 +389,16 @@ int mknod_common(struct inode *parent, s
  *
  * This is common implementation of vfs's followlink method of struct
  * inode_operations.
- * Assumes that inode's generic_ip points to the content of symbolic link.
+ * Assumes that inode's i_private points to the content of symbolic link.
  */
 void *follow_link_common(struct dentry *dentry, struct nameidata *nd)
 {
 	assert("vs-851", S_ISLNK(dentry->d_inode->i_mode));
 
-	if (!dentry->d_inode->u.generic_ip
+	if (!dentry->d_inode->i_private
 	    || !inode_get_flag(dentry->d_inode, REISER4_GENERIC_PTR_USED))
 		return ERR_PTR(RETERR(-EINVAL));
-	nd_set_link(nd, dentry->d_inode->u.generic_ip);
+	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;
 }
 
diff -puN fs/reiser4/plugin/item/static_stat.c~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4 fs/reiser4/plugin/item/static_stat.c
--- a/fs/reiser4/plugin/item/static_stat.c~inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4
+++ a/fs/reiser4/plugin/item/static_stat.c
@@ -430,21 +430,21 @@ save_large_times_sd(struct inode *inode 
 
 /* symlink stat data extension */
 
-/* allocate memory for symlink target and attach it to inode->u.generic_ip */
+/* allocate memory for symlink target and attach it to inode->i_private */
 static int
 symlink_target_to_inode(struct inode *inode, const char *target, int len)
 {
-	assert("vs-845", inode->u.generic_ip == NULL);
+	assert("vs-845", inode->i_private == NULL);
 	assert("vs-846", !inode_get_flag(inode, REISER4_GENERIC_PTR_USED));
 
 	/* FIXME-VS: this is prone to deadlock. Not more than other similar
 	   places, though */
-	inode->u.generic_ip = kmalloc((size_t) len + 1, get_gfp_mask());
-	if (!inode->u.generic_ip)
+	inode->i_private = kmalloc((size_t) len + 1, get_gfp_mask());
+	if (!inode->i_private)
 		return RETERR(-ENOMEM);
 
-	memcpy((char *)(inode->u.generic_ip), target, (size_t) len);
-	((char *)(inode->u.generic_ip))[len] = 0;
+	memcpy((char *)(inode->i_private), target, (size_t) len);
+	((char *)(inode->i_private))[len] = 0;
 	inode_set_flag(inode, REISER4_GENERIC_PTR_USED);
 	return 0;
 }
@@ -499,8 +499,8 @@ static int save_symlink_sd(struct inode 
 	if (!inode_get_flag(inode, REISER4_GENERIC_PTR_USED)) {
 		const char *target;
 
-		target = (const char *)(inode->u.generic_ip);
-		inode->u.generic_ip = NULL;
+		target = (const char *)(inode->i_private);
+		inode->i_private = NULL;
 
 		result = symlink_target_to_inode(inode, target, length);
 
@@ -510,7 +510,7 @@ static int save_symlink_sd(struct inode 
 	} else {
 		/* there is nothing to do in update but move area */
 		assert("vs-844",
-		       !memcmp(inode->u.generic_ip, sd->body,
+		       !memcmp(inode->i_private, sd->body,
 			       (size_t) length + 1));
 	}
 
_

Patches currently in -mm which might be from tytso@mit.edu are

reiser4.patch
inode_diet-replace-inodeugeneric_ip-with-inodei_private-reiser4.patch
inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default-reiser4.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
