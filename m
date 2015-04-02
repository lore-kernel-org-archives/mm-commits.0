From: akpm@linux-foundation.org
Subject: + thp-cleanup-khugepaged-startup.patch added to -mm tree
Date: Thu, 02 Apr 2015 14:12:25 -0700
Message-ID: <551db0b9.xES8CRgRGcZ/GPeo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbbDBVM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2015 17:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup khugepaged startup
has been added to the -mm tree.  Its filename is
     thp-cleanup-khugepaged-startup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-cleanup-khugepaged-startup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-cleanup-khugepaged-startup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: cleanup khugepaged startup

Few trivial cleanups:

 - no need to call set_recommended_min_free_kbytes() from
   late_initcall() -- start_khugepaged() calls it;

 - no need to call set_recommended_min_free_kbytes() from
   start_khugepaged() if khugepaged is not started;

 - there isn't much point in running start_khugepaged() if we've just
   set transparent_hugepage_flags to zero;

 - start_khugepaged() is misnamed -- it also used to stop the thread;

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN mm/huge_memory.c~thp-cleanup-khugepaged-startup mm/huge_memory.c
--- a/mm/huge_memory.c~thp-cleanup-khugepaged-startup
+++ a/mm/huge_memory.c
@@ -110,10 +110,6 @@ static int set_recommended_min_free_kbyt
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	/* khugepaged thread has stopped to failed to start */
-	if (!khugepaged_thread)
-		return 0;
-
 	for_each_populated_zone(zone)
 		nr_zones++;
 
@@ -145,9 +141,8 @@ static int set_recommended_min_free_kbyt
 	setup_per_zone_wmarks();
 	return 0;
 }
-late_initcall(set_recommended_min_free_kbytes);
 
-static int start_khugepaged(void)
+static int start_stop_khugepaged(void)
 {
 	int err = 0;
 	if (khugepaged_enabled()) {
@@ -158,6 +153,7 @@ static int start_khugepaged(void)
 			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
 			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
+			goto fail;
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -168,7 +164,7 @@ static int start_khugepaged(void)
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
 	}
-
+fail:
 	return err;
 }
 
@@ -302,7 +298,7 @@ static ssize_t enabled_store(struct kobj
 		int err;
 
 		mutex_lock(&khugepaged_mutex);
-		err = start_khugepaged();
+		err = start_stop_khugepaged();
 		mutex_unlock(&khugepaged_mutex);
 
 		if (err)
@@ -651,10 +647,12 @@ static int __init hugepage_init(void)
 	 * where the extra memory used could hurt more than TLB overhead
 	 * is likely to save.  The admin can still enable it through /sys.
 	 */
-	if (totalram_pages < (512 << (20 - PAGE_SHIFT)))
+	if (totalram_pages < (512 << (20 - PAGE_SHIFT))) {
 		transparent_hugepage_flags = 0;
+		return 0;
+	}
 
-	err = start_khugepaged();
+	err = start_stop_khugepaged();
 	if (err)
 		goto err_khugepaged;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
thp-cleanup-khugepaged-startup.patch
linux-next.patch

