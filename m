From: akpm@linux-foundation.org
Subject: [merged] thp-cleanup-khugepaged-startup.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:52:54 -0700
Message-ID: <552fe8e6.hQnjFHBRWMWpPfZn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbDPQrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup khugepaged startup
has been removed from the -mm tree.  Its filename was
     thp-cleanup-khugepaged-startup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
linux-next.patch

