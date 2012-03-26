From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:31 -0700
Message-ID: <20120326193131.63A93A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51042 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2CZTbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:32 -0400
Received: by qcsp5 with SMTP id p5so513914qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing

For clearing RTC interrupt, programming ALARM bit only is sufficient, as
all other bits are any way not affected by writing 0 to them.

Hence removed unwanted OR operation.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing
+++ a/drivers/rtc/rtc-twl.c
@@ -384,7 +384,7 @@ static irqreturn_t twl_rtc_interrupt(int
 	else
 		events |= RTC_IRQF | RTC_UF;
 
-	res = twl_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
+	res = twl_rtc_write_u8(BIT_RTC_STATUS_REG_ALARM_M,
 				   REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
_

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
linux-next.patch

