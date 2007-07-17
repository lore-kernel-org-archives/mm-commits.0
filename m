From: akpm@linux-foundation.org
Subject: + sparc64-rename-tlb_flush_mmu.patch added to -mm tree
Date: Tue, 17 Jul 2007 00:48:01 -0700
Message-ID: <200707170748.l6H7m1so005969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbXGQHsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 03:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, hugh@veritas.com, schwidefsky@de.ibm.com


The patch titled
     sparc64: rename tlb_flush_mmu()
has been added to the -mm tree.  Its filename is
     sparc64-rename-tlb_flush_mmu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sparc64: rename tlb_flush_mmu()
From: Andrew Morton <akpm@linux-foundation.org>

Martin's "mm: avoid tlb gather restarts" creates a kernel-wide
tlb_flush_mmu(), which conflicts with sparc64's private implementation.

And sparc64's tlb_flush_mmu() differs from the one in
include/asm-generic/tlb.h.

So let's rename the sparc64 function.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-sparc64/tlb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-sparc64/tlb.h~sparc64-rename-tlb_flush_mmu include/asm-sparc64/tlb.h
--- a/include/asm-sparc64/tlb.h~sparc64-rename-tlb_flush_mmu
+++ a/include/asm-sparc64/tlb.h
@@ -55,7 +55,7 @@ static inline struct mmu_gather *tlb_gat
 }
 
 
-static inline void tlb_flush_mmu(struct mmu_gather *mp)
+static inline void sparc64_tlb_flush_mmu(struct mmu_gather *mp)
 {
 	if (mp->need_flush) {
 		free_pages_and_swap_cache(mp->pages, mp->pages_nr);
@@ -74,7 +74,7 @@ extern void smp_flush_tlb_mm(struct mm_s
 
 static inline void tlb_finish_mmu(struct mmu_gather *mp, unsigned long start, unsigned long end)
 {
-	tlb_flush_mmu(mp);
+	sparc64_tlb_flush_mmu(mp);
 
 	if (mp->fullmm)
 		mp->fullmm = 0;
@@ -96,7 +96,7 @@ static inline void tlb_remove_page(struc
 	mp->need_flush = 1;
 	mp->pages[mp->pages_nr++] = page;
 	if (mp->pages_nr >= FREE_PTE_NR)
-		tlb_flush_mmu(mp);
+		sparc64_tlb_flush_mmu(mp);
 }
 
 #define tlb_remove_tlb_entry(mp,ptep,addr) do { } while (0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
sparc64-rename-tlb_flush_mmu.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
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
