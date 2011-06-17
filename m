From: akpm@linux-foundation.org
Subject: + tmpfs-use-kmemdup-for-short-symlinks.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:40:07 -0700
Message-ID: <201106172340.p5HNe7xu008326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478Ab1FQXkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, penberg@kernel.org, riel@redhat.com


The patch titled
     tmpfs: use kmemdup for short symlinks
has been added to the -mm tree.  Its filename is
     tmpfs-use-kmemdup-for-short-symlinks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
prio_tree-debugging-patch.patch

