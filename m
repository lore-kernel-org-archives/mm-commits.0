From: akpm@linux-foundation.org
Subject: - rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:19 -0700
Message-ID: <200805132134.m4DLYJ93000909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760479AbYEMVeu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, ab@mycable.de, david-b@pacbell.net, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     RTC/watchdog: M41T80: fix a potential use of unitialized data
has been removed from the -mm tree.  Its filename was
     rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: RTC/watchdog: M41T80: fix a potential use of unitialized data
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Watchdog handlers within the driver make use of "save_client" -- make sure it
has been initalized before the handlers are registered.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Bigga <ab@mycable.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data
+++ a/drivers/rtc/rtc-m41t80.c
@@ -803,6 +803,7 @@ static int m41t80_probe(struct i2c_clien
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
+		save_client = client;
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -811,7 +812,6 @@ static int m41t80_probe(struct i2c_clien
 			misc_deregister(&wdt_dev);
 			goto exit;
 		}
-		save_client = client;
 	}
 #endif
 	return 0;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-make-the-rtc-sync-mode-11-minute-again.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

