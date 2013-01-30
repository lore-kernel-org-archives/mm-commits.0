From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-report-gamma_table_count-correctly.patch added to -mm tree
Date: Tue, 29 Jan 2013 17:02:22 -0800
Message-ID: <20130130010222.955B05A410E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:57111 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3A3BCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 20:02:24 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so122218qah.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 17:02:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/s6e63m0.c: report ->gamma_table_count correctly
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-report-gamma_table_count-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
compat-return-efault-on-error-in-waitid.patch
backlight-s6e63m0-report-gamma_table_count-correctly.patch
edac-test-correct-variable-in-store-function.patch
rtc-add-support-for-spi-rtc-rx4581-fix.patch

