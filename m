From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-simplify-irq-setup-code.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:48 -0700
Message-ID: <20120326193148.67410A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:43084 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2CZTbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:51 -0400
Received: by eaaq10 with SMTP id q10so290016eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, Austin.Boyle@aviatnet.com, alessandro.zummo@towertech.it, danders.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: simplify irq setup code
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-simplify-irq-setup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: rtc: ds1307: simplify irq setup code

No need to have two seperate if-blocks for setting up the irq.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: David Anders <danders.dev@gmail.com>
Cc: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-simplify-irq-setup-code drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-simplify-irq-setup-code
+++ a/drivers/rtc/rtc-ds1307.c
@@ -646,11 +646,6 @@ static int __devinit ds1307_probe(struct
 	case ds_1337:
 	case ds_1339:
 	case ds_3231:
-		/* has IRQ? */
-		if (ds1307->client->irq > 0 && chip->alarm) {
-			INIT_WORK(&ds1307->work, ds1307_work);
-			want_irq = true;
-		}
 		/* get registers that the "rtc" read below won't read... */
 		tmp = ds1307->read_block_data(ds1307->client,
 				DS1337_REG_CONTROL, 2, buf);
@@ -668,10 +663,14 @@ static int __devinit ds1307_probe(struct
 		 * For some variants, be sure alarms can trigger when we're
 		 * running on Vbackup (BBSQI/BBSQW)
 		 */
-		if (want_irq) {
+		if (ds1307->client->irq > 0 && chip->alarm) {
+			INIT_WORK(&ds1307->work, ds1307_work);
+
 			ds1307->regs[0] |= DS1337_BIT_INTCN
 					| bbsqi_bitpos[ds1307->type];
 			ds1307->regs[0] &= ~(DS1337_BIT_A2IE | DS1337_BIT_A1IE);
+
+			want_irq = true;
 		}
 
 		i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL,
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch

