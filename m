From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-replace-0-with-null-for-pointer.patch removed from -mm tree
Date: Tue, 11 Sep 2012 12:32:27 -0700
Message-ID: <20120911193227.A9BD41E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63116 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2IKTc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 15:32:28 -0400
Received: by qcqs25 with SMTP id s25so96112qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 12:32:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mingo@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: replace 0 with NULL for pointer
has been removed from the -mm tree.  Its filename was
     mm-memblock-replace-0-with-null-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch

