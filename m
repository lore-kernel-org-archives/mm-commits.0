From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:29 -0700
Message-ID: <20120326193129.A7BF8A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:54542 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab2CZTbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:31 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so290191wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-twl.c: enable RTC irrespective of its prior state

As part of probe, before enabling RTC, RTC_CTRL register is read to check
if it is already running.  If RTC is used by kernel alone, then this read
is not required.  Even if RTC was enabled already by boot loader, setting
STOP_RTC bit again should not harm.  Hence removed unwanted read
operation.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state
+++ a/drivers/rtc/rtc-twl.c
@@ -457,19 +457,11 @@ static int __devinit twl_rtc_probe(struc
 			REG_INT_MSK_STS_A);
 	}
 
-	/* Check RTC module status, Enable if it is off */
-	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
+	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
+	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out1;
 
-	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
-		dev_info(&pdev->dev, "Enabling TWL-RTC.\n");
-		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
-		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
-		if (ret < 0)
-			goto out1;
-	}
