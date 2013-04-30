From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:37 -0700
Message-ID: <20130430190137.7A9D631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:45407 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552Ab3D3TBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:38 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so87572yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Fix to return -ENODEV in the chip not found error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -266,6 +266,7 @@ static int pcf2123_probe(struct spi_devi
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "chip not found\n");
+		ret = -ENODEV;
 		goto kfree_exit;
 	}
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch
drivers-w1-slaves-w1_ds2780c-fix-the-error-handling-in-w1_ds2780_add_slave.patch
drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch
drivers-w1-slaves-w1_ds2760c-fix-the-error-handling-in-w1_ds2760_add_slave.patch

