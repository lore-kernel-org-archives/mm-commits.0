Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB632C072A2
	for <mm-commits@archiver.kernel.org>; Fri, 17 Nov 2023 17:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjKQRbC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Nov 2023 12:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjKQRbA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2023 12:31:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B9990
        for <mm-commits@vger.kernel.org>; Fri, 17 Nov 2023 09:30:55 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D10C433C8;
        Fri, 17 Nov 2023 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700242255;
        bh=i/wxxMQnJ+1LAT0Qr9qLJU5ZbEMeDFVwYGQFRSkTsPI=;
        h=Date:To:From:Subject:From;
        b=PDOCBJwr7SfufHguXmkDpO2I15YbuE0C4rJARg0HhfxxZA57Z8G+26KigPFIJ6Zui
         3Tfs/25LkygnF2vQanw8c3l4IRbwkkpOYpgsvSVsbSLkO9gmWS1IBEo2VUQJk/8+7p
         2omxNbM7q3ygIJKaI/nMlFIxmCksZviezyZUtWig=
Date:   Fri, 17 Nov 2023 09:30:54 -0800
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-convert-error_remove_page-to-error_remove_folio.patch added to mm-unstable branch
Message-Id: <20231117173055.43D10C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: convert error_remove_page to error_remove_folio
has been added to the -mm mm-unstable branch.  Its filename is
     fs-convert-error_remove_page-to-error_remove_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-convert-error_remove_page-to-error_remove_folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: convert error_remove_page to error_remove_folio
Date: Fri, 17 Nov 2023 16:14:47 +0000

There were already assertions that we were not passing a tail page to
error_remove_page(), so make the compiler enforce that by converting
everything to pass and use a folio.

Link: https://lkml.kernel.org/r/20231117161447.2461643-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |    4 ++--
 Documentation/filesystems/vfs.rst     |    6 +++---
 block/fops.c                          |    2 +-
 fs/afs/write.c                        |    2 +-
 fs/bcachefs/fs.c                      |    2 +-
 fs/btrfs/inode.c                      |    2 +-
 fs/ceph/addr.c                        |    4 ++--
 fs/ext2/inode.c                       |    2 +-
 fs/ext4/inode.c                       |    6 +++---
 fs/f2fs/compress.c                    |    2 +-
 fs/f2fs/inode.c                       |    2 +-
 fs/gfs2/aops.c                        |    4 ++--
 fs/hugetlbfs/inode.c                  |    6 +++---
 fs/nfs/file.c                         |    2 +-
 fs/ntfs/aops.c                        |    6 +++---
 fs/ocfs2/aops.c                       |    2 +-
 fs/xfs/xfs_aops.c                     |    2 +-
 fs/zonefs/file.c                      |    2 +-
 include/linux/fs.h                    |    2 +-
 include/linux/mm.h                    |    3 ++-
 mm/memory-failure.c                   |   10 +++++-----
 mm/shmem.c                            |    6 +++---
 mm/truncate.c                         |    9 ++++-----
 23 files changed, 44 insertions(+), 44 deletions(-)

--- a/block/fops.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/block/fops.c
@@ -500,7 +500,7 @@ const struct address_space_operations de
 	.readahead		= blkdev_readahead,
 	.writepages		= blkdev_writepages,
 	.is_partially_uptodate  = iomap_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 	.migrate_folio		= filemap_migrate_folio,
 };
 #endif /* CONFIG_BUFFER_HEAD */
--- a/Documentation/filesystems/locking.rst~fs-convert-error_remove_page-to-error_remove_folio
+++ a/Documentation/filesystems/locking.rst
@@ -261,7 +261,7 @@ prototypes::
 			struct folio *src, enum migrate_mode);
 	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
-	int (*error_remove_page)(struct address_space *, struct page *);
+	int (*error_remove_folio)(struct address_space *, struct folio *);
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 	int (*swap_deactivate)(struct file *);
 	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
@@ -287,7 +287,7 @@ direct_IO:
 migrate_folio:		yes (both)
 launder_folio:		yes
 is_partially_uptodate:	yes
-error_remove_page:	yes
+error_remove_folio:	yes
 swap_activate:		no
 swap_deactivate:	no
 swap_rw:		yes, unlocks
--- a/Documentation/filesystems/vfs.rst~fs-convert-error_remove_page-to-error_remove_folio
+++ a/Documentation/filesystems/vfs.rst
@@ -823,7 +823,7 @@ cache in your filesystem.  The following
 		bool (*is_partially_uptodate) (struct folio *, size_t from,
 					       size_t count);
 		void (*is_dirty_writeback)(struct folio *, bool *, bool *);
-		int (*error_remove_page) (struct mapping *mapping, struct page *page);
+		int (*error_remove_folio)(struct mapping *mapping, struct folio *);
 		int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
 		int (*swap_deactivate)(struct file *);
 		int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
@@ -1034,8 +1034,8 @@ cache in your filesystem.  The following
 	VM if a folio should be treated as dirty or writeback for the
 	purposes of stalling.
 
-``error_remove_page``
-	normally set to generic_error_remove_page if truncation is ok
+``error_remove_folio``
+	normally set to generic_error_remove_folio if truncation is ok
 	for this address space.  Used for memory failure handling.
 	Setting this implies you deal with pages going away under you,
 	unless you have them locked or reference counts increased.
--- a/fs/afs/write.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/afs/write.c
@@ -242,7 +242,7 @@ static void afs_kill_pages(struct addres
 		folio_clear_uptodate(folio);
 		folio_end_writeback(folio);
 		folio_lock(folio);
-		generic_error_remove_page(mapping, &folio->page);
+		generic_error_remove_folio(mapping, folio);
 		folio_unlock(folio);
 		folio_put(folio);
 
--- a/fs/bcachefs/fs.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/bcachefs/fs.c
@@ -1103,7 +1103,7 @@ static const struct address_space_operat
 #ifdef CONFIG_MIGRATION
 	.migrate_folio	= filemap_migrate_folio,
 #endif
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 };
 
 struct bcachefs_fid {
--- a/fs/btrfs/inode.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/btrfs/inode.c
@@ -10930,7 +10930,7 @@ static const struct address_space_operat
 	.release_folio	= btrfs_release_folio,
 	.migrate_folio	= btrfs_migrate_folio,
 	.dirty_folio	= filemap_dirty_folio,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 	.swap_activate	= btrfs_swap_activate,
 	.swap_deactivate = btrfs_swap_deactivate,
 };
--- a/fs/ceph/addr.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/ceph/addr.c
@@ -907,8 +907,8 @@ static void writepages_finish(struct cep
 			doutc(cl, "unlocking %p\n", page);
 
 			if (remove_page)
-				generic_error_remove_page(inode->i_mapping,
-							  page);
+				generic_error_remove_folio(inode->i_mapping,
+							  page_folio(page));
 
 			unlock_page(page);
 		}
--- a/fs/ext2/inode.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/ext2/inode.c
@@ -969,7 +969,7 @@ const struct address_space_operations ex
 	.writepages		= ext2_writepages,
 	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate	= block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 };
 
 static const struct address_space_operations ext2_dax_aops = {
--- a/fs/ext4/inode.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/ext4/inode.c
@@ -3564,7 +3564,7 @@ static const struct address_space_operat
 	.direct_IO		= noop_direct_IO,
 	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 	.swap_activate		= ext4_iomap_swap_activate,
 };
 
@@ -3581,7 +3581,7 @@ static const struct address_space_operat
 	.direct_IO		= noop_direct_IO,
 	.migrate_folio		= buffer_migrate_folio_norefs,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 	.swap_activate		= ext4_iomap_swap_activate,
 };
 
@@ -3598,7 +3598,7 @@ static const struct address_space_operat
 	.direct_IO		= noop_direct_IO,
 	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 	.swap_activate		= ext4_iomap_swap_activate,
 };
 
--- a/fs/f2fs/compress.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/f2fs/compress.c
@@ -1944,7 +1944,7 @@ void f2fs_invalidate_compress_pages(stru
 				continue;
 			}
 
-			generic_error_remove_page(mapping, &folio->page);
+			generic_error_remove_folio(mapping, folio);
 			folio_unlock(folio);
 		}
 		folio_batch_release(&fbatch);
--- a/fs/f2fs/inode.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/f2fs/inode.c
@@ -600,7 +600,7 @@ make_now:
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 		inode->i_mapping->a_ops = &f2fs_compress_aops;
 		/*
-		 * generic_error_remove_page only truncates pages of regular
+		 * generic_error_remove_folio only truncates pages of regular
 		 * inode
 		 */
 		inode->i_mode |= S_IFREG;
--- a/fs/gfs2/aops.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/gfs2/aops.c
@@ -745,7 +745,7 @@ static const struct address_space_operat
 	.bmap = gfs2_bmap,
 	.migrate_folio = filemap_migrate_folio,
 	.is_partially_uptodate = iomap_is_partially_uptodate,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 };
 
 static const struct address_space_operations gfs2_jdata_aops = {
@@ -758,7 +758,7 @@ static const struct address_space_operat
 	.invalidate_folio = gfs2_invalidate_folio,
 	.release_folio = gfs2_release_folio,
 	.is_partially_uptodate = block_is_partially_uptodate,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 };
 
 void gfs2_set_aops(struct inode *inode)
--- a/fs/hugetlbfs/inode.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/hugetlbfs/inode.c
@@ -1129,8 +1129,8 @@ static int hugetlbfs_migrate_folio(struc
 #define hugetlbfs_migrate_folio NULL
 #endif
 
-static int hugetlbfs_error_remove_page(struct address_space *mapping,
-				struct page *page)
+static int hugetlbfs_error_remove_folio(struct address_space *mapping,
+				struct folio *folio)
 {
 	return 0;
 }
@@ -1277,7 +1277,7 @@ static const struct address_space_operat
 	.write_end	= hugetlbfs_write_end,
 	.dirty_folio	= noop_dirty_folio,
 	.migrate_folio  = hugetlbfs_migrate_folio,
-	.error_remove_page	= hugetlbfs_error_remove_page,
+	.error_remove_folio	= hugetlbfs_error_remove_folio,
 };
 
 
--- a/fs/nfs/file.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/nfs/file.c
@@ -567,7 +567,7 @@ const struct address_space_operations nf
 	.migrate_folio = nfs_migrate_folio,
 	.launder_folio = nfs_launder_folio,
 	.is_dirty_writeback = nfs_check_dirty_writeback,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 	.swap_activate = nfs_swap_activate,
 	.swap_deactivate = nfs_swap_deactivate,
 	.swap_rw = nfs_swap_rw,
--- a/fs/ntfs/aops.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/ntfs/aops.c
@@ -1644,7 +1644,7 @@ const struct address_space_operations nt
 	.bmap		= ntfs_bmap,
 	.migrate_folio	= buffer_migrate_folio,
 	.is_partially_uptodate = block_is_partially_uptodate,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 };
 
 /*
@@ -1658,7 +1658,7 @@ const struct address_space_operations nt
 #endif /* NTFS_RW */
 	.migrate_folio	= buffer_migrate_folio,
 	.is_partially_uptodate = block_is_partially_uptodate,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 };
 
 /*
@@ -1673,7 +1673,7 @@ const struct address_space_operations nt
 #endif /* NTFS_RW */
 	.migrate_folio	= buffer_migrate_folio,
 	.is_partially_uptodate	= block_is_partially_uptodate,
-	.error_remove_page = generic_error_remove_page,
+	.error_remove_folio = generic_error_remove_folio,
 };
 
 #ifdef NTFS_RW
--- a/fs/ocfs2/aops.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/ocfs2/aops.c
@@ -2480,5 +2480,5 @@ const struct address_space_operations oc
 	.release_folio		= ocfs2_release_folio,
 	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate	= block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 };
--- a/fs/xfs/xfs_aops.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/xfs/xfs_aops.c
@@ -584,7 +584,7 @@ const struct address_space_operations xf
 	.bmap			= xfs_vm_bmap,
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate  = iomap_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 	.swap_activate		= xfs_iomap_swapfile_activate,
 };
 
--- a/fs/zonefs/file.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/fs/zonefs/file.c
@@ -180,7 +180,7 @@ const struct address_space_operations zo
 	.invalidate_folio	= iomap_invalidate_folio,
 	.migrate_folio		= filemap_migrate_folio,
 	.is_partially_uptodate	= iomap_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_folio	= generic_error_remove_folio,
 	.swap_activate		= zonefs_swap_activate,
 };
 
--- a/include/linux/fs.h~fs-convert-error_remove_page-to-error_remove_folio
+++ a/include/linux/fs.h
@@ -434,7 +434,7 @@ struct address_space_operations {
 	bool (*is_partially_uptodate) (struct folio *, size_t from,
 			size_t count);
 	void (*is_dirty_writeback) (struct folio *, bool *dirty, bool *wb);
-	int (*error_remove_page)(struct address_space *, struct page *);
+	int (*error_remove_folio)(struct address_space *, struct folio *);
 
 	/* swapfile support */
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
--- a/include/linux/mm.h~fs-convert-error_remove_page-to-error_remove_folio
+++ a/include/linux/mm.h
@@ -2384,7 +2384,8 @@ extern void truncate_pagecache(struct in
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
-int generic_error_remove_page(struct address_space *mapping, struct page *page);
+int generic_error_remove_folio(struct address_space *mapping,
+		struct folio *folio);
 
 struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
 		unsigned long address, struct pt_regs *regs);
--- a/mm/memory-failure.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/mm/memory-failure.c
@@ -927,13 +927,13 @@ static int delete_from_lru_cache(struct
 	return -EIO;
 }
 
-static int truncate_error_page(struct folio *folio, unsigned long pfn,
+static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 				struct address_space *mapping)
 {
 	int ret = MF_FAILED;
 
-	if (mapping->a_ops->error_remove_page) {
-		int err = mapping->a_ops->error_remove_page(mapping, &folio->page);
+	if (mapping->a_ops->error_remove_folio) {
+		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
 		if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
@@ -1054,7 +1054,7 @@ static int me_pagecache_clean(struct pag
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
-	ret = truncate_error_page(folio, page_to_pfn(p), mapping);
+	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
@@ -1188,7 +1188,7 @@ static int me_huge_page(struct page_stat
 
 	mapping = folio_mapping(folio);
 	if (mapping) {
-		res = truncate_error_page(folio, page_to_pfn(p), mapping);
+		res = truncate_error_folio(folio, page_to_pfn(p), mapping);
 		/* The page is kept in page cache. */
 		extra_pins = true;
 		folio_unlock(folio);
--- a/mm/shmem.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/mm/shmem.c
@@ -4462,8 +4462,8 @@ static void __init shmem_destroy_inodeca
 }
 
 /* Keep the page in page cache instead of truncating it */
-static int shmem_error_remove_page(struct address_space *mapping,
-				   struct page *page)
+static int shmem_error_remove_folio(struct address_space *mapping,
+				   struct folio *folio)
 {
 	return 0;
 }
@@ -4478,7 +4478,7 @@ const struct address_space_operations sh
 #ifdef CONFIG_MIGRATION
 	.migrate_folio	= migrate_folio,
 #endif
-	.error_remove_page = shmem_error_remove_page,
+	.error_remove_folio = shmem_error_remove_folio,
 };
 EXPORT_SYMBOL(shmem_aops);
 
--- a/mm/truncate.c~fs-convert-error_remove_page-to-error_remove_folio
+++ a/mm/truncate.c
@@ -250,10 +250,9 @@ bool truncate_inode_partial_folio(struct
 /*
  * Used to get rid of pages on hardware memory corruption.
  */
-int generic_error_remove_page(struct address_space *mapping, struct page *page)
+int generic_error_remove_folio(struct address_space *mapping,
+		struct folio *folio)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
-
 	if (!mapping)
 		return -EINVAL;
 	/*
@@ -262,9 +261,9 @@ int generic_error_remove_page(struct add
 	 */
 	if (!S_ISREG(mapping->host->i_mode))
 		return -EIO;
-	return truncate_inode_folio(mapping, page_folio(page));
+	return truncate_inode_folio(mapping, folio);
 }
-EXPORT_SYMBOL(generic_error_remove_page);
+EXPORT_SYMBOL(generic_error_remove_folio);
 
 /**
  * mapping_evict_folio() - Remove an unused folio from the page-cache.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
gfp-include-__gfp_nowarn-in-gfp_nowait.patch
memory-failure-use-a-folio-in-me_pagecache_clean.patch
memory-failure-use-a-folio-in-me_pagecache_dirty.patch
memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch
memory-failure-use-a-folio-in-me_huge_page.patch
memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch
fs-convert-error_remove_page-to-error_remove_folio.patch
nilfs2-add-nilfs_end_folio_io.patch
nilfs2-convert-nilfs_abort_logs-to-use-folios.patch
nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch
nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch
nilfs2-convert-to-nilfs_folio_buffers_clean.patch
nilfs2-convert-nilfs_writepage-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch
nilfs2-convert-to-nilfs_clear_folio_dirty.patch
nilfs2-convert-to-__nilfs_clear_folio_dirty.patch
nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch
nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_gccache_submit_read_data-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch

