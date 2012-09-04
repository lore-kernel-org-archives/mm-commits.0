From: akpm@linux-foundation.org
Subject: + mm-memblock-replace-0-with-null-for-pointer.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:17:57 -0700
Message-ID: <20120904221758.0FC0220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:59223 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2IDWSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:18:00 -0400
Received: by wgbdt11 with SMTP id dt11so374723wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:17:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, mingo@kernel.org, tj@kernel.org


The patch titled
     Subject: mm/memblock: replace 0 with NULL for pointer
has been added to the -mm tree.  Its filename is
     mm-memblock-replace-0-with-null-for-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: mm/memblock: replace 0 with NULL for pointer

Silences the following sparse warning:
mm/memblock.c:249:49: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-replace-0-with-null-for-pointer mm/memblock.c
--- a/mm/memblock.c~mm-memblock-replace-0-with-null-for-pointer
+++ a/mm/memblock.c
@@ -246,7 +246,7 @@ static int __init_memblock memblock_doub
 				min(new_area_start, memblock.current_limit),
 				new_alloc_size, PAGE_SIZE);
 
-		new_array = addr ? __va(addr) : 0;
+		new_array = addr ? __va(addr) : NULL;
 	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
thermal-exynos-fix-build-error.patch
thermal-exynos-remove-duplicate-inclusion-of-errh-header-file.patch
thermal-exynos-use-devm_-functions.patch
mm-memblock-replace-0-with-null-for-pointer.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

