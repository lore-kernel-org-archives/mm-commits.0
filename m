From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata.patch
 added to -mm tree
Date: Tue, 10 Dec 2013 13:43:09 -0800
Message-ID: <52a78aed.jRVz9wsYuj2u5c22%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3LJVnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 16:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata.patch added to -mm tree
To: sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 13:43:09 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1305.c: remove redundant spi_set_drvdata()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata.patch

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
Subject: drivers/rtc/rtc-ds1305.c: remove redundant spi_set_drvdata()

Driver core sets driver data to NULL upon failure or remove.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1305.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1305.c~drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata
+++ a/drivers/rtc/rtc-ds1305.c
@@ -787,7 +787,6 @@ static int ds1305_remove(struct spi_devi
 		cancel_work_sync(&ds1305->work);
 	}
 
-	spi_set_drvdata(spi, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
drivers-rtc-rtc-ds1305c-remove-redundant-spi_set_drvdata.patch
linux-next.patch

