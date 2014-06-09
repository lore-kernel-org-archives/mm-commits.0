From: akpm@linux-foundation.org
Subject: [merged]
 rtc-fix-potential-race-condition-and-remove-build-errors.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:29:52 -0700
Message-ID: <53960b30.8gpQVW4BdMJpb18T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaFIT3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, a.zummo@towertech.it, ravi23ganiga@gmail.com

Subject: [merged] rtc-fix-potential-race-condition-and-remove-build-errors.patch removed from -mm tree
To: ravi23ganiga@gmail.com,a.zummo@towertech.it,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:29:52 -0700


The patch titled
     Subject: rtc: fix build error
has been removed from the -mm tree.  Its filename was
     rtc-fix-potential-race-condition-and-remove-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

