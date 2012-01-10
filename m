From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:46:41 -0800
Message-ID: <20120110224642.47880200079@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63998 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:46:45 -0500
Received: by eekd41 with SMTP id d41so3088eek.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:46:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch

This patch was dropped because it was folded into mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix

use vma_hugecache_offset() directly, per Michal

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix
+++ a/mm/hugetlb.c
@@ -2315,7 +2315,7 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = linear_hugepage_index(vma, address);
+	pgoff = vma_hugecache_offset(h, vma, address);
 	mapping = (struct address_space *)page_private(page);
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior-fix.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

