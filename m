From: akpm@linux-foundation.org
Subject: - shmem-and-simple-const-super_operations.patch removed from -mm tree
Date: Mon, 05 Mar 2007 15:54:57 -0800
Message-ID: <200703052354.l25NsvO7005147@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41905 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498AbXCEXzI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 18:55:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     shmem and simple const super_operations
has been removed from the -mm tree.  Its filename was
     shmem-and-simple-const-super_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: shmem and simple const super_operations
From: Hugh Dickins <hugh@veritas.com>

shmem's super_operations were missed from the recent const-ification;
and simple_fill_super()'s, which can share with get_sb_pseudo()'s.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   10 ++++++----
 mm/shmem.c |    4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/libfs.c~shmem-and-simple-const-super_operations fs/libfs.c
--- a/fs/libfs.c~shmem-and-simple-const-super_operations
+++ a/fs/libfs.c
@@ -190,6 +190,10 @@ const struct inode_operations simple_dir
 	.lookup		= simple_lookup,
 };
 
+static const struct super_operations simple_super_operations = {
+	.statfs		= simple_statfs,
+};
+
 /*
  * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
  * will never be mountable)
@@ -199,7 +203,6 @@ int get_sb_pseudo(struct file_system_typ
 	struct vfsmount *mnt)
 {
 	struct super_block *s = sget(fs_type, NULL, set_anon_super, NULL);
-	static const struct super_operations default_ops = {.statfs = simple_statfs};
 	struct dentry *dentry;
 	struct inode *root;
 	struct qstr d_name = {.name = name, .len = strlen(name)};
@@ -212,7 +215,7 @@ int get_sb_pseudo(struct file_system_typ
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
 	s->s_magic = magic;
-	s->s_op = ops ? ops : &default_ops;
+	s->s_op = ops ? ops : &simple_super_operations;
 	s->s_time_gran = 1;
 	root = new_inode(s);
 	if (!root)
@@ -359,7 +362,6 @@ int simple_commit_write(struct file *fil
 
 int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
 {
-	static struct super_operations s_ops = {.statfs = simple_statfs};
 	struct inode *inode;
 	struct dentry *root;
 	struct dentry *dentry;
@@ -368,7 +370,7 @@ int simple_fill_super(struct super_block
 	s->s_blocksize = PAGE_CACHE_SIZE;
 	s->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	s->s_magic = magic;
-	s->s_op = &s_ops;
+	s->s_op = &simple_super_operations;
 	s->s_time_gran = 1;
 
 	inode = new_inode(s);
diff -puN mm/shmem.c~shmem-and-simple-const-super_operations mm/shmem.c
--- a/mm/shmem.c~shmem-and-simple-const-super_operations
+++ a/mm/shmem.c
@@ -175,7 +175,7 @@ static inline void shmem_unacct_blocks(u
 		vm_unacct_memory(pages * VM_ACCT(PAGE_CACHE_SIZE));
 }
 
-static struct super_operations shmem_ops;
+static const struct super_operations shmem_ops;
 static const struct address_space_operations shmem_aops;
 static const struct file_operations shmem_file_operations;
 static const struct inode_operations shmem_inode_operations;
@@ -2383,7 +2383,7 @@ static const struct inode_operations shm
 #endif
 };
 
-static struct super_operations shmem_ops = {
+static const struct super_operations shmem_ops = {
 	.alloc_inode	= shmem_alloc_inode,
 	.destroy_inode	= shmem_destroy_inode,
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
take-anonymous-pages-off-the-lru-if-we-have-no-swap.patch
free-swap-space-of-reactivated-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rcu-preemptible-rcu-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
