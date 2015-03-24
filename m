From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch removed from
 -mm tree
Date: Tue, 24 Mar 2015 14:24:29 -0700
Message-ID: <5511d60d.Y9foFFMeYTJtWvwl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbbCXVYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, iamjoonsoo.kim@lge.com, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs-add-minimum-size-accounting-to-subpools-fix
has been removed from the -mm tree.  Its filename was
     hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch

This patch was dropped because it was folded into hugetlbfs-add-minimum-size-accounting-to-subpools.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlbfs-add-minimum-size-accounting-to-subpools-fix

clean up comments, use punctuation, etc

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN mm/hugetlb.c~hugetlbfs-add-minimum-size-accounting-to-subpools-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-add-minimum-size-accounting-to-subpools-fix
+++ a/mm/hugetlb.c
@@ -125,8 +125,10 @@ static long hugepage_subpool_get_pages(s
 
 	if (spool->min_hpages) {		/* minimum size accounting */
 		if (delta > spool->rsv_hpages) {
-			/* asking for more reserves than those already taken
-			 * on behalf of subpool. return difference */
+			/*
+			 * Asking for more reserves than those already taken on
+			 * behalf of subpool.  Return difference.
+			 */
 			ret = delta - spool->rsv_hpages;
 			spool->rsv_hpages = 0;
 		} else {
@@ -141,7 +143,7 @@ unlock_ret:
 }
 
 /*
- * subpool accounting for freeing and unreserving pages
+ * Subpool accounting for freeing and unreserving pages.
  * Return the number of global page reservations that must be dropped.
  * The return value may only be different than the passed value (delta)
  * in the case where a subpool minimum size must be maintained.
@@ -170,8 +172,10 @@ static long hugepage_subpool_put_pages(s
 			spool->rsv_hpages = spool->min_hpages;
 	}
 
-	/* If hugetlbfs_put_super couldn't free spool due to
-	* an outstanding quota reference, free it now. */
+	/*
+	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
+	 * quota reference, free it now.
+	 */
 	unlock_or_release_subpool(spool);
 
 	return ret;
@@ -923,9 +927,9 @@ void free_huge_page(struct page *page)
 	ClearPagePrivate(page);
 
 	/*
-	 * A return code of zero implies that the subpool will be under
-	 * it's minimum size if the reservation is not restored after
-	 * page is free.  Therefore, force restore_reserve operation.
+	 * A return code of zero implies that the subpool will be under its
+	 * minimum size if the reservation is not restored after page is free.
+	 * Therefore, force restore_reserve operation.
 	 */
 	if (hugepage_subpool_put_pages(spool, 1) == 0)
 		restore_reserve = true;
@@ -2523,8 +2527,8 @@ static void hugetlb_vm_op_close(struct v
 
 	if (reserve) {
 		/*
-		 * decrement reserve counts.  The global reserve count
-		 * may be adjusted if the subpool has a minimum size.
+		 * Decrement reserve counts.  The global reserve count may be
+		 * adjusted if the subpool has a minimum size.
 		 */
 		gbl_reserve = hugepage_subpool_put_pages(spool, reserve);
 		hugetlb_acct_memory(h, -gbl_reserve);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-support-madvisemadv_free-fix-2.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

