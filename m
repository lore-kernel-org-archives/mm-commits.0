From: akpm@linux-foundation.org
Subject: - reiserfs-shrink-superblock-if-no-xattrs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:11 -0700
Message-ID: <200705090245.l492jBJJ008713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969574AbXEICpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, reiserfs-dev@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: shrink superblock if no xattrs
has been removed from the -mm tree.  Its filename was
     reiserfs-shrink-superblock-if-no-xattrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: shrink superblock if no xattrs
From: Alexey Dobriyan <adobriyan@gmail.com>

This makes in-core superblock fit into one cacheline here.

Before:
    struct dentry *            xattr_root;           /*   124     4 */
    /* --- cacheline 1 boundary (128 bytes) --- */
    struct rw_semaphore        xattr_dir_sem;        /*   128    12 */
    int                        j_errno;              /*   140     4 */
    }; /* size: 144, cachelines: 2 */
       /* sum members: 142, holes: 1, sum holes: 2 */
       /* last cacheline: 16 bytes */

After:
    int                        j_errno;              /*   124     4 */
    /* --- cacheline 1 boundary (128 bytes) --- */
    }; /* size: 128, cachelines: 1 */
       /* sum members: 126, holes: 1, sum holes: 2 */

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <reiserfs-dev@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c            |    6 ++++--
 include/linux/reiserfs_fs_sb.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/reiserfs/super.c~reiserfs-shrink-superblock-if-no-xattrs fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-shrink-superblock-if-no-xattrs
+++ a/fs/reiserfs/super.c
@@ -433,12 +433,13 @@ int remove_save_link(struct inode *inode
 static void reiserfs_kill_sb(struct super_block *s)
 {
 	if (REISERFS_SB(s)) {
+#ifdef CONFIG_REISERFS_FS_XATTR
 		if (REISERFS_SB(s)->xattr_root) {
 			d_invalidate(REISERFS_SB(s)->xattr_root);
 			dput(REISERFS_SB(s)->xattr_root);
 			REISERFS_SB(s)->xattr_root = NULL;
 		}
-
+#endif
 		if (REISERFS_SB(s)->priv_root) {
 			d_invalidate(REISERFS_SB(s)->priv_root);
 			dput(REISERFS_SB(s)->priv_root);
@@ -1562,9 +1563,10 @@ static int reiserfs_fill_super(struct su
 	REISERFS_SB(s)->s_alloc_options.preallocmin = 0;
 	/* Preallocate by 16 blocks (17-1) at once */
 	REISERFS_SB(s)->s_alloc_options.preallocsize = 17;
+#ifdef CONFIG_REISERFS_FS_XATTR
 	/* Initialize the rwsem for xattr dir */
 	init_rwsem(&REISERFS_SB(s)->xattr_dir_sem);
-
+#endif
 	/* setup default block allocator options */
 	reiserfs_init_alloc_options(s);
 
diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-shrink-superblock-if-no-xattrs include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-shrink-superblock-if-no-xattrs
+++ a/include/linux/reiserfs_fs_sb.h
@@ -401,9 +401,10 @@ struct reiserfs_sb_info {
 	int reserved_blocks;	/* amount of blocks reserved for further allocations */
 	spinlock_t bitmap_lock;	/* this lock on now only used to protect reserved_blocks variable */
 	struct dentry *priv_root;	/* root of /.reiserfs_priv */
+#ifdef CONFIG_REISERFS_FS_XATTR
 	struct dentry *xattr_root;	/* root of /.reiserfs_priv/.xa */
 	struct rw_semaphore xattr_dir_sem;
-
+#endif
 	int j_errno;
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
pata_scc-fix-compilation.patch
git-parisc.patch
git-scsi-misc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
