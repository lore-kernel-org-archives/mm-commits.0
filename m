From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch added to -mm tree
Date: Thu, 29 Aug 2013 15:03:32 -0700
Message-ID: <521fc534.GhMcTKouQ6B0NEN8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3H2WDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 18:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, shc_work@mail.ru

Subject: + drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch added to -mm tree
To: shc_work@mail.ru,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 15:03:32 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: remove unused field "rtc" from private structure
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: drivers/rtc/rtc-ds1742.c: remove unused field "rtc" from private structure

Private field "rtc" is not used outside "probe", so there is no reason to
keep it.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1742.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure
+++ a/drivers/rtc/rtc-ds1742.c
@@ -52,7 +52,6 @@
 #define RTC_BATT_FLAG		0x80
 
 struct rtc_plat_data {
-	struct rtc_device *rtc;
 	void __iomem *ioaddr_nvram;
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
@@ -206,7 +205,6 @@ static int ds1742_rtc_probe(struct platf
 				  &ds1742_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
-	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &pdata->nvram_attr);
 
_

Patches currently in -mm which might be from shc_work@mail.ru are

drivers-rtc-rtc-ds1742c-use-devm_ioremap_resource.patch
drivers-rtc-rtc-ds1742c-remove-unused-field-rtc-from-private-structure.patch
drivers-rtc-rtc-ds1742c-report-to-rtc-core-if-retrieved-time-is-invalid.patch
linux-next.patch

