From: akpm@linux-foundation.org
Subject: - vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:50:10 -0700
Message-ID: <200807282350.m6SNoAdl002476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbYG1XvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     splitlru: BDI_CAP_SWAP_BACKED
has been removed from the -mm tree.  Its filename was
     vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch

This patch was dropped because it was folded into vmscan-split-lru-lists-into-anon-file-sets.patch

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

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
powerpc-lockless-get_user_pages.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
prio_tree-debugging-patch.patch

