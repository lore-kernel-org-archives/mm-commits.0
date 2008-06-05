From: akpm@linux-foundation.org
Subject: + mm-spinlock-tree_lock.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:35:09 -0700
Message-ID: <200806052035.m55KZ9mp028516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752741AbYFEUgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org


The patch titled
     mm: spinlock tree_lock
has been added to the -mm tree.  Its filename is
     mm-spinlock-tree_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: spinlock tree_lock
From: Nick Piggin <npiggin@suse.de>

mapping->tree_lock has no read lockers.  convert the lock from an rwlock
to a spinlock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                     |    4 ++--
 fs/inode.c                      |    2 +-
 include/asm-arm/cacheflush.h    |    4 ++--
 include/asm-parisc/cacheflush.h |    4 ++--
 include/linux/fs.h              |    2 +-
 mm/filemap.c                    |   10 +++++-----
 mm/migrate.c                    |    8 ++++----
 mm/page-writeback.c             |   12 ++++++------
 mm/swap_state.c                 |   10 +++++-----
 mm/swapfile.c                   |    4 ++--
 mm/truncate.c                   |    6 +++---
 mm/vmscan.c                     |    8 ++++----
 12 files changed, 37 insertions(+), 37 deletions(-)

diff -puN fs/buffer.c~mm-spinlock-tree_lock fs/buffer.c
--- a/fs/buffer.c~mm-spinlock-tree_lock
+++ a/fs/buffer.c
@@ -706,7 +706,7 @@ static int __set_page_dirty(struct page 
 	if (TestSetPageDirty(page))
 		return 0;
 
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 
@@ -719,7 +719,7 @@ static int __set_page_dirty(struct page 
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
 	return 1;
diff -puN fs/inode.c~mm-spinlock-tree_lock fs/inode.c
--- a/fs/inode.c~mm-spinlock-tree_lock
+++ a/fs/inode.c
@@ -209,7 +209,7 @@ void inode_init_once(struct inode *inode
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
-	rwlock_init(&inode->i_data.tree_lock);
+	spin_lock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
 	INIT_LIST_HEAD(&inode->i_data.private_list);
 	spin_lock_init(&inode->i_data.private_lock);
diff -puN include/asm-arm/cacheflush.h~mm-spinlock-tree_lock include/asm-arm/cacheflush.h
--- a/include/asm-arm/cacheflush.h~mm-spinlock-tree_lock
+++ a/include/asm-arm/cacheflush.h
@@ -417,9 +417,9 @@ static inline void flush_anon_page(struc
 }
 
 #define flush_dcache_mmap_lock(mapping) \
-	write_lock_irq(&(mapping)->tree_lock)
+	spin_lock_irq(&(mapping)->tree_lock)
 #define flush_dcache_mmap_unlock(mapping) \
-	write_unlock_irq(&(mapping)->tree_lock)
+	spin_unlock_irq(&(mapping)->tree_lock)
 
 #define flush_icache_user_range(vma,page,addr,len) \
 	flush_dcache_page(page)
diff -puN include/asm-parisc/cacheflush.h~mm-spinlock-tree_lock include/asm-parisc/cacheflush.h
--- a/include/asm-parisc/cacheflush.h~mm-spinlock-tree_lock
+++ a/include/asm-parisc/cacheflush.h
@@ -45,9 +45,9 @@ void flush_cache_mm(struct mm_struct *mm
 extern void flush_dcache_page(struct page *page);
 
 #define flush_dcache_mmap_lock(mapping) \
-	write_lock_irq(&(mapping)->tree_lock)
+	spin_lock_irq(&(mapping)->tree_lock)
 #define flush_dcache_mmap_unlock(mapping) \
-	write_unlock_irq(&(mapping)->tree_lock)
+	spin_unlock_irq(&(mapping)->tree_lock)
 
 #define flush_icache_page(vma,page)	do { 		\
 	flush_kernel_dcache_page(page);			\
diff -puN include/linux/fs.h~mm-spinlock-tree_lock include/linux/fs.h
--- a/include/linux/fs.h~mm-spinlock-tree_lock
+++ a/include/linux/fs.h
@@ -528,7 +528,7 @@ struct backing_dev_info;
 struct address_space {
 	struct inode		*host;		/* owner: inode, block_device */
 	struct radix_tree_root	page_tree;	/* radix tree of all pages */
-	rwlock_t		tree_lock;	/* and rwlock protecting it */
+	spinlock_t		tree_lock;	/* and lock protecting it */
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
diff -puN mm/filemap.c~mm-spinlock-tree_lock mm/filemap.c
--- a/mm/filemap.c~mm-spinlock-tree_lock
+++ a/mm/filemap.c
@@ -109,7 +109,7 @@
 /*
  * Remove a page from the page cache and free it. Caller has to make
  * sure the page is locked and that nobody else uses it - or that usage
- * is safe.  The caller must hold a write_lock on the mapping's tree_lock.
+ * is safe.  The caller must hold the mapping's tree_lock.
  */
 void __remove_from_page_cache(struct page *page)
 {
@@ -141,9 +141,9 @@ void remove_from_page_cache(struct page 
 
 	BUG_ON(!PageLocked(page));
 
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	__remove_from_page_cache(page);
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 }
 
 static int sync_page(void *word)
@@ -468,7 +468,7 @@ int add_to_page_cache(struct page *page,
 		page->mapping = mapping;
 		page->index = offset;
 
-		write_lock_irq(&mapping->tree_lock);
+		spin_lock_irq(&mapping->tree_lock);
 		error = radix_tree_insert(&mapping->page_tree, offset, page);
 		if (likely(!error)) {
 			mapping->nrpages++;
@@ -480,7 +480,7 @@ int add_to_page_cache(struct page *page,
 			page_cache_release(page);
 		}
 
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
 	} else
 		mem_cgroup_uncharge_cache_page(page);
diff -puN mm/migrate.c~mm-spinlock-tree_lock mm/migrate.c
--- a/mm/migrate.c~mm-spinlock-tree_lock
+++ a/mm/migrate.c
@@ -315,7 +315,7 @@ static int migrate_page_move_mapping(str
 		return 0;
 	}
 
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
  					page_index(page));
@@ -323,12 +323,12 @@ static int migrate_page_move_mapping(str
 	expected_count = 2 + !!PagePrivate(page);
 	if (page_count(page) != expected_count ||
 			(struct page *)radix_tree_deref_slot(pslot) != page) {
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
 
 	if (!page_freeze_refs(page, expected_count)) {
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
 
@@ -365,7 +365,7 @@ static int migrate_page_move_mapping(str
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	if (!PageSwapCache(newpage)) {
 		mem_cgroup_uncharge_cache_page(page);
 	} else
diff -puN mm/page-writeback.c~mm-spinlock-tree_lock mm/page-writeback.c
--- a/mm/page-writeback.c~mm-spinlock-tree_lock
+++ a/mm/page-writeback.c
@@ -1085,7 +1085,7 @@ int __set_page_dirty_nobuffers(struct pa
 		if (!mapping)
 			return 1;
 
-		write_lock_irq(&mapping->tree_lock);
+		spin_lock_irq(&mapping->tree_lock);
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
@@ -1099,7 +1099,7 @@ int __set_page_dirty_nobuffers(struct pa
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1255,7 +1255,7 @@ int test_clear_page_writeback(struct pag
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
 
-		write_lock_irqsave(&mapping->tree_lock, flags);
+		spin_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestClearPageWriteback(page);
 		if (ret) {
 			radix_tree_tag_clear(&mapping->page_tree,
@@ -1266,7 +1266,7 @@ int test_clear_page_writeback(struct pag
 				__bdi_writeout_inc(bdi);
 			}
 		}
-		write_unlock_irqrestore(&mapping->tree_lock, flags);
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
@@ -1284,7 +1284,7 @@ int test_set_page_writeback(struct page 
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
 
-		write_lock_irqsave(&mapping->tree_lock, flags);
+		spin_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestSetPageWriteback(page);
 		if (!ret) {
 			radix_tree_tag_set(&mapping->page_tree,
@@ -1297,7 +1297,7 @@ int test_set_page_writeback(struct page 
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_DIRTY);
-		write_unlock_irqrestore(&mapping->tree_lock, flags);
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
diff -puN mm/swap_state.c~mm-spinlock-tree_lock mm/swap_state.c
--- a/mm/swap_state.c~mm-spinlock-tree_lock
+++ a/mm/swap_state.c
@@ -39,7 +39,7 @@ static struct backing_dev_info swap_back
 
 struct address_space swapper_space = {
 	.page_tree	= RADIX_TREE_INIT(GFP_ATOMIC|__GFP_NOWARN),
-	.tree_lock	= __RW_LOCK_UNLOCKED(swapper_space.tree_lock),
+	.tree_lock	= __SPIN_LOCK_UNLOCKED(swapper_space.tree_lock),
 	.a_ops		= &swap_aops,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
 	.backing_dev_info = &swap_backing_dev_info,
@@ -80,7 +80,7 @@ int add_to_swap_cache(struct page *page,
 		SetPageSwapCache(page);
 		set_page_private(page, entry.val);
 
-		write_lock_irq(&swapper_space.tree_lock);
+		spin_lock_irq(&swapper_space.tree_lock);
 		error = radix_tree_insert(&swapper_space.page_tree,
 						entry.val, page);
 		if (likely(!error)) {
@@ -88,7 +88,7 @@ int add_to_swap_cache(struct page *page,
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 			INC_CACHE_INFO(add_total);
 		}
-		write_unlock_irq(&swapper_space.tree_lock);
+		spin_unlock_irq(&swapper_space.tree_lock);
 		radix_tree_preload_end();
 
 		if (unlikely(error)) {
@@ -183,9 +183,9 @@ void delete_from_swap_cache(struct page 
 
 	entry.val = page_private(page);
 
-	write_lock_irq(&swapper_space.tree_lock);
+	spin_lock_irq(&swapper_space.tree_lock);
 	__delete_from_swap_cache(page);
-	write_unlock_irq(&swapper_space.tree_lock);
+	spin_unlock_irq(&swapper_space.tree_lock);
 
 	swap_free(entry);
 	page_cache_release(page);
diff -puN mm/swapfile.c~mm-spinlock-tree_lock mm/swapfile.c
--- a/mm/swapfile.c~mm-spinlock-tree_lock
+++ a/mm/swapfile.c
@@ -368,13 +368,13 @@ int remove_exclusive_swap_page(struct pa
 	retval = 0;
 	if (p->swap_map[swp_offset(entry)] == 1) {
 		/* Recheck the page count with the swapcache lock held.. */
-		write_lock_irq(&swapper_space.tree_lock);
+		spin_lock_irq(&swapper_space.tree_lock);
 		if ((page_count(page) == 2) && !PageWriteback(page)) {
 			__delete_from_swap_cache(page);
 			SetPageDirty(page);
 			retval = 1;
 		}
-		write_unlock_irq(&swapper_space.tree_lock);
+		spin_unlock_irq(&swapper_space.tree_lock);
 	}
 	spin_unlock(&swap_lock);
 
diff -puN mm/truncate.c~mm-spinlock-tree_lock mm/truncate.c
--- a/mm/truncate.c~mm-spinlock-tree_lock
+++ a/mm/truncate.c
@@ -349,18 +349,18 @@ invalidate_complete_page2(struct address
 	if (PagePrivate(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
 		goto failed;
 
 	BUG_ON(PagePrivate(page));
 	__remove_from_page_cache(page);
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	ClearPageUptodate(page);
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
 failed:
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	return 0;
 }
 
diff -puN mm/vmscan.c~mm-spinlock-tree_lock mm/vmscan.c
--- a/mm/vmscan.c~mm-spinlock-tree_lock
+++ a/mm/vmscan.c
@@ -398,7 +398,7 @@ static int __remove_mapping(struct addre
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	/*
 	 * The non racy check for a busy page.
 	 *
@@ -433,17 +433,17 @@ static int __remove_mapping(struct addre
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 		swap_free(swap);
 	} else {
 		__remove_from_page_cache(page);
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 	}
 
 	return 1;
 
 cannot_free:
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	return 0;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

hugetlb-fix-lockdep-error.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
vt-fix-vc_resize-locking.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

