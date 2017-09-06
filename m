From: akpm@linux-foundation.org
Subject: [patch 006/119] dax: move all DAX radix tree defs to
 fs/dax.c
Date: Wed, 06 Sep 2017 16:18:51 -0700
Message-ID: <20170906231851.3MkuzmpVk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754151AbdIFXSw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:18:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger.kernel@dilger.ca, akpm@linux-foundation.org, corbet@lwn.net, dan.j.williams@intel.com, darrick.wong@oracle.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@redhat.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, rostedt@goodmis.org, torvalds@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: move all DAX radix tree defs to fs/dax.c

Now that we no longer insert struct page pointers in DAX radix trees the
page cache code no longer needs to know anything about DAX exceptional
entries.  Move all the DAX exceptional entry definitions from dax.h to
fs/dax.c.

Link: http://lkml.kernel.org/r/20170724170616.25810-6-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   34 ++++++++++++++++++++++++++++++++++
 include/linux/dax.h |   41 -----------------------------------------
 2 files changed, 34 insertions(+), 41 deletions(-)

diff -puN fs/dax.c~dax-move-all-dax-radix-tree-defs-to-fs-daxc fs/dax.c
--- a/fs/dax.c~dax-move-all-dax-radix-tree-defs-to-fs-daxc
+++ a/fs/dax.c
@@ -54,6 +54,40 @@ static int __init init_dax_wait_table(vo
 }
 fs_initcall(init_dax_wait_table);
 
+/*
+ * We use lowest available bit in exceptional entry for locking, one bit for
+ * the entry size (PMD) and two more to tell us if the entry is a zero page or
+ * an empty entry that is just used for locking.  In total four special bits.
+ *
+ * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
+ * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
+ * block allocation.
+ */
+#define RADIX_DAX_SHIFT		(RADIX_TREE_EXCEPTIONAL_SHIFT + 4)
+#define RADIX_DAX_ENTRY_LOCK	(1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
+#define RADIX_DAX_PMD		(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
+#define RADIX_DAX_ZERO_PAGE	(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
+#define RADIX_DAX_EMPTY		(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 3))
+
+static unsigned long dax_radix_sector(void *entry)
+{
+	return (unsigned long)entry >> RADIX_DAX_SHIFT;
+}
+
+static void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
+{
+	return (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY | flags |
+			((unsigned long)sector << RADIX_DAX_SHIFT) |
+			RADIX_DAX_ENTRY_LOCK);
+}
+
+static unsigned int dax_radix_order(void *entry)
+{
+	if ((unsigned long)entry & RADIX_DAX_PMD)
+		return PMD_SHIFT - PAGE_SHIFT;
+	return 0;
+}
+
 static int dax_is_pmd_entry(void *entry)
 {
 	return (unsigned long)entry & RADIX_DAX_PMD;
diff -puN include/linux/dax.h~dax-move-all-dax-radix-tree-defs-to-fs-daxc include/linux/dax.h
--- a/include/linux/dax.h~dax-move-all-dax-radix-tree-defs-to-fs-daxc
+++ a/include/linux/dax.h
@@ -89,33 +89,6 @@ void dax_flush(struct dax_device *dax_de
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 
-/*
- * We use lowest available bit in exceptional entry for locking, one bit for
- * the entry size (PMD) and two more to tell us if the entry is a zero page or
- * an empty entry that is just used for locking.  In total four special bits.
- *
- * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
- * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
- * block allocation.
- */
-#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 4)
-#define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
-#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
-#define RADIX_DAX_ZERO_PAGE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
-#define RADIX_DAX_EMPTY (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 3))
-
-static inline unsigned long dax_radix_sector(void *entry)
-{
-	return (unsigned long)entry >> RADIX_DAX_SHIFT;
-}
-
-static inline void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
-{
-	return (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY | flags |
-			((unsigned long)sector << RADIX_DAX_SHIFT) |
-			RADIX_DAX_ENTRY_LOCK);
-}
-
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
@@ -137,20 +110,6 @@ static inline int __dax_zero_page_range(
 }
 #endif
 
-#ifdef CONFIG_FS_DAX_PMD
-static inline unsigned int dax_radix_order(void *entry)
-{
-	if ((unsigned long)entry & RADIX_DAX_PMD)
-		return PMD_SHIFT - PAGE_SHIFT;
-	return 0;
-}
-#else
-static inline unsigned int dax_radix_order(void *entry)
-{
-	return 0;
-}
-#endif
