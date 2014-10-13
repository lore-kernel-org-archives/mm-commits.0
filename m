From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 15:37:28 -0700
Message-ID: <543c5428.6uy2PuLp7bxeXOpk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zyw@rock-chips.com, dianders@chromium.org, heiko@sntech.de, zhangqing@rock-chips.com, mm-commits@vger.kernel.org


The patch titled
     Subject: RTC: RK808: remove tm_def structure
has been removed from the -mm tree.  Its filename was
     rtc-rk808-add-rtc-driver-for-rk808-fix-2.patch

This patch was dropped because it was folded into rtc-rk808-add-rtc-driver-for-rk808.patch

------------------------------------------------------
From: Chris Zhong <zyw@rock-chips.com>
Subject: RTC: RK808: remove tm_def structure

If the date/time is invalid at bootup, there's no reason to set it to
a bogus value. We can just let the data and time be invalid until
someone makes it valid.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Cc: Zhang Qing <zhangqing@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix-2 drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix-2
+++ a/drivers/rtc/rtc-rk808.c
@@ -325,17 +325,6 @@ static int rk808_rtc_resume(struct devic
 static SIMPLE_DEV_PM_OPS(rk808_rtc_pm_ops,
 	rk808_rtc_suspend, rk808_rtc_resume);
 
-/* 2014.1.1 12:00:00 Saturday */
-static struct rtc_time tm_def = {
-	.tm_wday = 6,
-	.tm_year = 114,
-	.tm_mon = 0,
-	.tm_mday = 1,
-	.tm_hour = 12,
-	.tm_min = 0,
-	.tm_sec = 0,
-};
