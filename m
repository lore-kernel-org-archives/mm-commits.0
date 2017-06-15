From: akpm@linux-foundation.org
Subject: + zram-use-__sysfs_match_string-helper.patch added to -mm tree
Date: Thu, 15 Jun 2017 13:57:02 -0700
Message-ID: <5942f49e.VsIcZAPJS+is2L6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbdFOU5I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 16:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use __sysfs_match_string() helper
has been added to the -mm tree.  Its filename is
     zram-use-__sysfs_match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-__sysfs_match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-__sysfs_match_string-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zram-use-__sysfs_match_string-helper.patch

