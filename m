From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:23 -0700
Message-ID: <20120731185223.B5CEB1E0078@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2GaSwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:52:24 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bengt.g.jonsson@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: drivers/rtc/rtc-ab8500.c: remove fix for AB8500 ED version

AB8500 ED (Early Drop) is no longer supported by the kernel.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~drivers-rtc-rtc-ab8500c-remove-fix-for-ab8500-ed-version
+++ a/drivers/rtc/rtc-ab8500.c
@@ -89,22 +89,17 @@ static int ab8500_rtc_read_time(struct d
 	if (retval < 0)
 		return retval;
 
-	/* Early AB8500 chips will not clear the rtc read request bit */
-	if (abx500_get_chip_id(dev) == 0) {
-		usleep_range(1000, 1000);
-	} else {
-		/* Wait for some cycles after enabling the rtc read in ab8500 */
-		while (time_before(jiffies, timeout)) {
-			retval = abx500_get_register_interruptible(dev,
-				AB8500_RTC, AB8500_RTC_READ_REQ_REG, &value);
-			if (retval < 0)
-				return retval;
+	/* Wait for some cycles after enabling the rtc read in ab8500 */
+	while (time_before(jiffies, timeout)) {
+		retval = abx500_get_register_interruptible(dev,
+			AB8500_RTC, AB8500_RTC_READ_REQ_REG, &value);
+		if (retval < 0)
+			return retval;
 
-			if (!(value & RTC_READ_REQUEST))
-				break;
+		if (!(value & RTC_READ_REQUEST))
+			break;
 
-			usleep_range(1000, 5000);
-		}
+		usleep_range(1000, 5000);
 	}
 
 	/* Read the Watchtime registers */
_

Patches currently in -mm which might be from bengt.g.jonsson@stericsson.com are

origin.patch

