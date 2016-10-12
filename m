From: akpm@linux-foundation.org
Subject: [merged]
 mm-split-gfp_mask-and-mapping-flags-into-separate-fields.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:26:41 -0700
Message-ID: <57fe8e71.aqtrgBTzsoLARvQU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755948AbcJLT1l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: split gfp_mask and mapping flags into separate fields
has been removed from the -mm tree.  Its filename was
     mm-split-gfp_mask-and-mapping-flags-into-separate-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: split gfp_mask and mapping flags into separate fields

mapping->flags currently encodes two different things into a single flag. 
It contains sticky gfp_mask for page cache allocations and AS_ codes used
to report errors/enospace and other states which are mapping specific. 
Condensing the two semantically unrelated things saves few bytes but it
also complicates other things.  For one thing the gfp flags space is
reduced and in fact we are already running out of available bits.  It can
be assumed that more gfp flags will be necessary later on.

To not introduce the address_space grow (at least on x86_64) we can stick
it right after private_lock because we have a hole there.

struct address_space {
        struct inode *             host;                 /*     0     8 */
        struct radix_tree_root     page_tree;            /*     8    16 */
        spinlock_t                 tree_lock;            /*    24     4 */
        atomic_t                   i_mmap_writable;      /*    28     4 */
        struct rb_root             i_mmap;               /*    32     8 */
        struct rw_semaphore        i_mmap_rwsem;         /*    40    40 */
        /* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
        long unsigned int          nrpages;              /*    80     8 */
        long unsigned int          nrexceptional;        /*    88     8 */
        long unsigned int          writeback_index;      /*    96     8 */
        const struct address_space_operations  * a_ops;  /*   104     8 */
        long unsigned int          flags;                /*   112     8 */
        spinlock_t                 private_lock;         /*   120     4 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 2 boundary (128 bytes) --- */
        struct list_head           private_list;         /*   128    16 */
        void *                     private_data;         /*   144     8 */

        /* size: 152, cachelines: 3, members: 14 */
        /* sum members: 148, holes: 1, sum holes: 4 */
        /* last cacheline: 24 bytes */
};

Link: http://lkml.kernel.org/r/20160912114852.GI14524@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h      |    3 ++-
 include/linux/pagemap.h |   20 +++++++++-----------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff -puN include/linux/fs.h~mm-split-gfp_mask-and-mapping-flags-into-separate-fields include/linux/fs.h
--- a/include/linux/fs.h~mm-split-gfp_mask-and-mapping-flags-into-separate-fields
+++ a/include/linux/fs.h
@@ -440,8 +440,9 @@ struct address_space {
 	unsigned long		nrexceptional;
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
-	unsigned long		flags;		/* error bits/gfp mask */
+	unsigned long		flags;		/* error bits */
 	spinlock_t		private_lock;	/* for use by the address_space */
+	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
 	struct list_head	private_list;	/* ditto */
 	void			*private_data;	/* ditto */
 } __attribute__((aligned(sizeof(long))));
diff -puN include/linux/pagemap.h~mm-split-gfp_mask-and-mapping-flags-into-separate-fields include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-split-gfp_mask-and-mapping-flags-into-separate-fields
+++ a/include/linux/pagemap.h
@@ -16,17 +16,16 @@
 #include <linux/hugetlb_inline.h>
 
 /*
- * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
- * allocation mode flags.
+ * Bits in mapping->flags.
  */
 enum mapping_flags {
-	AS_EIO		= __GFP_BITS_SHIFT + 0,	/* IO error on async write */
-	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
-	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
-	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
-	AS_EXITING	= __GFP_BITS_SHIFT + 4, /* final truncate in progress */
+	AS_EIO		= 0,	/* IO error on async write */
+	AS_ENOSPC	= 1,	/* ENOSPC on async write */
+	AS_MM_ALL_LOCKS	= 2,	/* under mm_take_all_locks() */
+	AS_UNEVICTABLE	= 3,	/* e.g., ramdisk, SHM_LOCK */
+	AS_EXITING	= 4, 	/* final truncate in progress */
 	/* writeback related tags are not used */
-	AS_NO_WRITEBACK_TAGS = __GFP_BITS_SHIFT + 5,
+	AS_NO_WRITEBACK_TAGS = 5,
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
@@ -78,7 +77,7 @@ static inline int mapping_use_writeback_
 
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
-	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
+	return mapping->gfp_mask;
 }
 
 /* Restricts the given gfp_mask to what the mapping allows. */
@@ -94,8 +93,7 @@ static inline gfp_t mapping_gfp_constrai
  */
 static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 {
-	m->flags = (m->flags & ~(__force unsigned long)__GFP_BITS_MASK) |
-				(__force unsigned long)mask;
+	m->gfp_mask = mask;
 }
 
 void release_pages(struct page **pages, int nr, bool cold);
_

Patches currently in -mm which might be from mhocko@suse.com are


