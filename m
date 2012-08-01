From: akpm@linux-foundation.org
Subject: [merged] mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:05 -0700
Message-ID: <20120801201706.16E411E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAURH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:07 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add support for a filesystem to activate swap files and use direct_IO for writing swap pages
has been removed from the -mm tree.  Its filename was
     mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: add support for a filesystem to activate swap files and use direct_IO for writing swap pages

Currently swapfiles are managed entirely by the core VM by using ->bmap to
allocate space and write to the blocks directly.  This effectively ensures
that the underlying blocks are allocated and avoids the need for the swap
subsystem to locate what physical blocks store offsets within a file.

If the swap subsystem is to use the filesystem information to locate the
blocks, it is critical that information such as block groups, block
bitmaps and the block descriptor table that map the swap file were
resident in memory.  This patch adds address_space_operations that the VM
can call when activating or deactivating swap backed by a file.

  int swap_activate(struct file *);
  int swap_deactivate(struct file *);

The ->swap_activate() method is used to communicate to the file that the
VM relies on it, and the address_space should take adequate measures such
as reserving space in the underlying device, reserving memory for mempools
and pinning information such as the block descriptor table in memory.  The
->swap_deactivate() method is called on sys_swapoff() if ->swap_activate()
returned success.

After a successful swapfile ->swap_activate, the swapfile is marked
SWP_FILE and swapper_space.a_ops will proxy to
sis->swap_file->f_mappings->a_ops using ->direct_io to write swapcache
pages and ->readpage to read.

It is perfectly possible that direct_IO be used to read the swap pages but
it is an unnecessary complication.  Similarly, it is possible that
->writepage be used instead of direct_io to write the pages but filesystem
developers have stated that calling writepage from the VM is undesirable
for a variety of reasons and using direct_IO opens up the possibility of
writing back batches of swap pages in the future.

[a.p.zijlstra@chello.nl: Original patch]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |   13 +++++++
 Documentation/filesystems/vfs.txt |   12 ++++++
 include/linux/fs.h                |    4 ++
 include/linux/swap.h              |    2 +
 mm/page_io.c                      |   52 ++++++++++++++++++++++++++++
 mm/swap_state.c                   |    2 -
 mm/swapfile.c                     |   23 +++++++++++-
 7 files changed, 105 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/Locking~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/Documentation/filesystems/Locking
@@ -206,6 +206,8 @@ prototypes:
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, read_descriptor_t *, unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
+	int (*swap_activate)(struct file *);
+	int (*swap_deactivate)(struct file *);
 
 locking rules:
 	All except set_page_dirty and freepage may block
@@ -229,6 +231,8 @@ migratepage:		yes (both)
 launder_page:		yes
 is_partially_uptodate:	yes
 error_remove_page:	yes
+swap_activate:		no
+swap_deactivate:	no
 
 	->write_begin(), ->write_end(), ->sync_page() and ->readpage()
 may be called from the request handler (/dev/loop).
@@ -330,6 +334,15 @@ cleaned, or an error value if not. Note 
 getting mapped back in and redirtied, it needs to be kept locked
 across the entire operation.
 
+	->swap_activate will be called with a non-zero argument on
+files backing (non block device backed) swapfiles. A return value
+of zero indicates success, in which case this file can be used for
+backing swapspace. The swapspace operations will be proxied to the
+address space operations.
+
+	->swap_deactivate() will be called in the sys_swapoff()
+path after ->swap_activate() returned success.
+
 ----------------------- file_lock_operations ------------------------------
 prototypes:
 	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
diff -puN Documentation/filesystems/vfs.txt~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/Documentation/filesystems/vfs.txt
@@ -592,6 +592,8 @@ struct address_space_operations {
 	int (*migratepage) (struct page *, struct page *);
 	int (*launder_page) (struct page *);
 	int (*error_remove_page) (struct mapping *mapping, struct page *page);
+	int (*swap_activate)(struct file *);
+	int (*swap_deactivate)(struct file *);
 };
 
   writepage: called by the VM to write a dirty page to backing store.
@@ -760,6 +762,16 @@ struct address_space_operations {
 	Setting this implies you deal with pages going away under you,
 	unless you have them locked or reference counts increased.
 
+  swap_activate: Called when swapon is used on a file to allocate
+	space if necessary and pin the block lookup information in
+	memory. A return value of zero indicates success,
+	in which case this file can be used to back swapspace. The
+	swapspace operations will be proxied to this address space's
+	->swap_{out,in} methods.
+
+  swap_deactivate: Called during swapoff on files where swap_activate
+  	was successful.
+
 
 The File Object
 ===============
diff -puN include/linux/fs.h~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages include/linux/fs.h
--- a/include/linux/fs.h~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/include/linux/fs.h
@@ -638,6 +638,10 @@ struct address_space_operations {
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
+
+	/* swapfile support */
+	int (*swap_activate)(struct file *file);
+	int (*swap_deactivate)(struct file *file);
 };
 
 extern const struct address_space_operations empty_aops;
diff -puN include/linux/swap.h~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages include/linux/swap.h
--- a/include/linux/swap.h~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/include/linux/swap.h
@@ -151,6 +151,7 @@ enum {
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
+	SWP_FILE	= (1 << 7),	/* set after swap_activate success */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
@@ -320,6 +321,7 @@ static inline void mem_cgroup_uncharge_s
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
+extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err);
 
 /* linux/mm/swap_state.c */
diff -puN mm/page_io.c~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages mm/page_io.c
--- a/mm/page_io.c~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/mm/page_io.c
@@ -17,6 +17,7 @@
 #include <linux/swap.h>
 #include <linux/bio.h>
 #include <linux/swapops.h>
+#include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/frontswap.h>
 #include <asm/pgtable.h>
@@ -94,6 +95,7 @@ int swap_writepage(struct page *page, st
 {
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
+	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (try_to_free_swap(page)) {
 		unlock_page(page);
@@ -105,6 +107,32 @@ int swap_writepage(struct page *page, st
 		end_page_writeback(page);
 		goto out;
 	}
+
+	if (sis->flags & SWP_FILE) {
+		struct kiocb kiocb;
+		struct file *swap_file = sis->swap_file;
+		struct address_space *mapping = swap_file->f_mapping;
+		struct iovec iov = {
+			.iov_base = page_address(page),
+			.iov_len  = PAGE_SIZE,
+		};
+
+		init_sync_kiocb(&kiocb, swap_file);
+		kiocb.ki_pos = page_file_offset(page);
+		kiocb.ki_left = PAGE_SIZE;
+		kiocb.ki_nbytes = PAGE_SIZE;
+
+		unlock_page(page);
+		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
+						&kiocb, &iov,
+						kiocb.ki_pos, 1);
+		if (ret == PAGE_SIZE) {
+			count_vm_event(PSWPOUT);
+			ret = 0;
+		}
+		return ret;
+	}
+
 	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
 	if (bio == NULL) {
 		set_page_dirty(page);
@@ -126,6 +154,7 @@ int swap_readpage(struct page *page)
 {
 	struct bio *bio;
 	int ret = 0;
+	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageUptodate(page));
@@ -134,6 +163,17 @@ int swap_readpage(struct page *page)
 		unlock_page(page);
 		goto out;
 	}
+
+	if (sis->flags & SWP_FILE) {
+		struct file *swap_file = sis->swap_file;
+		struct address_space *mapping = swap_file->f_mapping;
+
+		ret = mapping->a_ops->readpage(swap_file, page);
+		if (!ret)
+			count_vm_event(PSWPIN);
+		return ret;
+	}
+
 	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
 	if (bio == NULL) {
 		unlock_page(page);
@@ -145,3 +185,15 @@ int swap_readpage(struct page *page)
 out:
 	return ret;
 }
+
+int swap_set_page_dirty(struct page *page)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+
+	if (sis->flags & SWP_FILE) {
+		struct address_space *mapping = sis->swap_file->f_mapping;
+		return mapping->a_ops->set_page_dirty(page);
+	} else {
+		return __set_page_dirty_no_writeback(page);
+	}
+}
diff -puN mm/swap_state.c~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages mm/swap_state.c
--- a/mm/swap_state.c~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/mm/swap_state.c
@@ -27,7 +27,7 @@
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.set_page_dirty	= __set_page_dirty_no_writeback,
+	.set_page_dirty	= swap_set_page_dirty,
 	.migratepage	= migrate_page,
 };
 
diff -puN mm/swapfile.c~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages mm/swapfile.c
--- a/mm/swapfile.c~mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages
+++ a/mm/swapfile.c
@@ -1329,6 +1329,14 @@ static void destroy_swap_extents(struct 
 		list_del(&se->list);
 		kfree(se);
 	}
+
+	if (sis->flags & SWP_FILE) {
+		struct file *swap_file = sis->swap_file;
+		struct address_space *mapping = swap_file->f_mapping;
+
+		sis->flags &= ~SWP_FILE;
+		mapping->a_ops->swap_deactivate(swap_file);
+	}
 }
 
 /*
@@ -1410,7 +1418,9 @@ add_swap_extent(struct swap_info_struct 
  */
 static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 {
-	struct inode *inode;
+	struct file *swap_file = sis->swap_file;
+	struct address_space *mapping = swap_file->f_mapping;
+	struct inode *inode = mapping->host;
 	unsigned blocks_per_page;
 	unsigned long page_no;
 	unsigned blkbits;
@@ -1421,13 +1431,22 @@ static int setup_swap_extents(struct swa
 	int nr_extents = 0;
 	int ret;
 
-	inode = sis->swap_file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
 		goto out;
 	}
 
+	if (mapping->a_ops->swap_activate) {
+		ret = mapping->a_ops->swap_activate(swap_file);
+		if (!ret) {
+			sis->flags |= SWP_FILE;
+			ret = add_swap_extent(sis, 0, sis->max, 0);
+			*span = sis->pages;
+		}
+		goto out;
+	}
+
 	blkbits = inode->i_blkbits;
 	blocks_per_page = PAGE_SIZE >> blkbits;
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

