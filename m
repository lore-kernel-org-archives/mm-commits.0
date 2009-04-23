From: akpm@linux-foundation.org
Subject: + i2c-pxac-timeouts-off-by-1.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:35:21 -0700
Message-ID: <200904232335.n3NNZL2Q023665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbZDWXjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ben-linux@fluff.org, khali@linux-fr.org, mike@compulab.co.il, w.sang@pengutronix.de


The patch titled
     i2c-pxa.c: timeouts off by 1
has been added to the -mm tree.  Its filename is
     i2c-pxac-timeouts-off-by-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c-pxa.c: timeouts off by 1
From: Roel Kluin <roel.kluin@gmail.com>

With `while (timeout--)' timeout reaches -1 after the loop, so the tests
below are off by one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pxa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/i2c/busses/i2c-pxa.c~i2c-pxac-timeouts-off-by-1 drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~i2c-pxac-timeouts-off-by-1
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -265,10 +265,10 @@ static int i2c_pxa_wait_bus_not_busy(str
 		show_state(i2c);
 	}
 
-	if (timeout <= 0)
+	if (timeout < 0)
 		show_state(i2c);
 
-	return timeout <= 0 ? I2C_RETRY : 0;
+	return timeout < 0 ? I2C_RETRY : 0;
 }
 
 static int i2c_pxa_wait_master(struct pxa_i2c *i2c)
@@ -612,7 +612,7 @@ static int i2c_pxa_pio_set_master(struct
 		show_state(i2c);
 	}
 
-	if (timeout <= 0) {
+	if (timeout < 0) {
 		show_state(i2c);
 		dev_err(&i2c->adap.dev,
 			"i2c_pxa: timeout waiting for bus free\n");
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
microblaze-iowrite-upon-timeout.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

