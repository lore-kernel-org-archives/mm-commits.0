From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:52:26 -0700
Message-ID: <20120731185227.1DD125C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:62249 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348Ab2GaSw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2012 14:52:29 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so292297lag.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:52:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, agust@denx.de, andreas.dumberger@tqs.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/rtc/rtc-r9701.c: avoid second call to rtc_valid_tm()

r9701_get_datetime() calls rtc_valid_tm() and returns the value returned
by rtc_valid_tm(), which can be used in the `if', so calling
rtc_valid_tm() a second time is not required.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Andreas Dumberger <andreas.dumberger@tqs.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm
+++ a/drivers/rtc/rtc-r9701.c
@@ -138,8 +138,7 @@ static int __devinit r9701_probe(struct 
 	 * contain invalid values. If so, try to write a default date:
 	 * 2000/1/1 00:00:00
 	 */
-	r9701_get_datetime(&spi->dev, &dt);
-	if (rtc_valid_tm(&dt)) {
+	if (r9701_get_datetime(&spi->dev, &dt)) {
 		dev_info(&spi->dev, "trying to repair invalid date/time\n");
 		dt.tm_sec  = 0;
 		dt.tm_min  = 0;
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
rtc-rtc-88pm80x-assign-ret-only-when-rtc_register_driver-fails.patch
rtc-rtc-88pm80x-remove-unneed-devm_kfree.patch
linux-next.patch

