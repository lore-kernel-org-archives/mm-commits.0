From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch-fix.patch
 removed from -mm tree
Date: Wed, 21 Oct 2015 13:37:28 -0700
Message-ID: <5627f788.iizdJLDKkK24qbgn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbbJUUh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 16:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch-fix

tidy up hugetlb_falloc initialisation

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch-fix
+++ a/fs/hugetlbfs/inode.c
@@ -509,7 +509,6 @@ static long hugetlbfs_punch_hole(struct
 	loff_t hpage_size = huge_page_size(h);
 	unsigned long hpage_shift = huge_page_shift(h);
 	loff_t hole_start, hole_end;
-	struct hugetlb_falloc hugetlb_falloc;
 
 	/*
 	 * For hole punch round up the beginning offset of the hole and
@@ -521,15 +520,16 @@ static long hugetlbfs_punch_hole(struct
 	if (hole_end > hole_start) {
 		struct address_space *mapping = inode->i_mapping;
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(hugetlb_falloc_waitq);
-
 		/*
-		 * Page faults on the area to be hole punched must be
-		 * stopped during the operation.  Initialize struct and
-		 * have inode->i_private point to it.
+		 * Page faults on the area to be hole punched must be stopped
+		 * during the operation.  Initialize struct and have
+		 * inode->i_private point to it.
 		 */
-		hugetlb_falloc.waitq = &hugetlb_falloc_waitq;
-		hugetlb_falloc.start = hole_start >> hpage_shift;
-		hugetlb_falloc.end = hole_end >> hpage_shift;
+		struct hugetlb_falloc hugetlb_falloc = {
+			.waitq = &hugetlb_falloc_waitq,
+			.start = hole_start >> hpage_shift,
+			.end = hole_end >> hpage_shift
+		};
 
 		mutex_lock(&inode->i_mutex);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-support-madvisemadv_free-vs-thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
drivers-rtc-rtc-pcf2127c-hack.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

