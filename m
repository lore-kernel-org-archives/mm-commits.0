From: akpm@linux-foundation.org
Subject: + s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:28:12 -0800
Message-ID: <200911122128.nACLSCcP031747__43486.9848461405$1258061314$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201AbZKLV2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org, linux@simtec.co.uk


The patch titled
     s3cmci: convert missed s3c2410_gpio calls to gpiolib calls
has been added to the -mm tree.  Its filename is
     s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: convert missed s3c2410_gpio calls to gpiolib calls
From: Ben Dooks <ben@simtec.co.uk>

Convert two missed s3c2410 specific gpio calls to gpiolib calls.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls
+++ a/drivers/mmc/host/s3cmci.c
@@ -1303,10 +1303,8 @@ static int s3cmci_get_ro(struct mmc_host
 	if (pdata->no_wprotect)
 		return 0;
 
-	ret = s3c2410_gpio_getpin(pdata->gpio_wprotect);
