From: akpm@linux-foundation.org
Subject: [merged] mm-move-shmem-prototypes-to-shmem_fsh.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:18 -0700
Message-ID: <201106282042.p5SKg0RF002949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab1F1UmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mm: move shmem prototypes to shmem_fs.h
has been removed from the -mm tree.  Its filename was
     mm-move-shmem-prototypes-to-shmem_fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move shmem prototypes to shmem_fs.h
From: Hugh Dickins <hughd@google.com>

Before adding any more global entry points into shmem.c, gather such
prototypes into shmem_fs.h.  Remove mm's own declarations from swap.h, but
for now leave the ones in mm.h: because shmem_file_setup() and
shmem_zero_setup() are called from various places, and we should not force
other subsystems to update immediately.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   17 +++++++++++++++++
 include/linux/swap.h     |   10 ----------
 mm/memcontrol.c          |    1 +
 mm/swapfile.c            |    2 +-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff -puN include/linux/shmem_fs.h~mm-move-shmem-prototypes-to-shmem_fsh include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~mm-move-shmem-prototypes-to-shmem_fsh
+++ a/include/linux/shmem_fs.h
@@ -5,6 +5,13 @@
 #include <linux/mempolicy.h>
 #include <linux/percpu_counter.h>
 
+struct page;
+struct file;
+struct inode;
+struct super_block;
+struct user_struct;
+struct vm_area_struct;
+
 /* inode in-kernel data */
 
 #define SHMEM_NR_DIRECT 16
@@ -45,7 +52,17 @@ static inline struct shmem_inode_info *S
 	return container_of(inode, struct shmem_inode_info, vfs_inode);
 }
 
+/*
+ * Functions in mm/shmem.c called directly from elsewhere:
+ */
 extern int init_tmpfs(void);
 extern int shmem_fill_super(struct super_block *sb, void *data, int silent);
+extern struct file *shmem_file_setup(const char *name,
+					loff_t size, unsigned long flags);
+extern int shmem_zero_setup(struct vm_area_struct *);
+extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern int shmem_unuse(swp_entry_t entry, struct page *page);
+extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
+					struct page **pagep, swp_entry_t *ent);
 
 #endif
diff -puN include/linux/swap.h~mm-move-shmem-prototypes-to-shmem_fsh include/linux/swap.h
--- a/include/linux/swap.h~mm-move-shmem-prototypes-to-shmem_fsh
+++ a/include/linux/swap.h
@@ -300,16 +300,6 @@ static inline void scan_unevictable_unre
 extern int kswapd_run(int nid);
 extern void kswapd_stop(int nid);
 
-#ifdef CONFIG_MMU
-/* linux/mm/shmem.c */
-extern int shmem_unuse(swp_entry_t entry, struct page *page);
-#endif /* CONFIG_MMU */
-
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
-					struct page **pagep, swp_entry_t *ent);
-#endif
-
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
diff -puN mm/memcontrol.c~mm-move-shmem-prototypes-to-shmem_fsh mm/memcontrol.c
--- a/mm/memcontrol.c~mm-move-shmem-prototypes-to-shmem_fsh
+++ a/mm/memcontrol.c
@@ -35,6 +35,7 @@
 #include <linux/limits.h>
 #include <linux/mutex.h>
 #include <linux/rbtree.h>
+#include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
diff -puN mm/swapfile.c~mm-move-shmem-prototypes-to-shmem_fsh mm/swapfile.c
--- a/mm/swapfile.c~mm-move-shmem-prototypes-to-shmem_fsh
+++ a/mm/swapfile.c
@@ -14,7 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
-#include <linux/shm.h>
+#include <linux/shmem_fs.h>
 #include <linux/blkdev.h>
 #include <linux/random.h>
 #include <linux/writeback.h>
_

Patches currently in -mm which might be from hughd@google.com are

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
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch

