From: akpm@linux-foundation.org
Subject: [merged] i2c-pxac-timeouts-off-by-1.patch removed from -mm tree
Date: Wed, 13 May 2009 11:32:00 -0700
Message-ID: <200905131832.n4DIW0TI018717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbZEMSgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ben-linux@fluff.org, khali@linux-fr.org, mike@compulab.co.il, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     i2c-pxa.c: timeouts off by 1
has been removed from the -mm tree.  Its filename was
     i2c-pxac-timeouts-off-by-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c-pxa.c: timeouts off by 1
From: Roel Kluin <roel.kluin@gmail.com>

With `while (timeout--)' timeout reaches -1 after the loop, so the tests
below are off by one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pxa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/i2c/busses/i2c-pxa.c~i2c-pxac-timeouts-off-by-1 drivers/i2c/busses/i2c-pxa.c
--- a/drivers/i2c/busses/i2c-pxa.c~i2c-pxac-timeouts-off-by-1
+++ a/drivers/i2c/busses/i2c-pxa.c
@@ -279,10 +279,10 @@ static int i2c_pxa_wait_bus_not_busy(str
 		show_state(i2c);
 	}
 
-	if (timeout <= 0)
+	if (timeout < 0)
 		show_state(i2c);
 
-	return timeout <= 0 ? I2C_RETRY : 0;
+	return timeout < 0 ? I2C_RETRY : 0;
 }
 
 static int i2c_pxa_wait_master(struct pxa_i2c *i2c)
@@ -626,7 +626,7 @@ static int i2c_pxa_pio_set_master(struct
 		show_state(i2c);
 	}
 
-	if (timeout <= 0) {
+	if (timeout < 0) {
 		show_state(i2c);
 		dev_err(&i2c->adap.dev,
 			"i2c_pxa: timeout waiting for bus free\n");
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

