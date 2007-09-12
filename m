From: akpm@linux-foundation.org
Subject: + rtc-pcf8583-check-for-i2c-adapter-functionality.patch added to -mm tree
Date: Wed, 12 Sep 2007 16:03:16 -0700
Message-ID: <200709122303.l8CN3GYx023602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbXILXDi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 19:03:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, a.zummo@towertech.it


The patch titled
     rtc-pcf8583: Check for i2c adapter functionality
has been added to the -mm tree.  Its filename is
     rtc-pcf8583-check-for-i2c-adapter-functionality.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-pcf8583: Check for i2c adapter functionality
From: Jean Delvare <khali@linux-fr.org>

Not all i2c adapters support I2C-level messaging.  Check that the adapter
does before probing for a PCF8583 chip, as the driver makes use of
i2c_transfer and i2c_master_send.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-check-for-i2c-adapter-functionality drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-check-for-i2c-adapter-functionality
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -332,6 +332,9 @@ static int pcf8583_probe(struct i2c_adap
 		}
 	};
 
+	if (!i2c_check_functionality(adap, I2C_FUNC_I2C))
+		return 0;
+
 	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
 	if (!pcf)
 		return -ENOMEM;
_

Patches currently in -mm which might be from khali@linux-fr.org are

git-dvb.patch
i2c-i801-documentation-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
git-hwmon.patch
applesmc-for-mac-pro-2-x-quad-core.patch
git-ieee1394.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
rtc-pcf8583-check-for-i2c-adapter-functionality.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
