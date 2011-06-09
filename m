From: akpm@linux-foundation.org
Subject: + mm-move-shmem-prototypes-to-shmem_fsh.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:21 -0700
Message-ID: <201106092242.p59MgLVf005027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab1FIWq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:46:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hch@infradead.org


The patch titled
     mm: move shmem prototypes to shmem_fs.h
has been added to the -mm tree.  Its filename is
     mm-move-shmem-prototypes-to-shmem_fsh.patch

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
@@ -302,16 +302,6 @@ static inline void scan_unevictable_unre
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

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

