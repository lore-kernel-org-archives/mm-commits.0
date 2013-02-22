From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-report-gamma_table_count-correctly.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:15 -0800
Message-ID: <20130222204215.A46DB31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:39282 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:16 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so103766yen.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/s6e63m0.c: report ->gamma_table_count correctly
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-report-gamma_table_count-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/video/backlight/s6e63m0.c: report ->gamma_table_count correctly

gamma_table has 3 arrays which each hold MAX_GAMMA_LEVEL pointers to int.

The current code sets ->gamma_table_count to 6 on 64bit arches and to 3 on
32 bit arches.  It should be 3 on everything.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-report-gamma_table_count-correctly drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-report-gamma_table_count-correctly
+++ a/drivers/video/backlight/s6e63m0.c
@@ -766,7 +766,7 @@ static int s6e63m0_probe(struct spi_devi
 	 * know that.
 	 */
 	lcd->gamma_table_count =
-	    sizeof(gamma_table) / (MAX_GAMMA_LEVEL * sizeof(int));
+	    sizeof(gamma_table) / (MAX_GAMMA_LEVEL * sizeof(int *));
 
 	ret = device_create_file(&(spi->dev), &dev_attr_gamma_mode);
 	if (ret < 0)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch

