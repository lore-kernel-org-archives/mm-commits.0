From: akpm@linux-foundation.org
Subject: [merged] adfs-constify-adfs_dir_ops-structures.patch removed from -mm tree
Date: Mon, 30 Nov 2015 12:34:52 -0800
Message-ID: <565cb2ec.vS9N+Blr09rUEqzE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbK3Uew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 15:34:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: adfs: constify adfs_dir_ops structures
has been removed from the -mm tree.  Its filename was
     adfs-constify-adfs_dir_ops-structures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: adfs: constify adfs_dir_ops structures

The adfs_dir_ops structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h      |    6 +++---
 fs/adfs/dir.c       |    6 +++---
 fs/adfs/dir_f.c     |    2 +-
 fs/adfs/dir_fplus.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/adfs/adfs.h~adfs-constify-adfs_dir_ops-structures fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~adfs-constify-adfs_dir_ops-structures
+++ a/fs/adfs/adfs.h
@@ -45,7 +45,7 @@ struct adfs_dir_ops;
 struct adfs_sb_info {
 	union { struct {
 		struct adfs_discmap *s_map;	/* bh list containing map	 */
-		struct adfs_dir_ops *s_dir;	/* directory operations		 */
+		const struct adfs_dir_ops *s_dir; /* directory operations	 */
 		};
 		struct rcu_head rcu;		/* used only at shutdown time	 */
 	};
@@ -168,8 +168,8 @@ void __adfs_error(struct super_block *sb
 extern const struct inode_operations adfs_dir_inode_operations;
 extern const struct file_operations adfs_dir_operations;
 extern const struct dentry_operations adfs_dentry_operations;
-extern struct adfs_dir_ops adfs_f_dir_ops;
-extern struct adfs_dir_ops adfs_fplus_dir_ops;
+extern const struct adfs_dir_ops adfs_f_dir_ops;
+extern const struct adfs_dir_ops adfs_fplus_dir_ops;
 
 extern int adfs_dir_update(struct super_block *sb, struct object_info *obj,
 			   int wait);
diff -puN fs/adfs/dir.c~adfs-constify-adfs_dir_ops-structures fs/adfs/dir.c
--- a/fs/adfs/dir.c~adfs-constify-adfs_dir_ops-structures
+++ a/fs/adfs/dir.c
@@ -21,7 +21,7 @@ adfs_readdir(struct file *file, struct d
 {
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
-	struct adfs_dir_ops *ops = ADFS_SB(sb)->s_dir;
+	const struct adfs_dir_ops *ops = ADFS_SB(sb)->s_dir;
 	struct object_info obj;
 	struct adfs_dir dir;
 	int ret = 0;
@@ -69,7 +69,7 @@ adfs_dir_update(struct super_block *sb,
 {
 	int ret = -EINVAL;
 #ifdef CONFIG_ADFS_FS_RW
-	struct adfs_dir_ops *ops = ADFS_SB(sb)->s_dir;
+	const struct adfs_dir_ops *ops = ADFS_SB(sb)->s_dir;
 	struct adfs_dir dir;
 
 	printk(KERN_INFO "adfs_dir_update: object %06X in dir %06X\n",
@@ -129,7 +129,7 @@ static int
 adfs_dir_lookup_byname(struct inode *inode, struct qstr *name, struct object_info *obj)
 {
 	struct super_block *sb = inode->i_sb;
-	struct adfs_dir_ops *ops = ADFS_SB(sb)->s_dir;
+	const struct adfs_dir_ops *ops = ADFS_SB(sb)->s_dir;
 	struct adfs_dir dir;
 	int ret;
 
diff -puN fs/adfs/dir_f.c~adfs-constify-adfs_dir_ops-structures fs/adfs/dir_f.c
--- a/fs/adfs/dir_f.c~adfs-constify-adfs_dir_ops-structures
+++ a/fs/adfs/dir_f.c
@@ -476,7 +476,7 @@ adfs_f_free(struct adfs_dir *dir)
 	dir->sb = NULL;
 }
 
-struct adfs_dir_ops adfs_f_dir_ops = {
+const struct adfs_dir_ops adfs_f_dir_ops = {
 	.read		= adfs_f_read,
 	.setpos		= adfs_f_setpos,
 	.getnext	= adfs_f_getnext,
diff -puN fs/adfs/dir_fplus.c~adfs-constify-adfs_dir_ops-structures fs/adfs/dir_fplus.c
--- a/fs/adfs/dir_fplus.c~adfs-constify-adfs_dir_ops-structures
+++ a/fs/adfs/dir_fplus.c
@@ -256,7 +256,7 @@ adfs_fplus_free(struct adfs_dir *dir)
 	dir->sb = NULL;
 }
 
-struct adfs_dir_ops adfs_fplus_dir_ops = {
+const struct adfs_dir_ops adfs_fplus_dir_ops = {
 	.read		= adfs_fplus_read,
 	.setpos		= adfs_fplus_setpos,
 	.getnext	= adfs_fplus_getnext,
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are


