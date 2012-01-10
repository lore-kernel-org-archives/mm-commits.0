From: akpm@linux-foundation.org
Subject: [folded] mempool-fix-first-round-failure-behavior-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:47:09 -0800
Message-ID: <20120110224709.D76A21E0451@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:50225 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2AJWrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:47:10 -0500
Received: by ggnk3 with SMTP id k3so14979ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:47:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mempool-fix-first-round-failure-behavior-fix
has been removed from the -mm tree.  Its filename was
     mempool-fix-first-round-failure-behavior-fix.patch

This patch was dropped because it was folded into mempool-fix-first-round-failure-behavior.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mempool-fix-first-round-failure-behavior-fix

shorten the lock hold time

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempool.c~mempool-fix-first-round-failure-behavior-fix mm/mempool.c
--- a/mm/mempool.c~mempool-fix-first-round-failure-behavior-fix
+++ a/mm/mempool.c
@@ -226,8 +226,8 @@ repeat_alloc:
 	 * alloc failed with that and @pool was empty, retry immediately.
 	 */
 	if (gfp_temp != gfp_mask) {
-		gfp_temp = gfp_mask;
 		spin_unlock_irqrestore(&pool->lock, flags);
+		gfp_temp = gfp_mask;
 		goto repeat_alloc;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
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

