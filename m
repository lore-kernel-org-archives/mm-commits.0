From: akpm@linux-foundation.org
Subject: - i2c-iop3xx-switch-to-static-adapter-numbering.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:57:54 -0700
Message-ID: <200706121857.l5CIvsgq018501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbXFLTID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:08:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tbm@cyrius.com, Riku.Voipio@movial.fi, dan.j.williams@intel.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c-iop3xx: switch to static adapter numbering
has been removed from the -mm tree.  Its filename was
     i2c-iop3xx-switch-to-static-adapter-numbering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2c-iop3xx: switch to static adapter numbering
From: Martin Michlmayr <tbm@cyrius.com>

Update the IOP3xx I2C driver to use i2c_add_numbered_adapter(), so that
later patches can convert boards to using new-style drivers.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Tested-by: Voipio Riku <Riku.Voipio@movial.fi>
Cc: Dan J Williams <dan.j.williams@intel.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-iop3xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-iop3xx.c~i2c-iop3xx-switch-to-static-adapter-numbering drivers/i2c/busses/i2c-iop3xx.c
--- a/drivers/i2c/busses/i2c-iop3xx.c~i2c-iop3xx-switch-to-static-adapter-numbering
+++ a/drivers/i2c/busses/i2c-iop3xx.c
@@ -491,6 +491,7 @@ iop3xx_i2c_probe(struct platform_device 
 	new_adapter->id = I2C_HW_IOP3XX;
 	new_adapter->owner = THIS_MODULE;
 	new_adapter->dev.parent = &pdev->dev;
+	new_adapter->nr = pdev->id;
 
 	/*
 	 * Default values...should these come in from board code?
@@ -508,7 +509,7 @@ iop3xx_i2c_probe(struct platform_device 
 	platform_set_drvdata(pdev, new_adapter);
 	new_adapter->algo_data = adapter_data;
 
-	i2c_add_adapter(new_adapter);
+	i2c_add_numbered_adapter(new_adapter);
 
 	return 0;
 
_

Patches currently in -mm which might be from tbm@cyrius.com are

update-zilog-timeout.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
