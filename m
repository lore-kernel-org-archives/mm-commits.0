From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1307-remove-superfluous-initialization.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:32 -0700
Message-ID: <20120531192032.672DEA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33186 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933078Ab2EaTUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:20:34 -0400
Received: by lagr15 with SMTP id r15so75924lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, Joakim.Tjernlund@transmode.se, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: remove superfluous initialization
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-remove-superfluous-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: rtc: ds1307: remove superfluous initialization

ds1307 was kzalloced, so no need to zero members of the struct.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-remove-superfluous-initialization drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-remove-superfluous-initialization
+++ a/drivers/rtc/rtc-ds1307.c
@@ -637,7 +637,6 @@ static int __devinit ds1307_probe(struct
 
 	ds1307->client	= client;
 	ds1307->type	= id->driver_data;
-	ds1307->offset	= 0;
 
 	buf = ds1307->regs;
 	if (i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch

