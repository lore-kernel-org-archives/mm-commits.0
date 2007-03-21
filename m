From: akpm@linux-foundation.org
Subject: + i2c-adapter-driver-ibm-iic-forgot-to-specify-physical-device.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:18:23 -0700
Message-ID: <200703212318.l2LNINSC006681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933766AbXCUXSl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bart.vanassche@gmail.com, khali@linux-fr.org


The patch titled
     I2C adapter driver IBM IIC forgot to specify physical device
has been added to the -mm tree.  Its filename is
     i2c-adapter-driver-ibm-iic-forgot-to-specify-physical-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I2C adapter driver IBM IIC forgot to specify physical device
From: Bart Van Assche <bart.vanassche@gmail.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8248

IBM IIC driver prints following message to console:
**WARNING** I2C adapter driver [IBM IIC] forgot to specify physical device; fix it!

This patch makes the warning go away.

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-ibm_iic.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/i2c/busses/i2c-ibm_iic.c~i2c-adapter-driver-ibm-iic-forgot-to-specify-physical-device drivers/i2c/busses/i2c-ibm_iic.c
--- a/drivers/i2c/busses/i2c-ibm_iic.c~i2c-adapter-driver-ibm-iic-forgot-to-specify-physical-device
+++ a/drivers/i2c/busses/i2c-ibm_iic.c
@@ -730,6 +730,7 @@ static int __devinit iic_probe(struct oc
 	adap->dev.parent = &ocp->dev;
 	strcpy(adap->name, "IBM IIC");
 	i2c_set_adapdata(adap, dev);
+	adap->dev.parent = &ocp->dev;
 	adap->id = I2C_HW_OCP;
 	adap->class = I2C_CLASS_HWMON;
 	adap->algo = &iic_algo;
_

Patches currently in -mm which might be from bart.vanassche@gmail.com are

ocotea-board-ntpd-complains-that-the-frequency-error-exceeds-the-tolerance.patch
i2c-adapter-driver-ibm-iic-forgot-to-specify-physical-device.patch
