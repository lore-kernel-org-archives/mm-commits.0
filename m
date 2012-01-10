From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:43:52 -0800
Message-ID: <20120110224353.13EEC5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40202 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab2AJWny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:43:54 -0500
Received: by mail-ey0-f202.google.com with SMTP id k10so3292eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:43:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch

This patch was dropped because it was folded into mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix

use &=

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix
+++ a/mm/hugetlb.c
@@ -2640,7 +2640,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
 
-	address = address & huge_page_mask(h);
+	address &= huge_page_mask(h);
 
 	ptep = huge_pte_offset(mm, address);
 	if (ptep) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
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

