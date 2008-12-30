From: akpm@linux-foundation.org
Subject: - reiser4-tree_lock-fixes.patch removed from -mm tree
Date: Tue, 30 Dec 2008 15:10:29 -0800
Message-ID: <200812302310.mBUNATIw019324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbYL3XLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:11:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     reiser4-tree_lock-fixes
has been removed from the -mm tree.  Its filename was
     reiser4-tree_lock-fixes.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4-tree_lock-fixes
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/as_ops.c |    4 ++--
 fs/reiser4/jnode.c  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-tree_lock-fixes fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-tree_lock-fixes
+++ a/fs/reiser4/as_ops.c
@@ -77,7 +77,7 @@ int reiser4_set_page_dirty(struct page *
 		struct address_space *mapping = page->mapping;
 
 		if (mapping) {
-			write_lock_irq(&mapping->tree_lock);
+			spin_lock_irq(&mapping->tree_lock);
 
 			/* check for race with truncate */
 			if (page->mapping) {
@@ -89,7 +89,7 @@ int reiser4_set_page_dirty(struct page *
 						   page->index,
 						   PAGECACHE_TAG_REISER4_MOVED);
 			}
-			write_unlock_irq(&mapping->tree_lock);
+			spin_unlock_irq(&mapping->tree_lock);
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 		}
 	}
diff -puN fs/reiser4/jnode.c~reiser4-tree_lock-fixes fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-tree_lock-fixes
+++ a/fs/reiser4/jnode.c
@@ -434,9 +434,9 @@ static void inode_attach_jnode(jnode * n
 	if (rtree->rnode == NULL) {
 		/* prevent inode from being pruned when it has jnodes attached
 		   to it */
-		write_lock_irq(&inode->i_data.tree_lock);
+		spin_lock_irq(&inode->i_data.tree_lock);
 		inode->i_data.nrpages++;
-		write_unlock_irq(&inode->i_data.tree_lock);
+		spin_unlock_irq(&inode->i_data.tree_lock);
 	}
 	assert("zam-1049", equi(rtree->rnode != NULL, info->nr_jnodes != 0));
 	check_me("zam-1045",
@@ -464,9 +464,9 @@ static void inode_detach_jnode(jnode * n
 	check_me("zam-1046", radix_tree_delete(rtree, node->key.j.index));
 	if (rtree->rnode == NULL) {
 		/* inode can be pruned now */
-		write_lock_irq(&inode->i_data.tree_lock);
+		spin_lock_irq(&inode->i_data.tree_lock);
 		inode->i_data.nrpages--;
-		write_unlock_irq(&inode->i_data.tree_lock);
+		spin_unlock_irq(&inode->i_data.tree_lock);
 	}
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style-fix.patch
mm-check-for-no-mmaps-in-exit_mmap-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
ioc4-automatically-load-sgiioc4-subordinate-module-checkpatch-fixes.patch
smp_call_function_single-be-slightly-less-stupid.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=0-checkpatch-fixes-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
fs-execc-make-do_coredump-void-checkpatch-fixes.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
edac-x38-use-the-architectures-readq-function-fix-fix.patch
dma_alloc_from_coherent-fix-fallback-to-generic-memory.patch
dma_alloc_coherent-clean-it-up.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
w1-allow-master-io-commands-fix.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
kmemleak-add-the-base-support-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

