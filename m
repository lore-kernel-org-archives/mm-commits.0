From: akpm@linux-foundation.org
Subject: [merged] mm-page_ioc-work-around-gcc-bug.patch removed from -mm
 tree
Date: Mon, 16 Jun 2014 12:08:55 -0700
Message-ID: <539f40c7.XRjyujsu9jvEKb4W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaFPTI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 15:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org

Subject: [merged] mm-page_ioc-work-around-gcc-bug.patch removed from -mm tree
To: akpm@linux-foundation.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 16 Jun 2014 12:08:55 -0700


The patch titled
     Subject: mm/page_io.c: work around gcc bug
has been removed from the -mm tree.  Its filename was
     mm-page_ioc-work-around-gcc-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_io.c: work around gcc bug

gcc-4.4.4 (at least) screws up this initialization.

mm/page_io.c: In function '__swap_writepage':
mm/page_io.c:277: error: unknown field 'bvec' specified in initializer
mm/page_io.c:278: warning: excess elements in struct initializer
mm/page_io.c:278: warning: (near initialization for 'from')

Fixes f990bbc9bfa3cbd2d ("bio_vec-backed iov_iter").

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_io.c~mm-page_ioc-work-around-gcc-bug mm/page_io.c
--- a/mm/page_io.c~mm-page_ioc-work-around-gcc-bug
+++ a/mm/page_io.c
@@ -274,9 +274,11 @@ int __swap_writepage(struct page *page,
 			.count = PAGE_SIZE,
 			.iov_offset = 0,
 			.nr_segs = 1,
-			.bvec = &bv
 		};
 
+		/* Do this by hand because old gcc messes up the initializer */
+		from.bvec = &bv;
+
 		init_sync_kiocb(&kiocb, swap_file);
 		kiocb.ki_pos = page_file_offset(page);
 		kiocb.ki_nbytes = PAGE_SIZE;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

