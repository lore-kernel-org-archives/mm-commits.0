From: akpm@linux-foundation.org
Subject: - fs-introduce-some-page-buffer-invariants-obnoxiousness.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:13:32 -0700
Message-ID: <200707170813.l6H8DWXQ006999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41951 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933307AbXGQINk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     fs-introduce-some-page-buffer-invariants-obnoxiousness
has been removed from the -mm tree.  Its filename was
     fs-introduce-some-page-buffer-invariants-obnoxiousness.patch

This patch was dropped because it was folded into fs-introduce-some-page-buffer-invariants.patch

------------------------------------------------------
Subject: fs-introduce-some-page-buffer-invariants-obnoxiousness
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c         |    4 ++--
 mm/page-writeback.c |    2 +-
 truncate.c          |    0 
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/buffer.c~fs-introduce-some-page-buffer-invariants-obnoxiousness fs/buffer.c
--- a/fs/buffer.c~fs-introduce-some-page-buffer-invariants-obnoxiousness
+++ a/fs/buffer.c
@@ -693,7 +693,7 @@ static int __set_page_dirty(struct page 
 
 	write_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
-		WARN_ON(warn && !PageUptodate(page));
+		WARN_ON_ONCE(warn && !PageUptodate(page));
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
@@ -1156,7 +1156,7 @@ __getblk_slow(struct block_device *bdev,
  */
 void fastcall mark_buffer_dirty(struct buffer_head *bh)
 {
-	WARN_ON(!buffer_uptodate(bh));
+	WARN_ON_ONCE(!buffer_uptodate(bh));
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
 		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
 }
diff -puN mm/page-writeback.c~fs-introduce-some-page-buffer-invariants-obnoxiousness mm/page-writeback.c
--- a/mm/page-writeback.c~fs-introduce-some-page-buffer-invariants-obnoxiousness
+++ a/mm/page-writeback.c
@@ -826,7 +826,7 @@ int __set_page_dirty_nobuffers(struct pa
 		mapping2 = page_mapping(page);
 		if (mapping2) { /* Race with truncate? */
 			BUG_ON(mapping2 != mapping);
-			WARN_ON(!PagePrivate(page) && !PageUptodate(page));
+			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
 				task_io_account_write(PAGE_CACHE_SIZE);
diff -puN mm/truncate.c~fs-introduce-some-page-buffer-invariants-obnoxiousness mm/truncate.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
file-capabilities-clear-caps-cleanup-fix.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
i386-speedup-touch_nmi_watchdog.patch
x86_64-speedup-touch_nmi_watchdog.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support.patch
spi-master-driver-for-xilinx-virtex.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
rtc-driver-for-ds1216-chips-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
