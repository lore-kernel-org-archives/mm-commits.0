From: akpm@linux-foundation.org
Subject: + vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch added to -mm tree
Date: Wed, 02 Jul 2008 16:35:49 -0700
Message-ID: <200807022335.m62NZn24009507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbYGBXhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 19:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com


The patch titled
     splitlru: BDI_CAP_SWAP_BACKED
has been added to the -mm tree.  Its filename is
     vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch

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
Subject: splitlru: BDI_CAP_SWAP_BACKED
From: Hugh Dickins <hugh@veritas.com>

The split-lru patches put file and swap-backed pages on different lrus. 
shmem/tmpfs pages are awkward because they are swap-backed file pages. 
Since it's difficult to change lru midstream, they are treated as swap-
backed throughout, with SetPageSwapBacked on allocation in shmem_getpage.

However, splice read (used by loop and sendfile) and readahead* allocate
pages first, add_to_page_cache_lru, and then call into the filesystem
through ->readpage.  Under memory pressure, the shmem pages arrive at
add_to_swap_cache and hit its BUG_ON(!PageSwapBacked(page)).

I've not yet found a better way to handle this than a "capability" flag in
shmem_backing_dev_info, tested by add_to_page_cache_lru.  And solely
because it would look suspicious without it, set that BDI_CAP_SWAP_BACKED
in swap_backing_dev_info also.

* readahead on shmem/tmpfs?  I'd always thought ra_pages 0 prevented that;
but in fact readahead(2), fadvise(POSIX_FADV_WILLNEED) and
madvise(MADV_WILLNEED) all force_page_cache_readahead and get there.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |   13 +++++++++++++
 mm/filemap.c                |   13 ++++++++++++-
 mm/shmem.c                  |    2 +-
 mm/swap_state.c             |    2 +-
 4 files changed, 27 insertions(+), 3 deletions(-)

diff -puN include/linux/backing-dev.h~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed
+++ a/include/linux/backing-dev.h
@@ -175,6 +175,8 @@ int bdi_set_max_ratio(struct backing_dev
  * BDI_CAP_READ_MAP:       Can be mapped for reading
  * BDI_CAP_WRITE_MAP:      Can be mapped for writing
  * BDI_CAP_EXEC_MAP:       Can be mapped for execution
+ *
+ * BDI_CAP_SWAP_BACKED:    Count shmem/tmpfs objects as swap-backed.
  */
 #define BDI_CAP_NO_ACCT_DIRTY	0x00000001
 #define BDI_CAP_NO_WRITEBACK	0x00000002
@@ -184,6 +186,7 @@ int bdi_set_max_ratio(struct backing_dev
 #define BDI_CAP_WRITE_MAP	0x00000020
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
+#define BDI_CAP_SWAP_BACKED	0x00000100
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -248,6 +251,11 @@ static inline bool bdi_cap_account_write
 				      BDI_CAP_NO_WRITEBACK));
 }
 
+static inline bool bdi_cap_swap_backed(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_SWAP_BACKED;
+}
+
 static inline bool mapping_cap_writeback_dirty(struct address_space *mapping)
 {
 	return bdi_cap_writeback_dirty(mapping->backing_dev_info);
@@ -258,4 +266,9 @@ static inline bool mapping_cap_account_d
 	return bdi_cap_account_dirty(mapping->backing_dev_info);
 }
 
+static inline bool mapping_cap_swap_backed(struct address_space *mapping)
+{
+	return bdi_cap_swap_backed(mapping->backing_dev_info);
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
diff -puN mm/filemap.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed mm/filemap.c
--- a/mm/filemap.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed
+++ a/mm/filemap.c
@@ -493,7 +493,18 @@ EXPORT_SYMBOL(add_to_page_cache);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t offset, gfp_t gfp_mask)
 {
-	int ret = add_to_page_cache(page, mapping, offset, gfp_mask);
+	int ret;
+
+	/*
+	 * Splice_read and readahead add shmem/tmpfs pages into the page cache
+	 * before shmem_readpage has a chance to mark them as SwapBacked: they
+	 * need to go on the active_anon lru below, and mem_cgroup_cache_charge
+	 * (called in add_to_page_cache) needs to know where they're going too.
+	 */
+	if (mapping_cap_swap_backed(mapping))
+		SetPageSwapBacked(page);
+
+	ret = add_to_page_cache(page, mapping, offset, gfp_mask);
 	if (ret == 0) {
 		if (page_is_file_cache(page))
 			lru_cache_add_file(page);
diff -puN mm/shmem.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed mm/shmem.c
--- a/mm/shmem.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed
+++ a/mm/shmem.c
@@ -201,7 +201,7 @@ static struct vm_operations_struct shmem
 
 static struct backing_dev_info shmem_backing_dev_info  __read_mostly = {
 	.ra_pages	= 0,	/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 	.unplug_io_fn	= default_unplug_io_fn,
 };
 
diff -puN mm/swap_state.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed mm/swap_state.c
--- a/mm/swap_state.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed
+++ a/mm/swap_state.c
@@ -33,7 +33,7 @@ static const struct address_space_operat
 };
 
 static struct backing_dev_info swap_backing_dev_info = {
-	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
 	.unplug_io_fn	= swap_unplug_io_fn,
 };
 
_

Patches currently in -mm which might be from hugh@veritas.com are

mm-dirty-page-accounting-vs-vm_mixedmap.patch
linux-next.patch
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
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
hugetlb-modular-state-for-hugetlb-page-size-cleanup.patch
hugetlb-reservations-move-region-tracking-earlier.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
security-remove-unused-forwards.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
prio_tree-debugging-patch.patch

