From: akpm@linux-foundation.org
Subject: [merged] mmc-rename-random32-to-prandom_u32.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:38 -0700
Message-ID: <20130430190238.75A075A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47208 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507Ab3D3TCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:39 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87773vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, cjb@laptop.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mmc: rename random32() to prandom_u32()
has been removed from the -mm tree.  Its filename was
     mmc-rename-random32-to-prandom_u32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mmc: rename random32() to prandom_u32()

Use preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-rename-random32-to-prandom_u32 drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-rename-random32-to-prandom_u32
+++ a/drivers/mmc/core/core.c
@@ -120,8 +120,8 @@ static void mmc_should_fail_request(stru
 	    !should_fail(&host->fail_mmc_request, data->blksz * data->blocks))
 		return;
 
-	data->error = data_errors[random32() % ARRAY_SIZE(data_errors)];
-	data->bytes_xfered = (random32() % (data->bytes_xfered >> 9)) << 9;
+	data->error = data_errors[prandom_u32() % ARRAY_SIZE(data_errors)];
+	data->bytes_xfered = (prandom_u32() % (data->bytes_xfered >> 9)) << 9;
 }
 
 #else /* CONFIG_FAIL_MMC_REQUEST */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
remove-unused-random32-and-srandom32.patch
notifier-error-inject-fix-module-names-in-kconfig.patch

