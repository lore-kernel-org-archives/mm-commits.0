From: akpm@linux-foundation.org
Subject: - rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-3.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:22 -0800
Message-ID: <200811102034.mAAKYM2I025034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388AbYKJUjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:39:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net, linux@wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     watchdog: add support for the WM8350 watchdog
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: add support for the WM8350 watchdog
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Since last submission the driver has been changed to use bit zero rather
than bit 1 when using test_and_set_bit() to ensure that we only have
one user.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <linux@wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/wm8350_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/wm8350_wdt.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-3 drivers/watchdog/wm8350_wdt.c
--- a/drivers/watchdog/wm8350_wdt.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-3
+++ a/drivers/watchdog/wm8350_wdt.c
@@ -123,7 +123,7 @@ static int wm8350_wdt_open(struct inode 
 	if (!wm8350)
 		return -ENODEV;
 
-	if (test_and_set_bit(1, &wm8350_wdt_users))
+	if (test_and_set_bit(0, &wm8350_wdt_users))
 		return -EBUSY;
 
 	ret = wm8350_wdt_start(wm8350);
@@ -144,7 +144,7 @@ static int wm8350_wdt_release(struct ino
 		wm8350_wdt_kick(wm8350);
 	}
 
-	clear_bit(1, &wm8350_wdt_users);
+	clear_bit(0, &wm8350_wdt_users);
 
 	return 0;
 }
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

