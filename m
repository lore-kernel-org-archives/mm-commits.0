From: akpm@linux-foundation.org
Subject: - rtc-rtc-wm8350-add-support-for-wm8350-rtc-update.patch removed from -mm tree
Date: Mon, 27 Oct 2008 23:22:29 -0700
Message-ID: <200810280622.m9S6MTLC022333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbYJ1GWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net, linux@wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     rtc-rtc-wm8350-add-support-for-wm8350-rtc update
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm8350-add-support-for-wm8350-rtc-update.patch

This patch was dropped because it was folded into rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-rtc-wm8350-add-support-for-wm8350-rtc update
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <linux@wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update
+++ a/drivers/rtc/rtc-wm8350.c
@@ -471,7 +471,7 @@ static int wm8350_rtc_probe(struct platf
 	return 0;
 }
 
-static int __exit wm8350_rtc_remove(struct platform_device *pdev)
+static int __devexit wm8350_rtc_remove(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 	struct wm8350_rtc *wm_rtc = &wm8350->rtc;
@@ -500,16 +500,15 @@ static int __init wm8350_rtc_init(void)
 {
 	return platform_driver_register(&wm8350_rtc_driver);
 }
+module_init(wm8350_rtc_init);
 
 static void __exit wm8350_rtc_exit(void)
 {
 	platform_driver_unregister(&wm8350_rtc_driver);
 }
