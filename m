From: akpm@linux-foundation.org
Subject: + rtc-ds1307-simplify-irq-setup-code.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:16:21 -0800
Message-ID: <20120224201621.EEA74A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55598 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2BXUQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:16:23 -0500
Received: by yenm1 with SMTP id m1so324801yen.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:16:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, Austin.Boyle@aviatnet.com, alessandro.zummo@towertech.it, danders.dev@gmail.com


The patch titled
     Subject: rtc: ds1307: simplify irq setup code
has been added to the -mm tree.  Its filename is
     rtc-ds1307-simplify-irq-setup-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc: ds1307: simplify irq setup code

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
rtc-ds1307-refactor-chip_desc-table.patch
rtc-ds1307-simplify-irq-setup-code.patch
rtc-ds1307-comment-and-format-cleanup.patch
rtc-ds1307-generalise-ram-size-and-offset.patch

