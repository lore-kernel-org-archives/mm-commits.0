From: akpm@linux-foundation.org
Subject: [merged] tmpfs-use-kmemdup-for-short-symlinks.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:22 -0700
Message-ID: <201108161848.p7GImTR0015326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPStF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, penberg@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: use kmemdup for short symlinks
has been removed from the -mm tree.  Its filename was
     tmpfs-use-kmemdup-for-short-symlinks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: use kmemdup for short symlinks
From: Hugh Dickins <hughd@google.com>

But we've not yet removed the old swp_entry_t i_direct[16] from
shmem_inode_info.  That's because it was still being shared with the
inline symlink.  Remove it now (saving 64 or 128 bytes from shmem inode
size), and use kmemdup() for short symlinks, say, those up to 128 bytes.

I wonder why mpol_free_shared_policy() is done in shmem_destroy_inode()
rather than shmem_evict_inode(), where we usually do such freeing?  I
guess it doesn't matter, and I'm not into NUMA mpol testing right now.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   11 +++--------
 mm/shmem.c               |   31 ++++++++++++++++++-------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-use-kmemdup-for-short-symlinks include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-use-kmemdup-for-short-symlinks
+++ a/include/linux/shmem_fs.h
@@ -8,20 +8,15 @@
 
 /* inode in-kernel data */
 
-#define SHMEM_NR_DIRECT 16
-
-#define SHMEM_SYMLINK_INLINE_LEN (SHMEM_NR_DIRECT * sizeof(swp_entry_t))
-
 struct shmem_inode_info {
 	spinlock_t		lock;
 	unsigned long		flags;
 	unsigned long		alloced;	/* data pages alloced to file */
-	unsigned long		swapped;	/* subtotal assigned to swap */
-	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	union {
-		swp_entry_t	i_direct[SHMEM_NR_DIRECT]; /* first blocks */
-		char		inline_symlink[SHMEM_SYMLINK_INLINE_LEN];
+		unsigned long	swapped;	/* subtotal assigned to swap */
+		char		*symlink;	/* unswappable short symlink */
 	};
+	struct shared_policy	policy;		/* NUMA memory alloc policy */
 	struct list_head	swaplist;	/* chain of maybes on swap */
 	struct list_head	xattr_list;	/* list of shmem_xattr */
 	struct inode		vfs_inode;
diff -puN mm/shmem.c~tmpfs-use-kmemdup-for-short-symlinks mm/shmem.c
--- a/mm/shmem.c~tmpfs-use-kmemdup-for-short-symlinks
+++ a/mm/shmem.c
@@ -73,6 +73,9 @@ static struct vfsmount *shm_mnt;
 /* Pretend that each entry is of this size in directory's i_size */
 #define BOGO_DIRENT_SIZE 20
 
+/* Symlink up to this size is kmalloc'ed instead of using a swappable page */
+#define SHORT_SYMLINK_LEN 128
+
 struct shmem_xattr {
 	struct list_head list;	/* anchored by shmem_inode_info->xattr_list */
 	char *name;		/* xattr name */
@@ -585,7 +588,8 @@ static void shmem_evict_inode(struct ino
 			list_del_init(&info->swaplist);
 			mutex_unlock(&shmem_swaplist_mutex);
 		}
-	}
+	} else
+		kfree(info->symlink);
 
 	list_for_each_entry_safe(xattr, nxattr, &info->xattr_list, list) {
 		kfree(xattr->name);
@@ -1173,7 +1177,7 @@ static struct inode *shmem_get_inode(str
 
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
-static const struct inode_operations shmem_symlink_inline_operations;
+static const struct inode_operations shmem_short_symlink_operations;
 
 static int
 shmem_write_begin(struct file *file, struct address_space *mapping,
@@ -1638,10 +1642,13 @@ static int shmem_symlink(struct inode *d
 
 	info = SHMEM_I(inode);
 	inode->i_size = len-1;
-	if (len <= SHMEM_SYMLINK_INLINE_LEN) {
-		/* do it inline */
-		memcpy(info->inline_symlink, symname, len);
-		inode->i_op = &shmem_symlink_inline_operations;
+	if (len <= SHORT_SYMLINK_LEN) {
+		info->symlink = kmemdup(symname, len, GFP_KERNEL);
+		if (!info->symlink) {
+			iput(inode);
+			return -ENOMEM;
+		}
+		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		error = shmem_getpage(inode, 0, &page, SGP_WRITE, NULL);
 		if (error) {
@@ -1664,9 +1671,9 @@ static int shmem_symlink(struct inode *d
 	return 0;
 }
 
-static void *shmem_follow_link_inline(struct dentry *dentry, struct nameidata *nd)
+static void *shmem_follow_short_symlink(struct dentry *dentry, struct nameidata *nd)
 {
-	nd_set_link(nd, SHMEM_I(dentry->d_inode)->inline_symlink);
+	nd_set_link(nd, SHMEM_I(dentry->d_inode)->symlink);
 	return NULL;
 }
 
@@ -1914,9 +1921,9 @@ static ssize_t shmem_listxattr(struct de
 }
 #endif /* CONFIG_TMPFS_XATTR */
 
-static const struct inode_operations shmem_symlink_inline_operations = {
+static const struct inode_operations shmem_short_symlink_operations = {
 	.readlink	= generic_readlink,
-	.follow_link	= shmem_follow_link_inline,
+	.follow_link	= shmem_follow_short_symlink,
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,
 	.getxattr	= shmem_getxattr,
@@ -2259,10 +2266,8 @@ static void shmem_destroy_callback(struc
 
 static void shmem_destroy_inode(struct inode *inode)
 {
-	if ((inode->i_mode & S_IFMT) == S_IFREG) {
-		/* only struct inode is valid if it's an inline symlink */
+	if ((inode->i_mode & S_IFMT) == S_IFREG)
 		mpol_free_shared_policy(&SHMEM_I(inode)->policy);
-	}
 	call_rcu(&inode->i_rcu, shmem_destroy_callback);
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch
prio_tree-debugging-patch.patch

