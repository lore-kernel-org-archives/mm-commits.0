From: akpm@linux-foundation.org
Subject: [merged] rtc-rs5c372-fix-buffer-size.patch removed from -mm tree
Date: Thu, 23 Dec 2010 14:36:36 -0800
Message-ID: <201012232240.oBNMeOSD015449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662Ab0LWWky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, a.v.rooyen@sercom.nl, a.zummo@towertech.it, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc: rs5c372: fix buffer size
has been removed from the -mm tree.  Its filename was
     rtc-rs5c372-fix-buffer-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rs5c372: fix buffer size
From: Wolfram Sang <w.sang@pengutronix.de>

Match the buffer size to the amount of initialized values.  Before, it was
one too big and thus destroyed the neighbouring register causing the clock
to run at false speeds.

Reported-by: Andre van Rooyen <a.v.rooyen@sercom.nl>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rs5c372-fix-buffer-size drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rs5c372-fix-buffer-size
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -207,7 +207,7 @@ static int rs5c372_get_datetime(struct i
 static int rs5c372_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	struct rs5c372	*rs5c = i2c_get_clientdata(client);
-	unsigned char	buf[8];
+	unsigned char	buf[7];
 	int		addr;
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d "
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
pata_mpc52xx-driver-needs-bmdma.patch

