From: akpm@linux-foundation.org
Subject: [folded] pps-new-client-driver-using-gpio-fix.patch removed from -mm tree
Date: Wed, 02 Nov 2011 13:18:52 -0700
Message-ID: <201111022018.pA2KIqtV018392@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:39575 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1KBUTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2011 16:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, giometti@linux.it, jamesnuss@nanometrics.ca, lasaine@lvk.cs.msu.su, plyatov@gmail.com, rasm@fe.up.pt, mm-commits@vger.kernel.org


The patch titled
     Subject: pps-new-client-driver-using-gpio-fix
has been removed from the -mm tree.  Its filename was
     pps-new-client-driver-using-gpio-fix.patch

This patch was dropped because it was folded into pps-new-client-driver-using-gpio.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pps-new-client-driver-using-gpio-fix

remove unneeded cast of void*

Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Igor Plyatov <plyatov@gmail.com>
Cc: James Nuss <jamesnuss@nanometrics.ca>
Cc: Ricardo Martins <rasm@fe.up.pt>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/clients/pps-gpio.c~pps-new-client-driver-using-gpio-fix drivers/pps/clients/pps-gpio.c
--- a/drivers/pps/clients/pps-gpio.c~pps-new-client-driver-using-gpio-fix
+++ a/drivers/pps/clients/pps-gpio.c
@@ -55,7 +55,7 @@ static irqreturn_t pps_gpio_irq_handler(
 	/* Get the time stamp first */
 	pps_get_ts(&ts);
 
-	info = (const struct pps_gpio_device_data *)data;
+	info = data;
 
 	rising_edge = gpio_get_value(info->pdata->gpio_pin);
 	if ((rising_edge && !info->pdata->assert_falling_edge) ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctl-add-support-for-poll.patch
include-linux-dma-mappingh-add-dma_zalloc_coherent.patch
pps-new-client-driver-using-gpio.patch

