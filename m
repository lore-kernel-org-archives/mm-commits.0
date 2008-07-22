From: akpm@linux-foundation.org
Subject: + mm-speculative-page-references-fix-add_to_page_cache.patch added to -mm tree
Date: Mon, 21 Jul 2008 17:10:27 -0700
Message-ID: <200807220010.m6M0ASdf032284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbYGVAKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 20:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, npiggin@suse.de


The patch titled
     speculative page references: fix add_to_page_cache
has been added to the -mm tree.  Its filename is
     mm-speculative-page-references-fix-add_to_page_cache.patch

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
Subject: speculative page references: fix add_to_page_cache
From: Hugh Dickins <hugh@veritas.com>

The speculative page references patch actually depends on another patch of
Nick's which he hasn't supplied this time around: an atomic-avoiding
__set_page_locked patch: see http://lkml.org/lkml/2007/11/10/5

This showed up when shmem_unuse_inode's add_to_page_cache failed: the page
was passed in locked and should remain locked, but speculative's
add_to_page_cache had unlocked it already, so the subsequent unlock_page
BUGged.  add_to_page_cache indeed should set and clear the page lock, but
shmem/tmpfs needs an add_to_page_cache_locked entry point to avoid that.

This fix patch below extracts and updates what's needed from Nick's
original, including his comments, but leaving out the atomic-avoidance.

(Do speculative page references actually need the page locked before it's
entered into the page cache?  I'm not sure myself, suspect that if
everywhere else handled PageUptodate and PageError correctly then it might
not be necessary; but we're pretty sure there are gaps in that error
handling, so I agree with Nick that we should lock before.  He may well be
able to supply a stronger reason why it's necessary.)

I apologize for not finding this sooner, my testing coverage weaker than
I'd thought: only hit this in checking the swap priority patch.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   18 +++++++++++++++++-
 mm/filemap.c            |   19 +++++++++----------
 mm/shmem.c              |    4 ++--
 mm/swap_state.c         |    2 +-
 4 files changed, 29 insertions(+), 14 deletions(-)

diff -puN include/linux/pagemap.h~mm-speculative-page-references-fix-add_to_page_cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-speculative-page-references-fix-add_to_page_cache
+++ a/include/linux/pagemap.h
@@ -227,7 +227,7 @@ static inline struct page *read_mapping_
 	return read_cache_page(mapping, index, filler, data);
 }
 
-int add_to_page_cache(struct page *page, struct address_space *mapping,
+int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
@@ -235,6 +235,22 @@ extern void remove_from_page_cache(struc
 extern void __remove_from_page_cache(struct page *page);
 
 /*
+ * Like add_to_page_cache_locked, but used to add newly allocated pages:
+ * the page is new, so we can just run SetPageLocked() against it.
+ */
+static inline int add_to_page_cache(struct page *page,
+		struct address_space *mapping, pgoff_t offset, gfp_t gfp_mask)
+{
+	int error;
+
+	SetPageLocked(page);
+	error = add_to_page_cache_locked(page, mapping, offset, gfp_mask);
+	if (unlikely(error))
+		ClearPageLocked(page);
+	return error;
+}
+
+/*
  * Return byte-offset into filesystem object for page.
  */
 static inline loff_t page_offset(struct page *page)
diff -puN mm/filemap.c~mm-speculative-page-references-fix-add_to_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-speculative-page-references-fix-add_to_page_cache
+++ a/mm/filemap.c
@@ -442,22 +442,23 @@ int filemap_write_and_wait_range(struct 
 }
 
 /**
- * add_to_page_cache - add newly allocated pagecache pages
+ * add_to_page_cache_locked - add newly allocated pagecache pages
  * @page:	page to add
  * @mapping:	the page's address_space
  * @offset:	page index
  * @gfp_mask:	page allocation mode
  *
- * This function is used to add newly allocated pagecache pages;
- * the page is new, so we can just run SetPageLocked() against it.
- * The other page state flags were set by rmqueue().
- *
+ * This function is used to add a page to the pagecache. It must be locked.
  * This function does not add the page to the LRU.  The caller must do that.
  */
-int add_to_page_cache(struct page *page, struct address_space *mapping,
+int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 		pgoff_t offset, gfp_t gfp_mask)
 {
-	int error = mem_cgroup_cache_charge(page, current->mm,
+	int error;
+
+	VM_BUG_ON(!PageLocked(page));
+
+	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & ~__GFP_HIGHMEM);
 	if (error)
 		goto out;
@@ -465,7 +466,6 @@ int add_to_page_cache(struct page *page,
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error == 0) {
 		page_cache_get(page);
-		SetPageLocked(page);
 		page->mapping = mapping;
 		page->index = offset;
 
@@ -476,7 +476,6 @@ int add_to_page_cache(struct page *page,
 			__inc_zone_page_state(page, NR_FILE_PAGES);
 		} else {
 			page->mapping = NULL;
-			ClearPageLocked(page);
 			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
 		}
@@ -488,7 +487,7 @@ int add_to_page_cache(struct page *page,
 out:
 	return error;
 }
-EXPORT_SYMBOL(add_to_page_cache);
+EXPORT_SYMBOL(add_to_page_cache_locked);
 
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t offset, gfp_t gfp_mask)
diff -puN mm/shmem.c~mm-speculative-page-references-fix-add_to_page_cache mm/shmem.c
--- a/mm/shmem.c~mm-speculative-page-references-fix-add_to_page_cache
+++ a/mm/shmem.c
@@ -936,7 +936,7 @@ found:
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
 	if (ptr && ptr->val == entry.val) {
-		error = add_to_page_cache(page, inode->i_mapping,
+		error = add_to_page_cache_locked(page, inode->i_mapping,
 						idx, GFP_NOWAIT);
 		/* does mem_cgroup_uncharge_cache_page on error */
 	} else	/* we must compensate for our precharge above */
@@ -1301,7 +1301,7 @@ repeat:
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
 			swap_free(swap);
-		} else if (!(error = add_to_page_cache(
+		} else if (!(error = add_to_page_cache_locked(
 				swappage, mapping, idx, GFP_NOWAIT))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
diff -puN mm/swap_state.c~mm-speculative-page-references-fix-add_to_page_cache mm/swap_state.c
--- a/mm/swap_state.c~mm-speculative-page-references-fix-add_to_page_cache
+++ a/mm/swap_state.c
@@ -64,7 +64,7 @@ void show_swap_cache_info(void)
 }
 
 /*
- * add_to_swap_cache resembles add_to_page_cache on swapper_space,
+ * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
 int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
ahci-use-correct-type-for-cpu-flags.patch
git-unionfs.patch
unionfs-fix-memory-leak.patch
fsstack-fsstack_copy_inode_size-locking.patch
mm-remove-nopfn-fix.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
security-remove-unused-forwards.patch
exec-remove-some-includes.patch
exec-remove-some-includes-fix.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
x86-implement-pte_special-fix.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
prio_tree-debugging-patch.patch

