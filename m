From: akpm@linux-foundation.org
Subject: + fs-new-truncate-helpers.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:13 -0700
Message-ID: <200908202248.n7KMmDXe029218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbZHTWtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     fs: new truncate helpers
has been added to the -mm tree.  Its filename is
     fs-new-truncate-helpers.patch

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
Subject: fs: new truncate helpers
From: Nick Piggin <npiggin@suse.de>

Introduce new truncate helpers truncate_pagecache and inode_newsize_ok. 
vmtruncate is also consolidated from mm/memory.c and mm/nommu.c and into
mm/truncate.c.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/locking |    2 -
 fs/attr.c                |   44 ++++++++++++++++++++++++-
 include/linux/fs.h       |    1 
 include/linux/mm.h       |    5 +-
 mm/filemap.c             |    2 -
 mm/memory.c              |   62 +----------------------------------
 mm/mremap.c              |    4 +-
 mm/nommu.c               |   40 -----------------------
 mm/truncate.c            |   64 +++++++++++++++++++++++++++++++++++++
 9 files changed, 118 insertions(+), 106 deletions(-)

diff -puN Documentation/vm/locking~fs-new-truncate-helpers Documentation/vm/locking
--- a/Documentation/vm/locking~fs-new-truncate-helpers
+++ a/Documentation/vm/locking
@@ -80,7 +80,7 @@ Note: PTL can also be used to guarantee 
 mm start up ... this is a loose form of stability on mm_users. For
 example, it is used in copy_mm to protect against a racing tlb_gather_mmu
 single address space optimization, so that the zap_page_range (from
-vmtruncate) does not lose sending ipi's to cloned threads that might 
+truncate) does not lose sending ipi's to cloned threads that might
 be spawned underneath it and go to user mode to drag in pte's into tlbs.
 
 swap_lock
diff -puN fs/attr.c~fs-new-truncate-helpers fs/attr.c
--- a/fs/attr.c~fs-new-truncate-helpers
+++ a/fs/attr.c
@@ -60,9 +60,51 @@ fine:
 error:
 	return retval;
 }
-
 EXPORT_SYMBOL(inode_change_ok);
 
+/**
+ * inode_newsize_ok - may this inode be truncated to a given size
+ * @inode:	the inode to be truncated
+ * @offset:	the new size to assign to the inode
+ * @Returns:	0 on success, -ve errno on failure
+ *
+ * inode_newsize_ok will check filesystem limits and ulimits to check that the
+ * new inode size is within limits. inode_newsize_ok will also send SIGXFSZ
+ * when necessary. Caller must not proceed with inode size change if failure is
+ * returned. @inode must be a file (not directory), with appropriate
+ * permissions to allow truncate (inode_newsize_ok does NOT check these
+ * conditions).
+ *
+ * inode_newsize_ok must be called with i_mutex held.
+ */
+int inode_newsize_ok(struct inode *inode, loff_t offset)
+{
+	if (inode->i_size < offset) {
+		unsigned long limit;
+
+		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		if (limit != RLIM_INFINITY && offset > limit)
+			goto out_sig;
+		if (offset > inode->i_sb->s_maxbytes)
+			goto out_big;
+	} else {
+		/*
+		 * truncation of in-use swapfiles is disallowed - it would
+		 * cause subsequent swapout to scribble on the now-freed
+		 * blocks.
+		 */
+		if (IS_SWAPFILE(inode))
+			return -ETXTBSY;
+	}
+
+	return 0;
+out_sig:
+	send_sig(SIGXFSZ, current, 0);
+out_big:
+	return -EFBIG;
+}
+EXPORT_SYMBOL(inode_newsize_ok);
+
 int inode_setattr(struct inode * inode, struct iattr * attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
diff -puN include/linux/fs.h~fs-new-truncate-helpers include/linux/fs.h
--- a/include/linux/fs.h~fs-new-truncate-helpers
+++ a/include/linux/fs.h
@@ -2388,6 +2388,7 @@ extern int buffer_migrate_page(struct ad
 #endif
 
 extern int inode_change_ok(struct inode *, struct iattr *);
+extern int inode_newsize_ok(struct inode *, loff_t offset);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
 
 extern void file_update_time(struct file *file);
diff -puN include/linux/mm.h~fs-new-truncate-helpers include/linux/mm.h
--- a/include/linux/mm.h~fs-new-truncate-helpers
+++ a/include/linux/mm.h
@@ -791,8 +791,9 @@ static inline void unmap_shared_mapping_
 	unmap_mapping_range(mapping, holebegin, holelen, 0);
 }
 
-extern int vmtruncate(struct inode * inode, loff_t offset);
-extern int vmtruncate_range(struct inode * inode, loff_t offset, loff_t end);
+extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new);
+extern int vmtruncate(struct inode *inode, loff_t offset);
+extern int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end);
 
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
diff -puN mm/filemap.c~fs-new-truncate-helpers mm/filemap.c
--- a/mm/filemap.c~fs-new-truncate-helpers
+++ a/mm/filemap.c
@@ -59,7 +59,7 @@
 /*
  * Lock ordering:
  *
- *  ->i_mmap_lock		(vmtruncate)
+ *  ->i_mmap_lock		(truncate_pagecache)
  *    ->private_lock		(__free_pte->__set_page_dirty_buffers)
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->mapping->tree_lock
diff -puN mm/memory.c~fs-new-truncate-helpers mm/memory.c
--- a/mm/memory.c~fs-new-truncate-helpers
+++ a/mm/memory.c
@@ -283,7 +283,8 @@ void free_pgtables(struct mmu_gather *tl
 		unsigned long addr = vma->vm_start;
 
 		/*
-		 * Hide vma from rmap and vmtruncate before freeing pgtables
+		 * Hide vma from rmap and truncate_pagecache before freeing
+		 * pgtables
 		 */
 		anon_vma_unlink(vma);
 		unlink_file_vma(vma);
@@ -2360,7 +2361,7 @@ restart:
  * @mapping: the address space containing mmaps to be unmapped.
  * @holebegin: byte in first page to unmap, relative to the start of
  * the underlying file.  This will be rounded down to a PAGE_SIZE
- * boundary.  Note that this is different from vmtruncate(), which
+ * boundary.  Note that this is different from truncate_pagecache(), which
  * must keep the partial page.  In contrast, we must get rid of
  * partial pages.
  * @holelen: size of prospective hole in bytes.  This will be rounded
@@ -2411,63 +2412,6 @@ void unmap_mapping_range(struct address_
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
-/**
- * vmtruncate - unmap mappings "freed" by truncate() syscall
- * @inode: inode of the file used
- * @offset: file offset to start truncating
- *
- * NOTE! We have to be ready to update the memory sharing
- * between the file and the memory map for a potential last
- * incomplete page.  Ugly, but necessary.
- */
-int vmtruncate(struct inode * inode, loff_t offset)
-{
-	if (inode->i_size < offset) {
-		unsigned long limit;
-
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-		if (limit != RLIM_INFINITY && offset > limit)
-			goto out_sig;
-		if (offset > inode->i_sb->s_maxbytes)
-			goto out_big;
-		i_size_write(inode, offset);
-	} else {
-		struct address_space *mapping = inode->i_mapping;
-
-		/*
-		 * truncation of in-use swapfiles is disallowed - it would
-		 * cause subsequent swapout to scribble on the now-freed
-		 * blocks.
-		 */
-		if (IS_SWAPFILE(inode))
-			return -ETXTBSY;
-		i_size_write(inode, offset);
-
-		/*
-		 * unmap_mapping_range is called twice, first simply for
-		 * efficiency so that truncate_inode_pages does fewer
-		 * single-page unmaps.  However after this first call, and
-		 * before truncate_inode_pages finishes, it is possible for
-		 * private pages to be COWed, which remain after
-		 * truncate_inode_pages finishes, hence the second
-		 * unmap_mapping_range call must be made for correctness.
-		 */
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-		truncate_inode_pages(mapping, offset);
-		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	}
-
-	if (inode->i_op->truncate)
-		inode->i_op->truncate(inode);
-	return 0;
-
-out_sig:
-	send_sig(SIGXFSZ, current, 0);
-out_big:
-	return -EFBIG;
-}
-EXPORT_SYMBOL(vmtruncate);
-
 int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
 {
 	struct address_space *mapping = inode->i_mapping;
diff -puN mm/mremap.c~fs-new-truncate-helpers mm/mremap.c
--- a/mm/mremap.c~fs-new-truncate-helpers
+++ a/mm/mremap.c
@@ -85,8 +85,8 @@ static void move_ptes(struct vm_area_str
 	if (vma->vm_file) {
 		/*
 		 * Subtle point from Rajesh Venkatasubramanian: before
-		 * moving file-based ptes, we must lock vmtruncate out,
-		 * since it might clean the dst vma before the src vma,
+		 * moving file-based ptes, we must lock truncate_pagecache
+		 * out, since it might clean the dst vma before the src vma,
 		 * and we propagate stale pages into the dst afterward.
 		 */
 		mapping = vma->vm_file->f_mapping;
diff -puN mm/nommu.c~fs-new-truncate-helpers mm/nommu.c
--- a/mm/nommu.c~fs-new-truncate-helpers
+++ a/mm/nommu.c
@@ -83,46 +83,6 @@ struct vm_operations_struct generic_file
 };
 
 /*
- * Handle all mappings that got truncated by a "truncate()"
- * system call.
- *
- * NOTE! We have to be ready to update the memory sharing
- * between the file and the memory map for a potential last
- * incomplete page.  Ugly, but necessary.
- */
-int vmtruncate(struct inode *inode, loff_t offset)
-{
-	struct address_space *mapping = inode->i_mapping;
-	unsigned long limit;
-
-	if (inode->i_size < offset)
-		goto do_expand;
-	i_size_write(inode, offset);
-
-	truncate_inode_pages(mapping, offset);
-	goto out_truncate;
-
-do_expand:
-	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-	if (limit != RLIM_INFINITY && offset > limit)
-		goto out_sig;
-	if (offset > inode->i_sb->s_maxbytes)
-		goto out;
-	i_size_write(inode, offset);
-
-out_truncate:
-	if (inode->i_op->truncate)
-		inode->i_op->truncate(inode);
-	return 0;
-out_sig:
-	send_sig(SIGXFSZ, current, 0);
-out:
-	return -EFBIG;
-}
-
-EXPORT_SYMBOL(vmtruncate);
-
-/*
  * Return the total memory allocated for this pointer, not
  * just what the caller asked for.
  *
diff -puN mm/truncate.c~fs-new-truncate-helpers mm/truncate.c
--- a/mm/truncate.c~fs-new-truncate-helpers
+++ a/mm/truncate.c
@@ -497,3 +497,67 @@ int invalidate_inode_pages2(struct addre
 	return invalidate_inode_pages2_range(mapping, 0, -1);
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2);
+
+/**
+ * truncate_pagecache - unmap and remove pagecache that has been truncated
+ * @inode: inode
+ * @old: old file offset
+ * @new: new file offset
+ *
+ * inode's new i_size must already be written before truncate_pagecache
+ * is called.
+ *
+ * This function should typically be called before the filesystem
+ * releases resources associated with the freed range (eg. deallocates
+ * blocks). This way, pagecache will always stay logically coherent
+ * with on-disk format, and the filesystem would not have to deal with
+ * situations such as writepage being called for a page that has already
+ * had its underlying blocks deallocated.
+ */
+void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
+{
+	if (new < old) {
+		struct address_space *mapping = inode->i_mapping;
+
+		/*
+		 * unmap_mapping_range is called twice, first simply for
+		 * efficiency so that truncate_inode_pages does fewer
+		 * single-page unmaps.  However after this first call, and
+		 * before truncate_inode_pages finishes, it is possible for
+		 * private pages to be COWed, which remain after
+		 * truncate_inode_pages finishes, hence the second
+		 * unmap_mapping_range call must be made for correctness.
+		 */
+		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
+		truncate_inode_pages(mapping, new);
+		unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
+	}
+}
+EXPORT_SYMBOL(truncate_pagecache);
+
+/**
+ * vmtruncate - unmap mappings "freed" by truncate() syscall
+ * @inode: inode of the file used
+ * @offset: file offset to start truncating
+ *
+ * NOTE! We have to be ready to update the memory sharing
+ * between the file and the memory map for a potential last
+ * incomplete page.  Ugly, but necessary.
+ */
+int vmtruncate(struct inode *inode, loff_t offset)
+{
+	loff_t oldsize;
+	int error;
+
+	error = inode_newsize_ok(inode, offset);
+	if (error)
+		return error;
+	oldsize = inode->i_size;
+	i_size_write(inode, offset);
+	truncate_pagecache(inode, oldsize, offset);
+	if (inode->i_op->truncate)
+		inode->i_op->truncate(inode);
+
+	return error;
+}
+EXPORT_SYMBOL(vmtruncate);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

