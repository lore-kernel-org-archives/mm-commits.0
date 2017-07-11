From: akpm@linux-foundation.org
Subject: [merged] zram-use-__sysfs_match_string-helper.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:23:49 -0700
Message-ID: <20170711192349.BUrj4PVcB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933717AbdGKTXu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: zram: use __sysfs_match_string() helper
has been removed from the -mm tree.  Its filename was
     zram-use-__sysfs_match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: zram: use __sysfs_match_string() helper

Use __sysfs_match_string() helper instead of open coded variant.

Link: http://lkml.kernel.org/r/20170609120835.22156-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-use-__sysfs_match_string-helper drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-use-__sysfs_match_string-helper
+++ a/drivers/block/zram/zcomp.c
@@ -68,13 +68,11 @@ static struct zcomp_strm *zcomp_strm_all
 
 bool zcomp_available_algorithm(const char *comp)
 {
-	int i = 0;
+	int i;
 
-	while (backends[i]) {
-		if (sysfs_streq(comp, backends[i]))
-			return true;
-		i++;
-	}
+	i = __sysfs_match_string(backends, -1, comp);
+	if (i >= 0)
+		return true;
 
 	/*
 	 * Crypto does not ignore a trailing new line symbol,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


