From: akpm@linux-foundation.org
Subject: + rtc-fix-potential-race-condition-and-remove-build-errors.patch
 added to -mm tree
Date: Mon, 19 May 2014 14:33:14 -0700
Message-ID: <537a789a.yMSPG114475F/6Uv%akpm__2340.90378876335$1400535206$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaESVdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 17:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, a.zummo@towertech.it, ravi23ganiga@gmail.com

Subject: + rtc-fix-potential-race-condition-and-remove-build-errors.patch added to -mm tree
To: ravi23ganiga@gmail.com,a.zummo@towertech.it,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 14:33:14 -0700


The patch titled
     Subject: rtc: fix build error
has been added to the -mm tree.  Its filename is
     rtc-fix-potential-race-condition-and-remove-build-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-fix-potential-race-condition-and-remove-build-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-fix-potential-race-condition-and-remove-build-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: rtc: fix build error

Fix the following build errors reported by kbuild test robot by selecting
REGMAP_SPI in Kconfig file

drivers/built-in.o: In function `ds1343_probe':
rtc-ds1343.c:(.text+0x1baf8f): undefined reference to `devm_regmap_init_spi'

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/Kconfig~rtc-fix-potential-race-condition-and-remove-build-errors drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-fix-potential-race-condition-and-remove-build-errors
+++ a/drivers/rtc/Kconfig
@@ -574,6 +574,7 @@ config RTC_DRV_DS1305
 	  will be called rtc-ds1305.
 
 config RTC_DRV_DS1343
+	select REGMAP_SPI
 	tristate "Dallas/Maxim DS1343/DS1344"
 	help
 	  If you say yes here you get support for the
_

Patches currently in -mm which might be from ravi23ganiga@gmail.com are

drivers-rtc-add-support-for-maxim-dallas-rtc-ds1343-and-ds1344.patch
rtc-fix-potential-race-condition-and-remove-build-errors.patch
drivers-rtc-rtc-ds1343c-fix-potential-race-condition.patch
linux-next.patch

