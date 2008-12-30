From: akpm@linux-foundation.org
Subject: - reiser4-tree_lock-fixes-fix.patch removed from -mm tree
Date: Tue, 30 Dec 2008 15:10:33 -0800
Message-ID: <200812302310.mBUNAXHa019450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbYL3XLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:11:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     reiser4-tree_lock-fixes-fix
has been removed from the -mm tree.  Its filename was
     reiser4-tree_lock-fixes-fix.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4-tree_lock-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |    8 +++----
 fs/reiser4/plugin/file/file.c          |   26 +++++++++++------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-tree_lock-fixes-fix fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-tree_lock-fixes-fix
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -3435,7 +3435,7 @@ static int find_anon_page_cluster(struct
 {
 	int i = 0;
 	int found;
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	do {
 		/* looking for one page */
 		found = radix_tree_gang_lookup_tag(&mapping->page_tree,
@@ -3457,7 +3457,7 @@ static int find_anon_page_cluster(struct
 		if (last_page_in_cluster(pages[i++]))
 			break;
 	} while (1);
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	return i;
 }
 
@@ -3532,10 +3532,10 @@ static int capture_anon_pages(struct add
 static int cryptcompress_inode_has_anon_pages(struct inode *inode)
 {
 	int result;
-	read_lock_irq(&inode->i_mapping->tree_lock);
+	spin_lock_irq(&inode->i_mapping->tree_lock);
 	result = radix_tree_tagged(&inode->i_mapping->page_tree,
 				   PAGECACHE_TAG_REISER4_MOVED);
-	read_unlock_irq(&inode->i_mapping->tree_lock);
+	spin_unlock_irq(&inode->i_mapping->tree_lock);
 	return result;
 }
 
diff -puN fs/reiser4/plugin/file/file.c~reiser4-tree_lock-fixes-fix fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-tree_lock-fixes-fix
+++ a/fs/reiser4/plugin/file/file.c
@@ -848,9 +848,9 @@ static int has_anonymous_pages(struct in
 {
 	int result;
 
-	read_lock_irq(&inode->i_mapping->tree_lock);
+	spin_lock_irq(&inode->i_mapping->tree_lock);
 	result = radix_tree_tagged(&inode->i_mapping->page_tree, PAGECACHE_TAG_REISER4_MOVED);
-	read_unlock_irq(&inode->i_mapping->tree_lock);
+	spin_unlock_irq(&inode->i_mapping->tree_lock);
 	return result;
 }
 
@@ -994,7 +994,7 @@ capture_anonymous_pages(struct address_s
 	nr = 0;
 
 	/* find pages tagged MOVED */
-	write_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	pvec.nr = radix_tree_gang_lookup_tag(&mapping->page_tree,
 					     (void **)pvec.pages, *index, count,
 					     PAGECACHE_TAG_REISER4_MOVED);
@@ -1003,7 +1003,7 @@ capture_anonymous_pages(struct address_s
 		 * there are no pages tagged MOVED in mapping->page_tree
 		 * starting from *index
 		 */
-		write_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 		*index = (pgoff_t)-1;
 		return 0;
 	}
@@ -1014,7 +1014,7 @@ capture_anonymous_pages(struct address_s
 		radix_tree_tag_clear(&mapping->page_tree, pvec.pages[i]->index,
 				     PAGECACHE_TAG_REISER4_MOVED);
 	}
-	write_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 
 
 	*index = pvec.pages[i - 1]->index + 1;
@@ -1039,13 +1039,13 @@ capture_anonymous_pages(struct address_s
 				 * set MOVED tag to all pages which left not
 				 * captured
 				 */
-				write_lock_irq(&mapping->tree_lock);
+				spin_lock_irq(&mapping->tree_lock);
 				for (; i < pagevec_count(&pvec); i ++) {
 					radix_tree_tag_set(&mapping->page_tree,
 							   pvec.pages[i]->index,
 							   PAGECACHE_TAG_REISER4_MOVED);
 				}
-				write_unlock_irq(&mapping->tree_lock);
+				spin_unlock_irq(&mapping->tree_lock);
 
 				pagevec_release(&pvec);
 				return result;
@@ -1055,11 +1055,11 @@ capture_anonymous_pages(struct address_s
 				 * 0 for Writeback-ed page. Set MOVED tag on
 				 * that page
 				 */
-				write_lock_irq(&mapping->tree_lock);
+				spin_lock_irq(&mapping->tree_lock);
 				radix_tree_tag_set(&mapping->page_tree,
 						   pvec.pages[i]->index,
 						   PAGECACHE_TAG_REISER4_MOVED);
-				write_unlock_irq(&mapping->tree_lock);
+				spin_unlock_irq(&mapping->tree_lock);
 				if (i == 0)
 					*index = pvec.pages[0]->index;
 				else
@@ -1135,7 +1135,7 @@ static int sync_page_list(struct inode *
 	mapping = inode->i_mapping;
 	from = 0;
 	result = 0;
-	read_lock_irq(&mapping->tree_lock);
+	spin_lock_irq(&mapping->tree_lock);
 	while (result == 0) {
 		struct page *page;
 
@@ -1150,17 +1150,17 @@ static int sync_page_list(struct inode *
 		 * truncating by inode->i_mutex locked by sys_fsync
 		 */
 		page_cache_get(page);
-		read_unlock_irq(&mapping->tree_lock);
+		spin_unlock_irq(&mapping->tree_lock);
 
 		from = page->index + 1;
 
 		result = sync_page(page);
 
 		page_cache_release(page);
-		read_lock_irq(&mapping->tree_lock);
+		spin_lock_irq(&mapping->tree_lock);
 	}
 
-	read_unlock_irq(&mapping->tree_lock);
+	spin_unlock_irq(&mapping->tree_lock);
 	return result;
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

