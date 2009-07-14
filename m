From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1374-fix-lock-imbalance.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:36 -0700
Message-ID: <200907142032.n6EKWaQH012119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756425AbZGNUcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:32:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, a.zummo@towertech.it, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rtc: ds1374, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: ds1374, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

When i2c_smbus_read_byte_data fails in ds1374_work, we forgot to unlock
the held lock.  Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Scott Wood <scottwood@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-fix-lock-imbalance drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-fix-lock-imbalance
+++ a/drivers/rtc/rtc-ds1374.c
@@ -283,7 +283,7 @@ static void ds1374_work(struct work_stru
 
 	stat = i2c_smbus_read_byte_data(client, DS1374_REG_SR);
 	if (stat < 0)
-		return;
+		goto unlock;
 
 	if (stat & DS1374_REG_SR_AF) {
 		stat &= ~DS1374_REG_SR_AF;
@@ -302,7 +302,7 @@ static void ds1374_work(struct work_stru
 out:
 	if (!ds1374->exiting)
 		enable_irq(client->irq);
